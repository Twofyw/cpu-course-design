module sccpu_dataflow (clock, reset, inst, mem, pc, wmem, alu, data_out, intr, inta, i_lw_out);
    input       [31:0]      inst, mem;
    input                   clock, reset;
    output      [31:0]      pc, alu, data_out;
    output                  wmem, i_lw_out;

    wire        [31:0]      alu_hi, alu_lo;
    assign                  alu         = {alu_hi, alu_lo};

    // Exceptions
    input                   intr;
    output                  inta;
    wire                    exc, wsta, wcau, wepc, mtc0;
    wire        [31:0]      sta, cau, epc, sta_in, cau_in, epc_in,
                            sta_l1_a0, epc_l1_a0, cause, alu_mem_c0, next_pc;
    wire         [1:0]      mfc0, selpc;

    wire        [31:0]      p4, bpc, npc, adr, ra, alua, alub, res, alu_mem, mem_bh, hilo, data_regfile;
    wire        [31:0]      reg_lo, reg_hi;
    wire         [4:0]      aluc;
    wire         [4:0]      reg_dest, wn;
    wire         [1:0]      pcsource;
    wire                    zero, wreg, regrt;
    wire         [1:0]      m2reg, dmems;
    wire                    shift, aluimm, jal, sext, sextb, sexth, whi, wlo, byte_and_hi, store_pc;

    wire                    e           = sext & inst[15];
    wire        [15:0]      imm         = { 16{e} };
    wire        [31:0]      immediate   = { imm, inst[15:0] };
    wire        [31:0]      sa          = { 27'b0, inst[10:6] };
    wire        [31:0]      offset      = { imm[13:0], inst[15:0], 2'b00 };
    wire                    rsgez       = ($signed(ra) >= $signed(0)) ? 1'b1 : 1'b0;
    wire                    wepty;
    reg         [31:0]      cp0_empty  [0:31];
    reg         [31:0]      cp0_empty_out;
    integer i;
    always @(negedge clock or posedge reset) begin
        if (reset) begin
          for (i = 0; i < 32; i = i + 1) begin
            cp0_empty[i] <= 32'b0;
          end
        end else if (wepty) begin
            cp0_empty[inst[15:11]] <= data_regfile;
        end else begin
            cp0_empty_out <= cp0_empty[inst[15:11]];
        end
    end

    // sext b/h
    wire                    e_b         = sextb & mem[7];
    wire                    e_h         = sexth & mem[15];
    wire        [31:0]      mem_b       = { {24{e_b}}, mem[7:0] };
    wire        [31:0]      mem_h       = { {16{e_h}}, mem[15:0] };

    sccu_dataflow           cu          (inst[31:26], inst[25:21], inst[20:16], inst[15:11], inst[5:0],
                                        zero, wmem, wreg, regrt, m2reg, aluc, shift,
                                        aluimm, pcsource, jal, sext, sextb, sexth, hilo_from_alu, whi, wlo,
                                        dmems, byte_and_hi, intr, inta, sta, cause, exc,
                                        wsta, wcau, wepc, mtc0, mfc0, selpc, rsgez, store_pc, rd_is_empty,
                                        wepty, read_empty, i_lw_out);
    dff32                   ip          (next_pc, clock, reset, pc);

    assign                  p4          = pc + 32'h4;
    assign                  adr         = p4 + offset;

    wire        [31:0]      jpc         = { p4[31:28], inst[25:0], 2'b00 };
    mux2         #(32)      alu_b       (data_regfile, immediate, aluimm, alub);
    mux2         #(32)      alu_a       (ra, sa, shift, alua);
    mux2         #(32)      mem_bh_m    (mem_h, mem_b, byte_and_hi, mem_bh);
    mux2         #(32)      reg_lohi_m  (reg_lo, reg_hi, byte_and_hi, hilo);
    mux4         #(32)      result      (alu_lo, store_pc ? p4 : mem, mem_bh, hilo, m2reg, alu_mem);
    mux2         #(32)      link        (alu_mem_c0, p4, jal, res);        // p8 for mips compatibility
    mux2          #(5)      reg_wn      (inst[15:11], inst[20:16], regrt, reg_dest);
    assign                  wn          = reg_dest | { 5{jal} };        // jal: r31 <-- p4;
    mux4         #(32)      nextpc      (p4, adr, ra, jpc, pcsource, npc);
    regfile                 cpu_ref     (inst[25:21], inst[20:16], res, wn, wreg, clock, reset, ra, data_regfile);
    alu                     al_unit     (alua, alub, aluc, {alu_hi, alu_lo}, zero);  // append carry, negative, overflow

    // Exceptions
    dffe32      c0_Status       (sta_in, clock, reset, wsta, sta);
    dffe32      c0_Cause        (cau_in, clock, reset, wcau, cau);
    dffe32      c0_EPC          (epc_in, clock, reset, wepc, epc);

    mux2        sta_l1          (sta_l1_a0, data_regfile, mtc0, sta_in);
    mux2        sta_l2          ({4'h0, sta[31:4]}, {sta[27:0], 4'h0}, exc, sta_l1_a0);
    mux2        cau_l1          (cause, data_regfile, mtc0, cau_in);
    mux2        epc_l1          (pc, data_regfile, mtc0, epc_in);
    mux4        irq_pc          (npc, epc, 32'h4, 32'h0, selpc, next_pc);
    mux4        fromc0          (read_empty ? cp0_empty_out : alu_mem, sta, cau, epc, mfc0, alu_mem_c0);
    // Exceptions end


    // LO/HI
    dffe32                  reg_hi_dffe (hilo_from_alu ? alu_hi : ra, clock, reset, whi, reg_hi);
    dffe32                  reg_lo_dffe (hilo_from_alu ? alu_lo : ra, clock, reset, wlo, reg_lo);
    mux4                    data_out_m  (data_regfile, {24'b0, data_regfile[7:0]}, {16'b0, data_regfile[15:0]}, 32'b0, dmems, data_out);


endmodule
