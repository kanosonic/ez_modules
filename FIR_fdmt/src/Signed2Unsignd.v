module Signed2Unsigned #(
	parameter BIT_WIDTH = 17	// Number of bits in input (2^n + 1)
) (
	input signed [BIT_WIDTH - 1:0] a,
	output reg [BIT_WIDTH - 2:0] a_unsigned
);
	always @(*) begin
		if (a < 0) begin
			a_unsigned = ~a[BIT_WIDTH - 2:0] + 1'b1; // Two's complement for negative numbers
		end else begin
			a_unsigned = a[BIT_WIDTH - 2:0]; // Direct assignment for non-negative numbers
		end
	end
	
endmodule