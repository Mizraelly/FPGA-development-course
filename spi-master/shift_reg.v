module shift_reg (i_clk, i_rst_n, i_load_en, i_sh_en, i_data_load, i_data_serial, o_data);

parameter WIDTH = 32;

input i_clk, i_rst_n, i_load_en, i_sh_en, i_data_serial;
input [WIDTH-1:0] i_data_load;

output reg [WIDTH-1:0] o_data;

always @(posedge i_clk or negedge i_rst_n) begin : proc_
	if(~i_rst_n) 
	begin
		o_data <= 0;
	end 
	else if (i_load_en)
	begin
		o_data <= i_data_load;
	end 
	else if (i_sh_en)
	begin
		o_data <= {o_data[WIDTH-2:0], i_data_serial};
	end
end

endmodule : shift_reg