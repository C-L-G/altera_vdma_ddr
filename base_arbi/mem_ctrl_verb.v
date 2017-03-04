/*模块包含读写仲裁，相当于将DDR2扩展为多个接口*/
module mem_ctrl_verb#(
	parameter 	MEM_DATA_BITS 		= 64,
	parameter 	ADDR_BITS			= 25,
	parameter	READ_PORTS			= 8,
	parameter	WRITE_PORTS			= 8
)
(
	input 						rst_n,
	input 						source_clk,
	output 						phy_clk,
	output 						aux_half_rate_clk,
	input 						ch0_rd_burst_req,
	input[9:0] 					ch0_rd_burst_len,
	input[ADDR_BITS-1:0]		ch0_rd_burst_addr,
	output 						ch0_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch0_rd_burst_data,
	output 						ch0_rd_burst_finish,
	
	input 						ch1_rd_burst_req,
	input[9:0] 					ch1_rd_burst_len,
	input[ADDR_BITS-1:0]		ch1_rd_burst_addr,
	output 						ch1_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch1_rd_burst_data,
	output 						ch1_rd_burst_finish,
	
	input 						ch2_rd_burst_req,
	input[9:0] 					ch2_rd_burst_len,
	input[ADDR_BITS-1:0]		ch2_rd_burst_addr,
	output 						ch2_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch2_rd_burst_data,
	output 						ch2_rd_burst_finish,
	
	input 						ch3_rd_burst_req,
	input[9:0] 					ch3_rd_burst_len,
	input[ADDR_BITS-1:0]		ch3_rd_burst_addr,
	output 						ch3_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch3_rd_burst_data,
	output 						ch3_rd_burst_finish,

	input 						ch4_rd_burst_req,
	input[9:0] 					ch4_rd_burst_len,
	input[ADDR_BITS-1:0]		ch4_rd_burst_addr,
	output 						ch4_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch4_rd_burst_data,
	output 						ch4_rd_burst_finish,
	
	input 						ch5_rd_burst_req,
	input[9:0] 					ch5_rd_burst_len,
	input[ADDR_BITS-1:0]		ch5_rd_burst_addr,
	output 						ch5_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch5_rd_burst_data,
	output 						ch5_rd_burst_finish,
	
	input 						ch6_rd_burst_req,
	input[9:0] 					ch6_rd_burst_len,
	input[ADDR_BITS-1:0]		ch6_rd_burst_addr,
	output 						ch6_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch6_rd_burst_data,
	output 						ch6_rd_burst_finish,
	
	input 						ch7_rd_burst_req,
	input[9:0] 					ch7_rd_burst_len,
	input[ADDR_BITS-1:0]		ch7_rd_burst_addr,
	output 						ch7_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch7_rd_burst_data,
	output 						ch7_rd_burst_finish,
	///////////////////////////////////////////
	input 						ch0_wr_burst_req,
	input[9:0] 					ch0_wr_burst_len,
	input[ADDR_BITS-1:0]		ch0_wr_burst_addr,
	output 						ch0_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 	ch0_wr_burst_data,
	output 						ch0_wr_burst_finish,
	
	input 						ch1_wr_burst_req,
	input[9:0] 					ch1_wr_burst_len,
	input[ADDR_BITS-1:0]		ch1_wr_burst_addr,
	output 						ch1_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 	ch1_wr_burst_data,
	output 						ch1_wr_burst_finish,
	
	input 						ch2_wr_burst_req,
	input[9:0] 					ch2_wr_burst_len,
	input[ADDR_BITS-1:0]		ch2_wr_burst_addr,
	output 						ch2_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 	ch2_wr_burst_data,
	output ch2_wr_burst_finish,
	
	input 						ch3_wr_burst_req,
	input[9:0] 					ch3_wr_burst_len,
	input[ADDR_BITS-1:0]		ch3_wr_burst_addr,
	output 						ch3_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 	ch3_wr_burst_data,
	output 						ch3_wr_burst_finish,
	
	input 						ch4_wr_burst_req,
	input[9:0] 					ch4_wr_burst_len,
	input[ADDR_BITS-1:0]		ch4_wr_burst_addr,
	output 						ch4_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 	ch4_wr_burst_data,
	output 						ch4_wr_burst_finish,
	
	input 						ch5_wr_burst_req,
	input[9:0] 					ch5_wr_burst_len,
	input[ADDR_BITS-1:0]		ch5_wr_burst_addr,
	output 						ch5_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 	ch5_wr_burst_data,
	output 						ch5_wr_burst_finish,
	
	input 						ch6_wr_burst_req,
	input[9:0] 					ch6_wr_burst_len,
	input[ADDR_BITS-1:0]		ch6_wr_burst_addr,
	output 						ch6_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 	ch6_wr_burst_data,
	output 						ch6_wr_burst_finish,
	
	input 						ch7_wr_burst_req,
	input[9:0] 					ch7_wr_burst_len,
	input[ADDR_BITS-1:0]		ch7_wr_burst_addr,
	output 						ch7_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 	ch7_wr_burst_data,
	output 						ch7_wr_burst_finish,
	
	
	/////////////////////////////////////
	output  wire[0 : 0]  		mem_cs_n,
	output  wire[0 : 0]  		mem_cke,
	output  wire[12: 0]  		mem_addr,
	output  wire[2 : 0]  		mem_ba,
	output  wire  				mem_ras_n,
	output  wire  				mem_cas_n,
	output  wire  				mem_we_n,
	inout  wire[0 : 0]  		mem_clk,
	inout  wire[0 : 0]  		mem_clk_n,
	output  wire[3 : 0]  		mem_dm,
	inout  wire[31: 0]  		mem_dq,
	inout  wire[3 : 0]  		mem_dqs,
	output[0:0]					mem_odt
);
wire[ADDR_BITS-1:0]			local_address;
wire 						local_write_req;
wire 						local_read_req;
wire[MEM_DATA_BITS - 1:0]	local_wdata;
wire[MEM_DATA_BITS/8 - 1:0]	local_be;
wire[2:0]					local_size;
wire 						local_ready;
wire[MEM_DATA_BITS - 1:0]	local_rdata;
wire 						local_rdata_valid;
wire 						local_wdata_req;
wire 						local_init_done;
wire 						rd_burst_finish;
wire 						wr_burst_finish;
wire[ADDR_BITS-1:0] 		wr_burst_addr;
wire[ADDR_BITS-1:0] 		rd_burst_addr;
wire 						wr_burst_data_req;
wire 						rd_burst_data_valid;
wire[9:0] 					wr_burst_len;
wire[9:0] 					rd_burst_len;
wire 						wr_burst_req;
wire 						rd_burst_req;
wire[MEM_DATA_BITS - 1:0] 	wr_burst_data;
wire[MEM_DATA_BITS - 1:0] 	rd_burst_data;
wire ddr_rst_n;
wire local_burstbegin;	
mem_burst_v2
#(
	.MEM_DATA_BITS	(MEM_DATA_BITS),
	.ADDR_BITS		(ADDR_BITS)
)
mem_burst_m0(
	.rst_n(rst_n),
	.mem_clk(phy_clk),
	.rd_burst_req(rd_burst_req),
	.wr_burst_req(wr_burst_req),
	.rd_burst_len(rd_burst_len),
	.wr_burst_len(wr_burst_len),
	.rd_burst_addr(rd_burst_addr),
	.wr_burst_addr(wr_burst_addr),
	.rd_burst_data_valid(rd_burst_data_valid),
	.wr_burst_data_req(wr_burst_data_req),
	.rd_burst_data(rd_burst_data),
	.wr_burst_data(wr_burst_data),
	.rd_burst_finish(rd_burst_finish),
	.wr_burst_finish(wr_burst_finish),
	///////////////////
	.local_init_done(local_init_done),
	.local_ready(local_ready),
	.local_burstbegin(local_burstbegin),
	.local_wdata(local_wdata),
	.local_rdata_valid(local_rdata_valid),
	.local_rdata(local_rdata),
	.local_write_req(local_write_req),
	.local_read_req(local_read_req),
	.local_address(local_address),
	.local_be(local_be),
	.local_size(local_size)
); 

