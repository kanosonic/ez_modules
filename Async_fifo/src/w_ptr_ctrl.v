module w_ptr_ctrl(
	input w_rst,
	input w_clk,
	input w_en,
	input [6:0]	r_ptr_g_sync,

	output w_full,
	output [6:0]	w_ptr_g,	//1-bit flag + 6-bit addr
	output [5:0]	w_addr

);

	reg[6:0] w_ptr_b;
	reg[6:0] w_ptr_b_next; //next w_ptr_b
	reg w_full_r;
	assign w_addr =  w_ptr_b[5:0];
	assign w_full = w_full_r;

	// output declaration of module gray2bin
	wire [6:0] r_ptr_b_sync;
	
	gray2bin u_gray2bin(
		.gray_format   	(r_ptr_g_sync ),
		.binary_format 	(r_ptr_b_sync )
	);
	
	bin2gray u_bin2gray(
		.binary_format 	(w_ptr_b  ),
		.gray_format   	(w_ptr_g  )
	);
	
	always @(*) begin
		w_ptr_b_next = w_ptr_b + 1'b1;
	end

	//judge full
	always @(posedge w_clk or posedge w_rst) begin
		if(w_rst)begin
			w_ptr_b   		<= 'd0;
			w_full_r  		<= 'd0;
		end	else begin
			//w_full_r  <= (r_ptr_b_sync[6] ^ w_ptr_b_next[6]) && (r_ptr_b_sync[5:0] == w_ptr_b_next[5:0]) && w_en;
			w_full_r  <= (r_ptr_b_sync[6] ^ w_ptr_b_next[6]) && (r_ptr_b_sync[5:0] == w_ptr_b_next[5:0]) || (r_ptr_b_sync[6] ^ w_ptr_b[6]) && (r_ptr_b_sync[5:0] == w_ptr_b[5:0]);
			w_ptr_b		<= (w_en && (!w_full_r))	?	(w_ptr_b + 'd1)	: 	w_ptr_b;
		end
	end

endmodule //w_ptr_ctrl
