module sccomp_dataflow (clk_in, reset, inst, pc, addr, intr, inta, sw, test_data, seg7_cs);
    // localparam              SHIFT = 32'h00400000;
    localparam              MSB         = 31; // for 32 bit cpu
    input                   clk_in, reset, intr;
    input       [15:0]      sw;
    output      [MSB:0]     inst, pc, addr, test_data; // addr = aluout
    output                  inta, seg7_cs;

    wire        [MSB:0]     mem_in, mem_out;
    wire                    wmem;
    // wire                    clk_divided;
    assign test_data = mem_in;

    // clk_div                 clock_divider(clk_in, reset, clk_divided);

    wire [31:0] data_sel;
    wire i_lw_out;
    sccpu_dataflow          sccpu       (clk_in, reset, inst, data_sel, pc, wmem, addr, mem_in, intr,
                                        inta, i_lw_out);

    scinstmem               imem        (reset, pc, inst);

    scdatamem               dmem        (clk_in, reset, mem_out, mem_in, addr, wmem);

    // io_ext
    wire seg7_cs, switch_cs;
    io_sel inst_io_sel (addr, 1'b1, wmem, i_lw_out, seg7_cs, switch_cs);

    sw_mem_sel sm (switch_cs, sw, mem_out, data_sel);

endmodule
