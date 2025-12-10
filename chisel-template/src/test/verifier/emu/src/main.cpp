#include <execinfo.h>
#include <signal.h>
#include <getopt.h>
#include "processor.h"
#include "disasm.h"
#include "simif.h"
#include "timing.h"

void handler_crash(int sig) {
  void *array[10];
  size_t size;

  // get void*'s for all entries on the stack
  size = backtrace(array, 10);

  // print out all the frames to stderr
  fprintf(stderr, "Error: signal %d:\n", sig);
  backtrace_symbols_fd(array, size, STDERR_FILENO);
  exit(1);
}

#define assertEq(message, actual, expected) do { \
    if (actual != expected) { \
    	printf("\n*** %s actual=%x expected=%x ***\n\n", message, actual, expected); \
	    failure(); \
    } \
} while (false)

const uint64_t MAX_STEPS = 256;

struct instruction_log_t {
    uint32_t pc;
    uint32_t timing;
    bool     flushed;
    uint64_t started;
    uint64_t decoded;
    // uint64_t dispatched;
    uint64_t issued;
    uint64_t retired;
};

struct sched_config_t {
    uint64_t fetch_latency;
    uint64_t decode_latency;
    uint32_t decode_ways;
    // uint32_t dispatch_ways;
    size_t iq_size;
};

/*
 if 0 addressing
 if 1 instruction / branch prediction 0 redir
 if 2 insn slice  / branch prediction 1 redir
 id 1 iq assign   / decode
 id 2 lsu assign  / register renaming
 rrd (dispatch)
 ex1 (ALU/CLU forward)
 ex2 (BLU forward) / mem1
 retire            / mem2
 flush             / mem3 (load forward: aligned word load only)
                   / retire
*/

class sched_t {
    static const size_t LOG_SIZE = MAX_STEPS * 2;
    static const size_t LOG_MASK = LOG_SIZE - 1;
    sched_config_t cfg_;
    instruction_log_t insn_log[LOG_SIZE];
    uint64_t cycles_ = 0;
    size_t iq_begin = 0;
    size_t iq_end   = 0;
    size_t iq_last  = 0;
    size_t iq_flushed = 0;
    uint32_t pred_pc = -1;
    uint64_t last_decoded = 0;
    uint32_t decode_rest = cfg_.decode_ways;
    // uint64_t last_dispatched = 0;
    uint64_t last_retired = 0;
    // uint32_t dispatch_rest = cfg.dispatch_ways;
    // uint64_t alu_cycle = 0;
    // uint64_t blu_cycle = 0;

private:
    uint64_t exec_latency(timing_t timing, uint32_t pc) {
        uint64_t latency;
        switch (timing >> 16) {
        case TC_ARITH:
            latency = 4;
            // latency = 2; // clu
            break;
        case TC_MUL:
            latency = 4;
            break;
        case TC_DIV:
            latency = 20;
            break;
        case TC_JB:
            latency = 4;
            break;
        case TC_CSR:
            latency = 4;
            break;
        case TC_LD:
            latency = 5;
            break;
        case TC_ST:
            latency = 5;
            break;
        default:
            printf("pc=%08x unknown timing: %d\n", pc, timing);
            latency = 10;
            break;
        }
        return latency;
    }
public:
    explicit sched_t(sched_config_t cfg): cfg_(cfg) {}
    uint64_t cycles() {
        return cycles_;
    }
    void decoded(reg_t pc, insn_t insn, timing_t timing) {
        // cycles += 1;
        insn_log[iq_last].pc = pc;
        insn_log[iq_last].timing = timing;
        insn_log[iq_last].flushed = (pred_pc != pc);
        pred_pc = pc + insn.length();
        iq_last = (iq_last + 1) & LOG_MASK;
    }
    void timesim() {
        uint64_t retired = last_retired;
        for (size_t i = iq_begin; i != iq_last; i = (i + 1) & LOG_MASK) {
            uint64_t decoded;
            if (insn_log[i].flushed) {
                iq_flushed = i;
                decoded = retired + cfg_.fetch_latency;
                // printf("pc=%08x decoded=%llu (flushed)\n", insn_log[i].pc, decoded);
                insn_log[i].decoded = decoded;
                last_decoded = decoded;
            } else {
                size_t from_flushed = (i - iq_flushed) & LOG_MASK;
                size_t iq_dist = std::min(from_flushed, cfg_.iq_size);
                size_t iq_top = (i - iq_dist) & LOG_MASK;
                decoded = last_decoded + (decode_rest == 0 ? 1 : 0);
                // printf("iq_top=%zu iq_flushed=%zu retired=%llu\n", iq_top, iq_flushed, insn_log[iq_top].retired);
                if (iq_top != iq_flushed) {
                    if (decoded < insn_log[iq_top].retired + 1) {
                        decoded = insn_log[iq_top].retired + 1;
                        decode_rest = 0;
                    }
                }
                if (decode_rest == 0) {
                    decode_rest = cfg_.decode_ways;
                }
                --decode_rest;
                // printf("pc=%08x decoded=%llu\n", insn_log[i].pc, decoded);
                insn_log[i].decoded = decoded;
                last_decoded = decoded;
            }
            retired = decoded + cfg_.decode_latency + exec_latency(insn_log[i].timing, insn_log[i].pc);
            insn_log[i].retired = retired;
        }
        last_retired = retired;
        cycles_ = retired;
        iq_begin = iq_last;
    }
};

