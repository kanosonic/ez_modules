module rom_cos (
    input               clk,
    input               en,
    input [7:0]         addr,
    output reg [9:0]     q);

   reg [9:0]           ROM [0 : 64] ;
   //as the symmetry of cos function, just store 1/4 data of one cycle

   initial begin
	$readmemb("dat/data_cos.dat", ROM);
   end
   
       always @(posedge clk) begin
        if (en) begin
            if (addr[7:6] == 2'b00 ) begin  //quadrant 1, addr[0, 63]
                q <= ROM[addr[5:0]] + 10'd512 ; //shift up 
            end
            else if (addr[7:6] == 2'b01 ) begin //2nd, addr[64, 127]
                q <= 10'd512 - ROM[64-addr[5:0]] ; //twice flip
            end
            else if (addr[7:6] == 2'b10 ) begin //3rd, addr[128, 192]
                q <= 10'd512 - ROM[addr[5:0]]; //flip & shift right
            end
            else begin     //4th quadrant, addr [193, 256]
                q <= 10'd512 + ROM[64-addr[5:0]]; //flip & shift up
            end
        end
        else begin
            q <= 'b0 ;
        end
    end
endmodule
