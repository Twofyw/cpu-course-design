`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 06/18/2018 09:36:37 PM
// Design Name:
// Module Name: datamem_disp_tb
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


module datamem_disp_tb();
    reg             clk, reset, we;
    reg    [31:0]   addr;
    wire   [31:0]   dataout, datain, a_shift;

    scdatamem_disp uut (clk, reset, dataout, datain, addr, we, a_shift);

    initial begin
        clk = 0;
        reset = 0;

        addr = 32'h10008000;

        #4
        addr = addr + 32'h1000;
        #4
        addr = addr + 32'h1000;
        #4
        addr = addr + 32'h1000;
        #4
        addr = addr + 32'h1000;
        #4
        addr = addr + 32'h1000;

        #4
        addr = 32'h10010000;
        #4
        addr = addr + 32'h1000;
    end

    always #2 clk = ~clk;

    always @ (posedge clk) begin
        $display("$time, addr: %h, a_shift: %h", addr, uut.a_shift);
    end
endmodule
