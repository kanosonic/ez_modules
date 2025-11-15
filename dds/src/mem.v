`define FREQ_WORD_WIDTH  8
`define PHASE_WORD_WIDTH  8
`define BITWIDTH  10
module mem(
    input           clk,            //reference clock
    input           rstn ,          //resetn, low effective
    input           en ,            //start to generating waves
    input [1:0]     sel ,           //waves selection

    input [`PHASE_WORD_WIDTH - 1:0]     addr ,
    output reg[`BITWIDTH - 1:0]    dout
	); 
	wire [`BITWIDTH - 1:0] q_cos;
	wire [`BITWIDTH - 1:0] q_pulse;
	wire [`BITWIDTH - 1:0] q_tri;
	wire [`BITWIDTH - 1:0] q_awg;


rom_cos u_rom_cos(
	.clk  	(clk   ),
	.en   	(en    ),
	.addr 	(addr  ),
	.q    	(q_cos )
);

	always @(posedge clk or negedge rstn) begin
		if(!rstn)begin
			dout <= 0;
		end
		else begin
			dout <= sel[0]?(sel[1]?q_awg:q_tri):(sel[1]?q_pulse:q_cos);
		end
	end



endmodule
