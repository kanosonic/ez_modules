module r_ptr_ctrl(
	input r_rst,
	input r_clk,
	input r_en,
	input [6:0]	w_ptr_g_sync,

	output r_empty,
	output [6:0]	r_ptr_g,	//1-bit flag + 6-bit addr
	output [5:0]	r_addr

);

	reg[6:0] r_ptr_b;
	reg[6:0] r_ptr_b_next; //next r_ptr_b
	reg r_empty_r;
	assign r_addr =  r_ptr_b[5:0];
	assign r_empty = r_empty_r;

	// output declaration of module gray2bin
	wire [6:0] w_ptr_b_sync;
	
	gray2bin u_gray2bin(
		.gray_format   	(w_ptr_g_sync ),
		.binary_format 	(w_ptr_b_sync )
	);
	
	bin2gray u_bin2gray(
		.binary_format 	(r_ptr_b  ),
		.gray_format   	(r_ptr_g  )
	);
	
	always @(*) begin
		r_ptr_b_next = r_ptr_b + 1'b1;
	end

	//judge empty
	always @(posedge r_clk or posedge r_rst) begin
		if(r_rst)begin
			r_ptr_b   		<= 'd0;
			r_empty_r  		<= 'd0;
		end	else begin
			//r_empty_r  <= (w_ptr_b_sync == r_ptr_b_next) && r_en;
			r_empty_r  <= (w_ptr_b_sync == r_ptr_b_next) || (w_ptr_b_sync == r_ptr_b);
			r_ptr_b	   <= (r_en && (!r_empty_r))	?	(r_ptr_b +'d1) : r_ptr_b;
		end
	end

endmodule //r_ptr_ctrl
