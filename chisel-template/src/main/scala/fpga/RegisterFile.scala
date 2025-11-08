package fpga

import chisel3._
import chisel3.util._
import common.Consts._
import common.UIntExtension._
import common.OptionExtension._
import chisel3.util.experimental.loadMemoryFromFileInline
import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations.MemorySynthInit

class AssignPhysRegister extends Bundle {
  val en        = Input(Bool())
  val addr      = Input(UInt(ADDR_LEN.W))
  val paddr     = Output(UInt(PHYS_ADDR_LEN.W))
  val paddr_rel = Output(UInt(PHYS_ADDR_LEN.W))
}

class ReadSpeculativeMapping extends Bundle {
  val addr  = Input(UInt(ADDR_LEN.W))
  val paddr = Output(UInt(PHYS_ADDR_LEN.W))
}

class SpeculativeMappingOps extends Bundle {
  val assign  = new AssignPhysRegister
  val map_rs1 = new ReadSpeculativeMapping
  val map_rs2 = new ReadSpeculativeMapping
  val map_rs3 = new ReadSpeculativeMapping
}

class StabilizeRegisterAssignment extends Bundle {
  val en        = Input(Bool())
  val addr      = Input(UInt(ADDR_LEN.W))
  val paddr_rel = Input(UInt(PHYS_ADDR_LEN.W))
  val paddr     = Input(UInt(PHYS_ADDR_LEN.W))
}

class ResetSpeculativeMapping extends Bundle {
  val en = Input(Bool())
}

class ReadPhysRegister extends Bundle {
  val paddr = Input(UInt(PHYS_ADDR_LEN.W))
  val rdata = Output(UInt(WORD_LEN.W))
}

class WritePhysRegister extends Bundle {
  val en    = Input(Bool())
  val paddr = Input(UInt(PHYS_ADDR_LEN.W))
  val wdata = Input(UInt(WORD_LEN.W))
}

class RegisterFileInitMemoryPath(
  val map_arch_to_phys_path: String,
  val free_phys_0_path: String,
  val free_phys_1_path: String,
) {}

class RegisterFile(initMemory: Option[RegisterFileInitMemoryPath] = None, enable_sim_probe: Boolean = false) extends Module {
  val debug = false

  val io = IO(new Bundle {
    val specul1    = new SpeculativeMappingOps
    val specul2    = new SpeculativeMappingOps
    val stabilize1 = new StabilizeRegisterAssignment
    val stabilize2 = new StabilizeRegisterAssignment
    val res        = new ResetSpeculativeMapping
    val read       = Vec(5, new ReadPhysRegister)
    val write      = Vec(2, new WritePhysRegister)
  })

  val regsel = Mem(48, UInt(1.W))
  val regfile1a = Mem(48, UInt(WORD_LEN.W))
  val regfile1b = Mem(48, UInt(WORD_LEN.W))
  val regfile2a = Mem(48, UInt(WORD_LEN.W))
  val regfile2b = Mem(48, UInt(WORD_LEN.W))

  val specul_sel = Mem(32, UInt(1.W))
  val phys0sel = Mem(32, UInt(1.W))
  val phys1sel = Mem(32, UInt(1.W))

  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapx1a_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapy1a_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapx1b_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapy1b_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapx1c_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapy1c_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapx2a_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapy2a_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapx2b_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapy2b_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapx2c_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val mapy2c_arch_to_phys = Mem(32, UInt(PHYS_ADDR_LEN.W))

  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val free_phys_queue_0 = Mem(REGQ_ENTRIES/2, UInt(PHYS_ADDR_LEN.W))
  annotate(new ChiselAnnotation {
    override def toFirrtl =
      MemorySynthInit
  })
  val free_phys_queue_1 = Mem(REGQ_ENTRIES/2, UInt(PHYS_ADDR_LEN.W))

  val specul_ptr = RegInit(0.U(REGQ_LEN.W))
  val stable_ptr = RegInit(0.U(REGQ_LEN.W))
  val enq_ptr    = RegInit(0.U(REGQ_LEN.W))

