fprintf(stderr, "rs1=%llx rs2=%llx\n", RS1, RS2);
if (RS1 != RS2)
  set_pc(BRANCH_TARGET);