sched_config_t sched_cfg = {
    3, 3, 1, 16
};

sched_t sched(sched_cfg);

class sim_wrap: public simif_t {
public:
    static const size_t IMEM_SIZE =   4 * 1024 * 1024;
    static const size_t DMEM_SIZE = 256 * 1024 * 1024;
    uint8_t imem[IMEM_SIZE];
    uint8_t dmem[DMEM_SIZE];
    // queue<IoAccess> mmioDut;
    
    // Configuration and Harts
    const cfg_t * const cfg;
    const std::map<size_t, processor_t*> harts;

    sim_wrap(const cfg_t *config): cfg(config) {
        memset(imem, 0, sizeof(imem));
        memset(dmem, 0, sizeof(dmem));
    }

    // should return NULL for MMIO addresses
    virtual char* addr_to_mem(reg_t addr) override {
        // if (0 <= addr && addr < IMEM_SIZE) {
        if (0x08000000 <= addr && addr < 0x08000000 + IMEM_SIZE) {
            return (char *)&imem[addr - 0x08000000];
        }
        if (0x20000000 <= addr && addr < 0x20000000 + DMEM_SIZE) {
            return (char *)&dmem[addr - 0x20000000];
        }
        return NULL;
    }
    // used for MMIO addresses
    virtual bool mmio_load(reg_t addr, size_t len, uint8_t* bytes) override {
        // printf("mmio_load %llx %ld\n", addr, len);
        if ((addr & 0xffff0000) != 0x30000000) return false;
        if ((addr & 0xffff) == 0x1000) {
            for (auto i = 0; i < len; i++) {
                bytes[i] = 0;
            }
        }
        return true;
        // assertTrue("missing mmio\n", !mmioDut.empty());
        // auto dut = mmioDut.front();
        // assertEq("mmio write\n", dut.write, false);
        // assertEq("mmio address\n", dut.addr, addr);
        // assertEq("mmio len\n", dut.len, len);
        // memcpy(bytes, dut.data, len);
        // mmioDut.pop();
        // return !dut.error;
    }
    virtual bool mmio_store(reg_t addr, size_t len, const uint8_t* bytes) override {
        // printf("mmio_store %llx %ld\n", addr, len);
        if ((addr & 0xffff0000) != 0x30000000) return false;
        if ((addr & 0xffff) == 0x1004) {
            putchar(bytes[0]);
            fflush(stdout);
        }
        return true;
        // assertTrue("missing mmio\n", !mmioDut.empty());
        // auto dut = mmioDut.front();
        // assertEq("mmio write\n", dut.write, true);
        // assertEq("mmio address\n", dut.addr, addr);
        // assertEq("mmio len\n", dut.len, len);
        // assertTrue("mmio data\n", !memcmp(dut.data, bytes, len));
        // mmioDut.pop();
        // return !dut.error;
    }

    virtual bool mmio_fetch(reg_t addr, size_t len, uint8_t* bytes) override {
        return mmio_load(addr, len, bytes);
    }


    // virtual bool mmio_mmu(reg_t addr, size_t len, uint8_t* bytes) override {
    //     return mmio_load(addr, len, bytes);
    // }

    // Callback for processors to let the simulation know they were reset.
    virtual void proc_reset(unsigned id) override {
//        printf("proc_reset %d\n", id);
    }

    virtual const cfg_t& get_cfg() const override {
        return *cfg;
    }

    virtual const std::map<size_t, processor_t*>& get_harts() const override {
        return harts;
    }

    virtual const char* get_symbol(uint64_t addr) override {
//        printf("get_symbol %lx\n", addr);
        return NULL;
    }

    virtual void decoded(reg_t pc, insn_t insn, timing_t timing) override {
        sched.decoded(pc, insn, timing);
    }
};

std::string sim_name = "???";
uint64_t timeout = -1;
bool load_bin = false;
std::string load_bin_name;
bool spike_debug = false;
sim_wrap *wrap;
processor_t *proc;
state_t *state;
cfg_t cfg;

