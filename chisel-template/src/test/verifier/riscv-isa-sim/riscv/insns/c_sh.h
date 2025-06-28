require_extension(EXT_ZCB);
MMU.store<uint16_t>(RVC_RS1S + insn.xcc_lsh_imm(), RVC_RS2S);
