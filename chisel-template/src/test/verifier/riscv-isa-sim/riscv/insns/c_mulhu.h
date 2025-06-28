require_extension(EXT_ZCB);
require_either_extension('M', EXT_ZMMUL);
WRITE_RVC_RS1S(sext32(((uint64_t)(uint32_t)RVC_RS1S * (uint64_t)(uint32_t)RVC_RS2S) >> 32));
