#include <verilated.h>
#include <verilated_fst_c.h>
#include <Vfetch.h>
#include <Vfetch___024root.h>
#include <memory>
#include <generator>
#include <ranges>
#include "catch_amalgamated.hpp"

template<typename T> class verilated_ptr {
private:
    std::unique_ptr<T> vp_;
    std::unique_ptr<VerilatedFstC> tfp_;
public:
    explicit verilated_ptr(T *vp, const char *fst_filename): vp_(vp), tfp_(new VerilatedFstC) {
        vp_->trace(&*tfp_, 100); // Trace 100 levels of hierarchy
        tfp_->open(fst_filename);
    }
    verilated_ptr(verilated_ptr<T> &other): vp_(other.vp_.release()), tfp_(other.tfp_.release()) {
    }
    ~verilated_ptr() {
        if (vp_) {
            vp_->final();
        }
        if (tfp_) {
            tfp_->close();
        }
    }
    T *operator->() {
        return &*vp_;
    }
    T &operator*() {
        return *vp_;
    }
    void dump(uint64_t cycles) {
        tfp_->dump(cycles);
    }
};

class context {
private:
    std::unique_ptr<VerilatedContext> ctxp_;
public:
    explicit context(): ctxp_(new VerilatedContext) {
        ctxp_->debug(0);
        ctxp_->randReset(2);
        ctxp_->traceEverOn(true);
        // ctxp_->commandArgs(0, nullptr);
    }
    VerilatedContext *vcontext() {
        return ctxp_.get();
    }
    std::string cycles_str() const {
        return std::format("In cycle {}", ctxp_->time());
    }
    uint64_t cycles() const {
        return ctxp_->time();
    }
    void advance_cycle() {
        ctxp_->timeInc(1);
    }
};

class task {
private:
    std::string name_;
    std::generator<int64_t> g_;
    decltype(((std::generator<int64_t> *)0)->begin()) it_;
    decltype(((std::generator<int64_t> *)0)->end()) last_;
    bool is_essential_;
    task(const task&) = delete;
    task& operator=(const task&) = delete;
public:
    explicit task(std::string_view name, auto &&gen, bool is_essential = true):
        name_(name), g_(gen()), it_(g_.begin()), last_(g_.end()), is_essential_(is_essential) {}
    std::string_view name() const {
        return name_;
    }
    bool finished() const {
        return it_ == last_;
    }
    bool is_essential() const {
        return is_essential_;
    }
    int64_t sleep_cycles() const {
        return *it_;
    }
    void next() {
        ++it_;
    }
};

enum class CyclePhase {
    WRITE = 0,
    READ = 1,
};

class task_runner {
private:
    std::vector<std::pair<uint64_t, std::shared_ptr<task>>> tasks_;
    context ctx_;
    uint64_t timeout_cycles_;

