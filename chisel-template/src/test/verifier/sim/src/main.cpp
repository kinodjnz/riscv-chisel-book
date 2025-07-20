#include <verilated.h>
#include <verilated_fst_c.h>
#include <Vriscv.h>
#include <Vriscv___024root.h>
#include <execinfo.h>
#include <signal.h>
#include <getopt.h>
#include "processor.h"
#include "simif.h"

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

class sim_wrap: public simif_t {
public:
    uint8_t imem[16384];
    uint8_t dmem[16384];
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
        if (0 <= addr && addr < 16384) {
            return (char *)&imem[addr];
        }
        if (0x20000000 <= addr && addr < 0x20000000 + 16384) {
            return (char *)&dmem[addr - 0x20000000];
        }
        return NULL;
    }
    // used for MMIO addresses
    virtual bool mmio_load(reg_t addr, size_t len, uint8_t* bytes) override {
//        printf("mmio_load %lx %ld\n", addr, len);
        if ((addr & 0xffff0000) != 0x30000000) return false;
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
//        printf("mmio_store %lx %ld\n", addr, len);
        if ((addr & 0xffff0000) != 0x30000000) return false;
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
};

struct inst_log_t {
    uint32_t pc;
    uint32_t inst;
    uint64_t cycles;
    uint32_t wb_addr;
    uint32_t data;
};

std::string sim_name = "???";
vluint64_t main_time = 0;
vluint64_t timeout = -1;
bool load_bin = false;
std::string load_bin_name;
bool trace_fst = false;
std::string fst_name;
bool trace_kanata = false;
std::string kanata_name;
FILE *kanata_fp = nullptr;
VerilatedFstC* tfp = nullptr;
// uint64_t load_bin_address;
Vriscv *top = nullptr;
sim_wrap *wrap;
processor_t *proc;
state_t *state;
cfg_t cfg;
std::deque<inst_log_t> inst_log;
const size_t max_inst_log = 10;
const uint64_t max_drift_cycles = 30;

class success_exception : public std::exception { };
#define failure() throw std::exception();
#define success() throw success_exception();

//http://www.mario-konrad.ch/blog/programming/getopt.html
enum ARG
{
    ARG_LOAD_BOOT_BIN = 1,
    ARG_TIMEOUT,
    ARG_TRACE_FST,
    ARG_TRACE_KANATA,
    ARG_HELP = 'h',
};

static const struct option long_options[] =
{
    { "help", no_argument, 0, ARG_HELP },
    { "load-boot-bin", required_argument, 0, ARG_LOAD_BOOT_BIN },
    { "timeout", required_argument, 0, ARG_TIMEOUT },
    { "trace-fst", required_argument, 0, ARG_TRACE_FST },
    { "trace-kanata", required_argument, 0, ARG_TRACE_KANATA },
};

std::string help_string = R"(
--help                  : Print this

Simulation setup
--load-boot-bin=FILE    : Load a binary file in the simulation bootrom memory.
--timeout=INT           : Simulation time before failure (~number of cycles x 2)
--trace-fst=FILE        : Dump trace to fst file.
--trace-kanata=FILE     : Output pipeline log in Kanata format.
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
            case ARG_TIMEOUT: timeout = std::stoi(optarg); break;
            case ARG_TRACE_FST: {
                trace_fst = true;
                fst_name = std::string(optarg);
            } break;
            case ARG_TRACE_KANATA: {
                trace_kanata = true;
                kanata_name = std::string(optarg);
            } break;
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

void verilator_init(int argc, char** argv) {
    Verilated::debug(0);
    Verilated::randReset(2);
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);
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
    // if(spike_debug) proc->debug = true;
    proc->debug = true;
    proc->set_pmp_num(1);
    proc->enable_log_commits();
    state = proc->get_state();
    state->pc = 0;
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

void rtl_init() {
    top = new Vriscv;
    if (load_bin) {
        VL_READMEM_N(
            true,
            32,
            4096,
            0,
            load_bin_name.c_str(),
            &(top->rootp->SimTop__DOT__boot_rom__DOT__imem),
            0,
            ~0ULL);
    }
    #ifdef VERILATOR_TRACE
    if (trace_fst) {
        tfp = new VerilatedFstC;
        top->trace(tfp, 100); // Trace 100 levels of hierarchy
        tfp->open(fst_name.c_str());
    }
    #endif
    if (trace_kanata) {
        kanata_fp = fopen(kanata_name.c_str(), "w");
        if (kanata_fp == nullptr) {
            throw std::runtime_error("Open kanata file failed");
        }
        fprintf(kanata_fp, "Kanata\t0004\n");
    }
}

