`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/08/2017 08:32:51 PM
// Design Name:
// Module Name: drawing
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Display elements drawing library
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
// blob: generate rectangle on screen
//
//////////////////////////////////////////////////////////////////////
module blob
   #(parameter WIDTH = 64,            // default width: 64 pixels
               HEIGHT = 64,           // default height: 64 pixels
               color = 12'hFFF)  // default color: white
   (input [11:0] x,hcount,
    input [9:0] y,vcount,
    output reg [11:0] pixel);

   always @ * begin
      if ((hcount >= x && hcount < (x+WIDTH)) &&
	       (vcount >= y && vcount < (y+HEIGHT)))
	      pixel <= color;
      else pixel <= 0;
   end
endmodule

module colorful_blob
   #(parameter WIDTH = 64,            // default width: 64 pixels
               HEIGHT = 64)           // default height: 64 pixels
   (input [11:0] x,hcount,
    input [10:0] y,vcount,
    input [11:0] color,  // default color: white
    output reg [11:0] pixel);

   always @* begin
      if ((hcount >= x && hcount < (x+WIDTH)) &&
	       (vcount >= y && vcount < (y+HEIGHT)))
	      pixel <= color;
      else pixel <= 0;
   end
endmodule

//////////////////////////////////////////////////////////////////////
//
// circle: generate solid circle on screen
//
//////////////////////////////////////////////////////////////////////
module circle
  #(parameter RADIUS = 32)
  (input [11:0] x,hcount,
   input [10:0] y,vcount,
   input [11:0] color,
   output reg [11:0] pixel);

  // Experimenting with pipeline
  reg [19:0] dist11, dist12, dist2;

  always @* begin
    dist11 <= (hcount-x)**2;
    dist12 <= (vcount-y)**2;
    dist2  <= RADIUS**2;

    if (dist11 + dist12 < dist2)
      pixel <= color;
    else pixel <= 0;
  end
endmodule
