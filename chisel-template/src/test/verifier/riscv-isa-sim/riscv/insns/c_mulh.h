require_extension(EXT_ZCB);
require_either_extension('M', EXT_ZMMUL);
WRITE_RVC_RS1S(sext32((sext32(RVC_RS1S) * sext32(RVC_RS2S)) >> 32));