    static int compare_task(std::pair<uint64_t, std::shared_ptr<task>> &lhs, std::pair<uint64_t, std::shared_ptr<task>> &rhs) {
        return rhs.first < lhs.first;
    }
    uint64_t time_of(uint64_t cycles, CyclePhase phase) const {
        return cycles * 2 + static_cast<uint64_t>(phase);
    }
    void push_task(std::shared_ptr<task> task, int64_t sleep_cycles, CyclePhase phase) {
        CyclePhase next_phase = sleep_cycles < 0 ? CyclePhase::READ : CyclePhase::WRITE;
        uint64_t fixed_cycles = sleep_cycles < 0 ? -sleep_cycles - 1 : sleep_cycles;
        uint64_t t = time_of(ctx_.cycles() + fixed_cycles, next_phase);
        tasks_.push_back(std::make_pair(t, task));
        std::push_heap(tasks_.begin(), tasks_.end(), compare_task);
        // WARN(std::format("task enqueued: {} {} {}", task->name(), t, ctx_.cycles()));
    }
    std::optional<std::shared_ptr<task>> pop_task(CyclePhase phase) {
        if (!tasks_.empty() && tasks_.front().first <= time_of(ctx_.cycles(), phase)) {
            // WARN(std::format("task retired: {} {} {}", tasks_.front().second->name(), time_of(ctx_.cycles(), phase), ctx_.cycles()));
            std::pop_heap(tasks_.begin(), tasks_.end(), compare_task);
            auto res = tasks_.back().second;
            tasks_.pop_back();
            return res;
        } else {
            return std::nullopt;
        }
    }
public:
    explicit task_runner(uint64_t timeout_cycles): timeout_cycles_(timeout_cycles) {}
    context *ctx() {
        return &ctx_;
    }
    VerilatedContext *vcontext() {
        return ctx_.vcontext();
    }
    void start_task(std::shared_ptr<task> task) {
        int64_t sleep_cycles = task->sleep_cycles();
        push_task(task, sleep_cycles, CyclePhase::WRITE);
    }
    bool process_task(CyclePhase phase) {
        auto task = pop_task(phase);
        while (task) {
            if (task.value()->is_essential() && task.value()->finished()) {
                return true;
            }
            if (!task.value()->finished()) {
                task.value()->next();
                int64_t sleep_cycles = task.value()->sleep_cycles();
                if (phase == CyclePhase::READ && sleep_cycles < 0) {
                    WARN(std::format("invalid {} {} {}", task.value()->name(), sleep_cycles, ctx_.cycles()));
                    FAIL("sleep cycles cannot be negative while READ phase");
                }
                push_task(task.value(), sleep_cycles, phase);
            }
            task = pop_task(phase);
        }
        return false;
    }
    template <typename T>
    void run(verilated_ptr<T> sut) {
        int64_t reset_time = 0;
        sut->clock = 0;
        while (!vcontext()->gotFinish() && reset_time < 4) {
            ++reset_time;
            sut->clock = !sut->clock;
            sut->reset = 1;
            sut->eval();
            sut.dump(reset_time-1);
        }
        sut->reset = 0;
        while (!vcontext()->gotFinish()) {
            ++reset_time;
            if (ctx_.cycles() >= timeout_cycles_) {
                FAIL(std::format("Timeout {} cycles", timeout_cycles_));
            }
            sut->clock = !sut->clock;
            CyclePhase phase = sut->clock ? CyclePhase::WRITE : CyclePhase::READ;
            if (process_task(phase)) {
                break;
            }
            sut->eval();
            sut.dump(reset_time-1);
            if (!sut->clock) {
                ctx_.advance_cycle();
            }
        }
        sut->final();
    }
};

std::generator<int64_t> input_task(Vfetch *vp, context *ctx) {
    co_yield 0;
    vp->io_ft_flush_en = 1;
    vp->io_ft_flush_iaddr = 0x08000000 >> 1;
    co_yield 1;
    vp->io_ft_flush_en = 0;
    vp->io_ft_flush_iaddr = 0x00000000 >> 1;
    co_yield 1;
}

static const std::vector<uint64_t> imem_32bit_insts = {
    0x00000013'00000003,
    0x00000033'00000023,
    0x00000053'00000043,
    0x00000073'00000063,
};

static const std::vector<uint64_t> imem_rvc_insts = {
    0x00320022'00120002, // 0000
    0x00620052'00000043, //  001
    0x00920000'00830072, //  010
    0x000000b3'000000a3, //   11
    0x000000e3'00d200c2, //  100
    0x01130102'000000f3, //  101
    0x01420132'01220000, // 000-
    0x01730000'01630152, //  110
    0x01920000'01830000, //  01-
    0x01c301b2'000001a3, //  101 (2)
    0x01e30000'01d30000, //  11-
    0x00000203'01f20000, //  10-
};

std::generator<int64_t> imem_mock_task(Vfetch *vp, context *ctx, const std::vector<uint64_t> &data) {
    bool valid = false;
    uint64_t idata = 0;
    co_yield 0;
    while (true) {
        vp->io_ft_imem_inst = idata;
        vp->io_ft_imem_valid = valid;
        co_yield -1;
        // WARN(std::format("io_ft_imem_en={}", vp->io_ft_imem_en));
        // WARN(std::format("io_ft_imem_addr={0:#x}", vp->io_ft_imem_addr));
        if (vp->io_ft_imem_en) {
            idata = (vp->io_ft_imem_addr & 0xff000000) == 0x08000000 ? data[((vp->io_ft_imem_addr - 0x08000000) >> 3) % data.size()] : 0;
            valid = true;
        } else {
            idata = 0;
            valid = false;
        }
        co_yield 1;
    }
}

