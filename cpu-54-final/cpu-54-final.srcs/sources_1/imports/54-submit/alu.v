`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/04/2017 04:37:49 AM
// Design Name:
// Module Name: alu
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
//                     Port Declarations
// ==============================================================================
module alu(
  input          [31:0]    a,
  input          [31:0]    b,
  input          [4:0]     aluc,
  output   reg   [63:0]    r,
  output   reg             zero,
  output   reg             carry,
  output   reg             negative,
  output                   overflow
  );

//  ==============================================================================
// 							  Parameters, Registers, and Wires
// ==============================================================================
  // aluc[3:2]
  localparam [1:0]    S_AddSub32= 2'b00,
                      S_Logical = 2'b01,
                      S_Comparer= 2'b10,
                      S_Shift   = 2'b11;
  localparam [2:0]    S_Clz     = 3'b001,
                      S_Divu    = 3'b010,
                      S_Div     = 3'b101,
                      S_Mul     = 3'b011,
                      S_Multu   = 3'b100;

  wire      [31:0]   Addsub32, Logical, Lui, Shift;
  wire               Slt, Sltu;

  // Intermediate flag bits for components
  wire zero_add,     negative_add,   carry_add;
  wire zero_logical, negative_logical;
  wire zero_cmp,     negative_cmp;
  wire zero_shift,                   carry_shift;

// ==============================================================================
// 							  		   Implementation
// ==============================================================================
  addsub32 addsub (a, b, aluc[1:0], Addsub32, carry_add, zero_add, negative_add, overflow);
  logical logi (a, b, aluc[1:0], Logical, zero_logical, negative_logical);

  // Lui, Slt, Sltu,
  assign Lui = {b[15:0], 16'b0};
  assign Slt = ($signed(a) < $signed(b) ? 1'b1 : 1'b0);
  assign Sltu = (a < b) ? 1'b1 : 1'b0;

  assign zero_cmp = (a == b) ? 1'b1 : 1'b0;
  assign negative_cmp = (a < b) ? 1'b1 : 1'b0;
  // end

  barrelshifter32 shift (a, b, aluc[1:0], carry_shift, Shift, zero_shift);

  function [31:0] clz;
    input   [31:0]  rs;
    begin
      clz =
        rs[31:31] == 1'b1 ? 32'd0:
        rs[31:30] == 2'b01 ? 32'd1:
        rs[31:29] == 3'b001 ? 32'd2:
        rs[31:28] == 4'b0001 ? 32'd3:
        rs[31:27] == 5'b00001 ? 32'd4:
        rs[31:26] == 6'b000001 ? 32'd5:
        rs[31:25] == 7'b0000001 ? 32'd6:
        rs[31:24] == 8'b00000001 ? 32'd7:
        rs[31:23] == 9'b000000001 ? 32'd8:
        rs[31:22] == 10'b0000000001 ? 32'd9:
        rs[31:21] == 11'b00000000001 ? 32'd10:
        rs[31:20] == 12'b000000000001 ? 32'd11:
        rs[31:19] == 13'b0000000000001 ? 32'd12:
        rs[31:18] == 14'b00000000000001 ? 32'd13:
        rs[31:17] == 15'b000000000000001 ? 32'd14:
        rs[31:16] == 16'b0000000000000001 ? 32'd15:
        rs[31:15] == 17'b00000000000000001 ? 32'd16:
        rs[31:14] == 18'b000000000000000001 ? 32'd17:
        rs[31:13] == 19'b0000000000000000001 ? 32'd18:
        rs[31:12] == 20'b00000000000000000001 ? 32'd19:
        rs[31:11] == 21'b000000000000000000001 ? 32'd20:
        rs[31:10] == 22'b0000000000000000000001 ? 32'd21:
        rs[31:9] == 23'b00000000000000000000001 ? 32'd22:
        rs[31:8] == 24'b000000000000000000000001 ? 32'd23:
        rs[31:7] == 25'b0000000000000000000000001 ? 32'd24:
        rs[31:6] == 26'b00000000000000000000000001 ? 32'd25:
        rs[31:5] == 27'b000000000000000000000000001 ? 32'd26:
        rs[31:4] == 28'b0000000000000000000000000001 ? 32'd27:
        rs[31:3] == 29'b00000000000000000000000000001 ? 32'd28:
        rs[31:2] == 30'b000000000000000000000000000001 ? 32'd29:
        rs[31:1] == 31'b0000000000000000000000000000001 ? 32'd30:
        rs[31:0] == 32'b00000000000000000000000000000001 ? 32'd31:
        32'd32;
    end
  endfunction

  always @(*)
    if (aluc[4]) begin
      case (aluc[2:0])
        S_Clz: begin
            r      <= {32'b0, clz(a)}; // a or b?
        end

        S_Div: begin
            r       <= {$signed(a) % $signed(b), $signed(a) / $signed(b)};
        end
        S_Divu: begin
            r       <= {a % b, a / b};
        end

        S_Mul: begin
            r       <= $signed(a) * $signed(b);
        end

        S_Multu: begin
            r       <= a * b;
        end
      endcase
    end else begin
      case (aluc[3:2])
        S_AddSub32: begin
          r        <= {32'b0, Addsub32};
          zero     <= zero_add;
          carry    <= carry_add;
          negative <= negative_add;
        end

        S_Logical: begin
          r        <= {32'b0, Logical};
          zero     <= zero_logical;
          negative <= negative_logical;
        end

        S_Comparer:
          case (aluc[1])
            1'b0: r <= {32'b0, Lui};
          default: begin
            r        <= {32'b0, aluc[0] ? Slt : Sltu};
            zero     <= zero_cmp;
            negative <= negative_cmp;
          end
          endcase

        S_Shift: begin
          r         <= {32'b0, Shift};
          zero      <= zero_shift;
          carry     <= carry_shift;
        end
      endcase
    end
endmodule
