module multiplier_nbit_unsigned #(
    parameter BITWIDTH_INPUT = 16  // Number of bits in input (2^n)
) (
    input clk,
    input rstn,

    input  [      BITWIDTH_INPUT - 1:0] a,
    input  [      BITWIDTH_INPUT - 1:0] b,
    output [(BITWIDTH_INPUT * 2) - 1:0] q
);
  generate
    if (BITWIDTH_INPUT > 2) begin : g_normal_mul

      reg [(BITWIDTH_INPUT * 2) - 1:0] q_buf;
      assign q = q_buf;

      wire [(BITWIDTH_INPUT / 2) - 1:0] a_h;
      wire [(BITWIDTH_INPUT / 2) - 1:0] a_l;
      wire [(BITWIDTH_INPUT / 2) - 1:0] b_h;
      wire [(BITWIDTH_INPUT / 2) - 1:0] b_l;

      assign a_h = a[BITWIDTH_INPUT-1:(BITWIDTH_INPUT/2)];
      assign a_l = a[(BITWIDTH_INPUT/2)-1:0];
      assign b_h = b[BITWIDTH_INPUT-1:(BITWIDTH_INPUT/2)];
      assign b_l = b[(BITWIDTH_INPUT/2)-1:0];

      // H*H
      wire [BITWIDTH_INPUT-1:0] q_bl_hh;
      multiplier_nbit_unsigned #(
          .BITWIDTH_INPUT(BITWIDTH_INPUT / 2)
      ) multiplier_nbit_unsigned_hh_inst (
          .clk (clk),
          .rstn(rstn),

          .a(a_h),
          .b(b_h),
          .q(q_bl_hh)
      );

      // H*L
      wire [BITWIDTH_INPUT-1:0] q_bl_hl;
      multiplier_nbit_unsigned #(
          .BITWIDTH_INPUT(BITWIDTH_INPUT / 2)
      ) multiplier_nbit_unsigned_hl_inst (
          .clk (clk),
          .rstn(rstn),

          .a(a_h),
          .b(b_l),
          .q(q_bl_hl)
      );

      // L*H
      wire [BITWIDTH_INPUT-1:0] q_bl_lh;
      multiplier_nbit_unsigned #(
          .BITWIDTH_INPUT(BITWIDTH_INPUT / 2)
      ) multiplier_nbit_unsigned_lh_inst (
          .clk (clk),
          .rstn(rstn),

          .a(a_l),
          .b(b_h),
          .q(q_bl_lh)
      );

      // L*L
      wire [BITWIDTH_INPUT-1:0] q_bl_ll;
      multiplier_nbit_unsigned #(
          .BITWIDTH_INPUT(BITWIDTH_INPUT / 2)
      ) multiplier_nbit_unsigned_ll_inst (
          .clk (clk),
          .rstn(rstn),

          .a(a_l),
          .b(b_l),
          .q(q_bl_ll)
      );

      // Output buffer adder 0
      reg [(BITWIDTH_INPUT * 2) - 1:0] q_buf_0;
      always @(posedge clk) begin
        if (!rstn) begin
          q_buf_0 <= {(2 * BITWIDTH_INPUT) {1'b0}};
        end else begin
          q_buf_0 <= {q_bl_hh, {(BITWIDTH_INPUT) {1'b0}}} + {q_bl_hl, {(BITWIDTH_INPUT / 2) {1'b0}}};
        end
      end

      // Output buffer adder 1
      reg [(BITWIDTH_INPUT * 2) - 1:0] q_buf_1;
      always @(posedge clk) begin
        if (!rstn) begin
          q_buf_1 <= {(2 * BITWIDTH_INPUT) {1'b0}};
        end else begin
          q_buf_1 <= {q_bl_lh, {(BITWIDTH_INPUT / 2) {1'b0}}} + q_bl_ll;
        end
      end

      // Output adder
      always @(posedge clk) begin
        if (!rstn) begin
          q_buf <= {(2 * BITWIDTH_INPUT) {1'b0}};
        end else begin
          q_buf <= q_buf_0 + q_buf_1;
        end
      end

    end else begin : g_b2_mul

    // output declaration of module Multipler_binary_unsigned

	Multipler_binary_unsigned mult_inst (
		.clk(clk),
		.rstn(rstn),

		.a(a),
		.b(b),
		.q(q)
	);
	

    end
  endgenerate

endmodule
