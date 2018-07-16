module scinstmem (reset, a, inst);
    localparam  SHIFT = 32'h00400000;
    // localparam  SHIFT = 32'h0;
    input               reset;
    input      [31:0]   a;

    wire    [31:0]      a_shift = a - SHIFT;

    output     [31:0]   inst;
    localparam              DEPTH = 2048;

    // reg     [31:0]          ram  [0:DEPTH-1];
    // assign inst = ram[a_shift[12:2]];

    dist_mem_gen_0 irom (.a(a_shift[12:2]), .spo(inst));
endmodule
