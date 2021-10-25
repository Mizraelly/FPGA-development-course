module master_spi (i_clk, i_rst_n_p, i_miso, o_data, o_mosi, o_cs, o_sck);

parameter DATA_WIDTH_MISO = 16;

input i_clk, i_rst_n_p, i_miso;
output o_mosi, o_cs, o_sck;
output [DATA_WIDTH_MISO-1:0] o_data;

//PARAMETERS
parameter WIDTH_CNT = 5;
parameter WIDTH_CNT_DIV_SCK = 5;
parameter ADDR_WIDTH = 5;
parameter ROM_DATA_WIDTH = 8;


///////////

//def all RED
wire o_red_inc_cnt_inst;
wire o_red_en_load_mosi;
wire o_red_mux_sck;
wire o_red_cs;

//def all FED
wire o_fed_mux_sck;

//def cnt_rom_inst to rom
wire [ADDR_WIDTH-1:0] o_cnt_rom_inst;

//def rom_out
wire [ROM_DATA_WIDTH-1:0] o_rom_inst;

//def CMP_cnt_bit_trans
wire [WIDTH_CNT-1:0] o_cnt_bit_mosi_data;
wire o_trans_mosi_cmplt;

//def CMP_cnt_bit_miso
wire [WIDTH_CNT-1:0] o_cnt_bit_miso_data;
wire o_trans_miso_cmplt;

//def sh_mosi_reg param
wire [ROM_DATA_WIDTH-1:0] o_sh_mosi_data;

//def sh_miso_reg param
wire [DATA_WIDTH_MISO-1:0] o_sh_miso_data;

//def cnt_div_sck
wire [WIDTH_CNT_DIV_SCK-1:0] o_cnt_div_sck; 
 
//def mux_sck
wire o_mux_sck;

//def FMM param
wire en_cs_n;
wire mux_control_sck;
wire en_sck_cnt;
wire en_miso_cnt;
wire rst_cnt_bit_mosi;
wire rst_cnt_bit_miso;
wire en_load_mosi;
wire inc_cnt_inst;
wire o_global_rst;

//def trig r
wire o_inst_d; 

// define detect RW, read_cmplt
wire trans_mosi_cmplt_Write;
wire trans_mosi_cmplt_Read;
wire trans_write_cmplt;

assign trans_mosi_cmplt_Write = o_trans_mosi_cmplt & o_fed_mux_sck & ~o_inst_d;
assign trans_mosi_cmplt_Read = o_trans_mosi_cmplt & o_fed_mux_sck & o_inst_d;
assign trans_write_cmplt = o_trans_mosi_cmplt & o_fed_mux_sck;

// CMP
assign o_trans_miso_cmplt = o_cnt_bit_miso_data == 8;
assign o_trans_mosi_cmplt = o_cnt_bit_mosi_data == 7;


// def en for cnt_bit_miso
wire en_miso_and;
assign en_miso_and = en_miso_cnt & o_red_mux_sck;

// assign cs
assign o_cs = en_cs_n;

//assign mosi 
assign o_mosi = o_sh_mosi_data[ROM_DATA_WIDTH-1];

//assign sck
assign o_sck = o_mux_sck;
// init all RED

// reset
wire rst_fmm, i_rst_n , o_rst_fmm;
assign i_rst_n =  ~(~i_rst_n_p | o_rst_fmm);

//wire for delay load_miso_buf

wire o_en_delay_miso_buff;


rise_edge_detect RST_FMM 		( 	.i_clk(i_clk),
									.i_rst_n(i_rst_n_p),
									.i_data(rst_fmm),
									.o_edge_detect(o_rst_fmm)
									);

rise_edge_detect RED_inc_cnt_inst ( .i_clk(i_clk),
									.i_rst_n(i_rst_n),
									.i_data(inc_cnt_inst),
									.o_edge_detect(o_red_inc_cnt_inst)
									);

rise_edge_detect RED_en_load_mosi (	.i_clk(i_clk),
									.i_rst_n(i_rst_n),
									.i_data(en_load_mosi),
									.o_edge_detect(o_red_en_load_mosi)
									);

rise_edge_detect RED_sck 		  ( .i_clk(i_clk),
									.i_rst_n(i_rst_n),
									.i_data(o_mux_sck),
									.o_edge_detect(o_red_mux_sck)
									);

rise_edge_detect RED_CS  		  ( .i_clk(i_clk),
									.i_rst_n(i_rst_n),
									.i_data(en_cs_n),
									.o_edge_detect(o_red_cs)
									);

// init FED
fall_edge_detect FED_sck  		  ( .i_clk(i_clk),
									.i_rst_n(i_rst_n),
									.i_data(o_mux_sck),
									.o_edge_detect(o_fed_mux_sck)
									);


