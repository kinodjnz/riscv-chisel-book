package common

import chisel3.{Data, Bool, Mux}
import chisel3.experimental.SourceInfo
import chisel3.util.log2Ceil

object PriorityMux2 {
  def priorityMux[T <: Data](
    in: Seq[(Bool, T)]
  )(
    implicit sourceInfo: SourceInfo
  ): T = {
    require(in.nonEmpty, "PriorityMux must have a non-empty argument")
    def muxBinary(in: Seq[(Bool, T)]): (Bool, T) = {
      if (in.size == 1) {
        in.head
      } else if (in.size == 2) {
        (in.head._1 | in.tail.head._1, Mux(in.head._1, in.head._2, in.tail.head._2))
      } else {
        val half = 1 << (log2Ceil(in.size) - 1)
        val fst = muxBinary(in.slice(0, half))
        val snd = muxBinary(in.slice(half, in.size))
        (fst._1 | snd._1, Mux(fst._1, fst._2, snd._2))
      }
    }
    muxBinary(in)._2
  }
}
