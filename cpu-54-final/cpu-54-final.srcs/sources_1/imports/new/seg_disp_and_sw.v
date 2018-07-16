`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 06/15/2018 02:04:32 PM
// Design Name:
// Module Name: seg_disp_and_sw
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module seg_disp_and_sw(
    CLK100MHz, CPU_RESETN, sw, o_seg, o_sel, LED
    );
    input           CLK100MHz;
    input           CPU_RESETN;
    input  [15:0]   sw;
    output  [7:0]   o_seg;
    output  [7:0]   o_sel;
    output [15:0]   LED;

    wire            reset   = ~CPU_RESETN;
    wire   [31:0]   inst, pc, addr;
    wire            inta;
    wire            intr    = 1'b0;
    wire            seg7_cs;

    // Temporary data
    // wire    [31:0]  seg7_data   = 32'haaaa_aaaa;
    // wire    [31:0]  seg7_data   = sw ? { 16'b0, sw } : {pc[15:0], dmem0[15:0]};
    wire    [31:0]  test_data;
    wire    [31:0]  seg7_data   = test_data;

    wire            CLK, locked;
    // clk_div #(.factor(10)) seg_clk_div (CLK100MHz, reset, CLK);
    clk_wiz_0 CLK65 (.clk_in1(CLK100MHz),.reset(reset),.clk_out1(CLK),.locked(locked));

    sccomp_dataflow cpu (CLK, reset, inst, pc, addr, intr, inta, sw, test_data, seg7_cs);

    seg7x16 seg7(CLK, reset, seg7_cs, seg7_data, o_seg, o_sel);

    assign LED[15:2] = 14'b0;
    assign LED[1]    = CLK;
    assign LED[0]    = seg7_cs;
endmodule
