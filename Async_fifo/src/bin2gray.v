module bin2gray(
	input [6:0]  binary_format,

	output [6:0] gray_format
);

	reg [6:0] gray_format_r;
	assign gray_format = gray_format_r;

	//integer i;
	//always @(*) begin
	//	gray_format_r[31] = binary_format[31];
	//	for (i = 0; i < 31; i = i + 1) begin
	//		gray_format_r[i] = binary_format[i] ^ binary_format[i + 1];
	//	end
	//end
	always @(*) begin
		gray_format_r = binary_format ^ (binary_format >> 1);
	end
	

endmodule
