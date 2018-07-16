module mux2 (a0, a1, s, y);
    parameter LENGTH = 32;
    localparam  MSB = LENGTH - 1;
    input   [MSB:0]  a0, a1;
    input           s;
    output  [MSB:0]  y;

    function [MSB:0] select;
        input   [MSB:0]  a0, a1;
        input   [1:0]   s;
        case (s)
            1'b0: select = a0;
            1'b1: select = a1;
        endcase
    endfunction

    assign y = select(a0, a1, s);
endmodule

module mux4 (a0, a1, a2, a3, s, y);
    parameter LENGTH = 32;
    localparam  MSB = LENGTH - 1;
    input   [MSB:0]  a0, a1, a2, a3;
    input   [1:0]   s;
    output  [MSB:0]  y;

    function [MSB:0] select;
        input   [MSB:0]  a0, a1, a2, a3;
        input   [1:0]   s;
        case (s)
            2'b00: select = a0;
            2'b01: select = a1;
            2'b10: select = a2;
            2'b11: select = a3;
        endcase
    endfunction

    assign y = select(a0, a1, a2, a3, s);
endmodule
