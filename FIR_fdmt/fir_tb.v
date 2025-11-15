//`timescale 1ns/1ns
//`include "src/FIR.v"

module fir_tb();
initial begin
	$dumpfile("fir_tb.vcd");
	$dumpvars(0, fir_tb);
end
	parameter DATA_WIDTH  = 17;	// Number of bits in input (2^n + 1)
	parameter COEFF_WIDTH = 17;	// Number of bits in coefficient (2^m + 1)
	parameter N_TAPS      = 16; // Number of taps (coefficients)
	parameter CAL_BIT_WIDTH = (DATA_WIDTH > COEFF_WIDTH) ? DATA_WIDTH : COEFF_WIDTH;

  reg clk;
  reg rstn;

  initial begin
	clk = 0;
	forever #5 clk = ~clk;
  end

  initial begin
	rstn = 0;
	#20 rstn = 1;
  end
  // Instantiate the Unit Under Test (UUT)
  wire signed [(CAL_BIT_WIDTH * 2) - 2:0] data_out;
  reg signed [DATA_WIDTH - 1:0] data_in;
  reg data_in_valid;
  wire data_out_valid;

  FIR #(
	.DATA_WIDTH(DATA_WIDTH),
	.COEFF_WIDTH(COEFF_WIDTH),
	.N_TAPS(N_TAPS)
  ) u_FIR (
	.clk(clk),
	.rst_n(rstn),
	.data_in(data_in),
	//.data_in_valid(data_in_valid),
	//.data_out_valid(data_out_valid)
	.data_out(data_out)
  );
    
  initial begin
	// Initialize Inputs
	data_in = 0;
	data_in_valid = 0;
	data_in = 17'sd0;

	// Wait for global reset to finish
	#100;



	//$stop;
  end
  	// Add stimulus here
	always @(negedge clk) begin
		data_in <= (data_in == 17'd10) ? 'd0 : (data_in + 1'b1); // Increment input value by 0.2 in fixed-point representation
	end

  always begin
        #100;
        if ($time >= 5000) $finish ;
    end
endmodule