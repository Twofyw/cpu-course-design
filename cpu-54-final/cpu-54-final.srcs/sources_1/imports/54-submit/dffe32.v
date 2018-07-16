`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/26/2018 11:31:10 PM
// Design Name:
// Module Name: dffe32
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


module dffe32(next_in, clock, reset, ena, current_out);
    localparam              MSB = 31;
    // localparam              SHIFT = 32'h00400000;
    localparam              SHIFT = 32'h0;
    input       [MSB:0]     next_in;
    input                   clock, reset, ena;
    output reg  [MSB:0]     current_out;

    always @ ( posedge clock or posedge reset ) begin
        if (reset) begin
            current_out <= SHIFT;
        end else if (ena) begin
            current_out <= next_in;
        end
    end


endmodule
