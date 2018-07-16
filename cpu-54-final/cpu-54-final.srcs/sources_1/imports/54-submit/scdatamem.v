module scdatamem (clk, reset, dataout, datain, addr, we);
    localparam  SHIFT = 32'h10010000;
    input           [31:0]      datain;
    input           [31:0]      addr;
    input                       clk, we, reset;
    output          [31:0]      dataout;
    wire write_enable = we & ~clk;

    wire    [12:0]      a_shift = addr - SHIFT;
    wire    [10:0]       a_shift_2 = a_shift[12:2];

    data_mem_dist dram_inst (
        // .a(addr[]),
        .a(a_shift_2),
        .clk(~clk), // negate clk?
        .d(datain),
        .spo(dataout),
        .we(we)
    );

    // localparam  SHIFT = 32'h0;
    // input   [31:0]      a;
    // output  [31:0]      inst;

    // localparam          DEPTH = 512;
    // reg     [31:0]      ram  [0:DEPTH-1];

    // integer i;
    // // always @ ( negedge clk or posedge reset ) begin
    // always @ ( a_shift_2 ) begin
    //     if (reset) begin
    //         for (i = 0; i < DEPTH; i = i + 1) begin
    //             ram[i] <= 32'b0;
    //         end
    //     end else begin
    //         if (we) begin
    //             ram[a_shift_2] <= datain;
    //         end else begin
    //             dataout <= ram[a_shift_2];
    //         end
    //     end
    // end
endmodule