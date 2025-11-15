module gray2bin(
	input [6:0] gray_format,


	output [6:0]  binary_format
);

	reg [6:0] binary_format_r;
	assign binary_format = binary_format_r;

	integer i;
	always @(*) begin
		binary_format_r[6] = gray_format[6];
		for (i = 5; i >= 0; i = i - 1) begin
			binary_format_r[i] = binary_format_r[i + 1] ^ gray_format[i];
		end
	end


endmodule