class success_exception : public std::exception { };
#define failure() throw std::exception()
#define success() throw success_exception()

//http://www.mario-konrad.ch/blog/programming/getopt.html
enum ARG
{
    ARG_LOAD_BOOT_BIN = 1,
    ARG_TIMEOUT,
    ARG_SPIKE_DEBUG,
    ARG_HELP = 'h',
};

static const struct option long_options[] =
{
    { "help", no_argument, 0, ARG_HELP },
    { "load-boot-bin", required_argument, 0, ARG_LOAD_BOOT_BIN },
    { "spike-debug", no_argument, 0, ARG_SPIKE_DEBUG },
    { "timeout", required_argument, 0, ARG_TIMEOUT },
};

std::string help_string = R"(
--help                  : Print this

Simulation setup
--load-boot-bin=FILE    : Load a binary file in the simulation bootrom memory.
--spike-debug           : Enable spike debug.
--timeout=INT           : Simulation time before failure (~number of cycles x 2)
)";

void parse_args_before_init(int argc, char** argv) {
    int result;
    int index = -1;
    while ((result = getopt_long(argc, argv, "h", long_options, &index)) != -1) {
        switch (result) {
            case ARG_HELP: printf("%s", help_string.c_str()); exit(0); break;
            case ARG_LOAD_BOOT_BIN: {
                load_bin = true;
                load_bin_name = std::string(optarg);
                size_t slash = load_bin_name.find_last_of('/');
                size_t sim_name_first = 0;
                if (slash != std::string::npos) {
                    sim_name_first = slash + 1;
                }
                size_t len = std::string::npos;
                size_t dot = load_bin_name.find_last_of('.');
                if (dot != std::string::npos) {
                    len = dot - sim_name_first;
                }
                sim_name = load_bin_name.substr(sim_name_first, len);
            } break;
            case ARG_SPIKE_DEBUG: spike_debug = true; break;
            case ARG_TIMEOUT: timeout = std::stoi(optarg); break;
            default: {
                printf("Unknown argument\n");
                failure();
                break;
            }
        }
    }
}

void parse_args_after_init(int argc, char** argv) {
    int result;
    int index = -1;
    while ((result = getopt_long(argc, argv, "h", long_options, &index)) != -1) {
        switch (result) {
            default: break;
        }
    }
}

void load_hex(std::string path, uint8_t *buf) {
    std::ifstream fs(path.c_str());
    std::string str;
    uint8_t *p = buf;
    while (fs >> str) {
        long x = strtol(str.c_str(), NULL, 16);
        std::size_t bytes = str.size() / 2;
        for (std::size_t i = 0; i < bytes; i++) {
            *p++ = (x & 255);
            x >>= 8;
        }
    }
    fs.close();
}

void spike_init() {
    std::string isa;
    std::string priv;

    FILE *fptr = stdout; //trace_ref ? fopen((outputDir + "/spike.log").c_str(),"w") : NULL;
    std::ofstream outfile("/dev/null", std::ofstream::binary);

    isa += "RV32I";
    isa += "MA";
    isa += "C";
    isa += "_Zba";
    isa += "_Zbb";
    isa += "_Zbs";
    isa += "_Zcb";
    isa += "_Zicntr";
    isa += "_smrnmi";
    priv = "MS";

    // Initialization of the config class
    cfg.isa = isa.c_str();
    cfg.priv = priv.c_str();
    cfg.misaligned = true;
    cfg.pmpregions = 0;
    cfg.hartids.push_back(0);

    // Instantiation
    wrap = new sim_wrap(&cfg);
    proc = new processor_t(isa.c_str(), "MSU", &cfg, wrap, 0, false, fptr, outfile);
    // proc->set_impl(IMPL_MMU_SV32, XLEN == 32);
    // proc->set_impl(IMPL_MMU_SV39, XLEN == 64);
    // proc->set_impl(IMPL_MMU_SV48, false);
    // proc->set_impl(IMPL_MMU, true);
    if(spike_debug) proc->debug = true;
    proc->set_pmp_num(1);
    // proc->enable_log_commits();
    state = proc->get_state();
    state->pc = 0x08000000;
    // for(int i = 0;i < 32;i++){
    //     float128_t tmp;
    //     tmp.v[0] = -1;
    //     tmp.v[1] = -1;
    //     state->FPR.write(i, tmp);
    // }
    if (load_bin) {
        load_hex(load_bin_name, wrap->imem);
    }
}

