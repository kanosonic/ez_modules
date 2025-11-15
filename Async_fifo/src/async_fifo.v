module async_fifo(
	input m_rst, 
	input w_rst, 
	input r_rst,
	input w_en, 
	input r_en,
	input w_clk, 
	input r_clk,
	input [31:0]w_data,

	output w_full, 
	output r_empty,
	output [31:0]r_data
);

	
	mem #(
		.DEPTH 	(64  ),
		.WIDTH 	(32  ))
	u_mem(
		.m_rst   	(m_rst    ),
		.w_clk   	(w_clk    ),
		.r_clk   	(r_clk    ),
		.w_valid 	(w_en && (~w_full)   ),
		.r_valid 	(r_en && (~r_empty)  ),
		.w_data  	(w_data   ),
		.w_addr  	(w_addr   ),
		.r_addr  	(r_addr   ),
		.r_data  	(r_data   )
	);
	
	// output declaration of module r_ptr_ctrl
	wire [6:0] r_ptr_g;
	wire [5:0] r_addr;
	
	r_ptr_ctrl u_r_ptr_ctrl(
		.r_rst        	(r_rst         ),
		.r_clk        	(r_clk         ),
		.r_en         	(r_en          ),
		.w_ptr_g_sync 	(w_ptr_g_sync  ),
		.r_empty      	(r_empty       ),
		.r_ptr_g      	(r_ptr_g       ),
		.r_addr       	(r_addr        )
	);
	
	// output declaration of module w_ptr_ctrl
	wire [6:0] w_ptr_g;
	wire [5:0] w_addr;
	
	w_ptr_ctrl u_w_ptr_ctrl(
		.w_rst        	(w_rst         ),
		.w_clk        	(w_clk         ),
		.w_en         	(w_en          ),
		.r_ptr_g_sync 	(r_ptr_g_sync  ),
		.w_full       	(w_full        ),
		.w_ptr_g      	(w_ptr_g       ),
		.w_addr       	(w_addr        )
	);
	
	// output declaration of module synch
	wire [6:0] w_ptr_g_sync;
	
	synch w_synch(
		.clk        	(w_clk       ),
		.data       	(w_ptr_g     ),
		.data_synch 	(w_ptr_g_sync)
	);
	
	// output declaration of module synch
	wire [6:0] r_ptr_g_sync;
	
	synch r_synch(
		.clk        	(r_clk       ),
		.data       	(r_ptr_g     ),
		.data_synch 	(r_ptr_g_sync)
	);
	
endmodule //asynch_fifo