enum class inst_attr {
    BR = 1,
    DJUMP = 2,
    DCALL = 3,
    RET = 4,
};

struct bp_cell {
    std::optional<uint32_t> zbtb_target;
    std::optional<inst_attr> btb_attr;
    uint32_t btb_target;
    bool pht_taken;
};

static const std::vector<bp_cell> bp_none = {
    bp_cell(std::nullopt, std::nullopt, 0),
};

static const std::vector<bp_cell> bp_32bit = {
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x04000002), std::make_optional(inst_attr::DJUMP), 0x04000002, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x04000008), std::make_optional(inst_attr::BR), 0x04000008, true),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x0400000a), std::make_optional(inst_attr::DJUMP), 0x0400000a, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x04000004), std::make_optional(inst_attr::BR), 0x04000004, true),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x0400000c), std::make_optional(inst_attr::DJUMP), 0x0400000c, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
};

static const std::vector<bp_cell> bp_miss_32bit = {
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::make_optional(inst_attr::BR), 0x04000002, true),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000008, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::make_optional(inst_attr::BR), 0x0400000a, true),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000004, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::make_optional(inst_attr::BR), 0x0400000c, true),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
};

static const std::vector<bp_cell> bp_mixed_32bit = {
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x04000004), std::make_optional(inst_attr::DJUMP), 0x04000002, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::make_optional(inst_attr::BR), 0x04000008, true),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x04000002), std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400000a, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x04000004), std::make_optional(inst_attr::DJUMP), 0x04000004, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x04000008), std::make_optional(inst_attr::BR), 0x0400000c, true),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::nullopt, std::nullopt, 0, false),
    bp_cell(std::make_optional(0x04000010), std::nullopt, 0, false),
};

