#![no_std]

extern crate alloc;

use alloc::boxed::Box;
use core::alloc::{GlobalAlloc, Layout};
use core::cell::{UnsafeCell, Cell};
use core::mem;

use core::panic::PanicInfo;
#[panic_handler]
#[no_mangle]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

struct SbrkAllocator {
    sbrk: UnsafeCell<*mut u32>,
}

#[global_allocator]
static ALLOCATOR: SbrkAllocator = SbrkAllocator {
    sbrk: UnsafeCell::new(0x2000_0000 as *mut u32),
};

unsafe impl Sync for SbrkAllocator {}

unsafe impl GlobalAlloc for SbrkAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let size = layout.size();
        // let align = layout.align();
        let ptr = *self.sbrk.get() as *mut u8;
        let sbrk_p = self.sbrk.get();
        *sbrk_p = (*sbrk_p).add(size >> 2);
        ptr
    }
    unsafe fn dealloc(&self, _ptr: *mut u8, _layout: Layout) {}
}

#[derive(PartialEq, Copy, Clone)]
enum Enumeration {
    Ident1,
    Ident2,
    Ident3,
    Ident4,
    Ident5,
}

#[repr(C, align(4))]
#[derive(Clone, Copy, PartialEq, PartialOrd)]
struct Str30([u8; 30]);


type OneThirty = i32;
type OneFifty = i32;
type CapitalLetter = u8;
type Boolean = bool;
// type Str30 = [u8; 30];
type Arr1Dim = [i32; 50];
type Arr2Dim = [[i32; 50]; 50];

#[repr(C, align(4))]
struct RecordVar1 {
    enum_comp: Cell<Enumeration>,
    int_comp: Cell<i32>,
    str_comp: Cell<Str30>,
    // _dummy: u16,
}

impl RecordVar1 {
    fn copy_from(&'_ self, rhs: &'_ RecordVar1) {
        self.enum_comp.set(rhs.enum_comp.get());
        self.int_comp.set(rhs.int_comp.get());
        self.str_comp.set(rhs.str_comp.get());
    }
}

#[repr(align(4))]
struct Record {
    ptr_comp: Cell<Option<&'static Record>>,
    discr: Cell<Enumeration>,
    var1: RecordVar1,
}

impl Record {
    fn copy_from(&self, rhs: &'static Record) {
        self.ptr_comp.set(rhs.ptr_comp.get());
        self.discr.set(rhs.discr.get());
        self.var1.copy_from(&rhs.var1);
    }
}

#[repr(C, align(4))]
struct Global {
    box_glob: Option<Box<Record>>,
    next_box_glob: Option<Box<Record>>,
    ptr_glob: Option<&'static Record>,
    next_ptr_glob: Option<&'static Record>,
    int_glob: i32,
    bool_glob: bool,
    ch1_glob: u8,
    ch2_glob: u8,
    // _dummy: u8,
    arr1_glob: [i32; 50],
    arr2_glob: [[i32; 50]; 50],
}

static mut GLOB: Global = unsafe { mem::zeroed() }; // Global {
    // ptr_glob: ptr::null_mut(),
    // next_ptr_glob: ptr::null_mut(),
    // int_glob: 0,
    // bool_glob: false,
    // ch1_glob: 0,
    // ch2_glob: 0,
    // _dummy: 0,
    // arr1_glob: [0; 50],
    // arr2_glob: [[0; 50]; 50],
// };

