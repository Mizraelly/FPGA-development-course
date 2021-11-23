module register (i_clk, i_rst_n, i_data, i_en_load, o_data);

parameter WIDTH_DATA = 8;

input i_clk, i_rst_n, i_en_load;
input 	 	[WIDTH_DATA-1:0] i_data;
output reg 	[WIDTH_DATA-1:0] o_data;

always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) 
	begin
		o_data <= 0;
	end 
	else if (i_en_load)
	begin 
		o_data <= i_data;
	end
end

endmodule