module Multipler_binary_unsigned (
    input clk,
    input rstn,

    input      [1:0] a,
    input      [1:0] b,
    output reg [3:0] q
);

  wire [4:0] res_rom[0:15];
  assign res_rom[4'b0000] = 4'b0000;
  assign res_rom[4'b0001] = 4'b0000;
  assign res_rom[4'b0010] = 4'b0000;
  assign res_rom[4'b0011] = 4'b0000;
  assign res_rom[4'b0100] = 4'b0000;
  assign res_rom[4'b0101] = 4'b0001;
  assign res_rom[4'b0110] = 4'b0010;
  assign res_rom[4'b0111] = 4'b0011;
  assign res_rom[4'b1000] = 4'b0000;
  assign res_rom[4'b1001] = 4'b0010;
  assign res_rom[4'b1010] = 4'b0100;
  assign res_rom[4'b1011] = 4'b0110;
  assign res_rom[4'b1100] = 4'b0000;
  assign res_rom[4'b1101] = 4'b0011;
  assign res_rom[4'b1110] = 4'b0110;
  assign res_rom[4'b1111] = 4'b1001;

  always @(posedge clk) begin
    if (!rstn) begin
      q <= 4'b0;
    end else begin
      q <= res_rom[{a, b}];
    end
  end

endmodule
