module scdatamem_disp (clk, reset, dataout, datain, addr, we);
    // generic data memory has depth 1000
    // graphics memory begins at [1000]
    // localparam  SHIFT_GP = 32'h10008000;
    localparam  SHIFT_DATA = 32'h10010000;
    input           [31:0]      datain;
    input           [31:0]      addr;
    input                       clk, we, reset;
    output   reg    [31:0]      dataout;
    wire write_enable = we & ~clk;

    wire            [31:0]      a_shift = addr - SHIFT_DATA;
    // assign a_shift = (addr < SHIFT_DATA) ? (addr - (SHIFT_GP - 32'h1000)) : addr - SHIFT_DATA;
    // output [31:0] a_shift = (addr < SHIFT_DATA) ? (addr - (SHIFT_GP - 32'h1000)) : addr - SHIFT_DATA;

    data_mem_dist dram_inst (
        .a(a_shift[12:2]),
        .clk(~clk), // negate clk?
        .d(datain),
        .spo(dataout),
        .we(write_enable)
        );

    // localparam  SHIFT = 32'h0;
    // input   [31:0]      a;
    // output  [31:0]      inst;

    // localparam          DEPTH = 2048;
    // reg     [31:0]      ram  [0:DEPTH-1];

    // integer i;
    // always @ ( negedge clk or posedge reset ) begin
    // // always @ ( * ) begin
    //     if (reset) begin
    //         for (i = 0; i < DEPTH; i = i + 1) begin
    //             ram[i] <= 32'b0;
    //         end
    //     end else begin
    //         if (we) begin
    //             ram[a_shift] <= datain;
    //         end else begin
    //             dataout <= ram[a_shift];
    //         end
    //     end
    // end
endmodule