mem_read_arbi_verb 
#(
	.MEM_DATA_BITS	(MEM_DATA_BITS	),
	.ADDR_BITS		(ADDR_BITS		),
	.PINTS			(READ_PORTS		)
)
mem_read_arbi_m0
(
	.rst_n						(rst_n),
	.mem_clk					(phy_clk),
	.ch0_rd_burst_req			(ch0_rd_burst_req),
	.ch0_rd_burst_len			(ch0_rd_burst_len),
	.ch0_rd_burst_addr			(ch0_rd_burst_addr),
	.ch0_rd_burst_data_valid	(ch0_rd_burst_data_valid),
	.ch0_rd_burst_data			(ch0_rd_burst_data),
	.ch0_rd_burst_finish		(ch0_rd_burst_finish),
	
	.ch1_rd_burst_req			(ch1_rd_burst_req),
	.ch1_rd_burst_len			(ch1_rd_burst_len),
	.ch1_rd_burst_addr			(ch1_rd_burst_addr),
	.ch1_rd_burst_data_valid	(ch1_rd_burst_data_valid),
	.ch1_rd_burst_data			(ch1_rd_burst_data),
	.ch1_rd_burst_finish		(ch1_rd_burst_finish),
	
	.ch2_rd_burst_req			(ch2_rd_burst_req),
	.ch2_rd_burst_len			(ch2_rd_burst_len),
	.ch2_rd_burst_addr			(ch2_rd_burst_addr),
	.ch2_rd_burst_data_valid	(ch2_rd_burst_data_valid),
	.ch2_rd_burst_data			(ch2_rd_burst_data),
	.ch2_rd_burst_finish		(ch2_rd_burst_finish),
	
	.ch3_rd_burst_req			(ch3_rd_burst_req),
	.ch3_rd_burst_len			(ch3_rd_burst_len),
	.ch3_rd_burst_addr			(ch3_rd_burst_addr),
	.ch3_rd_burst_data_valid	(ch3_rd_burst_data_valid),
	.ch3_rd_burst_data			(ch3_rd_burst_data),
	.ch3_rd_burst_finish		(ch3_rd_burst_finish),
	
	.ch4_rd_burst_req			(ch4_rd_burst_req),
	.ch4_rd_burst_len			(ch4_rd_burst_len),
	.ch4_rd_burst_addr			(ch4_rd_burst_addr),
	.ch4_rd_burst_data_valid	(ch4_rd_burst_data_valid),
	.ch4_rd_burst_data			(ch4_rd_burst_data),
	.ch4_rd_burst_finish		(ch4_rd_burst_finish),
	
	.ch5_rd_burst_req			(ch5_rd_burst_req),
	.ch5_rd_burst_len			(ch5_rd_burst_len),
	.ch5_rd_burst_addr			(ch5_rd_burst_addr),
	.ch5_rd_burst_data_valid	(ch5_rd_burst_data_valid),
	.ch5_rd_burst_data			(ch5_rd_burst_data),
	.ch5_rd_burst_finish		(ch5_rd_burst_finish),
	
	.ch6_rd_burst_req			(ch6_rd_burst_req),
	.ch6_rd_burst_len			(ch6_rd_burst_len),
	.ch6_rd_burst_addr			(ch6_rd_burst_addr),
	.ch6_rd_burst_data_valid	(ch6_rd_burst_data_valid),
	.ch6_rd_burst_data			(ch6_rd_burst_data),
	.ch6_rd_burst_finish		(ch6_rd_burst_finish),
	
	.ch7_rd_burst_req			(ch7_rd_burst_req),
	.ch7_rd_burst_len			(ch7_rd_burst_len),
	.ch7_rd_burst_addr			(ch7_rd_burst_addr),
	.ch7_rd_burst_data_valid	(ch7_rd_burst_data_valid),
	.ch7_rd_burst_data			(ch7_rd_burst_data),
	.ch7_rd_burst_finish		(ch7_rd_burst_finish),
	
	///////////////////////////////////////////
	.rd_burst_req				(rd_burst_req),
	.rd_burst_len				(rd_burst_len),
	.rd_burst_addr				(rd_burst_addr),
	.rd_burst_data_valid		(rd_burst_data_valid),
	.rd_burst_data				(rd_burst_data),
	.rd_burst_finish			(rd_burst_finish)	
);

