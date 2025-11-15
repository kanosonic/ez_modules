`define FREQ_WORD_WIDTH  8
`define PHASE_WORD_WIDTH  8
`define BITWIDTH  10
module dds (
	input clk,
	input rstn,
	input wave_ena,

	input [1:0] wave_sel, //00:sine
	input [1:0] wave_amp,
	input [`FREQ_WORD_WIDTH - 1:0] f_word,
	input [`PHASE_WORD_WIDTH - 1:0] p_word,

	output [`BITWIDTH - 1:0] dout
);


	//add phase
	reg[`PHASE_WORD_WIDTH - 1:0] phase_regist; 

	always @(posedge clk or negedge rstn) begin
		if(!rstn)begin
			phase_regist <= 0;
		end
		else if(wave_ena)begin
			phase_regist <= phase_regist + f_word;
		end
		else begin
			phase_regist <= 0;
		end
	end

	//get addr
	reg[`PHASE_WORD_WIDTH - 1:0] mem_addr;  
	always @(posedge clk or negedge rstn) begin
		if(!rstn)begin
			mem_addr <= 0;
		end
		else if(wave_ena)begin
			mem_addr <= phase_regist + p_word;
		end
		else begin
			mem_addr <= 0;
		end
	end

	//read rom
	wire [`BITWIDTH - 1:0] dout_read;

	
	mem u_mem(
		.clk  	(clk   ),
		.rstn 	(rstn  ),
		.en   	(wave_ena   ),
		.sel  	(wave_sel   ),
		.addr 	(mem_addr),
		.dout 	(dout_read  )
	);


	//control amp
	assign dout = dout_read >> wave_amp;

endmodule
