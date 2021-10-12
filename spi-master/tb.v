`timescale 1ns/1ps
module testbench;
parameter PERIOD = 20;

reg clk, rst_n;
reg [27:0] miso_dat;

wire [15:0] data;
wire mosi, miso, cs, sck;
master_spi master (	.i_clk(clk), 
					.i_rst_n(rst_n), 
					.i_miso(miso_dat[27]), 
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
	else 
	begin
		miso_dat <= {miso_dat[26:0], 1'b0};
	end
end


initial #30000 $finish;
endmodule : testbench