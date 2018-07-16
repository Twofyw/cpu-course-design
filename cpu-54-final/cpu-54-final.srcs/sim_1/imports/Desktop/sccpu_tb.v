`timescale 1ns / 1ps
module  sccpu_tb();
    reg                 reset, clk, ready_ok;
    wire    [31:0]      instr, pc, addr, test_data;
    reg     [31:0]      old_instr, old_pc;
    wire                intr = 1'b0;
    wire                inta;
    reg    [15:0]      sw = 16'h8001;
    sccomp_dataflow uut (clk, reset, instr, pc, addr, intr, inta, sw, test_data, seg7_cs);

    localparam SHIFT = 32'h00400000;

    reg [31:0] old_reg [0:31];

    integer file_output, delay, i, old_reg_i;
    initial begin
        reset       <= 1;
        ready_ok    <= 0;
        clk         <= 0;
        file_output  = $fopen("result.txt");
        delay       <= 0;

        #200
        reset       <= 0;

        // #30 sw = 16';

        // Initialize inst_array
        // $readmemh("C:/Users/twofyw/Documents/vivado/54CPUtest/custom-test-1.txt", uut.imem.ram);
        // $readmemh("C:/Users/twofyw/Documents/vivado/54CPUtest/36.39_lbsb2.hex.txt", uut.imem.ram);
        // for (i = 0; i < 5; i = i + 1) begin
        //     $display("rdata:%h",uut.imem.ram[i]);
        // end
        #0
        old_pc  <= pc - SHIFT;
        old_instr <= instr;

        for (old_reg_i = 0; old_reg_i < 32; old_reg_i=old_reg_i+1) begin
            old_reg[old_reg_i] = 0;
        end
        ready_ok    <= 1;
    end

    always #2 clk = ~clk;

    always @ ( posedge clk ) begin
        if (ready_ok) begin
            #0
            // $fdisplay(file_output,"pc: %h", pc < SHIFT ? pc : pc - SHIFT);
            $fdisplay(file_output,"pc: %h", pc);
            $fdisplay(file_output,"instr: %h", instr);
            // $fdisplay(file_output,"pc: %h", old_pc);
            // $fdisplay(file_output,"instr: %h", old_instr);
            // $fdisplay(file_output,"seg7_cs: %h", uut.seg7_cs);
            // $fdisplay(file_output,"switch_cs: %h", uut.switch_cs);
            // $fdisplay(file_output,"addr: %h", uut.addr);
            // $fdisplay(file_output,"test_data: %h", test_data);
            // $fdisplay(file_output,"pcsource: %h", uut.sccpu.pcsource);
            // $fdisplay(file_output,"selpc: %h", uut.sccpu.selpc);
            // // $fdisplay(file_output,"p4: %h", uut.sccpu.p4);
            // $fdisplay(file_output,"pc: %h", uut.sccpu.pc);
            // // $fdisplay(file_output,"npc: %h", uut.sccpu.npc);
            // $fdisplay(file_output,"next_pc: %h", uut.sccpu.next_pc);
            // $fdisplay(file_output,"ip.pc: %h", uut.sccpu.ip.pc);
            // $fdisplay(file_output,"inst a: %h", uut.imem.a);
            // $fdisplay(file_output,"dmem a: %h", uut.dmem.a_shift);
            // $fdisplay(file_output,"dmem 0: %h", uut.dmem.ram[0]);
            // $fdisplay(file_output,"m2reg: %b", uut.sccpu.m2reg);
            // $fdisplay(file_output,"mem: %h", uut.sccpu.mem);
            // $fdisplay(file_output,"store_pc: %h", uut.sccpu.store_pc);
            // $fdisplay(file_output,"alu_lo: %h", uut.sccpu.alu_lo);
            // $fdisplay(file_output,"aluc: %b", uut.sccpu.aluc);
            // $fdisplay(file_output,"c0_Status: %h", uut.sccpu.c0_Status.current_out);
            // $fdisplay(file_output,"c0_Cause: %h", uut.sccpu.c0_Cause.current_out);
            // $fdisplay(file_output,"c0_EPC: %h", uut.sccpu.c0_EPC.current_out);
            // $fdisplay(file_output,"wcau: %h", uut.sccpu.wcau);
            // $fdisplay(file_output,"cau: %h", uut.sccpu.cau);
            // $fdisplay(file_output,"mtc0: %h", uut.sccpu.mtc0);
            // $fdisplay(file_output,"cp0_empty_out: %h", uut.sccpu.cp0_empty_out);
            // $fdisplay(file_output,"read_empty: %h", uut.sccpu.read_empty);
            // $fdisplay(file_output,"mfc0: %h", uut.sccpu.mfc0);
            // $fdisplay(file_output,"alu_mem_c0: %h", uut.sccpu.alu_mem_c0);
            // $fdisplay(file_output,"wreg: %h", uut.sccpu.wreg);
            // $fdisplay(file_output,"res: %h", uut.sccpu.res);
            // $fdisplay(file_output,"cause: %h", uut.sccpu.cu.cause);
            // $fdisplay(file_output,"i_break: %h", uut.sccpu.cu.i_break);
            // $fdisplay(file_output,"i_syscall: %h", uut.sccpu.cu.i_syscall);
            // $fdisplay(file_output,"i_teq: %h", uut.sccpu.cu.i_teq);
            // $fdisplay(file_output,"i_eret: %h", uut.sccpu.cu.i_eret);
            // $fdisplay(file_output,"i_eret: %h", uut.sccpu.cu.i_eret);
            // $fdisplay(file_output,"wn: %h", uut.sccpu.wn);
            // $fdisplay(file_output,"al_r: %b", uut.sccpu.al_unit.r);

            $fdisplay(file_output,"regfile0: %h",  old_reg[0]);
            $fdisplay(file_output,"regfile1: %h",  old_reg[1]);
            $fdisplay(file_output,"regfile2: %h",  old_reg[2]);
            $fdisplay(file_output,"regfile3: %h",  old_reg[3]);
            $fdisplay(file_output,"regfile4: %h",  old_reg[4]);
            $fdisplay(file_output,"regfile5: %h",  old_reg[5]);
            $fdisplay(file_output,"regfile6: %h",  old_reg[6]);
            $fdisplay(file_output,"regfile7: %h",  old_reg[7]);
            $fdisplay(file_output,"regfile8: %h",  old_reg[8]);
            $fdisplay(file_output,"regfile9: %h",  old_reg[9]);
            $fdisplay(file_output,"regfile10: %h", old_reg[10]);
            $fdisplay(file_output,"regfile11: %h", old_reg[11]);
            $fdisplay(file_output,"regfile12: %h", old_reg[12]);
            $fdisplay(file_output,"regfile13: %h", old_reg[13]);
            $fdisplay(file_output,"regfile14: %h", old_reg[14]);
            $fdisplay(file_output,"regfile15: %h", old_reg[15]);
            $fdisplay(file_output,"regfile16: %h", old_reg[16]);
            $fdisplay(file_output,"regfile17: %h", old_reg[17]);
            $fdisplay(file_output,"regfile18: %h", old_reg[18]);
            $fdisplay(file_output,"regfile19: %h", old_reg[19]);
            $fdisplay(file_output,"regfile20: %h", old_reg[20]);
            $fdisplay(file_output,"regfile21: %h", old_reg[21]);
            $fdisplay(file_output,"regfile22: %h", old_reg[22]);
            $fdisplay(file_output,"regfile23: %h", old_reg[23]);
            $fdisplay(file_output,"regfile24: %h", old_reg[24]);
            $fdisplay(file_output,"regfile25: %h", old_reg[25]);
            $fdisplay(file_output,"regfile26: %h", old_reg[26]);
            $fdisplay(file_output,"regfile27: %h", old_reg[27]);
            $fdisplay(file_output,"regfile28: %h", old_reg[28]);
            $fdisplay(file_output,"regfile29: %h", old_reg[29]);
            $fdisplay(file_output,"regfile30: %h", old_reg[30]);
            $fdisplay(file_output,"regfile31: %h", old_reg[31]);
            // $fdisplay(file_output,"regfile0: %h",  uut.sccpu.cpu_ref.array_reg[0]);
            // $fdisplay(file_output,"regfile1: %h",  uut.sccpu.cpu_ref.array_reg[1]);
            // $fdisplay(file_output,"regfile2: %h",  uut.sccpu.cpu_ref.array_reg[2]);
            // $fdisplay(file_output,"regfile3: %h",  uut.sccpu.cpu_ref.array_reg[3]);
            // $fdisplay(file_output,"regfile4: %h",  uut.sccpu.cpu_ref.array_reg[4]);
            // $fdisplay(file_output,"regfile5: %h",  uut.sccpu.cpu_ref.array_reg[5]);
            // $fdisplay(file_output,"regfile6: %h",  uut.sccpu.cpu_ref.array_reg[6]);
            // $fdisplay(file_output,"regfile7: %h",  uut.sccpu.cpu_ref.array_reg[7]);
            // $fdisplay(file_output,"regfile8: %h",  uut.sccpu.cpu_ref.array_reg[8]);
            // $fdisplay(file_output,"regfile9: %h",  uut.sccpu.cpu_ref.array_reg[9]);
            // $fdisplay(file_output,"regfile10: %h", uut.sccpu.cpu_ref.array_reg[10]);
            // $fdisplay(file_output,"regfile11: %h", uut.sccpu.cpu_ref.array_reg[11]);
            // $fdisplay(file_output,"regfile12: %h", uut.sccpu.cpu_ref.array_reg[12]);
            // $fdisplay(file_output,"regfile13: %h", uut.sccpu.cpu_ref.array_reg[13]);
            // $fdisplay(file_output,"regfile14: %h", uut.sccpu.cpu_ref.array_reg[14]);
            // $fdisplay(file_output,"regfile15: %h", uut.sccpu.cpu_ref.array_reg[15]);
            // $fdisplay(file_output,"regfile16: %h", uut.sccpu.cpu_ref.array_reg[16]);
            // $fdisplay(file_output,"regfile17: %h", uut.sccpu.cpu_ref.array_reg[17]);
            // $fdisplay(file_output,"regfile18: %h", uut.sccpu.cpu_ref.array_reg[18]);
            // $fdisplay(file_output,"regfile19: %h", uut.sccpu.cpu_ref.array_reg[19]);
            // $fdisplay(file_output,"regfile20: %h", uut.sccpu.cpu_ref.array_reg[20]);
            // $fdisplay(file_output,"regfile21: %h", uut.sccpu.cpu_ref.array_reg[21]);
            // $fdisplay(file_output,"regfile22: %h", uut.sccpu.cpu_ref.array_reg[22]);
            // $fdisplay(file_output,"regfile23: %h", uut.sccpu.cpu_ref.array_reg[23]);
            // $fdisplay(file_output,"regfile24: %h", uut.sccpu.cpu_ref.array_reg[24]);
            // $fdisplay(file_output,"regfile25: %h", uut.sccpu.cpu_ref.array_reg[25]);
            // $fdisplay(file_output,"regfile26: %h", uut.sccpu.cpu_ref.array_reg[26]);
            // $fdisplay(file_output,"regfile27: %h", uut.sccpu.cpu_ref.array_reg[27]);
            // $fdisplay(file_output,"regfile28: %h", uut.sccpu.cpu_ref.array_reg[28]);
            // $fdisplay(file_output,"regfile29: %h", uut.sccpu.cpu_ref.array_reg[29]);
            // $fdisplay(file_output,"regfile30: %h", uut.sccpu.cpu_ref.array_reg[30]);
            // $fdisplay(file_output,"regfile31: %h", uut.sccpu.cpu_ref.array_reg[31]);



            // old_pc  <= pc - SHIFT;
            old_pc  <= pc;
            old_instr <= instr;

            for (old_reg_i = 0; old_reg_i < 32; old_reg_i=old_reg_i+1) begin
                old_reg[old_reg_i] = uut.sccpu.cpu_ref.array_reg[old_reg_i];
            end
        end
    end
endmodule
