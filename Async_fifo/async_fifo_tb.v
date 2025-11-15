//`timescale 1ns/1ns
// output declaration of module DDS

module async_fifo_tb;
initial begin
	$dumpfile("async_fifo_tb.vcd");
	$dumpvars(0, async_fifo_tb);
end


// output declaration of module asynch_fifo
wire w_full;
wire r_empty;
wire [31:0] r_data;
reg	 [31:0] w_data;

async_fifo u_async_fifo(
	.m_rst   	(m_rst    ),
	.w_rst   	(w_rst    ),
	.r_rst   	(r_rst    ),
	.w_en    	(w_en     ),
	.r_en    	(r_en     ),
	.w_clk   	(w_clk    ),
	.r_clk   	(r_clk    ),
	.w_data  	(w_data   ),
	.w_full  	(w_full   ),
	.r_empty 	(r_empty  ),
	.r_data  	(r_data   )
);


    parameter    w_clk_freq    = 100000000 ; //100MHz
	parameter    r_clk_freq    = 30000000 ; //20MHz

	reg m_rst; 
	reg w_rst; 
	reg r_rst; 
	reg w_en ; 
	reg r_en ; 
	reg w_clk; 
	reg r_clk; 


initial begin
        m_rst  =	'd1;
		w_rst  =	'd1;
		r_rst  =	'd1;
		w_en   =	'd0;
		r_en   =	'd0;
		w_clk  =	'd0;
		r_clk  =	'd0;
		w_data = 	'd0;
        #100 ;//write_full
        m_rst  =	'd0;
		w_rst  =	'd0;
		r_rst  =	'd0;
		w_en   =	'd1;
		r_en   =	'd0;
		#1000;//read_empty
		m_rst  =	'd0;
		w_rst  =	'd0;
		r_rst  =	'd0;
		w_en   =	'd0;
		r_en   =	'd1;

    end

initial begin
	forever #5 w_clk = !w_clk;	 //100MHz
end
initial begin
	forever #25 r_clk = !w_clk; //20MHz
end
initial begin
	forever #10 w_data = w_data + 'd1; //20MHz
end

    always begin
        #100;
        if ($time >= 500000) $finish ;
    end

endmodule
