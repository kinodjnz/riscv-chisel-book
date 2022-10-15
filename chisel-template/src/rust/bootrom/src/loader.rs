use super::sdc;
use super::uart;
use core::arch::asm;

fn read_unaligned<T>(addr: *const u32, byte_offset: usize) -> T {
    unsafe { ((addr as *mut u8).add(byte_offset) as *mut T).read_unaligned() }
}

fn read<T>(addr: *const u32, byte_offset: usize) -> T {
    unsafe { ((addr as *mut u8).add(byte_offset) as *mut T).read() }
}

fn array_to_u32<const N: usize>(b: &[u8; N]) -> u32 {
    b.iter().rev().fold(0u32, |acc, x| (acc << 8) + *x as u32)
}

pub fn load_kernel() -> u32 {
    let buf: *mut u32 = 0x2000_1000 as *mut u32;

    let s = sdc::read_sector(0, 1, buf);
    if s != 0 {
        return 1;
    }
    let boot_sector: u32 = read_unaligned(buf, 0x1c6);
    // uart::print(boot_sector);
    // uart::puts(b" #bs\r\n");

    let s = sdc::read_sector(boot_sector, 1, buf);
    if s != 0 {
        return 2;
    }
    let sector_per_cluster: u32 = read::<u8>(buf, 0x00d) as u32;
    let reserved_sector_count: u32 = read::<u16>(buf, 0x00e) as u32;
    let num_fat: u32 = read::<u8>(buf, 0x010) as u32;
    let root_dirent_count: u32 = read_unaligned::<u16>(buf, 0x011) as u32;
    let fat_sector_count: u32 = read::<u16>(buf, 0x016) as u32;

    let fat_start_sector: u32 = boot_sector + reserved_sector_count;
    let fats_sectors: u32 = num_fat * fat_sector_count;
    let root_dirent_start_sector: u32 = fat_start_sector + fats_sectors;
    let root_dirent_sector_count: u32 = ((root_dirent_count << 5) + 511) >> 9;
    let data_start_sector: u32 = root_dirent_start_sector + root_dirent_sector_count;
    let cluster_shift: u32 = sector_per_cluster.trailing_zeros();
    // uart::print(fat_start_sector);
    // uart::puts(b" ");
    // uart::print(root_dirent_start_sector);
    // uart::puts(b" ");
    // uart::print(root_dirent_sector_count);
    // uart::puts(b" ");
    // uart::print(cluster_shift);
    // uart::puts(b" #dirent\r\n");

    let mut j = 0;
    let mut kernel_start_cluster: u32 = 0;
    let mut kernel_file_size: u32 = 0;
    for _ in 0..root_dirent_count {
        if j == 0 {
            let s = sdc::read_sector(root_dirent_start_sector, 1, buf);
            if s != 0 {
                uart::print(s);
                uart::puts(b" ");
                return 3;
            }
        }
        let name_head4: u32 = read::<u32>(buf, j);
        if (name_head4 & 0xff) == 0x00 {
            break; // last entry
        }
        if name_head4 == array_to_u32(b"KERN")
            && read::<u32>(buf, j + 4) == array_to_u32(b"EL  ")
            && (read::<u32>(buf, j + 8) & 0xFFFFFF) == array_to_u32(b"BIN")
        {
            kernel_start_cluster = read::<u16>(buf, j + 26) as u32;
            kernel_file_size = read::<u32>(buf, j + 28);
            break;
        }
        j = (j + 32) & 511
    }

    //uart::print(kernel_file_size);
    //uart::puts(b" #kern\r\n");

    let kernel_sector_count: u32 = (kernel_file_size + 511) >> 9;
    let mut remaining_sectors: u32 = kernel_sector_count;
    let mut current_cluster: u32 = kernel_start_cluster;
    let fat: *mut u32 = 0x2000_0e00 as *mut u32;
    let mut current_fat_sector: u32 = 0xffff_ffff;
    let mut p: *mut u32 = buf;
    loop {
        // uart::print(current_cluster);
        // uart::puts(b" ");
        // uart::print(p as u32);
        // uart::puts(b"\r\n");

        let s = sdc::read_sector(
            data_start_sector + ((current_cluster - 2) << cluster_shift),
            if remaining_sectors > sector_per_cluster { sector_per_cluster } else { remaining_sectors },
            p,
        );
        if s != 0 {
            return 4;
        }
        if remaining_sectors <= sector_per_cluster {
            break;
        }
        remaining_sectors -= sector_per_cluster;
        p = unsafe { p.add((sector_per_cluster << 7) as usize) };
        let fat_sector: u32 = fat_start_sector + ((current_cluster * 2) >> 9);
        if fat_sector != current_fat_sector {
            let s = sdc::read_sector(fat_sector, 1, fat);
            if s != 0 {
                return 5;
            }
            current_fat_sector = fat_sector;
        }
        current_cluster = read::<u16>(fat, ((current_cluster * 2) & 511) as usize) as u32
    }

    // let pp: *const u32 = 0x2000_2700 as *const u32;
    // for i in 0..128 {
    //     uart::print(read::<u32>(pp, i * 4));
    //     uart::puts(b"\r\n");
    // }
    uart::puts(b"KERNEL.BIN loaded\r\n");

    unsafe {
        asm!("fence.i");
        asm!("lui a0,0x20001");
        asm!("jr a0");
        core::hint::unreachable_unchecked();
    }
}
