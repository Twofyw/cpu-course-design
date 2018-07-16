`timescale 1ns / 1ps
module barrelshifter32(
  input signed  [31:0]  a,
  input signed  [31:0]  b,
  input          [1:0]  aluc,
  output reg            carry,
  output reg    [31:0]  data_out,
  output                zero
  );

  always @ ( * )
    if (aluc[1])
      {carry, data_out} = b << a;
    else
      data_out          = (aluc[0] ? b >> a : $signed(b) >>> $signed(a));

  assign zero           = (data_out ? 1'b0 : 1'b1);
endmodule
