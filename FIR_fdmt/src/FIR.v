module FIR #(
	parameter DATA_WIDTH  = 17,	// Number of bits in input (2^n + 1)
	parameter COEFF_WIDTH = 17,	// Number of bits in coefficient (2^m + 1)
	parameter CAL_BIT_WIDTH = (DATA_WIDTH > COEFF_WIDTH) ? DATA_WIDTH : COEFF_WIDTH,
	parameter N_TAPS      = 16 // Number of taps (coefficients)
) (
	input clk,
	input rst_n,
	input signed [DATA_WIDTH - 1:0] data_in,
	output reg signed [(CAL_BIT_WIDTH * 2) - 2:0] data_out
);
	// Coefficients for FIR filter
	
	// Example coefficients for a low-pass filter
reg signed [COEFF_WIDTH-1:0] coeffs [0:N_TAPS-1];
initial begin
	coeffs[0]  =  -17'sd177;
	coeffs[1]  =  -17'sd736;
	coeffs[2]  =  -17'sd1687;
	coeffs[3]  =  -17'sd1463;
	coeffs[4]  =  17'sd2781;
	coeffs[5]  =  17'sd12306;
	coeffs[6]  =  17'sd24297;
	coeffs[7]  =  17'sd32767;
	coeffs[8]  =  17'sd32767;
	coeffs[9]  =  17'sd24297;
	coeffs[10] =  17'sd12306;
	coeffs[11] =  17'sd2781;
	coeffs[12] = -17'sd1463;
	coeffs[13] = -17'sd1687;
	coeffs[14] = -17'sd736;
	coeffs[15] = -17'sd177;
end
	
	// Shift register to hold input samples
	reg signed [DATA_WIDTH - 1:0] shift_reg [0:N_TAPS-1];
	integer i;
	
	// Initialize shift register
	initial begin
		for (i = 0; i < N_TAPS; i = i + 1) begin
			shift_reg[i] = 0;
		end
	end
	
	// Shift in new data sample on each clock cycle
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < N_TAPS; i = i + 1) begin
				shift_reg[i] <= 0;
			end
		end else begin
			for (i = N_TAPS-1; i > 0; i = i - 1) begin
				shift_reg[i] <= shift_reg[i-1];
			end
			shift_reg[0] <= data_in;
		end
	end
	
	// Multiply and accumulate
	wire signed [(CAL_BIT_WIDTH * 2) - 2:0] mult_results [0:N_TAPS-1];
	genvar j;
	generate
		for (j = 0; j < N_TAPS; j = j + 1) begin : mult_accum
			Multiplier_nbit_signed #(
				.BIT_WIDTH(CAL_BIT_WIDTH)
			) multiplier_inst (
				.clk(clk),
				.rst_n(rst_n),
				.a(shift_reg[j]),
				.b(coeffs[j]),
				.product(mult_results[j])
			);
		end
	endgenerate	


	reg signed [(CAL_BIT_WIDTH * 2) + $clog2(N_TAPS) - 1:0] sum;
always @(*) begin
    sum = 0;
    for (i = 0; i < N_TAPS; i = i + 1) begin
        sum = sum + mult_results[i];
    end
end

// 在时钟边沿存储结果
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
    end else begin
        data_out <= sum; 
    end
end
	
endmodule