void spike_step() {
    //Sync some CSR
//     state->mip->unlogged_write_with_mask(-1, 0);
    uint64_t backup;
    if (top->io_pipeline_probe_csr_read) {
        // printf("read csr: %x %x\n", top->io_pipeline_probe_csr_addr, top->io_pipeline_probe_csr_data);
        switch (top->io_pipeline_probe_csr_addr) {
        case CSR_CYCLE:
            backup = state->mcycle->read();
            state->mcycle->unlogged_write(top->io_pipeline_probe_csr_data);
            break;
        case CSR_CYCLEH:
            backup = state->mcycle->read();
            state->mcycle->unlogged_write((((uint64_t)top->io_pipeline_probe_csr_data) << 32));
            break;
        }
    }

//     if(robCtx.csrReadDone){
//         switch(robCtx.csrAddress){
//         case MIP:
//         case SIP:
//         case UIP:
//             backup = state->mie->read();
//             state->mip->unlogged_write_with_mask(-1, robCtx.csrReadData);
//             state->mie->unlogged_write_with_mask(MIE_MTIE | MIE_MEIE |  MIE_MSIE | MIE_SEIE, 0);
// //                                cout << main_time << " " << hex << robCtx.csrReadData << " " << state->mip->read()  << " " << state->csrmap[robCtx.csrAddress]->read() << dec << endl;
//             break;
//         case CSR_MCYCLE:
//         case CSR_UCYCLE:
//             backup = state->minstret->read();
//             state->minstret->unlogged_write(robCtx.csrReadData+1); //+1 patch a spike internal workaround XD
//             break;
//         case CSR_MCYCLEH:
//         case CSR_UCYCLEH:
//             backup = state->minstret->read();
//             state->minstret->unlogged_write((((u64)robCtx.csrReadData) << 32)+1);
//             break;
//         default:
//             if(robCtx.csrAddress >= CSR_MHPMCOUNTER3 && robCtx.csrAddress <= CSR_MHPMCOUNTER31){
//                 state->csrmap[robCtx.csrAddress]->unlogged_write(robCtx.csrReadData);
//             }
//             break;
//         }
//     }

    //Run spike for one commit or trap
    proc->step(1);
    // state->mip->unlogged_write_with_mask(-1, 0);

    if (top->io_pipeline_probe_csr_read) {
        switch (top->io_pipeline_probe_csr_addr) {
        case CSR_CYCLE:
        case CSR_CYCLEH:
            state->mcycle->unlogged_write(backup+2);
            break;
        }
    }

    //Sync back some CSR
    // if(robCtx.csrReadDone){
    //     switch(robCtx.csrAddress){
    //     case MIP:
    //     case SIP:
    //     case UIP:
    //         state->mie->unlogged_write_with_mask(MIE_MTIE | MIE_MEIE |  MIE_MSIE | MIE_SEIE, backup);
    //         break;
    //     case CSR_MCYCLE:
    //     case CSR_MCYCLEH:
    //         state->minstret->unlogged_write(backup+2);
    //         break;
    //         break;
    //     }
    // }
}

struct instruction_trace {
    uint32_t inst_id;
    uint32_t pc;
    uint32_t inst;
};

const uint32_t INST_TRACE_SIZE = 256;

instruction_trace inst_traces[INST_TRACE_SIZE];

uint32_t mask_rvc(uint32_t inst) {
    return (inst & 3) == 3 ? inst : inst & 0xffff;
}

