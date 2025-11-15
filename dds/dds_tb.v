//`timescale 1ns/1ns
// output declaration of module DDS

module dds_tb;
initial begin
	$dumpfile("dds_tb.vcd");
	$dumpvars(0, dds_tb);
end
wire [10-1:0] dout;
	reg clk;
	reg rstn    ;
	reg wave_ena;
	reg [1:0]wave_sel;
	reg [1:0]wave_amp;
	reg [7:0]f_word  ;
	reg [7:0]p_word  ;

dds u_dds(
	.clk      	(clk       ),
	.rstn     	(rstn      ),
	.wave_ena 	(wave_ena  ),
	.wave_sel 	(wave_sel  ),
	.wave_amp 	(wave_amp  ),
	.f_word   	(f_word    ),
	.p_word   	(p_word    ),
	.dout     	(dout      )
);


    parameter    clk_freq    = 100000000 ; //100MHz
    integer      freq_dst    = 2000000 ;   //2MHz


initial begin
        clk           = 1'b0 ;
        rstn          = 1'b0 ;
        #100 ;
        rstn          = 1'b1 ;
    end
	always #5 clk = !clk;

initial begin
	wave_ena = 1'b1;
	wave_amp = 2'b00;
	f_word   = (1 << 8) * freq_dst / clk_freq;
	p_word 	 = 9'b0;
	wave_sel = 2'b00;
	#5000
	wave_amp = 2'b01;
	#5000
	p_word 	 = 9'b010000000;
end


    always begin
        #100;
        if ($time >= 500000) $finish ;
    end

endmodule
