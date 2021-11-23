module fall_edge_detect (i_clk, i_rst_n, i_data, o_edge_detect);

input i_clk,i_rst_n,i_data;
output o_edge_detect;

reg[1:0] ff;

//	description for d-flopping


always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) 
	begin
		 ff <= 2'b00;
	end else 
	begin
		 ff <= {ff[0], i_data};
	end
end

assign o_edge_detect = ff[1] & ~ff[0];

endmodule	