static const std::vector<bp_cell> bp_rvc = {
    /*00 */ bp_cell(std::make_optional(0x04000003), std::make_optional(inst_attr::DJUMP), 0x04000003, false),
    /*01 */ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*02 */ bp_cell(std::make_optional(0x0400000c), std::make_optional(inst_attr::DJUMP), 0x0400000c, false),
    /*03 */ bp_cell(std::make_optional(0x04000009), std::make_optional(inst_attr::DJUMP), 0x04000009, false),
    /*04^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*05v*/ bp_cell(std::make_optional(0x04000016), std::make_optional(inst_attr::DJUMP), 0x04000016, false),
    /*06 */ bp_cell(std::make_optional(0x04000010), std::make_optional(inst_attr::DJUMP), 0x04000010, false),
    /*07 */ bp_cell(std::make_optional(0x04000001), std::make_optional(inst_attr::DJUMP), 0x04000001, false),
    /*08 */ bp_cell(std::make_optional(0x04000014), std::make_optional(inst_attr::DJUMP), 0x04000014, false),
    /*09^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0av*/ bp_cell(std::make_optional(0x04000007), std::make_optional(inst_attr::DJUMP), 0x04000007, false),
    /*0b */ bp_cell(std::make_optional(0x04000011), std::make_optional(inst_attr::DJUMP), 0x04000011, false),
    /*0c^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0dv*/ bp_cell(std::make_optional(0x04000006), std::make_optional(inst_attr::DJUMP), 0x04000006, false),
    /*0e^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0fv*/ bp_cell(std::make_optional(0x04000008), std::make_optional(inst_attr::DJUMP), 0x04000008, false),
    /*10 */ bp_cell(std::make_optional(0x0400000e), std::make_optional(inst_attr::DJUMP), 0x0400000e, false),
    /*11 */ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*12^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*13v*/ bp_cell(std::make_optional(0x0400001b), std::make_optional(inst_attr::DJUMP), 0x0400001b, false),
    /*14^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*15v*/ bp_cell(std::make_optional(0x0400000b), std::make_optional(inst_attr::DJUMP), 0x0400000b, false),
    /*16 */ bp_cell(std::make_optional(0x04000023), std::make_optional(inst_attr::DJUMP), 0x04000023, false),
    /*17^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*18v*/ bp_cell(std::make_optional(0x04000024), std::make_optional(inst_attr::DJUMP), 0x04000024, false),
    /*19 */ bp_cell(std::make_optional(0x04000026), std::make_optional(inst_attr::DJUMP), 0x04000026, false),
    /*1a */ bp_cell(std::make_optional(0x0400001d), std::make_optional(inst_attr::DJUMP), 0x0400001d, false),
    /*1b */ bp_cell(std::make_optional(0x04000021), std::make_optional(inst_attr::DJUMP), 0x04000021, false),
    /*1c */ bp_cell(std::make_optional(0x04000029), std::make_optional(inst_attr::DJUMP), 0x04000029, false),
    /*1d^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*1ev*/ bp_cell(std::make_optional(0x0400002b), std::make_optional(inst_attr::DJUMP), 0x0400002b, false),
    /*1f^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*20v*/ bp_cell(std::make_optional(0x0400001c), std::make_optional(inst_attr::DJUMP), 0x0400001c, false),
    /*21^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*22v*/ bp_cell(std::make_optional(0x04000004), std::make_optional(inst_attr::DJUMP), 0x04000004, false),
    /*23 */ bp_cell(std::make_optional(0x04000019), std::make_optional(inst_attr::DJUMP), 0x04000019, false),
    /*24^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*25v*/ bp_cell(std::make_optional(0x04000027), std::make_optional(inst_attr::DJUMP), 0x04000027, false),
    /*26 */ bp_cell(std::make_optional(0x0400001f), std::make_optional(inst_attr::DJUMP), 0x0400001f, false),
    /*27^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*28v*/ bp_cell(std::make_optional(0x0400002e), std::make_optional(inst_attr::DJUMP), 0x0400002e, false),
    /*29^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2av*/ bp_cell(std::make_optional(0x0400002d), std::make_optional(inst_attr::DJUMP), 0x0400002d, false),
    /*2b^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2cv*/ bp_cell(std::make_optional(0x04000017), std::make_optional(inst_attr::DJUMP), 0x04000017, false),
    /*2d */ bp_cell(std::make_optional(0x0400001a), std::make_optional(inst_attr::DJUMP), 0x0400001a, false),
    /*2e^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2fv*/ bp_cell(std::nullopt, std::nullopt, 0, false),
};

static const std::vector<bp_cell> bp_miss_rvc = {
    /*00 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000003, false),
    /*01 */ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*02 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400000c, false),
    /*03 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000009, false),
    /*04^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*05v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000016, false),
    /*06 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000010, false),
    /*07 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000001, false),
    /*08 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000014, false),
    /*09^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0av*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000007, false),
    /*0b */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000011, false),
    /*0c^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0dv*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000006, false),
    /*0e^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0fv*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000008, false),
    /*10 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400000e, false),
    /*11 */ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*12^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*13v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400001b, false),
    /*14^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*15v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400000b, false),
    /*16 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000023, false),
    /*17^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*18v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000024, false),
    /*19 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000026, false),
    /*1a */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400001d, false),
    /*1b */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000021, false),
    /*1c */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000029, false),
    /*1d^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*1ev*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400002b, false),
    /*1f^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*20v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400001c, false),
    /*21^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*22v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000004, false),
    /*23 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000019, false),
    /*24^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*25v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000027, false),
    /*26 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400001f, false),
    /*27^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*28v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400002e, false),
    /*29^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2av*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400002d, false),
    /*2b^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2cv*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000017, false),
    /*2d */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400001a, false),
    /*2e^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2fv*/ bp_cell(std::nullopt, std::nullopt, 0, false),
};

