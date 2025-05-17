#include <verilated.h>
#include <verilated_fst_c.h>
#include <Vriscv.h>
#include <Vriscv___024root.h>
#include <execinfo.h>
#include <signal.h>
#include <getopt.h>

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

std::string sim_name = "???";
vluint64_t main_time = 0;
vluint64_t timeout = -1;
bool load_bin = false;
std::string load_bin_name;
bool trace_fst = false;
std::string fst_name;
VerilatedFstC* tfp = nullptr;
// uint64_t load_bin_address;
Vriscv *top = nullptr;

class success_exception : public std::exception { };
#define failure() throw std::exception();
#define success() throw success_exception();

//http://www.mario-konrad.ch/blog/programming/getopt.html
enum ARG
{
    ARG_LOAD_BOOT_BIN = 1,
    ARG_TIMEOUT,
    ARG_TRACE_FST,
    ARG_HELP = 'h',
};

static const struct option long_options[] =
{
    { "help", no_argument, 0, ARG_HELP },
    { "load-boot-bin", required_argument, 0, ARG_LOAD_BOOT_BIN },
    { "timeout", required_argument, 0, ARG_TIMEOUT },
    { "trace-fst", required_argument, 0, ARG_TRACE_FST },
};

std::string help_string = R"(
--help                  : Print this

Simulation setup
--load-boot-bin=FILE    : Load a binary file in the simulation bootrom memory.
--timeout=INT           : Simulation time before failure (~number of cycles x 2)
--trace-fst=FILE        : Dump trace to fst file.
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
}

struct instruction_trace {
    uint32_t inst_id;
    uint32_t pc;
    uint32_t inst;
};

const uint32_t INST_TRACE_SIZE = 256;

instruction_trace inst_traces[INST_TRACE_SIZE];

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
                    if (top->io_pipeline_probe_if2_valid) {
                        uint32_t index = top->io_pipeline_probe_if2_inst_id % INST_TRACE_SIZE;
                        inst_traces[index].inst_id = top->io_pipeline_probe_if2_inst_id;
                        inst_traces[index].pc = top->io_pipeline_probe_if2_pc;
                        inst_traces[index].inst = top->io_pipeline_probe_if2_inst;
                    }
                    if (top->io_pipeline_probe_ex2_retired) {
                        ++retired;
                        uint32_t index = top->io_pipeline_probe_ex2_inst_id % INST_TRACE_SIZE;
                        uint32_t inst_id = inst_traces[index].inst_id;
                        if (inst_id != top->io_pipeline_probe_ex2_inst_id) {
                            // printf("retired ex2: unknown inst_id=%u\n", inst_id);
                        } else {
                            uint32_t pc = inst_traces[index].pc;
                            uint32_t inst = inst_traces[index].inst;
                            // printf("retired ex2: pc=0x%08x, inst=0x%08x\n", pc, inst);
                        }
                    }
                    if (top->io_pipeline_probe_mem3_retired) {
                        ++retired;
                        uint32_t index = top->io_pipeline_probe_mem3_inst_id % INST_TRACE_SIZE;
                        uint32_t inst_id = inst_traces[index].inst_id;
                        if (inst_id != top->io_pipeline_probe_mem3_inst_id) {
                            // printf("retired mem: unknown inst_id=%u\n", inst_id);
                        } else {
                            uint32_t pc = inst_traces[index].pc;
                            uint32_t inst = inst_traces[index].inst;
                            // printf("retired mem: pc=0x%08x, inst=0x%08x\n", pc, inst);
                        }
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
        printf("FAILURE %s\n", sim_name.c_str());
    }
}

void cleanup() {
    // if(fptr) {
    //     fflush(fptr);
    //     fclose(fptr);
    // }

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
        parse_args_after_init(argc, argv);
        sim_loop();
    } catch (const std::exception &e) {
    }
    cleanup();
    return 0;
}
