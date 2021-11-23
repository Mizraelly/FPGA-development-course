module counter (i_clk, i_rst_n, i_srst, i_en, o_data);

parameter WIDTH = 5;

input i_clk, i_rst_n, i_srst, i_en;

output reg [WIDTH-1:0] o_data;

always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) 
	begin
		o_data <= 0;
	end 
	else if (i_srst)
	begin
		o_data <= 0;
	end 
	else if (i_en)
	begin
		o_data <= o_data + 1'b1;
	end 
end

endmodule