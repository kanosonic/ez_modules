module synch(
        input clk,
        input [6:0] data,

        output [6:0] data_synch

    );
    reg [6:0] data_r;
    reg [6:0] data_r2;

    always @(posedge clk) begin
        data_r  <= data;
        data_r2 <= data_r;
    end

    assign data_synch = data_r2;
endmodule