void spike_next(uint32_t index, uint32_t inst_id, uint32_t pc, uint32_t inst, uint64_t cycles, uint32_t wb_addr, uint32_t wb_data) {
    bool found = false;
    for (auto &&it = inst_log.begin(); it != inst_log.end(); ++it) {
        if (it->pc == pc) {
            assertEq("inst unmatch", mask_rvc(inst), (uint32_t) it->inst);
            if (it->wb_addr != 0) {
                assertEq("reg write addr unmatch", wb_addr, it->wb_addr);
                assertEq("reg write data unmatch", wb_data, it->data);
            }
            inst_log.erase(it);
            found = true;
            break;
        }
    }
    while (!found && inst_log.size() < max_inst_log) {
        bool skip_log = false;
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
                    fprintf(stderr, "??? unknown spike trace %llx, addr=%llx, pc=%08x\n", item.first & 0xf, item.first >> 4, spike_pc);
                    if (state->mcause->read() == 2) {
                        failure();
                    }
                    if ((item.first & 0xf) == 4 && (item.first >> 4) == 0x342) {
                        skip_log = true;
                    }
                }
            }
        }
        if (spike_pc == pc) {
            assertEq("inst unmatch", mask_rvc(inst), (uint32_t) state->last_inst.bits());
            if (spike_wb_addr != 0) {
                // fprintf(stderr, "pc=%08x\n", pc);
                // fprintf(stderr, "inst=%08x\n", inst);
                // fprintf(stderr, "addr=%08x\n", wb_addr);
                // fprintf(stderr, "data=%08x (actual)\n", wb_data);
                // fprintf(stderr, "data=%08x (expected)\n", spike_wb_data);
                assertEq("reg write addr unmatch", wb_addr, spike_wb_addr);
                assertEq("reg write data unmatch", wb_data, spike_wb_data);
            }
            found = true;
            break;
        } else if (!skip_log) {
            inst_log.push_back(inst_log_t(spike_pc, state->last_inst.bits(), cycles, spike_wb_addr, spike_wb_data));
        }
    }
    if (!found) {
        fprintf(stderr, "pc not found: %08x\n", pc);
        fprintf(stderr, "inst: %08x\n", inst);
        failure();
    }
}

void trace_kanata_log() {
    if (top->io_pipeline_probe_if2_valid1) {
        uint32_t inst_id = top->io_pipeline_probe_if2_inst_id1;
        fprintf(kanata_fp, "I\t%d\t%d\t0\n", inst_id, inst_id);
        fprintf(kanata_fp, "L\t%d\t0\t%08x %08x\n", inst_id, top->io_pipeline_probe_if2_pc1, top->io_pipeline_probe_if2_inst1);
        fprintf(kanata_fp, "S\t%d\t0\tIF\n", inst_id);
    }
    if (top->io_pipeline_probe_if2_valid2) {
        uint32_t inst_id = top->io_pipeline_probe_if2_inst_id2;
        fprintf(kanata_fp, "I\t%d\t%d\t0\n", inst_id, inst_id);
        fprintf(kanata_fp, "L\t%d\t0\t%08x %08x\n", inst_id, top->io_pipeline_probe_if2_pc2, top->io_pipeline_probe_if2_inst2);
        fprintf(kanata_fp, "S\t%d\t0\tIF\n", inst_id);
    }
    if (top->io_pipeline_probe_ida_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tID\n", top->io_pipeline_probe_ida_inst_id);
    }
    if (top->io_pipeline_probe_idb_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tID\n", top->io_pipeline_probe_idb_inst_id);
    }
    if (top->io_pipeline_probe_rrd_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tRRD\n", top->io_pipeline_probe_rrd_inst_id);
    }
    if (top->io_pipeline_probe_rrd_i2_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tRRD\n", top->io_pipeline_probe_rrd_i2_inst_id);
    }
    if (top->io_pipeline_probe_ex1_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tEX1\n", top->io_pipeline_probe_ex1_inst_id);
    }
    if (top->io_pipeline_probe_ex1_i2_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tEX1\n", top->io_pipeline_probe_ex1_i2_inst_id);
    }
    if (top->io_pipeline_probe_ex2_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tEX2\n", top->io_pipeline_probe_ex2_inst_id);
    }
    if (top->io_pipeline_probe_mem1_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tMEM1\n", top->io_pipeline_probe_mem1_inst_id);
    }
    if (top->io_pipeline_probe_mem2_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tMEM2\n", top->io_pipeline_probe_mem2_inst_id);
    }
    if (top->io_pipeline_probe_mem3_valid) {
        fprintf(kanata_fp, "S\t%d\t0\tMEM3\n", top->io_pipeline_probe_mem3_inst_id);
    }
    fprintf(kanata_fp, "C\t1\n");
    if (top->io_pipeline_probe_if2_valid1) {
        fprintf(kanata_fp, "E\t%d\t0\tIF\n", top->io_pipeline_probe_if2_inst_id1);
    }
    if (top->io_pipeline_probe_if2_valid2) {
        fprintf(kanata_fp, "E\t%d\t0\tIF\n", top->io_pipeline_probe_if2_inst_id2);
    }
    if (top->io_pipeline_probe_ida_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tID\n", top->io_pipeline_probe_ida_inst_id);
    }
    if (top->io_pipeline_probe_idb_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tID\n", top->io_pipeline_probe_idb_inst_id);
    }
    if (top->io_pipeline_probe_rrd_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tRRD\n", top->io_pipeline_probe_rrd_inst_id);
    }
    if (top->io_pipeline_probe_rrd_i2_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tRRD\n", top->io_pipeline_probe_rrd_i2_inst_id);
    }
    if (top->io_pipeline_probe_ex1_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tEX1\n", top->io_pipeline_probe_ex1_inst_id);
    }
    if (top->io_pipeline_probe_ex1_i2_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tEX1\n", top->io_pipeline_probe_ex1_i2_inst_id);
    }
    if (top->io_pipeline_probe_ex1_i2_retired) {
        uint32_t inst_id = top->io_pipeline_probe_ex1_i2_inst_id;
        fprintf(kanata_fp, "R\t%d\t%d\t0\n", inst_id, inst_id);
    }
    if (top->io_pipeline_probe_ex2_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tEX2\n", top->io_pipeline_probe_ex2_inst_id);
    }
    if (top->io_pipeline_probe_ex2_retired) {
        uint32_t inst_id = top->io_pipeline_probe_ex2_inst_id;
        fprintf(kanata_fp, "R\t%d\t%d\t0\n", inst_id, inst_id);
    }
    if (top->io_pipeline_probe_mem1_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tMEM1\n", top->io_pipeline_probe_mem1_inst_id);
    }
    if (top->io_pipeline_probe_mem2_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tMEM2\n", top->io_pipeline_probe_mem2_inst_id);
    }
    if (top->io_pipeline_probe_mem3_valid) {
        fprintf(kanata_fp, "E\t%d\t0\tMEM3\n", top->io_pipeline_probe_mem3_inst_id);
    }
    if (top->io_pipeline_probe_mem3_retired) {
        uint32_t inst_id = top->io_pipeline_probe_mem3_inst_id;
        fprintf(kanata_fp, "R\t%d\t%d\t0\n", inst_id, inst_id);
    }
}