#[no_mangle]
pub extern "C" fn main() -> i32 {
    let mut int1_loc: OneFifty = 0;
    let mut int2_loc: OneFifty = 0;
    let mut int3_loc: OneFifty = 0;
    // let mut ch_index: u8 = b'X';
    let mut enum_loc: Enumeration = Enumeration::Ident1;
    // let mut str1_loc: Str30 = [b'X'; 30];
    let mut str2_loc: Str30 = unsafe { mem::zeroed() };
    // let mut run_index: i32 = 0;

    // let mut number_of_runs: i32 = 0;

    let glob: &mut Global = unsafe { &mut GLOB };

    glob.next_box_glob = Some(Box::new(Record {
        ptr_comp: Cell::new(None),
        discr: Cell::new(Enumeration::Ident1),
        var1: RecordVar1 {
            enum_comp: Cell::new(Enumeration::Ident1),
            int_comp: Cell::new(0),
            str_comp: Cell::new(Str30([0; 30])),
            // _dummy: 0,
        }
    }));
    glob.next_ptr_glob = Some(glob.next_box_glob.as_ref().unwrap());
    glob.box_glob = Some(Box::new(Record {
        ptr_comp: Cell::new(glob.next_ptr_glob),
        discr: Cell::new(Enumeration::Ident1),
        var1: RecordVar1 {
            enum_comp: Cell::new(Enumeration::Ident3),
            int_comp: Cell::new(40),
            str_comp: Cell::new(Str30(*b"DHRYSTONE PROGRAM, SOME STRING")),
            // _dummy: 0,
        }
    }));
    glob.ptr_glob = Some(glob.box_glob.as_ref().unwrap());
    let str1_loc: Str30 = Str30(*b"DHRYSTONE PROGRAM, 1'ST STRING");

    glob.arr2_glob[8][7] = 10;

    let number_of_runs: i32 = 10;

    for run_index in 1..=number_of_runs {
        proc5();
        proc4();
        int1_loc = 2;
        int2_loc = 3;
        str2_loc = Str30(*b"DHRYSTONE PROGRAM, 2'ND STRING");
        enum_loc = Enumeration::Ident2;
        glob.bool_glob = !func2(&str1_loc, &str2_loc);
        while int1_loc < int2_loc {
            int3_loc = 5 * int1_loc - int2_loc;
            proc7(int1_loc, int2_loc, Cell::from_mut(&mut int3_loc));
            int1_loc += 1;
        }
        proc8(&mut glob.arr1_glob, &mut glob.arr2_glob, int1_loc, int3_loc); // TODO
        proc1(glob.ptr_glob.unwrap());
        for ch_index in b'A'..=glob.ch2_glob {
            if enum_loc == func1(ch_index, b'C') {
                proc6(Enumeration::Ident1, Cell::from_mut(&mut enum_loc));
                str2_loc = Str30(*b"DHRYSTONE PROGRAM, 3'RD STRING");
                int2_loc = run_index;
                glob.int_glob = run_index;
            }
        }
        int2_loc = int2_loc * int1_loc;
        int1_loc = int2_loc / int3_loc;
        int2_loc = 7 * (int2_loc - int3_loc) - int1_loc;
        proc2(Cell::from_mut(&mut int1_loc));
    }

    if !(
        glob.int_glob == 5 &&
        glob.bool_glob &&
        glob.ch1_glob == b'A' &&
        glob.ch2_glob == b'B' &&
        glob.arr1_glob[8] == 7 &&
        glob.arr2_glob[8][7] == number_of_runs + 10 &&
        glob.ptr_glob.unwrap().discr.get() == Enumeration::Ident1 &&
        glob.ptr_glob.unwrap().var1.enum_comp.get() == Enumeration::Ident3 &&
        glob.ptr_glob.unwrap().var1.int_comp.get() == 17 &&
        glob.ptr_glob.unwrap().var1.str_comp.get() == Str30(*b"DHRYSTONE PROGRAM, SOME STRING") &&
        glob.next_ptr_glob.unwrap().discr.get() == Enumeration::Ident1 &&
        glob.next_ptr_glob.unwrap().var1.enum_comp.get() == Enumeration::Ident2 &&
        glob.next_ptr_glob.unwrap().var1.int_comp.get() == 18 &&
        glob.next_ptr_glob.unwrap().var1.str_comp.get() == Str30(*b"DHRYSTONE PROGRAM, SOME STRING") &&
        int1_loc == 5 &&
        int2_loc == 13 &&
        int3_loc == 7 &&
        enum_loc == Enumeration::Ident2 &&
        str1_loc == Str30(*b"DHRYSTONE PROGRAM, 1'ST STRING") &&
        str2_loc == Str30(*b"DHRYSTONE PROGRAM, 2'ND STRING") &&
        true
    ) {
        return 2;
    }

    return 1;
}

fn proc1(ptr_val_par: &'static Record) {
    let glob: &mut Global = unsafe { &mut GLOB };
    // let val_par: &mut Record = unsafe {&mut *ptr_val_par};
    let next_record: &Record = ptr_val_par.ptr_comp.get().unwrap();

    ptr_val_par.ptr_comp.get().unwrap().copy_from(glob.ptr_glob.unwrap());
    // ptr_val_par.ptr_comp.get().unwrap().ptr_comp.set(glob.ptr_glob.unwrap().ptr_comp.get());
    ptr_val_par.var1.int_comp.set(5);
    next_record.var1.int_comp.set(ptr_val_par.var1.int_comp.get());
    next_record.ptr_comp.set(ptr_val_par.ptr_comp.get());
    proc3(&next_record.ptr_comp);
    if next_record.discr.get() == Enumeration::Ident1 {
        next_record.var1.int_comp.set(6);
        proc6(ptr_val_par.var1.enum_comp.get(), &next_record.var1.enum_comp);
        next_record.ptr_comp.set(glob.ptr_glob.unwrap().ptr_comp.get());
        proc7(next_record.var1.int_comp.get(), 10, &next_record.var1.int_comp);
    } else {
        ptr_val_par.copy_from(ptr_val_par.ptr_comp.get().unwrap());
    }
}