mem_write_arbi_verb
#(
	.MEM_DATA_BITS	(MEM_DATA_BITS),
	.ADDR_BITS		(ADDR_BITS),
	.PINTS			(WRITE_PORTS)
)
mem_write_arbi_m0(
	.rst_n					(rst_n),
	.mem_clk				(phy_clk),
	
	.ch0_wr_burst_req		(ch0_wr_burst_req),
	.ch0_wr_burst_len		(ch0_wr_burst_len),
	.ch0_wr_burst_addr		(ch0_wr_burst_addr),
	.ch0_wr_burst_data_req	(ch0_wr_burst_data_req),
	.ch0_wr_burst_data		(ch0_wr_burst_data),
	.ch0_wr_burst_finish	(ch0_wr_burst_finish),
	
	.ch1_wr_burst_req		(ch1_wr_burst_req),
	.ch1_wr_burst_len		(ch1_wr_burst_len),
	.ch1_wr_burst_addr		(ch1_wr_burst_addr),
	.ch1_wr_burst_data_req	(ch1_wr_burst_data_req),
	.ch1_wr_burst_data		(ch1_wr_burst_data),
	.ch1_wr_burst_finish	(ch1_wr_burst_finish),
	
	.ch2_wr_burst_req		(ch2_wr_burst_req),
	.ch2_wr_burst_len		(ch2_wr_burst_len),
	.ch2_wr_burst_addr		(ch2_wr_burst_addr),
	.ch2_wr_burst_data_req	(ch2_wr_burst_data_req),
	.ch2_wr_burst_data		(ch2_wr_burst_data),
	.ch2_wr_burst_finish	(ch2_wr_burst_finish),
	
	.ch3_wr_burst_req		(ch3_wr_burst_req),
	.ch3_wr_burst_len		(ch3_wr_burst_len),
	.ch3_wr_burst_addr		(ch3_wr_burst_addr),
	.ch3_wr_burst_data_req	(ch3_wr_burst_data_req),
	.ch3_wr_burst_data		(ch3_wr_burst_data),
	.ch3_wr_burst_finish	(ch3_wr_burst_finish),

	.ch4_wr_burst_req		(ch4_wr_burst_req),
	.ch4_wr_burst_len		(ch4_wr_burst_len),
	.ch4_wr_burst_addr		(ch4_wr_burst_addr),
	.ch4_wr_burst_data_req	(ch4_wr_burst_data_req),
	.ch4_wr_burst_data		(ch4_wr_burst_data),
	.ch4_wr_burst_finish	(ch4_wr_burst_finish),
	
	.ch5_wr_burst_req		(ch5_wr_burst_req),
	.ch5_wr_burst_len		(ch5_wr_burst_len),
	.ch5_wr_burst_addr		(ch5_wr_burst_addr),
	.ch5_wr_burst_data_req	(ch5_wr_burst_data_req),
	.ch5_wr_burst_data		(ch5_wr_burst_data),
	.ch5_wr_burst_finish	(ch5_wr_burst_finish),
	
	.ch6_wr_burst_req		(ch6_wr_burst_req),
	.ch6_wr_burst_len		(ch6_wr_burst_len),
	.ch6_wr_burst_addr		(ch6_wr_burst_addr),
	.ch6_wr_burst_data_req	(ch6_wr_burst_data_req),
	.ch6_wr_burst_data		(ch6_wr_burst_data),
	.ch6_wr_burst_finish	(ch6_wr_burst_finish),
	
	.ch7_wr_burst_req		(ch7_wr_burst_req),
	.ch7_wr_burst_len		(ch7_wr_burst_len),
	.ch7_wr_burst_addr		(ch7_wr_burst_addr),
	.ch7_wr_burst_data_req	(ch7_wr_burst_data_req),
	.ch7_wr_burst_data		(ch7_wr_burst_data),
	.ch7_wr_burst_finish	(ch7_wr_burst_finish),
	
	.wr_burst_req			(wr_burst_req),
	.wr_burst_len			(wr_burst_len),
	.wr_burst_addr			(wr_burst_addr),
	.wr_burst_data_req		(wr_burst_data_req),
	.wr_burst_data			(wr_burst_data),
	.wr_burst_finish		(wr_burst_finish)	
);

