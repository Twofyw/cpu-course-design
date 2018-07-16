`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 06/15/2018 04:07:28 PM
// Design Name:
// Module Name: clk_div
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


module clk_div ( clk_in, rst, out_clk );
    parameter       factor   = 5_000_000;  // the factor of dividing source frequency by
    // target frequency. Target frequency is 20 Hz in this case with 100MHz input frequency;

    localparam      count_to = factor >> 1;
    localparam      MSB      = 26; // Maximumly divides up to but not including 1Hz

    input           clk_in, rst;
    output  reg     out_clk;

    reg     [MSB:0]  counter = 0;

    always @(posedge clk_in or posedge rst) begin
        counter <= counter + 1;
        if (rst) begin
          counter <= 0;
          out_clk <= 0;
        end else if(counter == factor)
        begin
            counter <= 0;
            out_clk <= ~out_clk;
        end
    end

endmodule
