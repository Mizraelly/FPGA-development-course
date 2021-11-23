`timescale 1ns / 1ps

module i2c_tb;

reg clk, rst;
reg [6:0] addr;
reg [7:0] data_in;
reg enable, rw_en;
wire i2c_sda;
wire i2c_scl;
wire data_out, ready;
reg sda;

parameter PERIOD = 20;
reg write_enable;
reg sda_out = 0;


realTime_i2c iic(.clk(clk),
				 .rst(rst),				 
				 .addr(addr),
				 .data_in(data_in),
				 .enable(enable),
				 .rw_en(rw_en),
				 .data_out(data_out),
				 .ready(ready),
				 .i2c_sda(i2c_sda),
				 .i2c_scl(i2c_scl)				 
				);

assign i2c_sda = (write_enable) ? sda : 'bz;

initial begin
    clk = 0;
    forever #(PERIOD/2) clk = ~clk;
end

initial begin
	rst = 1;
	#10 rst = 0;
end

initial begin
	addr    = 7'b1111000;
	data_in = 8'b00111100;
	enable  = 1'b1;
	rw_en   = 1'b0;
end

initial begin
	write_enable = 0;
	#830 write_enable = 1; 
	#80  write_enable = 0;
	#640 write_enable = 1;
	#80  write_enable = 0;
	#640 write_enable = 1;
	#80  write_enable = 0;
end

initial begin 
	#800 sda = 0; 
end

initial #3000 $finish; 

endmodule