  initMemory.foreach { m =>
    loadMemoryFromFileInline(mapx1a_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapy1a_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapx1b_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapy1b_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapx1c_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapy1c_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapx2a_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapy2a_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapx2b_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapy2b_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapx2c_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(mapy2c_arch_to_phys, m.map_arch_to_phys_path)
    loadMemoryFromFileInline(free_phys_queue_0, m.free_phys_0_path)
    loadMemoryFromFileInline(free_phys_queue_1, m.free_phys_1_path)
  }

  def read_mapx1_arch_to_phys(port: Int, addr: UInt): UInt = {
    port match {
      case 0 => mapx1a_arch_to_phys(addr)
      case 1 => mapx1b_arch_to_phys(addr)
      case _ => mapx1c_arch_to_phys(addr)
    }
  }

  def read_mapy1_arch_to_phys(port: Int, addr: UInt): UInt = {
    port match {
      case 0 => mapy1a_arch_to_phys(addr)
      case 1 => mapy1b_arch_to_phys(addr)
      case _ => mapy1c_arch_to_phys(addr)
    }
  }

  def read_mapx2_arch_to_phys(port: Int, addr: UInt): UInt = {
    port match {
      case 0 => mapx2a_arch_to_phys(addr)
      case 1 => mapx2b_arch_to_phys(addr)
      case _ => mapx2c_arch_to_phys(addr)
    }
  }

  def read_mapy2_arch_to_phys(port: Int, addr: UInt): UInt = {
    port match {
      case 0 => mapy2a_arch_to_phys(addr)
      case 1 => mapy2b_arch_to_phys(addr)
      case _ => mapy2c_arch_to_phys(addr)
    }
  }

  def write_mapx1_arch_to_phys(addr: UInt, paddr: UInt) = {
    mapx1a_arch_to_phys(addr) := paddr
    mapx1b_arch_to_phys(addr) := paddr
    mapx1c_arch_to_phys(addr) := paddr
  }

  def write_mapy1_arch_to_phys(addr: UInt, paddr: UInt) = {
    mapy1a_arch_to_phys(addr) := paddr
    mapy1b_arch_to_phys(addr) := paddr
    mapy1c_arch_to_phys(addr) := paddr
  }

  def write_mapx2_arch_to_phys(addr: UInt, paddr: UInt) = {
    mapx2a_arch_to_phys(addr) := paddr
    mapx2b_arch_to_phys(addr) := paddr
    mapx2c_arch_to_phys(addr) := paddr
  }

  def write_mapy2_arch_to_phys(addr: UInt, paddr: UInt) = {
    mapy2a_arch_to_phys(addr) := paddr
    mapy2b_arch_to_phys(addr) := paddr
    mapy2c_arch_to_phys(addr) := paddr
  }

  def read_specul_map(port: Int, addr: UInt): UInt = {
    val res = Wire(UInt(PHYS_ADDR_LEN.W))
    when (specul_sel(addr) === 0.U) {
      when (phys0sel(addr) === 0.U) {
        res := read_mapx1_arch_to_phys(port, addr)
      }.otherwise {
        res := read_mapx2_arch_to_phys(port, addr)
      }
    }.otherwise {
      when (phys1sel(addr) === 0.U) {
        res := read_mapy1_arch_to_phys(port, addr)
      }.otherwise {
        res := read_mapy2_arch_to_phys(port, addr)
      }
    }
    res
  }
  def write_specul_map(port: Int, addr: UInt, paddr: UInt): Unit = {
    phys1sel(addr) := port.U
    if (port == 0) {
      write_mapy1_arch_to_phys(addr, paddr)
    } else {
      write_mapy2_arch_to_phys(addr, paddr)
    }
    specul_sel(addr) := 1.U
  }
  def read_stable_map(addr: UInt): UInt = {
    val res = Wire(UInt(PHYS_ADDR_LEN.W))
    when (phys0sel(addr) === 0.U) {
      res := read_mapx1_arch_to_phys(0, addr)
    }.otherwise {
      res := read_mapx2_arch_to_phys(0, addr)
    }
    res
  }
  if (debug) {
    for (i <- 0 until 32) {
      printf(cf"rf[x${i}%02d]: {0x${read_specul_map(0, i.U)}%x}  {0x${read_stable_map(i.U)}%x}\n")
    }
    for (i <- 0 until 16) {
      printf(cf"fq[${i}%02d]: {0x${if (i % 2 == 0) free_phys_queue_0(i / 2) else free_phys_queue_1(i / 2)}%x}\n")
    }
  }
  printf(cf"enq_ptr=${enq_ptr}  specul_ptr=${specul_ptr}\n")

  def write_stable_map(port: Int, addr: UInt, paddr: UInt): Unit = {
    phys0sel(addr) := port.U
    if (port == 0) {
      write_mapx1_arch_to_phys(addr, paddr)
    } else {
      write_mapx2_arch_to_phys(addr, paddr)
    }
  }

  def map_specul: Unit = {
    val specul_ptr2 = specul_ptr + 1.U
    val queue_addr_0 = Mux(specul_ptr(0), specul_ptr2, specul_ptr) >> 1
    val queue_addr_1 = Mux(specul_ptr(0), specul_ptr, specul_ptr2) >> 1
    val paddr_0 = free_phys_queue_0(queue_addr_0)
    val paddr_1 = free_phys_queue_1(queue_addr_1)
    val assign1_paddr = Mux(specul_ptr(0), paddr_1, paddr_0)
    val assign2_paddr = Mux(specul_ptr(0), paddr_0, paddr_1)
    io.specul1.map_rs1.paddr    := read_specul_map(0, io.specul1.map_rs1.addr)
    io.specul1.map_rs2.paddr    := read_specul_map(0, io.specul1.map_rs2.addr)
    io.specul1.map_rs3.paddr    := read_specul_map(0, io.specul1.map_rs3.addr)
    io.specul1.assign.paddr     := assign1_paddr
    io.specul1.assign.paddr_rel := read_specul_map(1, io.specul1.assign.addr)
    io.specul2.map_rs1.paddr    := Mux(io.specul1.assign.en && io.specul2.map_rs1.addr === io.specul1.assign.addr, assign1_paddr, read_specul_map(2, io.specul2.map_rs1.addr))
    io.specul2.map_rs2.paddr    := Mux(io.specul1.assign.en && io.specul2.map_rs2.addr === io.specul1.assign.addr, assign1_paddr, read_specul_map(2, io.specul2.map_rs2.addr))
    io.specul2.map_rs3.paddr    := Mux(io.specul1.assign.en && io.specul2.map_rs3.addr === io.specul1.assign.addr, assign1_paddr, read_specul_map(2, io.specul2.map_rs3.addr))
    io.specul2.assign.paddr     := Mux(io.specul1.assign.en, assign2_paddr, assign1_paddr)
    io.specul2.assign.paddr_rel := Mux(io.specul1.assign.en && io.specul2.assign.addr === io.specul1.assign.addr, assign1_paddr, read_specul_map(1, io.specul2.assign.addr))
    when (!io.res.en && (io.specul1.assign.en || io.specul2.assign.en)) {
      specul_ptr := specul_ptr + 1.U
      write_specul_map(0, Mux(io.specul1.assign.en, io.specul1.assign.addr, io.specul2.assign.addr), assign1_paddr)
    }
    when (!io.res.en && io.specul1.assign.en && io.specul2.assign.en) {
      specul_ptr := specul_ptr + 2.U
      write_specul_map(1, io.specul2.assign.addr, assign2_paddr)
    }
    when (!io.res.en && io.specul1.assign.en) {
      printf(cf"rf rs1 x${io.specul1.map_rs1.addr}%d -> {0x${io.specul1.map_rs1.paddr}%x}\n")
      printf(cf"rf rs2 x${io.specul1.map_rs2.addr}%d -> {0x${io.specul1.map_rs2.paddr}%x}\n")
      printf(cf"rf rs3 x${io.specul1.map_rs3.addr}%d -> {0x${io.specul1.map_rs3.paddr}%x}\n")
      printf(cf"rf wb  x${io.specul1.assign.addr}%d -> {0x${io.specul1.assign.paddr}%x}\n")
    }
    when (!io.res.en && io.specul2.assign.en) {
      printf(cf"rf rs1 x${io.specul2.map_rs1.addr}%d -> {0x${io.specul2.map_rs1.paddr}%x}\n")
      printf(cf"rf rs2 x${io.specul2.map_rs2.addr}%d -> {0x${io.specul2.map_rs2.paddr}%x}\n")
      printf(cf"rf rs3 x${io.specul2.map_rs3.addr}%d -> {0x${io.specul2.map_rs3.paddr}%x}\n")
      printf(cf"rf wb  x${io.specul2.assign.addr}%d -> {0x${io.specul2.assign.paddr}%x}\n")
    }
  }

  def stabilize: Unit = {
    val enq_ptr2 = enq_ptr + 1.U
    val queue_addr_0 = Mux(enq_ptr(0), enq_ptr2, enq_ptr) >> 1
    val queue_addr_1 = Mux(enq_ptr(0), enq_ptr, enq_ptr2) >> 1
    val paddr_rel_0  = Mux(enq_ptr(0) || !io.stabilize1.en, io.stabilize2.paddr_rel, io.stabilize1.paddr_rel)
    val paddr_rel_1  = Mux(enq_ptr(0) &&  io.stabilize1.en, io.stabilize1.paddr_rel, io.stabilize2.paddr_rel)
    val paddr_0  = Mux(enq_ptr(0) || !io.stabilize1.en, io.stabilize2.paddr, io.stabilize1.paddr)
    val paddr_1  = Mux(enq_ptr(0) &&  io.stabilize1.en, io.stabilize1.paddr, io.stabilize2.paddr)
    when (!enq_ptr(0) && (io.stabilize1.en || io.stabilize2.en) || enq_ptr(0) && io.stabilize1.en && io.stabilize2.en) {
      if (debug) {
        when (free_phys_queue_0(queue_addr_0) =/= paddr_0) {
          printf(cf"free phys queue mismatch 0\n")
        }
      }
      free_phys_queue_0(queue_addr_0) := paddr_rel_0
    }
    when (enq_ptr(0) && (io.stabilize1.en || io.stabilize2.en) || !enq_ptr(0) && io.stabilize1.en && io.stabilize2.en) {
      if (debug) {
        when (free_phys_queue_1(queue_addr_1) =/= paddr_1) {
          printf(cf"free phys queue mismatch 1\n")
        }
      }
      free_phys_queue_1(queue_addr_1) := paddr_rel_1
    }
    when (io.stabilize1.en) {
      write_stable_map(0, io.stabilize1.addr, io.stabilize1.paddr)
    }
    when (io.stabilize2.en) {
      write_stable_map(1, io.stabilize2.addr, io.stabilize2.paddr)
    }
    when (io.stabilize1.en || io.stabilize2.en) {
      enq_ptr := enq_ptr + 1.U
    }
    when (io.stabilize1.en && io.stabilize2.en) {
      enq_ptr := enq_ptr + 2.U
    }
    when (io.res.en) {
      (0 until 32).map(i => specul_sel(i) := 0.U)
      specul_ptr := enq_ptr
    }

    printf(cf"stabilize1.en = ${io.stabilize1.en}  stabilize2.en = ${io.stabilize2.en}\n")
    when (io.stabilize1.en) {
      printf(cf"rf wbr x${io.stabilize1.addr}%d // {0x${io.stabilize1.paddr_rel}%x}\n")
      printf(cf"rf wbs x${io.stabilize1.addr}%d -> {0x${io.stabilize1.paddr}%x}\n")
    }
    when (io.stabilize2.en) {
      printf(cf"rf wbr x${io.stabilize2.addr}%d // {0x${io.stabilize2.paddr_rel}%x}\n")
      printf(cf"rf wbs x${io.stabilize2.addr}%d -> {0x${io.stabilize2.paddr}%x}\n")
    }
  }

  def read: Unit = {
    def read_regfile_a(paddr: UInt): UInt = {
      Mux(regsel(paddr) === 0.U, regfile1a(paddr), regfile2a(paddr))
    }
    def read_regfile_b(paddr: UInt): UInt = {
      Mux(regsel(paddr) === 0.U, regfile1b(paddr), regfile2b(paddr))
    }

    for (i <- 0 until 3) {
      io.read(i).rdata := read_regfile_a(io.read(i).paddr)
    }
    for (i <- 3 until 5) {
      io.read(i).rdata := read_regfile_b(io.read(i).paddr)
    }
  }

  def write: Unit = {
    def write_regfile_1(paddr: UInt, wdata: UInt): Unit = {
      regsel(paddr) := 0.U
      regfile1a(paddr) := wdata
      regfile1b(paddr) := wdata
    }
    def write_regfile_2(paddr: UInt, wdata: UInt): Unit = {
      regsel(paddr) := 1.U
      regfile2a(paddr) := wdata
      regfile2b(paddr) := wdata
    }

    when (io.write(0).en) {
      write_regfile_1(io.write(0).paddr, io.write(0).wdata)
    }
    when (io.write(1).en) {
      write_regfile_2(io.write(1).paddr, io.write(1).wdata)
    }
  }

  map_specul
  stabilize
  read
  write
}
