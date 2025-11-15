module mem #(
	parameter DEPTH = 64,
	parameter WIDTH = 32
)(
	input m_rst,
	input w_clk,
	input r_clk,
	input w_valid,
	input r_valid,
	input [31:0] w_data,
	input [5:0] w_addr,
	input [5:0] r_addr,

	output [31:0] r_data

);
	integer i;
	reg [31:0] r_data_r;
	reg [WIDTH - 1:0] fifo_mem [DEPTH - 1:0];
	assign r_data = r_data_r;
	always @(posedge w_clk or posedge m_rst) begin
		//Memory_reset
		if (m_rst) begin
			for (i = 0; i < DEPTH; i = i + 1) begin
				fifo_mem[i] <= 'd0;
				r_data_r	<= 'd0;
			end
		end	else begin
			fifo_mem[w_addr] <= w_valid ? w_data : fifo_mem[w_addr];
		end
	end

	always @(posedge r_clk) begin
		r_data_r <= r_valid ? fifo_mem[r_addr] : r_data;
	end
	
endmodule //mem