void sim_loop() {
    try {
        uint64_t retired = 0;
        uint64_t cycles = 0;
        top->clock = 0;
        while (!Verilated::gotFinish()) {
            ++main_time;

            if (main_time == timeout) {
                printf("\033[31mFAILED timeout %llu / %llu [retired / total cycles]\033[39m\n", retired, cycles);
                failure();
            }
            top->clock = !top->clock;
            top->reset = (main_time <= 4) ? 1 : 0;
            if (!top->clock) {
                top->eval();
            if (Verilated::gotFinish()) failure();
            } else {
                if (!top->reset) {
                    if (top->io_sim_probe_exit) {
                        if (top->io_sim_probe_gp == 1) {
                            printf("\033[32mSUCCESS %llu / %llu [retired / total cycles]\033[39m\n", retired, cycles);
                            success();
                        } else {
                            printf("\033[31mFAILED gp=%d %llu / %llu [retired / total cycles]\033[39m\n", top->io_sim_probe_gp, retired, cycles);
                            failure();
                        }
                    }
                    ++cycles;
                    if (trace_kanata) {
                        trace_kanata_log();
                    }
                    if (top->io_pipeline_probe_if2_valid1) {
                        uint32_t index = top->io_pipeline_probe_if2_inst_id1 % INST_TRACE_SIZE;
                        uint32_t inst_id = top->io_pipeline_probe_if2_inst_id1;
                        inst_traces[index].inst_id = inst_id;
                        inst_traces[index].pc = top->io_pipeline_probe_if2_pc1;
                        inst_traces[index].inst = top->io_pipeline_probe_if2_inst1;
                        fprintf(stderr, "if2 valid: inst_id=%u pc=%x\n", top->io_pipeline_probe_if2_inst_id1, top->io_pipeline_probe_if2_pc1);
                    }
                    if (top->io_pipeline_probe_if2_valid2) {
                        uint32_t index = top->io_pipeline_probe_if2_inst_id2 % INST_TRACE_SIZE;
                        uint32_t inst_id = top->io_pipeline_probe_if2_inst_id2;
                        inst_traces[index].inst_id = inst_id;
                        inst_traces[index].pc = top->io_pipeline_probe_if2_pc2;
                        inst_traces[index].inst = top->io_pipeline_probe_if2_inst2;
                        fprintf(stderr, "if2 valid: inst_id=%u pc=%x\n", top->io_pipeline_probe_if2_inst_id2, top->io_pipeline_probe_if2_pc2);
                    }
                    if (top->io_pipeline_probe_ex1_i2_retired) {
                        ++retired;
                        uint32_t index = top->io_pipeline_probe_ex1_i2_inst_id % INST_TRACE_SIZE;
                        uint32_t inst_id = inst_traces[index].inst_id;
                        uint32_t pc;
                        uint32_t inst;
                        if (inst_id != top->io_pipeline_probe_ex1_i2_inst_id) {
                            fprintf(stderr, "retired ex2: unknown inst_id=%u\n", top->io_pipeline_probe_ex1_i2_inst_id);
                            failure();
                        } else {
                            pc = inst_traces[index].pc;
                            inst = inst_traces[index].inst;
                            fprintf(stderr, "retired ex1: pc=0x%08x, inst=0x%08x inst_id=%08x\n", pc, inst, inst_id);
                        }
                        spike_next(index, inst_id, pc, inst, cycles, top->io_pipeline_probe_ex1_i2_wb_addr, top->io_pipeline_probe_ex1_i2_wb_data);
                    }
                    if (top->io_pipeline_probe_ex2_retired) {
                        ++retired;
                        uint32_t index = top->io_pipeline_probe_ex2_inst_id % INST_TRACE_SIZE;
                        uint32_t inst_id = inst_traces[index].inst_id;
                        uint32_t pc;
                        uint32_t inst;
                        if (inst_id != top->io_pipeline_probe_ex2_inst_id) {
                            fprintf(stderr, "retired ex2: unknown inst_id=%u\n", top->io_pipeline_probe_ex2_inst_id);
                            failure();
                        } else {
                            pc = inst_traces[index].pc;
                            inst = inst_traces[index].inst;
                            fprintf(stderr, "retired ex2: pc=0x%08x, inst=0x%08x inst_id=%08x\n", pc, inst, inst_id);
                        }
                        spike_next(index, inst_id, pc, inst, cycles, top->io_pipeline_probe_ex2_wb_addr, top->io_pipeline_probe_ex2_wb_data);
                    }
                    if (top->io_pipeline_probe_mem3_retired) {
                        ++retired;
                        uint32_t index = top->io_pipeline_probe_mem3_inst_id % INST_TRACE_SIZE;
                        uint32_t inst_id = inst_traces[index].inst_id;
                        uint32_t pc;
                        uint32_t inst;
                        if (inst_id != top->io_pipeline_probe_mem3_inst_id) {
                            fprintf(stderr, "retired mem: unknown inst_id=%u\n", top->io_pipeline_probe_mem3_inst_id);
                            failure();
                        } else {
                            pc = inst_traces[index].pc;
                            inst = inst_traces[index].inst;
                            printf("retired mem: pc=0x%08x, inst=0x%08x\n", pc, inst);
                            printf("retired cycles=%llu, retired=%llu\n", cycles, retired);
                        }
                        spike_next(index, inst_id, pc, inst, cycles, top->io_pipeline_probe_mem3_wb_addr, top->io_pipeline_probe_mem3_wb_data);
                    }
                }
                if (!inst_log.empty()) {
                    if (inst_log[0].cycles + max_drift_cycles < cycles) {
                        fprintf(stderr, "not retired pc=%08x\n", inst_log[0].pc);
                        failure();
                    }
                }
                top->eval();
                if (trace_fst) {
                    tfp->dump(cycles);
                }
                if (Verilated::gotFinish()) failure();
            }
        }
    } catch (const success_exception e) {
        printf("SUCCESS %s\n", sim_name.c_str());
    } catch (const std::exception& e) {
        ++main_time;
        printf("TIME=%llu\n", main_time);
        printf("\033[31mFAILURE %s\033[39m\n", sim_name.c_str());
    }
}

void cleanup() {
    // if(fptr) {
    //     fflush(fptr);
    //     fclose(fptr);
    // }

    if (kanata_fp != nullptr) {
        fclose(kanata_fp);
        kanata_fp = nullptr;
    }

    if (top != nullptr) {
        top->final();
        #ifdef VERILATOR_TRACE
        if (trace_fst) {
            tfp->close();
        }
        #endif

        delete top;
        // if(proc) delete proc;
        top = nullptr;
    }
    exit(0);
}

int main(int argc, char** argv, char** env) {
    signal(SIGSEGV, handler_crash);
    try {
        parse_args_before_init(argc, argv);
        verilator_init(argc, argv);
        rtl_init();
        spike_init();
        parse_args_after_init(argc, argv);
        sim_loop();
    } catch (const std::exception &e) {
    }
    cleanup();
    return 0;
}
