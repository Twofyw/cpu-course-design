// TODO: break
//  Check ExcCode truth table

module sccu_dataflow (op, op1, op2, rd, func, z, wmem, wreg, regrt, m2reg, aluc, shift,
        aluimm, pcsource, jal, sext, sextb, sexth, hilo_from_alu, whi, wlo, dmems, byte_and_hi,
        intr, inta, sta, cause, exc, wsta, wcau, wepc, mtc0, mfc0, selpc, rsgez, store_pc,
        rd_is_empty, wepty, read_empty, i_lw_out);
    input       [5:0]       op, func;
    input       [4:0]       op1, op2, rd;
    input                   z, rsgez;
    output                  wreg, regrt, jal, shift, aluimm, sext, wmem;
    output      [4:0]       aluc;
    output      [1:0]       pcsource, dmems, m2reg;
    output                  sextb, sexth, hilo_from_alu, whi, wlo, byte_and_hi, store_pc;
    output                  rd_is_empty, wepty, read_empty;
    output                  i_lw_out;

    wire r_type  = ~|op;
    wire c0_type = ~op[5] &    op[4] &   ~op[3] &   ~op[2] &   ~op[1] &   ~op[0] ;
    wire i_syscall=r_type & ~func[5] & ~func[4] &  func[3] &  func[2] & ~func[1] & ~func[0];
    wire i_eret  =c0_type &   op1[4] &  ~op1[3] &  ~op1[2] &  ~op1[1] &  ~op1[0] &
                 ~func[5] &  func[4] &  func[3] & ~func[2] & ~func[1] & ~func[0] ;
    wire i_break = r_type & ~func[5] & ~func[4] &  func[3] &  func[2] & ~func[1] &  func[0];
    wire i_mfc0  =c0_type &  ~op1[4] &  ~op1[3] &  ~op1[2] &  ~op1[1] &  ~op1[0] ;
    wire i_mtc0  =c0_type &  ~op1[4] &  ~op1[3] &   op1[2] &  ~op1[1] &  ~op1[0] ;
    wire i_teq   = r_type &  func[5] &  func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0];

    // Exceptions
    input                   intr;
    input       [31:0]      sta;
    output                  wcau, wepc, mtc0, exc, inta, wsta;
    output       [1:0]      mfc0, selpc;
    output      [31:0]      cause;

    wire int_int = sta[0] & intr;
    assign inta  = int_int;
    wire exc_sys = sta[1] & i_syscall;
    wire exc_brk = sta[2] & i_break;
    wire exc_teq = sta[3] & i_teq;
    assign exc   = int_int | exc_sys | exc_brk | exc_teq;

    wire         [3:0]      ExcCode;
    assign ExcCode[3] = 1;
    assign ExcCode[2] = i_teq;
    assign ExcCode[1] = 0;
    assign ExcCode[0] = i_teq | i_break;
    assign cause   = { 26'b0, ExcCode, 2'b00 };

    wire rd_is_status = (rd == 5'd12);
    wire rd_is_cause  = (rd == 5'd13);
    wire rd_is_epc    = (rd == 5'd14);
    assign rd_is_empty  = ~rd_is_cause & ~rd_is_status & ~rd_is_epc;

    assign mtc0 = i_mtc0;
    assign wsta = exc | mtc0 & rd_is_status | i_eret;
    assign wcau = exc | mtc0 & rd_is_cause;
    assign wepc = exc | mtc0 & rd_is_epc;
    assign wepty= exc | mtc0;
    assign read_empty = i_mfc0 & ~rd_is_cause & ~rd_is_status & ~rd_is_epc;

    assign mfc0[0]    = i_mfc0 & rd_is_status | i_mfc0 & rd_is_epc;
    assign mfc0[1]    = i_mfc0 & rd_is_cause  | i_mfc0 & rd_is_epc;

    assign selpc[0] = i_eret;
    assign selpc[1] = exc;
    // Exceptions end

    wire i_add   = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
    wire i_addi  =            ~op[5] &   ~op[4] &    op[3] &   ~op[2] &   ~op[1] &   ~op[0];
    wire i_addiu =            ~op[5] &   ~op[4] &    op[3] &   ~op[2] &   ~op[1] &    op[0];
    wire i_addu  = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] &  func[0];
    wire i_and   = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0];
    wire i_andi  =            ~op[5] &   ~op[4] &    op[3] &    op[2] &   ~op[1] &   ~op[0];
    wire i_beq   =            ~op[5] &   ~op[4] &   ~op[3] &    op[2] &   ~op[1] &   ~op[0];
    wire i_bne   =            ~op[5] &   ~op[4] &   ~op[3] &    op[2] &   ~op[1] &    op[0];
    wire i_j     =            ~op[5] &   ~op[4] &   ~op[3] &   ~op[2] &    op[1] &   ~op[0];
    wire i_jal   =            ~op[5] &   ~op[4] &   ~op[3] &   ~op[2] &    op[1] &    op[0];
    wire i_jr    = r_type & ~func[5] & ~func[4] &  func[3] & ~func[2] & ~func[1] & ~func[0];
    wire i_lui   =            ~op[5] &   ~op[4] &    op[3] &    op[2] &    op[1] &    op[0];
    wire i_lw    =             op[5] &   ~op[4] &   ~op[3] &   ~op[2] &    op[1] &    op[0];
    assign i_lw_out = i_lw;
    wire i_nor   = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] &  func[0];
    wire i_or    = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] &  func[0];
    wire i_ori   =            ~op[5] &   ~op[4] &    op[3] &    op[2] &   ~op[1] &    op[0];
    wire i_sll   = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
    wire i_sllv  = r_type & ~func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0];
    wire i_slt   = r_type &  func[5] & ~func[4] &  func[3] & ~func[2] &  func[1] & ~func[0];
    wire i_slti  =            ~op[5] &   ~op[4] &    op[3] &   ~op[2] &    op[1] &   ~op[0];
    wire i_sltiu =            ~op[5] &   ~op[4] &    op[3] &   ~op[2] &    op[1] &    op[0];
    wire i_sltu  = r_type &  func[5] & ~func[4] &  func[3] & ~func[2] &  func[1] &  func[0];
    wire i_sra   = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] &  func[0];
    wire i_srav  = r_type & ~func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] &  func[0];
    wire i_srl   = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];
    wire i_srlv  = r_type & ~func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] & ~func[0];
    wire i_sub   = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];
    wire i_subu  = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] &  func[0];
    wire i_sw    =             op[5] &   ~op[4] &    op[3] &   ~op[2] &    op[1] &    op[0];
    wire i_xor   = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] & ~func[0];
    wire i_xori  =            ~op[5] &   ~op[4] &    op[3] &    op[2] &    op[1] &   ~op[0];
    wire i_lb    =             op[5] &   ~op[4] &   ~op[3] &   ~op[2] &   ~op[1] &   ~op[0];
    wire i_lbu   =             op[5] &   ~op[4] &   ~op[3] &    op[2] &   ~op[1] &   ~op[0];
    wire i_lhu   =             op[5] &   ~op[4] &   ~op[3] &    op[2] &   ~op[1] &    op[0];
    wire i_sb    =             op[5] &   ~op[4] &    op[3] &   ~op[2] &   ~op[1] &   ~op[0];
    wire i_sh    =             op[5] &   ~op[4] &    op[3] &   ~op[2] &   ~op[1] &    op[0];
    wire i_lh    =             op[5] &   ~op[4] &   ~op[3] &   ~op[2] &   ~op[1] &    op[0];
    wire i_mfhi  = r_type & ~func[5] &  func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
    wire i_mflo  = r_type & ~func[5] &  func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];
    wire i_mthi  = r_type & ~func[5] &  func[4] & ~func[3] & ~func[2] & ~func[1] &  func[0];
    wire i_mtlo  = r_type & ~func[5] &  func[4] & ~func[3] & ~func[2] &  func[1] &  func[0];
    wire i_clz   = ~op[5] &    op[4] &    op[3] &    op[2] &   ~op[1] &   ~op[0] &
                  func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
    wire i_divu  = r_type & ~func[5] &  func[4] &  func[3] & ~func[2] &  func[1] &  func[0];
    wire i_jalr  = r_type & ~func[5] & ~func[4] &  func[3] & ~func[2] & ~func[1] &  func[0];
    wire i_mul  =~op[5] &     op[4] &    op[3] &    op[2] &   ~op[1] &   ~op[0] &
                  ~func[5] &~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];
    wire i_multu = r_type & ~func[5] &  func[4] &  func[3] & ~func[2] & ~func[1] &  func[0];
    wire i_div   = r_type & ~func[5] &  func[4] &  func[3] & ~func[2] &  func[1] & ~func[0];
    wire i_bgez  = ~op[5] &   ~op[4] &   ~op[3] &   ~op[2] &   ~op[1] &    op[0] &
                   ~op2[4]&  ~op2[3] &  ~op2[2] &  ~op2[1] &   op2[0];

    assign wreg  =  i_add  | i_addu  | i_and  | i_nor  | i_or   | i_sll   | i_sllv | i_slt   | i_sltu  |
                    i_sra  | i_srav  | i_srl  | i_srlv | i_sub  | i_subu  | i_xor  | i_addi  | i_addiu |
                    i_andi | i_lui   | i_lw   | i_ori  | i_slti | i_sltiu | i_xori | i_jal   | i_lb    |
                    i_lbu  | i_lhu   | i_lh   | i_mfhi | i_mflo | i_mul   | i_mfc0 | i_jalr  | i_clz   |
                    read_empty;
    assign regrt =  i_addi | i_addiu | i_andi | i_lui  | i_lw   | i_ori   | i_slti | i_sltiu | i_xori  |
                    i_lb   | i_lbu   | i_lh   | i_lhu | i_mfc0;
    assign jal   =  i_jal;
    assign shift =  i_sll  | i_sra   | i_srl;
    assign aluimm=  i_addi | i_addiu | i_andi | i_lui  | i_ori  | i_slti  | i_xori | i_sltiu | i_lw    |
                    i_sw   | i_lb    | i_lbu  | i_lhu  | i_sb   | i_sh    | i_lh;
    assign sext  =  i_addi | i_beq   | i_bne  | i_lw   | i_sw   | i_slti  | i_addiu| i_lb    | i_lbu   |
                    i_lhu  | i_sb    | i_sh   | i_lh;
    assign aluc[4]= i_clz  | i_divu  | i_mul | i_multu | i_div;
    assign aluc[3]= i_sll  | i_sllv  | i_slt  | i_sltu | i_sra  | i_srav  | i_srl  | i_srlv  | i_sltiu |
    				i_lui  | i_slti;
    assign aluc[2]= i_and  | i_nor   | i_or   | i_sll  | i_sllv | i_sra   | i_srav | i_srl   | i_srlv  |
    				i_xor  | i_andi  | i_beq  | i_bne  | i_ori  | i_xori  | i_multu| i_div;
    assign aluc[1]= i_add  | i_nor   | i_sll  | i_sllv | i_slt  | i_sltu  | i_slti | i_sltiu | i_sub   |
    				i_xor  | i_addi  | i_beq  | i_bne  | i_xori | i_lw    | i_sw   | i_lb    | i_lbu   |
                    i_lhu  | i_sb    | i_sh   | i_lh   | i_mul;
    assign aluc[0]= i_nor  | i_or    | i_ori  | i_slt  | i_slti | i_srl   | i_srlv | i_sub   | i_subu  |
                    i_clz  | i_mul   | i_div;
    assign wmem   = i_sw   | i_sb    | i_sh   ;
    // BUG: input is x
    assign pcsource[1]  =    i_jr    | i_j    | i_jal  | i_jalr;
    assign pcsource[0]  =    i_jal   | i_j    | i_beq&z| i_bne&~z| i_bgez & rsgez;
    // assign pcsource = 2'b00;

    assign byte_and_hi  =    i_lb    | i_lbu  | i_mfhi | i_mthi;
    assign m2reg[1]= i_lb  | i_lbu   | i_lhu  | i_lh   | i_mfhi | i_mflo  | i_mthi | i_mtlo;
    assign m2reg[0]= i_lw  | i_mfhi  | i_mflo | i_mthi | i_mtlo | i_jalr;
    assign sextb  = i_lb;
    assign sexth  = i_lh;
    assign whi    = i_mthi | i_divu  | i_div  | i_multu;
    assign wlo    = i_mtlo | i_divu  | i_div  | i_multu;
    assign hilo_from_alu =   i_divu  | i_multu| i_div;
    assign dmems[1]=i_sh;
    assign dmems[0]=i_sb;
    assign store_pc = i_jalr;

endmodule