fn proc2(int_par_ref: &Cell<OneFifty>) {
    let glob: &mut Global = unsafe { &mut GLOB };
    let mut int_loc: OneFifty = int_par_ref.get() + 10;
    let mut enum_loc = Enumeration::Ident1;
    loop {
        if glob.ch1_glob == b'A' {
            int_loc -= 1;
            int_par_ref.set(int_loc - glob.int_glob);
            enum_loc = Enumeration::Ident1;
        }
        if enum_loc == Enumeration::Ident1 {
            break;
        }
    }
}

fn proc3(ptr_ref_par: &Cell<Option<&'static Record>>) {
    let glob: &mut Global = unsafe { &mut GLOB };
    if let Some(ptr_glob) = glob.ptr_glob {
        ptr_ref_par.set(ptr_glob.ptr_comp.get());
    }
    proc7(10, glob.int_glob, &glob.ptr_glob.unwrap().var1.int_comp);
}

fn proc4() {
    let glob: &mut Global = unsafe { &mut GLOB };
    let bool_loc = glob.ch1_glob == b'A';
    glob.bool_glob = bool_loc | glob.bool_glob;
    glob.ch2_glob = b'B';
}

fn proc5() {
    let glob: &mut Global = unsafe { &mut GLOB };
    glob.ch1_glob = b'A';
    glob.bool_glob = false;
}

fn proc6(enum_val_par: Enumeration, enum_ref_par: &Cell<Enumeration>) {
    let glob: &mut Global = unsafe { &mut GLOB };
    enum_ref_par.set(enum_val_par);
    if !func3(enum_val_par) {
        enum_ref_par.set(Enumeration::Ident4);
    }
    match enum_val_par {
        Enumeration::Ident1 => enum_ref_par.set(Enumeration::Ident1),
        Enumeration::Ident2 => {
            if glob.int_glob > 100 {
                enum_ref_par.set(Enumeration::Ident1);
            } else {
                enum_ref_par.set(Enumeration::Ident4);
            }
        }
        Enumeration::Ident3 => enum_ref_par.set(Enumeration::Ident2),
        Enumeration::Ident4 => {},
        Enumeration::Ident5 => enum_ref_par.set(Enumeration::Ident3),
    }
}

fn proc7(int1_par_val: OneFifty, int2_par_val: OneFifty, int_par_ref: &Cell<OneFifty>) {
    let int_loc: OneFifty = int1_par_val + 2;
    int_par_ref.set(int2_par_val + int_loc);
}

fn proc8(arr1_par_ref: &mut Arr1Dim, arr2_par_ref: &mut Arr2Dim, int1_par_val: i32, int2_par_val: i32) {
    let glob: &mut Global = unsafe { &mut GLOB };
    let int_loc = (int1_par_val + 5) as usize;
    arr1_par_ref[int_loc] = int2_par_val;
    arr1_par_ref[int_loc + 1] = arr1_par_ref[int_loc];
    arr1_par_ref[int_loc + 30] = int_loc as i32;
    for int_index in int_loc..=int_loc + 1 {
        arr2_par_ref[int_loc][int_index] = int_loc as i32;
    }
    arr2_par_ref[int_loc][int_loc - 1] += 1;
    arr2_par_ref[int_loc + 20][int_loc] = arr1_par_ref[int_loc];
    glob.int_glob = 5;
}

fn func1(ch1_par_val: CapitalLetter, ch2_par_val: CapitalLetter) -> Enumeration {
    let glob: &mut Global = unsafe { &mut GLOB };
    let ch1_loc: CapitalLetter = ch1_par_val;
    let ch2_loc: CapitalLetter = ch1_loc;
    if ch2_loc != ch2_par_val {
        return Enumeration::Ident1;
    } else {
        glob.ch1_glob = ch1_loc;
        return Enumeration::Ident2;
    }
}

fn func2(str1_par_ref: &Str30, str2_par_ref: &Str30) -> bool {
    let glob: &mut Global = unsafe { &mut GLOB };
    let mut int_loc: usize = 2;
    let mut ch_loc: CapitalLetter = 0;
    while int_loc <= 2 {
        if func1(str1_par_ref.0[int_loc], str2_par_ref.0[int_loc + 1]) == Enumeration::Ident1 {
            ch_loc = b'A';
            int_loc += 1;
        }
    }
    if ch_loc >= b'W' && ch_loc < b'Z' {
        int_loc = 7;
    }
    if ch_loc == b'R' {
        return true;
    } else {
        if *str1_par_ref > *str2_par_ref {
            int_loc += 7;
            glob.int_glob = int_loc as i32;
            return true;
        } else {
            return false;
        }
    }
}

fn func3(enum_par_val: Enumeration) -> bool {
    let enum_loc: Enumeration = enum_par_val;
    if enum_loc == Enumeration::Ident3 {
        return true;
    } else {
        return false;
    }
}
