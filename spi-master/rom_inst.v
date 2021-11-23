module rom_inst (i_addr, o_data);

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 5;

input [ADDR_WIDTH-1:0] i_addr;
output reg[DATA_WIDTH-1:0] o_data;

reg [(DATA_WIDTH-1):0] inst_mem [($pow(2,ADDR_WIDTH)-1):0];

initial $readmemh ("rom_init.hex",inst_mem); 

always @(*) begin
	o_data = inst_mem [i_addr];
end

endmodule
