module Multiplier_nbit_signed #(
	parameter BIT_WIDTH = 17	// Number of bits in input (2^n + 1) 等位宽
) (
	input clk,
	input rst_n,
	input signed [BIT_WIDTH - 1:0] a,
	input signed [BIT_WIDTH - 1:0] b,
	output reg signed [(BIT_WIDTH * 2) - 2:0] product
);
	wire [BIT_WIDTH - 2:0] a_unsigned;
	wire [BIT_WIDTH - 2:0] b_unsigned;
	wire [(BIT_WIDTH * 2) - 3:0] product_unsigned;
	// Convert signed inputs to unsigned
	Signed2Unsigned #(
		.BIT_WIDTH(BIT_WIDTH)
	) signed_to_unsigned_a (
		.a(a),
		.a_unsigned(a_unsigned)
	);			
	Signed2Unsigned #(
		.BIT_WIDTH(BIT_WIDTH)
	) signed_to_unsigned_b (
		.a(b),
		.a_unsigned(b_unsigned)
	);			
	// Multiply unsigned values
	
	multiplier_nbit_unsigned #(
		.BITWIDTH_INPUT 	(BIT_WIDTH - 1))
	u_multiplier_nbit_unsigned(
		.clk  	(clk   ),
		.rstn 	(rstn  ),
		.a    	(a_unsigned    	 	),
		.b    	(b_unsigned     	),
		.q    	(product_unsigned   )
	);
	// Convert unsigned product back to signed
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			product <= 0;
		end else begin
			product <= {{a[BIT_WIDTH - 1] ^ b[BIT_WIDTH - 1]}, product_unsigned};
		end
	end
	

endmodule