// init FMM
FMM fmm		(	.i_clk(i_clk), .i_rst_n(i_rst_n), .i_read(trans_mosi_cmplt_Read), 
				.i_write(trans_mosi_cmplt_Write), .i_read_cmplt(o_trans_miso_cmplt), .i_write_cmplt(trans_write_cmplt),
				.en_cs_n(en_cs_n),
				.mux_control_sck(mux_control_sck),
				.en_sck_cnt(en_sck_cnt),
				.en_miso_cnt(en_miso_cnt),
				.rst_cnt_bit_mosi(rst_cnt_bit_mosi),
				.rst_cnt_bit_miso(rst_cnt_bit_miso),
				.en_load_mosi(en_load_mosi),
				.inc_cnt_inst(inc_cnt_inst),
				.i_en_delay_miso_buff(o_en_delay_miso_buff),
				.o_rst(rst_fmm)
			);

// init mux
mux mux1 (
			.i_dat0(1'b0), 
			.i_dat1(o_cnt_div_sck[WIDTH_CNT_DIV_SCK-1]), 
			.i_control(mux_control_sck), 
			.o_dat(o_mux_sck)
			);

// init sh_mosi_reg
shift_reg #(.WIDTH(ROM_DATA_WIDTH)) sh_mosi_reg 
			(
				.i_clk(i_clk),
				.i_rst_n(i_rst_n), 
				.i_load_en(o_red_en_load_mosi), 
				.i_sh_en(o_fed_mux_sck), 
				.i_data_load(o_rom_inst), 
				.i_data_serial(1'b0),
				.o_data(o_sh_mosi_data)
			);

// init sh_miso_reg
shift_reg #(.WIDTH(DATA_WIDTH_MISO)) sh_miso_reg 
			(
				.i_clk(i_clk),
				.i_rst_n(i_rst_n), 
				.i_load_en(1'b0), 
				.i_sh_en(en_miso_and), 
				.i_data_load(16'b0), 
				.i_data_serial(i_miso),
				.o_data(o_sh_miso_data)
			);

// delay for i_en_load_MISO buff
rise_edge_detect en_load_miso	(	.i_clk(i_clk),
									.i_rst_n(i_rst_n),
									.i_data(o_red_mux_sck),
									.o_edge_detect(o_en_delay_miso_buff)
									);
wire read_word;
assign read_word = (o_trans_miso_cmplt & o_en_delay_miso_buff);
// init miso buf
register #(.WIDTH_DATA(DATA_WIDTH_MISO)) miso_buffer 
	(
		.i_clk(i_clk), 
		.i_rst_n(i_rst_n_p), 
		.i_data(o_sh_miso_data), 
		.i_en_load(read_word), 
		.o_data(o_data)
	);

// init inst_d trig
register #(.WIDTH_DATA(1'b1)) inst_d 
	(
		.i_clk(i_clk), 
		.i_rst_n(i_rst_n), 
		.i_data(o_rom_inst[ROM_DATA_WIDTH-1]), 
		.i_en_load(1'b1), 
		.o_data(o_inst_d)
	);

//init cnt_bit_miso
counter #(.WIDTH(WIDTH_CNT)) cnt_bit_miso (
	.i_clk(i_clk), 
	.i_rst_n(i_rst_n), 
	.i_srst(rst_cnt_bit_miso), 
	.i_en(en_miso_and), 
	.o_data(o_cnt_bit_miso_data)
	);


//init cnt_bit_mosi
counter #(.WIDTH(WIDTH_CNT)) cnt_bit_mosi (
	.i_clk(i_clk), 
	.i_rst_n(i_rst_n), 
	.i_srst(rst_cnt_bit_mosi), 
	.i_en(o_fed_mux_sck), 
	.o_data(o_cnt_bit_mosi_data)
	);

//init cnt_div_sck
counter #(.WIDTH(WIDTH_CNT_DIV_SCK)) cnt_div_sck (
	.i_clk(i_clk), 
	.i_rst_n(i_rst_n), 
	.i_srst(1'b0), 
	.i_en(en_sck_cnt), 
	.o_data(o_cnt_div_sck)
	);

//init cnt_rom_inst
counter #(.WIDTH(WIDTH_CNT)) cnt_rom_inst (
	.i_clk(i_clk), 
	.i_rst_n(i_rst_n), 
	.i_srst(1'b0), 
	.i_en(o_red_inc_cnt_inst), 
	.o_data(o_cnt_rom_inst)
	);

//init rom_inst
rom_inst #(.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(ROM_DATA_WIDTH)) rom_inst1 
	(
		.i_addr(o_cnt_rom_inst), 
		.o_data(o_rom_inst)
	);


endmodule