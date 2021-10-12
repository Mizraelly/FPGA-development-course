module FMM (i_clk, i_rst_n, i_read, i_write, i_read_cmplt,i_write_cmplt,
			en_cs_n,
			mux_control_sck,
			en_sck_cnt,
			en_miso_cnt,
			rst_cnt_bit_mosi,
			rst_cnt_bit_miso,
			en_load_mosi,
			inc_cnt_inst
			);

parameter IDLE = 0, CS_EN = 1, SCK_EN = 2, CNT_INST = 3,
ADDR_WRITE = 4, READ = 5, WR_AFT_RST = 6, WRITE = 7; 

input i_clk, i_rst_n, i_read, i_write, i_read_cmplt, i_write_cmplt;

output reg en_cs_n,mux_control_sck,en_sck_cnt;
output reg en_miso_cnt,rst_cnt_bit_mosi,rst_cnt_bit_miso;
output reg en_load_mosi,inc_cnt_inst;



reg [3:0] state, next_state;

always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) 
	begin
		state <= IDLE;
	end else  
	begin
		state <= next_state;
	end
end

always@* begin
	case (state)
		IDLE:		next_state = CS_EN;
		CS_EN:		next_state = SCK_EN;
		SCK_EN:		next_state = CNT_INST;
		CNT_INST:	next_state = ADDR_WRITE;
		ADDR_WRITE:	if (i_write)	
					begin
						next_state = WR_AFT_RST;
					end
					else if (i_read) 
					begin
						next_state = READ;
					end

		READ:		if (i_read_cmplt)
					begin
						next_state = IDLE;
					end

		WR_AFT_RST: next_state = WRITE;

		WRITE:		if (i_write_cmplt)
					begin
						next_state = CNT_INST;
					end

		default:	next_state = IDLE;
	endcase	
end

always @(state) begin
	case (state)
		IDLE:	begin
					en_cs_n = 1;
					mux_control_sck = 0;
					en_sck_cnt = 0;
					en_miso_cnt = 0;
					rst_cnt_bit_miso = 0;
					rst_cnt_bit_mosi = 0;
					en_load_mosi = 0;
					inc_cnt_inst = 0;
				end

		CS_EN:	begin
					en_cs_n = 0;
				end

		SCK_EN:	begin
					mux_control_sck = 1;
					en_sck_cnt = 1;
				end

		CNT_INST:begin
					inc_cnt_inst = 1;
					rst_cnt_bit_mosi = 1;
					rst_cnt_bit_miso = 1;
					en_load_mosi = 0;
				end

		ADDR_WRITE:begin
					inc_cnt_inst = 0;
					rst_cnt_bit_miso = 0;
					rst_cnt_bit_mosi = 0;
					en_load_mosi = 1;
				end

		READ:	begin
					en_miso_cnt = 1;
				end

		WR_AFT_RST:begin
					inc_cnt_inst = 1;
					rst_cnt_bit_mosi = 1;
					en_load_mosi = 0;
				end

		WRITE: 	begin
					inc_cnt_inst = 0;
					rst_cnt_bit_mosi = 0;
					en_load_mosi = 1;
				end
	endcase
end

endmodule