// void spike_step() {
    //Sync some CSR
    // uint64_t backup;
    // if (top->io_pipeline_probe_csr_read) {
    //     printf("read csr: %x %x\n", top->io_pipeline_probe_csr_addr, top->io_pipeline_probe_csr_data);
    //     switch (top->io_pipeline_probe_csr_addr) {
    //     case CSR_CYCLE:
    //         backup = state->mcycle->read();
    //         state->mcycle->unlogged_write(top->io_pipeline_probe_csr_data);
    //         state->mcycle->bump(0);
    //         break;
    //     case CSR_CYCLEH:
    //         backup = state->mcycle->read();
    //         state->mcycle->unlogged_write((((uint64_t)top->io_pipeline_probe_csr_data) << 32));
    //         state->mcycle->bump(0);
    //         break;
    //     }
    // }

    //Run spike for one commit or trap
    // proc->step(1);
    // state->mip->unlogged_write_with_mask(-1, 0);

    // if (top->io_pipeline_probe_csr_read) {
    //     switch (top->io_pipeline_probe_csr_addr) {
    //     case CSR_CYCLE:
    //     case CSR_CYCLEH:
    //         state->mcycle->unlogged_write(backup+2);
    //         state->mcycle->bump(0);
    //         break;
    //     }
    // }
// }

/*
void spike_next(uint32_t index, uint32_t inst_id, uint32_t pc, uint32_t inst, uint64_t cycles, uint32_t wb_addr, uint32_t wb_data) {
    bool found = false;
    bool machine_trap = false;
    uint32_t spike_pc = state->pc;
    spike_step();
    uint32_t spike_wb_addr = 0;
    uint32_t spike_wb_data = 0;
    for (auto item : state->log_reg_write) {
        if (item.first != 0) {
            if ((item.first & 0xf) == 0) {
                spike_wb_addr = item.first >> 4;
                spike_wb_data = item.second.v[0];
            } else {
                fprintf(stderr, "??? unknown spike trace %llx, addr=%llx, data=%llx, pc=%08x\n", item.first & 0xf, item.first >> 4, item.second.v[0], spike_pc);
                if (state->mcause->read() == 2) {
                    failure();
                }
                if ((item.first & 0xf) == 4 && (item.first >> 4) == 0x342) {
                    machine_trap = true;
                }
                // if ((item.first & 0xf) == 4 && (item.first >> 4) == 0x342) {
                //     skip_log = true;
                // }
            }
        }
    }
    assertEq("pc unmatch", pc, spike_pc);
    if (!machine_trap) {
        assertEq("inst unmatch", mask_rvc(inst), (uint32_t) state->last_inst.bits());
    }
    if (spike_wb_addr != 0) {
        // fprintf(stderr, "pc=%08x\n", pc);
        // fprintf(stderr, "inst=%08x\n", inst);
        // fprintf(stderr, "addr=%08x\n", wb_addr);
        // fprintf(stderr, "data=%08x (actual)\n", wb_data);
        // fprintf(stderr, "data=%08x (expected)\n", spike_wb_data);
        assertEq("reg write addr unmatch", wb_addr, spike_wb_addr);
        assertEq("reg write data unmatch", wb_data, spike_wb_data);
    }
}
*/

void sim_loop() {
    uint64_t retired = 0;
    try {
        while (true) {
            if (timeout != -1 && sched.cycles() >= timeout) {
                printf("\033[31mFAILED timeout %llu / %llu [retired / total cycles]\033[39m\n", retired, sched.cycles());
                failure();
            }

            uint32_t spike_pc = state->pc;
            // spike_step();
            size_t rest = proc->step(MAX_STEPS, true);
            retired += MAX_STEPS - rest;
            sched.timesim();
            state->mcycle->unlogged_write(sched.cycles());
            state->mcycle->bump(0);
            // printf("\033[31m %llu / %llu [retired / total cycles]\033[39m\n", retired, sched.cycles());
            int32_t mcause = state->mcause->read();
            if (mcause > 0) {
                if (mcause == 11) {
                    // fprintf(stderr, "ecall from umode, mcause=%d\n", mcause);
                    success();
                } else {
                    fprintf(stderr, "caught trap, mcause=%d\n", mcause);
                    failure();
                }
            }
        }
    } catch (const success_exception e) {
        printf("SUCCESS %llu / %llu [retired / total cycles]\n", retired, sched.cycles());
        // printf("SUCCESS %s\n", sim_name.c_str());
    } catch (const std::exception& e) {
        printf("TIME=%llu\n", sched.cycles());
        printf("\033[31mFAILURE %s\033[39m\n", sim_name.c_str());
    }
}

void cleanup() {
    exit(0);
}

int main(int argc, char** argv, char** env) {
    signal(SIGSEGV, handler_crash);
    try {
        parse_args_before_init(argc, argv);
        spike_init();
        parse_args_after_init(argc, argv);
        sim_loop();
    } catch (const std::exception &e) {
    }
    cleanup();
    return 0;
}
