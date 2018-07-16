module regfile (rna, rnb, d, wn, we, clk, clr, qa, qb);
    input        [4:0]      rna, rnb, wn;
    input       [31:0]      d;
    input                   we, clk, clr;
    output      [31:0]      qa, qb;
    reg         [31:0]      array_reg [0:31]; // omit 0 when implementing

    // 2 read ports
    assign      qa = (rna == 0) ? 0 : array_reg[rna];
    assign      qb = (rnb == 0) ? 0 : array_reg[rnb];

    // 1 wire port
    // integer i;
    // always @(negedge clk or posedge clr)
    //     if (clr == 1) begin
    //         for (i = 0; i < 32; i = i + 1) // omit 0 when implementing
    //             array_reg[i] <= 0;
    //     end else if ((wn != 0) && we)
    //     #1
    //         array_reg[wn] <= d;
    integer i;
    always @(negedge clk)
        if (clr == 1) begin
            for (i = 0; i < 32; i = i + 1) // omit 0 when implementing
                array_reg[i] <= 0;
        end else if ((wn != 0) && we)
            array_reg[wn] <= d;
endmodule // regfile