static const std::vector<bp_cell> bp_flush_rvc = {
    /*00 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000003, false),
    /*01 */ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*02 */ bp_cell(std::make_optional(0x0400000c), std::make_optional(inst_attr::DJUMP), 0x0400000c, false),
    /*03 */ bp_cell(std::make_optional(0x04000009), std::make_optional(inst_attr::DJUMP), 0x04000009, false),
    /*04^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*05v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000016, false),
    /*06 */ bp_cell(std::make_optional(0x04000010), std::make_optional(inst_attr::DJUMP), 0x04000010, false),
    /*07 */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000001, false),
    /*08 */ bp_cell(std::make_optional(0x04000014), std::make_optional(inst_attr::DJUMP), 0x04000014, false),
    /*09^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0av*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000007, false),
    /*0b */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000011, false),
    /*0c^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0dv*/ bp_cell(std::make_optional(0x04000006), std::make_optional(inst_attr::DJUMP), 0x04000006, false),
    /*0e^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*0fv*/ bp_cell(std::make_optional(0x04000008), std::make_optional(inst_attr::DJUMP), 0x04000008, false),
    /*10 */ bp_cell(std::make_optional(0x0400000e), std::make_optional(inst_attr::DJUMP), 0x0400000e, false),
    /*11 */ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*12^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*13v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400001b, false),
    /*14^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*15v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400010b, false),
    /*16 */ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*17^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*18v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000024, false),
    /*19 */ bp_cell(std::make_optional(0x04000026), std::make_optional(inst_attr::DJUMP), 0x04000026, false),
    /*1a */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400001d, false),
    /*1b */ bp_cell(std::make_optional(0x04000021), std::make_optional(inst_attr::DJUMP), 0x04000021, false),
    /*1c */ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000029, false),
    /*1d^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*1ev*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400002b, false),
    /*1f^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*20v*/ bp_cell(std::make_optional(0x0400001c), std::make_optional(inst_attr::DJUMP), 0x0400001c, false),
    /*21^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*22v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000004, false),
    /*23 */ bp_cell(std::make_optional(0x04000019), std::make_optional(inst_attr::DJUMP), 0x04000019, false),
    /*24^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*25v*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000027, false),
    /*26 */ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*27^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*28v*/ bp_cell(std::make_optional(0x0400002e), std::make_optional(inst_attr::DJUMP), 0x0400002e, false),
    /*29^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2av*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x0400002d, false),
    /*2b^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2cv*/ bp_cell(std::nullopt, std::make_optional(inst_attr::DJUMP), 0x04000117, false),
    /*2d */ bp_cell(std::make_optional(0x0400001a), std::make_optional(inst_attr::DJUMP), 0x0400001a, false),
    /*2e^*/ bp_cell(std::nullopt, std::nullopt, 0, false),
    /*2fv*/ bp_cell(std::nullopt, std::nullopt, 0, false),
};

#define DECLARE_REFERENCE_ARRAY(VAR_NAME) \
    std::reference_wrapper<std::remove_reference<decltype(vp->io_##VAR_NAME##_0)>::type> VAR_NAME[] = { \
        vp->io_##VAR_NAME##_0, \
        vp->io_##VAR_NAME##_1, \
        vp->io_##VAR_NAME##_2, \
        vp->io_##VAR_NAME##_3, \
    }

#define DECLARE_REFERENCE_ARRAY_POSTFIX(VAR_NAME, POSTFIX) \
    std::reference_wrapper<std::remove_reference<decltype(vp->io_##VAR_NAME##_0_##POSTFIX)>::type> VAR_NAME##_##POSTFIX[] = { \
        vp->io_##VAR_NAME##_0_##POSTFIX, \
        vp->io_##VAR_NAME##_1_##POSTFIX, \
        vp->io_##VAR_NAME##_2_##POSTFIX, \
        vp->io_##VAR_NAME##_3_##POSTFIX, \
    }

