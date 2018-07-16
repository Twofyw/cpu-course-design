`timescale 1ns / 1ps
// ==============================================================================
// 										  Define Module
// ==============================================================================
module logical(
  input  [31:0] a,
  input  [31:0] b,
  input  [1:0]  aluc,
  output reg [31:0] data_out,
  output zero, negative
  );

// ==============================================================================
// 							  Parameters, Registers, and Wires
// ==============================================================================
  wire   [31:0] And, Or, Xor, Nor;
// ==============================================================================
// 							  		   Implementation
// ==============================================================================
  assign And = a & b;
  assign Or  = a | b;
  assign Xor = a ^ b;
  assign Nor = ~(a | b);

  always @(*)
    case (aluc[1:0])
      2'b00: data_out = And;
      2'b01: data_out = Or;
      2'b10: data_out = Xor;
      2'b11: data_out = Nor;
    endcase

  assign zero = (data_out ? 1'b0 : 1'b1);
  assign negative = (data_out[31] ? 1'b1 : 1'b0);

endmodule
