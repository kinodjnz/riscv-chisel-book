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
    vp->io_flush_en = 1;
    vp->io_flush_iaddr = 0x08000000 >> 1;
    co_yield 1;
    vp->io_flush_en = 0;
    vp->io_flush_iaddr = 0x00000000 >> 1;
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
        vp->io_imem_inst = idata;
        vp->io_imem_valid = valid;
        co_yield -1;
        // WARN(std::format("io_imem_en={}", vp->io_imem_en));
        // WARN(std::format("io_imem_addr={0:#x}", vp->io_imem_addr));
        if (vp->io_imem_en) {
            idata = (vp->io_imem_addr & 0xff000000) == 0x08000000 ? data[((vp->io_imem_addr - 0x08000000) >> 3) % data.size()] : 0;
            valid = true;
        } else {
            idata = 0;
            valid = false;
        }
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

static const std::vector<uint32_t> expected_32bit_insts = {
    0x00000003,
    0x00000013,
    0x00000023,
    0x00000033,
    0x00000043,
    0x00000053,
    0x00000063,
    0x00000073,
};

static const std::vector<uint32_t> expected_rvc_insts = {
    0x00000002,
    0x00000012,
    0x00000022,
    0x00000032,
    0x00000043,
    0x00000052,
    0x00000062,
    0x00000072,
    0x00000083,
    0x00000092,
    0x000000a3,
    0x000000b3,
    0x000000c2,
    0x000000d2,
    0x000000e3,
    0x000000f3,
    0x00000102,
    0x00000113,
    0x00000122,
    0x00000132,
    0x00000142,
    0x00000152,
    0x00000163,
    0x00000173,
    0x00000183,
    0x00000192,
    0x000001a3,
    0x000001b2,
    0x000001c3,
    0x000001d3,
    0x000001e3,
    0x000001f2,
    0x00000203,
};

std::generator<int64_t> probe_fetch_task(
    Vfetch *vp,
    context *ctx,
    const std::vector<int> &ready_counts,
    const std::vector<uint32_t> &expected
) {
    size_t read_count = 0;
    size_t ready_index = 0;
    uint32_t address_offset = 0;
    co_yield 0;
    while (read_count < expected.size()) {
        int ready_count = ready_counts[ready_index % ready_counts.size()];
        vp->io_inst1_ready = ready_count >= 1;
        vp->io_inst2_ready = ready_count >= 2;
        co_yield -1;
        if (ready_count >= 1 && vp->io_inst1_valid) {
            uint32_t e = expected[read_count];
            UNSCOPED_INFO(ctx->cycles_str());
            CHECK((vp->io_inst1_data & ((e & 3) == 3 ? 0xffffffff : 0xffff)) == e);
            UNSCOPED_INFO(ctx->cycles_str());
            CHECK(vp->io_inst1_addr == (0x08000000 + address_offset) >> 1);
            UNSCOPED_INFO(ctx->cycles_str());
            CHECK(vp->io_inst1_half == ((e & 3) == 3 ? 0 : 1));
            read_count++;
            address_offset += ((e & 3) == 3 ? 4 : 2);
        }
        if (ready_count >= 2 && vp->io_inst2_valid) {
            if (read_count < expected.size()) {
                uint32_t e = expected[read_count];
                UNSCOPED_INFO(ctx->cycles_str());
                CHECK((vp->io_inst2_data & ((e & 3) == 3 ? 0xffffffff : 0xffff)) == e);
                UNSCOPED_INFO(ctx->cycles_str());
                CHECK(vp->io_inst2_addr == (0x08000000 + address_offset) >> 1);
                UNSCOPED_INFO(ctx->cycles_str());
                CHECK(vp->io_inst2_half == ((e & 3) == 3 ? 0 : 1));
                read_count++;
                address_offset += ((e & 3) == 3 ? 4 : 2);
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
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_32bit_insts); }));

    runner.run(sut);
}

TEST_CASE("32bit insts, 64bit fetch", "[fetch]") {
    task_runner runner(8);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/32bit_insts_64bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_32bit_insts); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed64bit_ready_counts, expected_32bit_insts); }));

    runner.run(sut);
}

TEST_CASE("32bit insts, mixed fetch", "[fetch]") {
    task_runner runner(40);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/32bit_insts_mixed_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_32bit_insts); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, mixed_ready_counts, expected_32bit_insts); }));

    runner.run(sut);
}

TEST_CASE("rvc insts, 32bit fetch", "[fetch]") {
    task_runner runner(40);
    verilated_ptr<Vfetch> sut(new Vfetch{runner.vcontext()}, "fetch/logs/rvc_insts_32bit_fetch.fst");
    context *ctx = runner.ctx();

    runner.start_task(std::make_shared<task>("input", [&sut, &ctx]() { return input_task(&*sut, ctx); }, false));
    runner.start_task(std::make_shared<task>("imem",  [&sut, &ctx]() { return imem_mock_task(&*sut, ctx, imem_rvc_insts); }, false));
    runner.start_task(std::make_shared<task>("prove", [&sut, &ctx]() { return probe_fetch_task(&*sut, ctx, fixed32bit_ready_counts, expected_rvc_insts); }));

    runner.run(sut);
}