std::generator<int64_t> bp_mock_task(Vfetch *vp, context *ctx, const std::vector<bp_cell> &data) {
    uint32_t zbtb_pc = 0;
    uint32_t btb_pc = 0;
    uint32_t pht_pc = 0;
    co_yield 0;
    while (true) {
        DECLARE_REFERENCE_ARRAY(zbtb_lu_matches);
        DECLARE_REFERENCE_ARRAY(zbtb_lu_target);
        DECLARE_REFERENCE_ARRAY_POSTFIX(btb_lu_result, jump);
        DECLARE_REFERENCE_ARRAY_POSTFIX(btb_lu_result, br);
        DECLARE_REFERENCE_ARRAY_POSTFIX(btb_lu_result, attr);
        DECLARE_REFERENCE_ARRAY_POSTFIX(btb_lu_result, is_ret);
        DECLARE_REFERENCE_ARRAY_POSTFIX(btb_lu_result, target);
        DECLARE_REFERENCE_ARRAY(pht___05Flu_taken);
        DECLARE_REFERENCE_ARRAY(pht___05Flu_lcnt);
        DECLARE_REFERENCE_ARRAY(pht___05Flu_gcnt);
        for (int i = 0; i < 4; i++) {
            const bp_cell &c = data[((zbtb_pc & 0x00fffffc) + i) % data.size()];
            zbtb_lu_matches[i].get() = c.zbtb_target.has_value();
            zbtb_lu_target[i].get() = c.zbtb_target.value_or(0);
        }
        for (int i = 0; i < 4; i++) {
            const bp_cell &c = data[((btb_pc & 0x00fffffc) + i) % data.size()];
            btb_lu_result_jump[i].get() = c.btb_attr.transform([](auto a) { return a == inst_attr::DJUMP || a == inst_attr::DCALL; }).value_or(false);
            btb_lu_result_br[i].get() = c.btb_attr.transform([](auto a) { return a == inst_attr::BR; }).value_or(false);
            btb_lu_result_attr[i].get() = c.btb_attr.transform([](auto a) { return a == inst_attr::RET ? 0 : static_cast<int>(a); }).value_or(0);
            btb_lu_result_is_ret[i].get() = c.btb_attr.transform([](auto a) { return a == inst_attr::RET; }).value_or(false);
            btb_lu_result_target[i].get() = c.btb_target;
        }
        for (int i = 0; i < 4; i++) {
            const bp_cell &c = data[((btb_pc & 0x00fffffc) + i) % data.size()];
            pht___05Flu_taken[i].get() = c.pht_taken;
            pht___05Flu_lcnt[i].get() = c.pht_taken ? 1 : 0;
            pht___05Flu_gcnt[i].get() = 0;
        }
        co_yield -1;
        zbtb_pc = vp->io_zbtb_lu_pc;
        btb_pc = vp->io_btb_lu_pc;
        pht_pc = vp->io_pht___05Flu_pc;
        co_yield 1;
    }
}

static const std::vector<int> fixed32bit_ready_counts = {
    1,
};

static const std::vector<int> fixed64bit_ready_counts = {
    2,
};

static const std::vector<int> mixed_ready_counts = {
    1, 2, 0, 2, 1, 0, 0, 1,
};

struct addr_data {
    uint32_t address;
    uint32_t data;
};

static const std::vector<addr_data> expected_32bit_insts = {
    addr_data(0x04000000, 0x00000003),
    addr_data(0x04000002, 0x00000013),
    addr_data(0x04000004, 0x00000023),
    addr_data(0x04000006, 0x00000033),
    addr_data(0x04000008, 0x00000043),
    addr_data(0x0400000a, 0x00000053),
    addr_data(0x0400000c, 0x00000063),
    addr_data(0x0400000e, 0x00000073),
};

static const std::vector<addr_data> expected_rvc_insts = {
    addr_data(0x04000000, 0x00000002),
    addr_data(0x04000001, 0x00000012),
    addr_data(0x04000002, 0x00000022),
    addr_data(0x04000003, 0x00000032),
    addr_data(0x04000004, 0x00000043),
    addr_data(0x04000006, 0x00000052),
    addr_data(0x04000007, 0x00000062),
    addr_data(0x04000008, 0x00000072),
    addr_data(0x04000009, 0x00000083),
    addr_data(0x0400000b, 0x00000092),
    addr_data(0x0400000c, 0x000000a3),
    addr_data(0x0400000e, 0x000000b3),
    addr_data(0x04000010, 0x000000c2),
    addr_data(0x04000011, 0x000000d2),
    addr_data(0x04000012, 0x000000e3),
    addr_data(0x04000014, 0x000000f3),
    addr_data(0x04000016, 0x00000102),
    addr_data(0x04000017, 0x00000113),
    addr_data(0x04000019, 0x00000122),
    addr_data(0x0400001a, 0x00000132),
    addr_data(0x0400001b, 0x00000142),
    addr_data(0x0400001c, 0x00000152),
    addr_data(0x0400001d, 0x00000163),
    addr_data(0x0400001f, 0x00000173),
    addr_data(0x04000021, 0x00000183),
    addr_data(0x04000023, 0x00000192),
    addr_data(0x04000024, 0x000001a3),
    addr_data(0x04000026, 0x000001b2),
    addr_data(0x04000027, 0x000001c3),
    addr_data(0x04000029, 0x000001d3),
    addr_data(0x0400002b, 0x000001e3),
    addr_data(0x0400002d, 0x000001f2),
    addr_data(0x0400002e, 0x00000203),
};

