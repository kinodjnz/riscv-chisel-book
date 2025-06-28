require_extension(EXT_ZCB);
MMU.store<uint8_t>(RVC_RS1S + insn.xcc_lsb_imm(), RVC_RS2S);