ddr_ip ddr_m0(
	.local_address(local_address),
	.local_write_req(local_write_req),
	.local_read_req(local_read_req),
	.local_wdata(local_wdata),
	.local_be(local_be),
	.local_size(local_size),
	.global_reset_n(rst_n),
	//.local_refresh_req(1'b0), 
	//.local_self_rfsh_req(1'b0),
	.pll_ref_clk(source_clk),
	.soft_reset_n(1'b1),
	.local_ready(local_ready),
	.local_rdata(local_rdata),
	.local_rdata_valid(local_rdata_valid),
	.reset_request_n(),
	.mem_cs_n(mem_cs_n),
	.mem_cke(mem_cke),
	.mem_addr(mem_addr),
	.mem_ba(mem_ba),
	.mem_ras_n(mem_ras_n),
	.mem_cas_n(mem_cas_n),
	.mem_we_n(mem_we_n),
	.mem_dm(mem_dm),
	.local_refresh_ack(),
	.local_burstbegin(local_burstbegin),
	.local_init_done(local_init_done),
	.reset_phy_clk_n(),
	.phy_clk(phy_clk),
	.aux_full_rate_clk(),
	.aux_half_rate_clk(),
	.mem_clk(mem_clk),
	.mem_clk_n(mem_clk_n),
	.mem_dq(mem_dq),
	.mem_dqs(mem_dqs),
	.mem_odt(mem_odt)
	);
endmodule 