static const std::vector<addr_data> expected_32bit_bp_insts = {
    addr_data(0x04000000, 0x00000003),
    addr_data(0x04000002, 0x00000013),
    addr_data(0x04000008, 0x00000043),
    addr_data(0x04000004, 0x00000023),
    addr_data(0x04000006, 0x00000033),
    addr_data(0x0400000a, 0x00000053),
    addr_data(0x0400000c, 0x00000063),
    addr_data(0x0400000e, 0x00000073),
};

static const std::vector<addr_data> expected_rvc_bp_insts = {
    addr_data(0x04000000, 0x00000002),
    addr_data(0x04000003, 0x00000032),
    addr_data(0x04000009, 0x00000083),
    addr_data(0x04000007, 0x00000062),
    addr_data(0x04000001, 0x00000012),
    addr_data(0x04000002, 0x00000022),
    addr_data(0x0400000c, 0x000000a3),
    addr_data(0x04000006, 0x00000052),
    addr_data(0x04000010, 0x000000c2),
    addr_data(0x0400000e, 0x000000b3),
    addr_data(0x04000008, 0x00000072),
    addr_data(0x04000014, 0x000000f3),
    addr_data(0x0400000b, 0x00000092),
    addr_data(0x04000011, 0x000000d2),
    addr_data(0x04000012, 0x000000e3),
    addr_data(0x0400001b, 0x00000142),
    addr_data(0x04000021, 0x00000183),
    addr_data(0x04000004, 0x00000043),
    addr_data(0x04000016, 0x00000102),
    addr_data(0x04000023, 0x00000192),
    addr_data(0x04000019, 0x00000122),
    addr_data(0x04000026, 0x000001b2),
    addr_data(0x0400001f, 0x00000173),
    addr_data(0x0400001c, 0x00000152),
    addr_data(0x04000029, 0x000001d3),
    addr_data(0x0400002d, 0x000001f2),
    addr_data(0x0400001a, 0x00000132),
    addr_data(0x0400001d, 0x00000163),
    addr_data(0x0400002b, 0x000001e3),
    addr_data(0x04000017, 0x00000113),
    addr_data(0x04000024, 0x000001a3),
    addr_data(0x04000027, 0x000001c3),
    addr_data(0x0400002e, 0x00000203),
};

static const std::map<uint32_t, uint32_t> flush_addresses = {
    { 0x04000014, 0x0400000b },
    { 0x04000016, 0x04000023 },
    { 0x04000026, 0x0400001f },
    { 0x0400002b, 0x04000017 },
};

