`timescale 1ns/1ps
module testbench;
parameter PERIOD = 20;

reg clk, rst_n;
reg [7:0] miso_dat;
reg [7:0] mosi_dat;

reg [4:0] cnt;


wire [15:0] data;
wire mosi, miso, cs, sck;
master_spi master (	.i_clk(clk), 
					.i_rst_n_p(rst_n), 
					.i_miso(miso_dat[7]), 
					.o_data(data), 
					.o_mosi(mosi), 
					.o_cs(cs), 
					.o_sck(sck)
					);

//descript test for module
//init clk 
initial begin
	clk = 0;
	forever #(PERIOD / 2) clk = ~clk;
end

initial begin
	rst_n = 0;

	#2 rst_n = 1;
end

always@ (negedge sck or negedge rst_n)begin
	if (~rst_n) 
	begin 
		miso_dat <= 15;
	end 
	else begin
		miso_dat <= {miso_dat[6:0], 1'b0};
	end
end


always@ (posedge sck or negedge rst_n)begin
	if (~rst_n) begin 
		mosi_dat <= 0;
	end 
	else begin
		mosi_dat <= {mosi_dat[6:0], mosi}; 
	end
end

initial begin
	# 15630 miso_dat = 15;
	# 20200 miso_dat = 10;

end


initial #60000 $finish;
endmodule : testbench