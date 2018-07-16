`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/26/2018 11:31:10 PM
// Design Name:
// Module Name: dff32
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


module dff32(npc, clock, reset, pc);
    localparam              MSB = 31;
    localparam              SHIFT = 32'h00400000;
    // localparam              SHIFT = 32'h0;
    input       [MSB:0]     npc;
    input                   clock, reset;
    output reg  [MSB:0]     pc;

    always @ ( posedge clock or posedge reset ) begin
        if (reset) begin
            pc <= SHIFT;
        end else begin
            pc <= npc;
        end
    end


endmodule