std::generator<int64_t> probe_fetch_task(
    Vfetch *vp,
    context *ctx,
    const std::vector<int> &ready_counts,
    const std::vector<addr_data> &expected,
    const std::map<uint32_t, uint32_t> &flush_addrs = {}
) {
    size_t read_count = 0;
    size_t ready_index = 0;
    bool flush_en = false;
    uint32_t flush_target = 0;
    co_yield 0;
    while (read_count < expected.size()) {
        int ready_count = ready_counts[ready_index % ready_counts.size()];
        vp->io_ft_inst1_ready = ready_count >= 1;
        vp->io_ft_inst2_ready = ready_count >= 2;
        if (ctx->cycles() >= 1) {
            vp->io_ft_flush_en = flush_en;
            vp->io_ft_flush_iaddr = flush_target;
        }
        flush_en = false;
        co_yield -1;
        if (ready_count >= 1 && vp->io_ft_inst1_valid) {
            uint32_t addr = expected[read_count].address;
            uint32_t e = expected[read_count].data;
            UNSCOPED_INFO(ctx->cycles_str());
            CHECK((vp->io_ft_inst1_data & ((e & 3) == 3 ? 0xffffffff : 0xffff)) == e);
            UNSCOPED_INFO(ctx->cycles_str());
            CHECK(vp->io_ft_inst1_addr == addr);
            UNSCOPED_INFO(ctx->cycles_str());
            // CHECK(vp->io_ft_inst1_half == ((e & 3) == 3 ? 0 : 1));
            auto it = flush_addrs.find(addr);
            if (it != flush_addrs.end()) {
                flush_en = true;
                flush_target = it->second;
            }
            read_count++;
        }
        if (ready_count >= 2 && vp->io_ft_inst2_valid) {
            if (read_count < expected.size()) {
                uint32_t addr = expected[read_count].address;
                uint32_t e = expected[read_count].data;
                UNSCOPED_INFO(ctx->cycles_str());
                CHECK((vp->io_ft_inst2_data & ((e & 3) == 3 ? 0xffffffff : 0xffff)) == e);
                UNSCOPED_INFO(ctx->cycles_str());
                CHECK(vp->io_ft_inst2_addr == addr);
                UNSCOPED_INFO(ctx->cycles_str());
                // CHECK(vp->io_ft_inst2_half == ((e & 3) == 3 ? 0 : 1));
                auto it = flush_addrs.find(addr);
                if (!flush_en && it != flush_addrs.end()) {
                    flush_en = true;
                    flush_target = it->second;
                }
                read_count++;
            }
        }
        ready_index++;
        co_yield 1;
    }
}

TEST_CASE("32bit insts, 32bit fetch", "[fetch]") {
    task_runner runner(12);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/32bit_insts_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_32bit_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_none); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_32bit_insts); }));

    runner.run(sut);
}

TEST_CASE("32bit insts, 64bit fetch", "[fetch]") {
    task_runner runner(8);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/32bit_insts_64bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_32bit_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_none); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed64bit_ready_counts, expected_32bit_insts); }));

    runner.run(sut);
}

TEST_CASE("32bit insts, mixed fetch", "[fetch]") {
    task_runner runner(40);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/32bit_insts_mixed_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_32bit_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_none); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, mixed_ready_counts, expected_32bit_insts); }));

    runner.run(sut);
}

TEST_CASE("rvc insts, 32bit fetch", "[fetch]") {
    task_runner runner(40);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/rvc_insts_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_rvc_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_none); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_rvc_insts); }));

    runner.run(sut);
}

TEST_CASE("32bit bp, 32bit fetch", "[fetch]") {
    task_runner runner(24);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/32bit_bp_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_32bit_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_32bit); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_32bit_bp_insts); }));

    runner.run(sut);
}

TEST_CASE("32bit bp miss, 32bit fetch", "[fetch]") {
    task_runner runner(24);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/32bit_bp_miss_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_32bit_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_miss_32bit); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_32bit_bp_insts); }));

    runner.run(sut);
}

TEST_CASE("32bit bp mixed, 32bit fetch", "[fetch]") {
    task_runner runner(24);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/32bit_bp_mixed_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_32bit_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_mixed_32bit); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_32bit_bp_insts); }));

    runner.run(sut);
}

TEST_CASE("rvc bp, 32bit fetch", "[fetch]") {
    task_runner runner(60);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/rvc_bp_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_rvc_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_rvc); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_rvc_bp_insts); }));

    runner.run(sut);
}

TEST_CASE("rvc bp miss, 32bit fetch", "[fetch]") {
    task_runner runner(90);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/rvc_bp_miss_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_rvc_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_miss_rvc); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_rvc_bp_insts); }));

    runner.run(sut);
}

TEST_CASE("rvc bp flush, 32bit fetch", "[fetch]") {
    task_runner runner(90);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/rvc_bp_flush_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_rvc_insts); }, false));
    runner.start_task(std::make_shared<task>("bp",    [&sut, &ctx]() { return bp_mock_task(&*sut, ctx, bp_flush_rvc); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_rvc_bp_insts, flush_addresses); }));

    runner.run(sut);
}
