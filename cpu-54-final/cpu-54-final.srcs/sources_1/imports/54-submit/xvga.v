`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/10/2017 01:42:24 AM
// Design Name:
// Module Name: xvga
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
////////////////////////////////////////////////////////////////////////////////
//
// xvga: Generate XVGA display signals (1024 x 768 @ 60Hz)
//
////////////////////////////////////////////////////////////////////////////////
module xvga(input vclock,
            output reg [10:0] hcount,    // pixel number on current line
            output reg [10:0] vcount,	 // line number
            output reg vsync,hsync);

   // horizontal: 1344 pixels total
   // display 1024 pixels per line
   wire hsyncon,hsyncoff,hreset;
   assign hsyncon = (hcount == 1047);
   assign hsyncoff = (hcount == 1183);
   assign hreset = (hcount == 1343);

   // vertical: 806 lines total
   // display 768 lines
   wire vsyncon,vsyncoff,vreset;
   assign vsyncon = hreset & (vcount == 776);
   assign vsyncoff = hreset & (vcount == 782);
   assign vreset = hreset & (vcount == 805);

   // sync and blanking
   always @(posedge vclock) begin
      hcount <= hreset ? 0 : hcount + 1;
      hsync <= hsyncon ? 0 : hsyncoff ? 1 : hsync;  // active low

      vcount <= hreset ? (vreset ? 0 : vcount + 1) : vcount;
      vsync <= vsyncon ? 0 : vsyncoff ? 1 : vsync;  // active low
   end
endmodule
