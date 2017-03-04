/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
---------------------------------------------------------------------------------------|
Version: VERA.1.0                                                                      |
	create wait_for_data for write port                                                |
	create signal get_enough_data out_not_ready for read port                          |
Version: VERA.2.0                                                                      |
	create 'width 'height 'length signals for write port , I think them are useful.    |
	And  you can dont use them, module will work like VERA.1.0                         |
	Discard vblk,                                                                      |
Version: VERA.2.1                                                                      |
	add video_width video_height to read port                                          |
Version: VERB.0.0                                                                      |
	add out_valid for somemodule ,you can leave it not connect                         |
	complete all port                                                                  |
Version: VERC.0.0                                                                      |
	for line by line                                                                   |
Version: VERD.0.0                                                                      |
	test discontinuous de                                                              |
Version: VERD.1.0                                                                      |
	8 write ports                                                                      |
	8 read ports                                                                       |
Version: VERD.1.1                                                                      |
	make more params for outside                                                       |
---------------------------------------------------------------------------------------|
Version: VERA.0.0 : 2015/12/11 10:24:14
creaded: 2015/5/7 9:54:43
madified:2015/5/21 15:02:21
***********************************************/
`timescale 1ns/1ps
module mem_if_stream_and_vhf #(
	parameter[7:0]	WR_MODE				= 8'b0000_0000,		//0: VHF 1:STREAM
	parameter[7:0]	RD_MODE				= 8'b0000_0000,		//0: VHF 1:STREAM
	parameter		ADDR_BITS			= 25,
	parameter[7:0]	READ_PORTS			= 8'b1111_1111,
	parameter[7:0]	WRITE_PORTS			= 8'b1111_1111,
	parameter	W0_SIZE				= 24,	parameter	R0_SIZE				= 24,
	parameter	W1_SIZE				= 24,	parameter	R1_SIZE				= 24,
	parameter	W2_SIZE				= 24,	parameter	R2_SIZE				= 24,
	parameter	W3_SIZE				= 24,	parameter	R3_SIZE				= 24,
	parameter	W4_SIZE				= 24,	parameter	R4_SIZE				= 24,
	parameter	W5_SIZE				= 24,	parameter	R5_SIZE				= 24,
	parameter	W6_SIZE				= 24,	parameter	R6_SIZE				= 24,
	parameter	W7_SIZE				= 24,	parameter	R7_SIZE				= 24,
	parameter	W0_DELTA			= 6,	parameter	R0_DELTA			= 6,
	parameter	W1_DELTA			= 6,	parameter	R1_DELTA			= 6,
	parameter	W2_DELTA			= 6,	parameter	R2_DELTA			= 6,
	parameter	W3_DELTA			= 6,	parameter	R3_DELTA			= 6,
	parameter	W4_DELTA			= 6,	parameter	R4_DELTA			= 6,
	parameter	W5_DELTA			= 6,	parameter	R5_DELTA			= 6,
	parameter	W6_DELTA			= 6,	parameter	R6_DELTA			= 6,
	parameter	W7_DELTA			= 6,	parameter	R7_DELTA			= 6,
	parameter	W0_FLIPPING			= "FALSE",		//FALSE TRUE
	parameter	W1_FLIPPING			= "FALSE",		//FALSE TRUE
	parameter	W2_FLIPPING			= "FALSE",		//FALSE TRUE
	parameter	W3_FLIPPING			= "FALSE",		//FALSE TRUE
	parameter	W4_FLIPPING			= "FALSE",		//FALSE TRUE
	parameter	W5_FLIPPING			= "FALSE",		//FALSE TRUE
	parameter	W6_FLIPPING			= "FALSE",		//FALSE TRUE
	parameter	W7_FLIPPING			= "FALSE"		//FALSE TRUE

)(
	input					sys_clk				,
	input					rst_n		    	,
	//-- write port 0---
	input					w0_clk		    	,
    input					w0_rst_n        	,
    input					w0_vsync        	,
    input					w0_de           	,
    input [W0_SIZE-1:0]		w0_indata       	,
	input [ADDR_BITS-1:0]	w0_baseaddr     	,
	output					w0_wait_for_data	,
	input [11:0]			w0_video_width		,
	input [11:0]			w0_video_height		,
	//-- read port 0 --
	input					r0_clk          	,
    input					r0_rst_n        	,
    input					r0_vsync        	,
    input					r0_hsync        	,
    input					r0_de           	,
    output					r0_outvsync     	,
    output					r0_outhsync     	,
    output					r0_outde        	,
    output[R0_SIZE-1:0]		r0_outdata      	,
	output					r0_data_vld			,
	input [11:0]			r0_video_width	    ,
	input [11:0]			r0_video_height		,
    input [ADDR_BITS-1:0]	r0_baseaddr     	,
	input					r0_get_enough_data	,
	output					r0_out_not_ready	,
	//-- write port 1---
	input					w1_clk		    	,
    input					w1_rst_n        	,
    input					w1_vsync        	,
    input					w1_vblk         	,
    input					w1_de           	,
    input [W1_SIZE-1:0]		w1_indata       	,
	input [ADDR_BITS-1:0]	w1_baseaddr     	,
	output					w1_wait_for_data	,
	input [11:0]			w1_video_width		,
	input [11:0]			w1_video_height		,
	//-- read port 1 --
	input					r1_clk          	,
    input					r1_rst_n        	,
    input					r1_vsync        	,
    input					r1_hsync        	,
    input					r1_de           	,
    output					r1_outvsync     	,
    output					r1_outhsync     	,
    output					r1_outde        	,
    output[R1_SIZE-1:0]		r1_outdata      	,
	output					r1_data_vld			,
	input [11:0]			r1_video_width	    ,
	input [11:0]			r1_video_height		,
    input [ADDR_BITS-1:0]	r1_baseaddr     	,
	input					r1_get_enough_data	,
	output					r1_out_not_ready	,
	//-- write port 2---
	input					w2_clk		    	,
    input					w2_rst_n        	,
    input					w2_vsync        	,
    input					w2_vblk         	,
    input					w2_de           	,
    input [W2_SIZE-1:0]		w2_indata       	,
	input [ADDR_BITS-1:0]	w2_baseaddr     	,
	output					w2_wait_for_data	,
	input [11:0]			w2_video_width		,
	input [11:0]			w2_video_height		,
	//-- read port 2 --
	input					r2_clk          	,
    input					r2_rst_n        	,
    input					r2_vsync        	,
    input					r2_hsync        	,
    input					r2_de           	,
    output					r2_outvsync     	,
    output					r2_outhsync     	,
    output					r2_outde        	,
    output[R2_SIZE-1:0]		r2_outdata      	,
	output					r2_data_vld			,
	input [11:0]			r2_video_width	    ,
	input [11:0]			r2_video_height		,
    input [ADDR_BITS-1:0]	r2_baseaddr     	,
	input					r2_get_enough_data	,
	output					r2_out_not_ready	,
	//-- write port 3---
	input					w3_clk		    	,
    input					w3_rst_n        	,
    input					w3_vsync        	,
    input					w3_vblk         	,
    input					w3_de           	,
    input [W3_SIZE-1:0]		w3_indata       	,
	input [ADDR_BITS-1:0]	w3_baseaddr     	,
	output					w3_wait_for_data	,
	input [11:0]			w3_video_width		,
	input [11:0]			w3_video_height		,
	//-- read port 3 --
	input					r3_clk          	,
    input					r3_rst_n        	,
    input					r3_vsync        	,
    input					r3_hsync        	,
    input					r3_de           	,
    output					r3_outvsync     	,
    output					r3_outhsync     	,
    output					r3_outde        	,
    output[R3_SIZE-1:0]		r3_outdata      	,
	output					r3_data_vld			,
	input [11:0]			r3_video_width	    ,
	input [11:0]			r3_video_height		,
    input [ADDR_BITS-1:0]	r3_baseaddr     	,
	input					r3_get_enough_data	,
	output					r3_out_not_ready	,
	//-- write port 4---
	input					w4_clk		    	,
    input					w4_rst_n        	,
    input					w4_vsync        	,
    input					w4_de           	,
    input [W4_SIZE-1:0]		w4_indata       	,
	input [ADDR_BITS-1:0]	w4_baseaddr     	,
	output					w4_wait_for_data	,
	input [11:0]			w4_video_width		,
	input [11:0]			w4_video_height		,
	//-- read port 4 --
	input					r4_clk          	,
    input					r4_rst_n        	,
    input					r4_vsync        	,
    input					r4_hsync        	,
    input					r4_de           	,
    output					r4_outvsync     	,
    output					r4_outhsync     	,
    output					r4_outde        	,
    output[R4_SIZE-1:0]		r4_outdata      	,
	output					r4_data_vld			,
	input [11:0]			r4_video_width	    ,
	input [11:0]			r4_video_height		,
    input [ADDR_BITS-1:0]	r4_baseaddr     	,
	input					r4_get_enough_data	,
	output					r4_out_not_ready	,
	//-- write port 5---
	input					w5_clk		    	,
    input					w5_rst_n        	,
    input					w5_vsync        	,
    input					w5_vblk         	,
    input					w5_de           	,
    input [W5_SIZE-1:0]		w5_indata       	,
	input [ADDR_BITS-1:0]	w5_baseaddr     	,
	output					w5_wait_for_data	,
	input [11:0]			w5_video_width		,
	input [11:0]			w5_video_height		,
	//-- read port 5 --
	input					r5_clk          	,
    input					r5_rst_n        	,
    input					r5_vsync        	,
    input					r5_hsync        	,
    input					r5_de           	,
    output					r5_outvsync     	,
    output					r5_outhsync     	,
    output					r5_outde        	,
    output[R5_SIZE-1:0]		r5_outdata      	,
	output					r5_data_vld			,
	input [11:0]			r5_video_width	    ,
	input [11:0]			r5_video_height		,
    input [ADDR_BITS-1:0]	r5_baseaddr     	,
	input					r5_get_enough_data	,
	output					r5_out_not_ready	,
	//-- write port 6---
	input					w6_clk		    	,
    input					w6_rst_n        	,
    input					w6_vsync        	,
    input					w6_vblk         	,
    input					w6_de           	,
    input [W6_SIZE-1:0]		w6_indata       	,
	input [ADDR_BITS-1:0]	w6_baseaddr     	,
	output					w6_wait_for_data	,
	input [11:0]			w6_video_width		,
	input [11:0]			w6_video_height		,
	//-- read port 6 --
	input					r6_clk          	,
    input					r6_rst_n        	,
    input					r6_vsync        	,
    input					r6_hsync        	,
    input					r6_de           	,
    output					r6_outvsync     	,
    output					r6_outhsync     	,
    output					r6_outde        	,
    output[R6_SIZE-1:0]		r6_outdata      	,
	output					r6_data_vld			,
	input [11:0]			r6_video_width	    ,
	input [11:0]			r6_video_height		,
    input [ADDR_BITS-1:0]	r6_baseaddr     	,
	input					r6_get_enough_data	,
	output					r6_out_not_ready	,
	//-- write port 7---
	input					w7_clk		    	,
    input					w7_rst_n        	,
    input					w7_vsync        	,
    input					w7_vblk         	,
    input					w7_de           	,
    input [W7_SIZE-1:0]		w7_indata       	,
	input [ADDR_BITS-1:0]	w7_baseaddr     	,
	output					w7_wait_for_data	,
	input [11:0]			w7_video_width		,
	input [11:0]			w7_video_height		,
	//-- read port 7 --
	input					r7_clk          	,
    input					r7_rst_n        	,
    input					r7_vsync        	,
    input					r7_hsync        	,
    input					r7_de           	,
    output					r7_outvsync     	,
    output					r7_outhsync     	,
    output					r7_outde        	,
    output[R7_SIZE-1:0]		r7_outdata      	,
	output					r7_data_vld			,
	input [11:0]			r7_video_width	    ,
	input [11:0]			r7_video_height		,
    input [ADDR_BITS-1:0]	r7_baseaddr     	,
	input					r7_get_enough_data	,
	output					r7_out_not_ready	,
	//--stream write
	//----STREAM WR 0
	input						w0_stream_clk					,
	input						w0_stream_rst_n                 ,
	input						w0_stream_in_sof                ,
	input						w0_stream_in_vld                ,
	output						w0_stream_out_wait_for_data     ,
	input [W0_SIZE-1:0]			w0_stream_in_data               ,
	input [ADDR_BITS-1:0]		w0_stream_in_baseaddr           ,
	input [23:0]				w0_stream_in_length             ,
	//----STREAM WR 1
	input						w1_stream_clk					,
	input						w1_stream_rst_n                 ,
	input						w1_stream_in_sof                ,
	input						w1_stream_in_vld                ,
	output						w1_stream_out_wait_for_data     ,
	input [W1_SIZE-1:0]			w1_stream_in_data               ,
	input [ADDR_BITS-1:0]		w1_stream_in_baseaddr           ,
	input [23:0]				w1_stream_in_length             ,
	//----STREAM WR 2
	input						w2_stream_clk					,
	input						w2_stream_rst_n                 ,
	input						w2_stream_in_sof                ,
	input						w2_stream_in_vld                ,
	output						w2_stream_out_wait_for_data     ,
	input [W2_SIZE-1:0]			w2_stream_in_data               ,
	input [ADDR_BITS-1:0]		w2_stream_in_baseaddr           ,
	input [23:0]				w2_stream_in_length             ,
	//----STREAM WR 3
	input						w3_stream_clk					,
	input						w3_stream_rst_n                 ,
	input						w3_stream_in_sof                ,
	input						w3_stream_in_vld                ,
	output						w3_stream_out_wait_for_data     ,
	input [W3_SIZE-1:0]			w3_stream_in_data               ,
	input [ADDR_BITS-1:0]		w3_stream_in_baseaddr           ,
	input [23:0]				w3_stream_in_length             ,
	//----STREAM WR 4
	input						w4_stream_clk					,
	input						w4_stream_rst_n                 ,
	input						w4_stream_in_sof                ,
	input						w4_stream_in_vld                ,
	output						w4_stream_out_wait_for_data     ,
	input [W4_SIZE-1:0]			w4_stream_in_data               ,
	input [ADDR_BITS-1:0]		w4_stream_in_baseaddr           ,
	input [23:0]				w4_stream_in_length             ,
	//----STREAM WR 5
	input						w5_stream_clk					,
	input						w5_stream_rst_n                 ,
	input						w5_stream_in_sof                ,
	input						w5_stream_in_vld                ,
	output						w5_stream_out_wait_for_data     ,
	input [W5_SIZE-1:0]			w5_stream_in_data               ,
	input [ADDR_BITS-1:0]		w5_stream_in_baseaddr           ,
	input [23:0]				w5_stream_in_length             ,
	//----STREAM WR 6
	input						w6_stream_clk					,
	input						w6_stream_rst_n                 ,
	input						w6_stream_in_sof                ,
	input						w6_stream_in_vld                ,
	output						w6_stream_out_wait_for_data     ,
	input [W6_SIZE-1:0]			w6_stream_in_data               ,
	input [ADDR_BITS-1:0]		w6_stream_in_baseaddr           ,
	input [23:0]				w6_stream_in_length             ,
	//----STREAM WR 7
	input						w7_stream_clk					,
	input						w7_stream_rst_n                 ,
	input						w7_stream_in_sof                ,
	input						w7_stream_in_vld                ,
	output						w7_stream_out_wait_for_data     ,
	input [W7_SIZE-1:0]			w7_stream_in_data               ,
	input [ADDR_BITS-1:0]		w7_stream_in_baseaddr           ,
	input [23:0]				w7_stream_in_length             ,
	//--stream read
	//----STREAM RD 0
	input						r0_stream_clk					,
	input						r0_stream_rst_n                 ,
	input						r0_stream_in_request            ,
	input						r0_stream_in_read               ,
	output						r0_stream_out_sof               ,
	output						r0_stream_out_read_sync         ,
	output						r0_stream_out_not_ready         ,
	output[R0_SIZE-1:0]			r0_stream_out_data              ,
	output						r0_stream_out_vld               ,
	input [23:0]				r0_stream_in_length             ,
	input [ADDR_BITS-1:0]		r0_stream_in_baseaddr           ,
	output						r0_stream_out_req_respond		,	//++++ A2
	output						r0_stream_out_req_waiting		,	//++++ A2
	output						r0_stream_out_req_proc_fsh		,	//++++ A2
	//----STREAM RD 1
	input						r1_stream_clk					,
	input						r1_stream_rst_n                 ,
	input						r1_stream_in_request            ,
	input						r1_stream_in_read               ,
	output						r1_stream_out_sof               ,
	output						r1_stream_out_read_sync         ,
	output						r1_stream_out_not_ready         ,
	output[R1_SIZE-1:0]			r1_stream_out_data              ,
	output						r1_stream_out_vld               ,
	input [23:0]				r1_stream_in_length             ,
	input [ADDR_BITS-1:0]		r1_stream_in_baseaddr           ,
	output						r1_stream_out_req_respond		,	//++++ A2
	output						r1_stream_out_req_waiting		,	//++++ A2
	output						r1_stream_out_req_proc_fsh		,	//++++ A2
	//----STREAM RD 2
	input						r2_stream_clk					,
	input						r2_stream_rst_n                 ,
	input						r2_stream_in_request            ,
	input						r2_stream_in_read               ,
	output						r2_stream_out_sof               ,
	output						r2_stream_out_read_sync         ,
	output						r2_stream_out_not_ready         ,
	output[R2_SIZE-1:0]			r2_stream_out_data              ,
	output						r2_stream_out_vld               ,
	input [23:0]				r2_stream_in_length             ,
	input [ADDR_BITS-1:0]		r2_stream_in_baseaddr           ,
	output						r2_stream_out_req_respond		,	//++++ A2
	output						r2_stream_out_req_waiting		,	//++++ A2
	output						r2_stream_out_req_proc_fsh		,	//++++ A2
	//----STREAM RD 3
	input						r3_stream_clk					,
	input						r3_stream_rst_n                 ,
	input						r3_stream_in_request            ,
	input						r3_stream_in_read               ,
	output						r3_stream_out_sof               ,
	output						r3_stream_out_read_sync         ,
	output						r3_stream_out_not_ready         ,
	output[R3_SIZE-1:0]			r3_stream_out_data              ,
	output						r3_stream_out_vld               ,
	input [23:0]				r3_stream_in_length             ,
	input [ADDR_BITS-1:0]		r3_stream_in_baseaddr           ,
	output						r3_stream_out_req_respond		,	//++++ A2
	output						r3_stream_out_req_waiting		,	//++++ A2
	output						r3_stream_out_req_proc_fsh		,	//++++ A2
	//----STREAM RD 4
	input						r4_stream_clk					,
	input						r4_stream_rst_n                 ,
	input						r4_stream_in_request            ,
	input						r4_stream_in_read               ,
	output						r4_stream_out_sof               ,
	output						r4_stream_out_read_sync         ,
	output						r4_stream_out_not_ready         ,
	output[R4_SIZE-1:0]			r4_stream_out_data              ,
	output						r4_stream_out_vld               ,
	input [23:0]				r4_stream_in_length             ,
	input [ADDR_BITS-1:0]		r4_stream_in_baseaddr           ,
	output						r4_stream_out_req_respond		,	//++++ A2
	output						r4_stream_out_req_waiting		,	//++++ A2
	output						r4_stream_out_req_proc_fsh		,	//++++ A2
	//----STREAM RD 5
	input						r5_stream_clk					,
	input						r5_stream_rst_n                 ,
	input						r5_stream_in_request            ,
	input						r5_stream_in_read               ,
	output						r5_stream_out_sof               ,
	output						r5_stream_out_read_sync         ,
	output						r5_stream_out_not_ready         ,
	output[R5_SIZE-1:0]			r5_stream_out_data              ,
	output						r5_stream_out_vld               ,
	input [23:0]				r5_stream_in_length             ,
	input [ADDR_BITS-1:0]		r5_stream_in_baseaddr           ,
	output						r5_stream_out_req_respond		,	//++++ A2
	output						r5_stream_out_req_waiting		,	//++++ A2
	output						r5_stream_out_req_proc_fsh		,	//++++ A2
	//----STREAM RD 6
	input						r6_stream_clk					,
	input						r6_stream_rst_n                 ,
	input						r6_stream_in_request            ,
	input						r6_stream_in_read               ,
	output						r6_stream_out_sof               ,
	output						r6_stream_out_read_sync         ,
	output						r6_stream_out_not_ready         ,
	output[R6_SIZE-1:0]			r6_stream_out_data              ,
	output						r6_stream_out_vld               ,
	input [23:0]				r6_stream_in_length             ,
	input [ADDR_BITS-1:0]		r6_stream_in_baseaddr           ,
	output						r6_stream_out_req_respond		,	//++++ A2
	output						r6_stream_out_req_waiting		,	//++++ A2
	output						r6_stream_out_req_proc_fsh		,	//++++ A2
	//----STREAM RD 7
	input						r7_stream_clk					,
	input						r7_stream_rst_n                 ,
	input						r7_stream_in_request            ,
	input						r7_stream_in_read               ,
	output						r7_stream_out_sof               ,
	output						r7_stream_out_read_sync         ,
	output						r7_stream_out_not_ready         ,
	output[R7_SIZE-1:0]			r7_stream_out_data              ,
	output						r7_stream_out_vld               ,
	input [23:0]				r7_stream_in_length             ,
	input [ADDR_BITS-1:0]		r7_stream_in_baseaddr           ,
	output						r7_stream_out_req_respond		,	//++++ A2
	output						r7_stream_out_req_waiting		,	//++++ A2
	output						r7_stream_out_req_proc_fsh		,	//++++ A2
	//--ddr interface
	output[0 : 0]  				mem_cs_n,
	output[0 : 0]  				mem_cke,
	output[12: 0]  				mem_addr,
	output[2 : 0]  				mem_ba,
	output  					mem_ras_n,
	output  					mem_cas_n,
	output  					mem_we_n,
	inout [0 : 0]  				mem_clk,
	inout [0 : 0]  				mem_clk_n,
	output[3 : 0]  				mem_dm,
	inout [31: 0]  				mem_dq,
	inout [3 : 0]  				mem_dqs,
	output[0:0]					mem_odt
);


wire 				phy_clk;
wire 				ch0_rd_burst_req;
wire[9:0] 			ch0_rd_burst_len;
wire[ADDR_BITS-1:0] ch0_rd_burst_addr;
wire  				ch0_rd_burst_data_valid;
wire[63:0] 			ch0_rd_burst_data;
wire 				ch0_rd_burst_finish;

wire 				ch0_wr_burst_req;
wire[9:0] 			ch0_wr_burst_len;
wire[ADDR_BITS-1:0] ch0_wr_burst_addr;
wire 				ch0_wr_burst_data_req;
wire[63:0] 			ch0_wr_burst_data;
wire 				ch0_wr_burst_finish;

wire 				ch1_rd_burst_req;
wire[9:0] 			ch1_rd_burst_len;
wire[ADDR_BITS-1:0] ch1_rd_burst_addr;
wire  				ch1_rd_burst_data_valid;
wire[63:0] 			ch1_rd_burst_data;
wire 				ch1_rd_burst_finish;

wire 				ch1_wr_burst_req;
wire[9:0] 			ch1_wr_burst_len;
wire[ADDR_BITS-1:0] ch1_wr_burst_addr;
wire 				ch1_wr_burst_data_req;
wire[63:0] 			ch1_wr_burst_data;
wire 				ch1_wr_burst_finish;

wire 				ch2_rd_burst_req;
wire[9:0] 			ch2_rd_burst_len;
wire[ADDR_BITS-1:0]	ch2_rd_burst_addr;
wire  				ch2_rd_burst_data_valid;
wire[63:0] 			ch2_rd_burst_data;
wire 				ch2_rd_burst_finish;

wire 				ch2_wr_burst_req;
wire[9:0] 			ch2_wr_burst_len;
wire[ADDR_BITS-1:0] ch2_wr_burst_addr;
wire 				ch2_wr_burst_data_req;
wire[63:0] 			ch2_wr_burst_data;
wire 				ch2_wr_burst_finish;

wire 				ch3_rd_burst_req;
wire[9:0] 			ch3_rd_burst_len;
wire[ADDR_BITS-1:0] ch3_rd_burst_addr;
wire  				ch3_rd_burst_data_valid;
wire[63:0] 			ch3_rd_burst_data;
wire 				ch3_rd_burst_finish;

wire 				ch3_wr_burst_req;
wire[9:0] 			ch3_wr_burst_len;
wire[ADDR_BITS-1:0] ch3_wr_burst_addr;
wire 				ch3_wr_burst_data_req;
wire[63:0] 			ch3_wr_burst_data;
wire 				ch3_wr_burst_finish;

wire 				ch4_rd_burst_req;
wire[9:0] 			ch4_rd_burst_len;
wire[ADDR_BITS-1:0] ch4_rd_burst_addr;
wire  				ch4_rd_burst_data_valid;
wire[63:0] 			ch4_rd_burst_data;
wire 				ch4_rd_burst_finish;

wire 				ch4_wr_burst_req;
wire[9:0] 			ch4_wr_burst_len;
wire[ADDR_BITS-1:0] ch4_wr_burst_addr;
wire 				ch4_wr_burst_data_req;
wire[63:0] 			ch4_wr_burst_data;
wire 				ch4_wr_burst_finish;

wire 				ch5_rd_burst_req;
wire[9:0] 			ch5_rd_burst_len;
wire[ADDR_BITS-1:0] ch5_rd_burst_addr;
wire  				ch5_rd_burst_data_valid;
wire[63:0] 			ch5_rd_burst_data;
wire 				ch5_rd_burst_finish;

wire 				ch5_wr_burst_req;
wire[9:0] 			ch5_wr_burst_len;
wire[ADDR_BITS-1:0] ch5_wr_burst_addr;
wire 				ch5_wr_burst_data_req;
wire[63:0] 			ch5_wr_burst_data;
wire 				ch5_wr_burst_finish;

wire 				ch6_rd_burst_req;
wire[9:0] 			ch6_rd_burst_len;
wire[ADDR_BITS-1:0]	ch6_rd_burst_addr;
wire  				ch6_rd_burst_data_valid;
wire[63:0] 			ch6_rd_burst_data;
wire 				ch6_rd_burst_finish;

wire 				ch6_wr_burst_req;
wire[9:0] 			ch6_wr_burst_len;
wire[ADDR_BITS-1:0] ch6_wr_burst_addr;
wire 				ch6_wr_burst_data_req;
wire[63:0] 			ch6_wr_burst_data;
wire 				ch6_wr_burst_finish;

wire 				ch7_rd_burst_req;
wire[9:0] 			ch7_rd_burst_len;
wire[ADDR_BITS-1:0] ch7_rd_burst_addr;
wire  				ch7_rd_burst_data_valid;
wire[63:0] 			ch7_rd_burst_data;
wire 				ch7_rd_burst_finish;

wire 				ch7_wr_burst_req;
wire[9:0] 			ch7_wr_burst_len;
wire[ADDR_BITS-1:0] ch7_wr_burst_addr;
wire 				ch7_wr_burst_data_req;
wire[63:0] 			ch7_wr_burst_data;
wire 				ch7_wr_burst_finish;

wire			mem_rst_n;
assign			mem_rst_n	= rst_n;

generate
if(WRITE_PORTS[0] == 1'b1)begin:WR_PORT_BLOCK_0
//--- vin port 0---
if(WR_MODE[0] == 1'b0)begin
vin_process_discontinuous #(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS),
	.DSIZE				(W0_SIZE),
	.FIFO_DEPTH			(256),
	.DETAL				(W0_DELTA		),
	.FLIPPING			(W0_FLIPPING	)
)vin_process_inst0(
/*	input						*/	.pclk				(w0_clk					),
/*	input						*/	.prst_n             (w0_rst_n				),
/*	input						*/	.vsync              (w0_vsync   			),
/*	input						*/	.de                 (w0_de      			),
/*	output						*/	.wait_for_data		(w0_wait_for_data       ),
/*	input [DSIZE-1:0]			*/	.indata             (w0_indata  			),
/*	input [ADDR_BITS-1:0]		*/	.baseaddr           (w0_baseaddr			),
/*	input [11:0]				*/	.video_width		(w0_video_width   		),
/*	input [11:0]				*/	.video_height		(w0_video_height  		),
	//-- mem interface
/*	input						*/	.mem_clk    		(phy_clk         		),
/*	input						*/	.mem_rst_n          (mem_rst_n              ),
/*	output 						*/	.wr_burst_req       (ch0_wr_burst_req       ),
/*	output[9:0] 				*/	.wr_burst_len       (ch0_wr_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      (ch0_wr_burst_addr      ),
/*	input 						*/	.wr_burst_data_req  (ch0_wr_burst_data_req  ),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      (ch0_wr_burst_data      ),
/*	input 						*/	.wr_burst_finish    (ch0_wr_burst_finish    )
);
end else begin
in_stream_process #(
	.MEM_DATA_BITS 		(64				),
	.ADDR_BITS			(ADDR_BITS      ),
	.DSIZE				(W0_SIZE        ),
	.FIFO_DEPTH			(256            )
)in_stream_process_inst0(
/*	input						*/	.stream_clk					(w0_stream_clk					),
/*	input						*/	.stream_rst_n               (w0_stream_rst_n                ),
/*	input						*/	.stream_in_sof              (w0_stream_in_sof               ),
/*	input						*/	.stream_in_vld              (w0_stream_in_vld               ),
/*	output						*/	.stream_out_wait_for_data   (w0_stream_out_wait_for_data    ),
/*	input [DSIZE-1:0]			*/	.stream_in_data             (w0_stream_in_data              ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr         (w0_stream_in_baseaddr          ),
/*	input [23:0]				*/	.stream_in_length           (w0_stream_in_length            ),
/*	//-- mem interface          */
/*	input						*/	.mem_clk    				(phy_clk         				),
/*	input						*/	.mem_rst_n          		(mem_rst_n              		),
/*	output 						*/	.wr_burst_req       		(ch0_wr_burst_req       		),
/*	output[9:0] 				*/	.wr_burst_len       		(ch0_wr_burst_len       		),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      		(ch0_wr_burst_addr      		),
/*	input 						*/	.wr_burst_data_req  		(ch0_wr_burst_data_req  		),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      		(ch0_wr_burst_data      		),
/*	input 						*/	.wr_burst_finish    		(ch0_wr_burst_finish    		)
);
end
end else begin
assign	ch0_wr_burst_req		= 1'b0;
assign	ch0_wr_burst_len		= 10'd0;
assign	ch0_wr_burst_addr		= {ADDR_BITS{1'b0}};
assign	ch0_wr_burst_data		= 64'd0;
end
endgenerate

generate
if(WRITE_PORTS[1] == 1'b1 )begin:WR_PORT_BLOCK_1
//--- vin port 1---
if(WR_MODE[1] == 1'b0)begin
vin_process_discontinuous #(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS),
	.DSIZE				(W1_SIZE),
	.FIFO_DEPTH			(256),
	.DETAL				(W1_DELTA		),
	.FLIPPING			(W1_FLIPPING	)
)vin_process_inst1(
/*	input						*/	.pclk				(w1_clk					),
/*	input						*/	.prst_n             (w1_rst_n				),
/*	input						*/	.vsync              (w1_vsync   			),
/*	input						*/	.de                 (w1_de      			),
/*	output						*/	.wait_for_data		(w1_wait_for_data       ),
/*	input [DSIZE-1:0]			*/	.indata             (w1_indata  			),
/*	input [ADDR_BITS-1:0]		*/	.baseaddr           (w1_baseaddr			),
/*	input [11:0]				*/	.video_width		(w1_video_width   		),
/*	input [11:0]				*/	.video_height		(w1_video_height  		),
	//-- mem interface
/*	input						*/	.mem_clk    		(phy_clk         		),
/*	input						*/	.mem_rst_n          (mem_rst_n              ),
/*	output 						*/	.wr_burst_req       (ch1_wr_burst_req       ),
/*	output[9:0] 				*/	.wr_burst_len       (ch1_wr_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      (ch1_wr_burst_addr      ),
/*	input 						*/	.wr_burst_data_req  (ch1_wr_burst_data_req  ),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      (ch1_wr_burst_data      ),
/*	input 						*/	.wr_burst_finish    (ch1_wr_burst_finish    )
);
end else begin
in_stream_process #(
	.MEM_DATA_BITS 		(64				),
	.ADDR_BITS			(ADDR_BITS      ),
	.DSIZE				(W1_SIZE        ),
	.FIFO_DEPTH			(256            )
)in_stream_process_inst1(
/*	input						*/	.stream_clk					(w1_stream_clk					),
/*	input						*/	.stream_rst_n               (w1_stream_rst_n                ),
/*	input						*/	.stream_in_sof              (w1_stream_in_sof               ),
/*	input						*/	.stream_in_vld              (w1_stream_in_vld               ),
/*	output						*/	.stream_out_wait_for_data   (w1_stream_out_wait_for_data    ),
/*	input [DSIZE-1:0]			*/	.stream_in_data             (w1_stream_in_data              ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr         (w1_stream_in_baseaddr          ),
/*	input [23:0]				*/	.stream_in_length           (w1_stream_in_length            ),
/*	//-- mem interface          */
/*	input						*/	.mem_clk    				(phy_clk         				),
/*	input						*/	.mem_rst_n          		(mem_rst_n              		),
/*	output 						*/	.wr_burst_req       		(ch1_wr_burst_req       		),
/*	output[9:0] 				*/	.wr_burst_len       		(ch1_wr_burst_len       		),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      		(ch1_wr_burst_addr      		),
/*	input 						*/	.wr_burst_data_req  		(ch1_wr_burst_data_req  		),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      		(ch1_wr_burst_data      		),
/*	input 						*/	.wr_burst_finish    		(ch1_wr_burst_finish    		)
);
end
end  else begin
assign	ch1_wr_burst_req		= 1'b0;
assign	ch1_wr_burst_len		= 10'd0;
assign	ch1_wr_burst_addr		= {ADDR_BITS{1'b0}};
assign	ch1_wr_burst_data		= 64'd0;
end
endgenerate
generate
if(WRITE_PORTS[2] == 1'b1)begin:WR_PORT_BLOCK_2
//--- vin port 2---
if(WR_MODE[2] == 2'b0)begin
vin_process_discontinuous #(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS),
	.DSIZE				(W2_SIZE),
	.FIFO_DEPTH			(256),
	.DETAL				(W2_DELTA		),
	.FLIPPING			(W2_FLIPPING	)
)vin_process_inst2(
/*	input						*/	.pclk				(w2_clk					),
/*	input						*/	.prst_n             (w2_rst_n				),
/*	input						*/	.vsync              (w2_vsync   			),
/*	input						*/	.de                 (w2_de      			),
/*	output						*/	.wait_for_data		(w2_wait_for_data       ),
/*	input [DSIZE-1:0]			*/	.indata             (w2_indata  			),
/*	input [ADDR_BITS-1:0]		*/	.baseaddr           (w2_baseaddr			),
/*	input [11:0]				*/	.video_width		(w2_video_width   		),
/*	input [11:0]				*/	.video_height		(w2_video_height  		),
	//-- mem interface
/*	input						*/	.mem_clk    		(phy_clk         		),
/*	input						*/	.mem_rst_n          (mem_rst_n              ),
/*	output 						*/	.wr_burst_req       (ch2_wr_burst_req       ),
/*	output[9:0] 				*/	.wr_burst_len       (ch2_wr_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      (ch2_wr_burst_addr      ),
/*	input 						*/	.wr_burst_data_req  (ch2_wr_burst_data_req  ),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      (ch2_wr_burst_data      ),
/*	input 						*/	.wr_burst_finish    (ch2_wr_burst_finish    )
);
end else begin
in_stream_process #(
	.MEM_DATA_BITS 		(64				),
	.ADDR_BITS			(ADDR_BITS      ),
	.DSIZE				(W2_SIZE        ),
	.FIFO_DEPTH			(256            )
)in_stream_process_inst2(
/*	input						*/	.stream_clk					(w2_stream_clk					),
/*	input						*/	.stream_rst_n               (w2_stream_rst_n                ),
/*	input						*/	.stream_in_sof              (w2_stream_in_sof               ),
/*	input						*/	.stream_in_vld              (w2_stream_in_vld               ),
/*	output						*/	.stream_out_wait_for_data   (w2_stream_out_wait_for_data    ),
/*	input [DSIZE-1:0]			*/	.stream_in_data             (w2_stream_in_data              ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr         (w2_stream_in_baseaddr          ),
/*	input [23:0]				*/	.stream_in_length           (w2_stream_in_length            ),
/*	//-- mem interface          */
/*	input						*/	.mem_clk    				(phy_clk         				),
/*	input						*/	.mem_rst_n          		(mem_rst_n              		),
/*	output 						*/	.wr_burst_req       		(ch2_wr_burst_req       		),
/*	output[9:0] 				*/	.wr_burst_len       		(ch2_wr_burst_len       		),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      		(ch2_wr_burst_addr      		),
/*	input 						*/	.wr_burst_data_req  		(ch2_wr_burst_data_req  		),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      		(ch2_wr_burst_data      		),
/*	input 						*/	.wr_burst_finish    		(ch2_wr_burst_finish    		)
);
end
end else begin
assign	ch2_wr_burst_req		= 1'b0;
assign	ch2_wr_burst_len		= 10'd0;
assign	ch2_wr_burst_addr		= {ADDR_BITS{1'b0}};
assign	ch2_wr_burst_data		= 64'd0;
end
endgenerate
generate
if(WRITE_PORTS[3] == 1'b1 )begin:WR_PORT_BLOCK_3
//--- vin port 3---
if(WR_MODE[3] == 1'b0)begin
vin_process_discontinuous #(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS),
	.DSIZE				(W3_SIZE),
	.FIFO_DEPTH			(256),
	.DETAL				(W3_DELTA		),
	.FLIPPING			(W3_FLIPPING	)
)vin_process_inst3(
/*	input						*/	.pclk				(w3_clk					),
/*	input						*/	.prst_n             (w3_rst_n				),
/*	input						*/	.vsync              (w3_vsync   			),
/*	input						*/	.de                 (w3_de      			),
/*	output						*/	.wait_for_data		(w3_wait_for_data       ),
/*	input [DSIZE-1:0]			*/	.indata             (w3_indata  			),
/*	input [ADDR_BITS-1:0]		*/	.baseaddr           (w3_baseaddr			),
/*	input [11:0]				*/	.video_width		(w3_video_width   		),
/*	input [11:0]				*/	.video_height		(w3_video_height  		),
	//-- mem interface
/*	input						*/	.mem_clk    		(phy_clk         		),
/*	input						*/	.mem_rst_n          (mem_rst_n              ),
/*	output 						*/	.wr_burst_req       (ch3_wr_burst_req       ),
/*	output[9:0] 				*/	.wr_burst_len       (ch3_wr_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      (ch3_wr_burst_addr      ),
/*	input 						*/	.wr_burst_data_req  (ch3_wr_burst_data_req  ),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      (ch3_wr_burst_data      ),
/*	input 						*/	.wr_burst_finish    (ch3_wr_burst_finish    )
);
end else begin
in_stream_process #(
	.MEM_DATA_BITS 		(64				),
	.ADDR_BITS			(ADDR_BITS      ),
	.DSIZE				(W3_SIZE        ),
	.FIFO_DEPTH			(256            )
)in_stream_process_inst3(
/*	input						*/	.stream_clk					(w3_stream_clk					),
/*	input						*/	.stream_rst_n               (w3_stream_rst_n                ),
/*	input						*/	.stream_in_sof              (w3_stream_in_sof               ),
/*	input						*/	.stream_in_vld              (w3_stream_in_vld               ),
/*	output						*/	.stream_out_wait_for_data   (w3_stream_out_wait_for_data    ),
/*	input [DSIZE-1:0]			*/	.stream_in_data             (w3_stream_in_data              ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr         (w3_stream_in_baseaddr          ),
/*	input [23:0]				*/	.stream_in_length           (w3_stream_in_length            ),
/*	//-- mem interface          */
/*	input						*/	.mem_clk    				(phy_clk         				),
/*	input						*/	.mem_rst_n          		(mem_rst_n              		),
/*	output 						*/	.wr_burst_req       		(ch3_wr_burst_req       		),
/*	output[9:0] 				*/	.wr_burst_len       		(ch3_wr_burst_len       		),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      		(ch3_wr_burst_addr      		),
/*	input 						*/	.wr_burst_data_req  		(ch3_wr_burst_data_req  		),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      		(ch3_wr_burst_data      		),
/*	input 						*/	.wr_burst_finish    		(ch3_wr_burst_finish    		)
);
end
end else begin
assign	ch3_wr_burst_req		= 1'b0;
assign	ch3_wr_burst_len		= 10'd0;
assign	ch3_wr_burst_addr		= {ADDR_BITS{1'b0}};
assign	ch3_wr_burst_data		= 64'd0;
end
endgenerate
generate
if(WRITE_PORTS[4] == 1'b1 )begin:WR_PORT_BLOCK_4
//--- vin port 4---
if(WR_MODE[4] == 1'b0)begin
vin_process_discontinuous #(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS),
	.DSIZE				(W4_SIZE),
	.FIFO_DEPTH			(256),
	.DETAL				(W4_DELTA		),
	.FLIPPING			(W4_FLIPPING	)
)vin_process_inst4(
/*	input						*/	.pclk				(w4_clk					),
/*	input						*/	.prst_n             (w4_rst_n				),
/*	input						*/	.vsync              (w4_vsync   			),
/*	input						*/	.de                 (w4_de      			),
/*	output						*/	.wait_for_data		(w4_wait_for_data       ),
/*	input [DSIZE-1:0]			*/	.indata             (w4_indata  			),
/*	input [ADDR_BITS-1:0]		*/	.baseaddr           (w4_baseaddr			),
/*	input [11:0]				*/	.video_width		(w4_video_width   		),
/*	input [11:0]				*/	.video_height		(w4_video_height  		),
	//-- mem interface
/*	input						*/	.mem_clk    		(phy_clk         		),
/*	input						*/	.mem_rst_n          (mem_rst_n              ),
/*	output 						*/	.wr_burst_req       (ch4_wr_burst_req       ),
/*	output[9:0] 				*/	.wr_burst_len       (ch4_wr_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      (ch4_wr_burst_addr      ),
/*	input 						*/	.wr_burst_data_req  (ch4_wr_burst_data_req  ),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      (ch4_wr_burst_data      ),
/*	input 						*/	.wr_burst_finish    (ch4_wr_burst_finish    )
);
end else begin
in_stream_process #(
	.MEM_DATA_BITS 		(64				),
	.ADDR_BITS			(ADDR_BITS      ),
	.DSIZE				(W4_SIZE        ),
	.FIFO_DEPTH			(256            )
)in_stream_process_inst4(
/*	input						*/	.stream_clk					(w4_stream_clk					),
/*	input						*/	.stream_rst_n               (w4_stream_rst_n                ),
/*	input						*/	.stream_in_sof              (w4_stream_in_sof               ),
/*	input						*/	.stream_in_vld              (w4_stream_in_vld               ),
/*	output						*/	.stream_out_wait_for_data   (w4_stream_out_wait_for_data    ),
/*	input [DSIZE-1:0]			*/	.stream_in_data             (w4_stream_in_data              ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr         (w4_stream_in_baseaddr          ),
/*	input [23:0]				*/	.stream_in_length           (w4_stream_in_length            ),
/*	//-- mem interface          */
/*	input						*/	.mem_clk    				(phy_clk         				),
/*	input						*/	.mem_rst_n          		(mem_rst_n              		),
/*	output 						*/	.wr_burst_req       		(ch4_wr_burst_req       		),
/*	output[9:0] 				*/	.wr_burst_len       		(ch4_wr_burst_len       		),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      		(ch4_wr_burst_addr      		),
/*	input 						*/	.wr_burst_data_req  		(ch4_wr_burst_data_req  		),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      		(ch4_wr_burst_data      		),
/*	input 						*/	.wr_burst_finish    		(ch4_wr_burst_finish    		)
);
end
end else begin
assign	ch4_wr_burst_req		= 1'b0;
assign	ch4_wr_burst_len		= 10'd0;
assign	ch4_wr_burst_addr		= {ADDR_BITS{1'b0}};
assign	ch4_wr_burst_data		= 64'd0;
end
endgenerate
generate
if(WRITE_PORTS[5] == 1'b1 )begin:WR_PORT_BLOCK_5
//--- vin port 5---
if(WR_MODE[5] == 1'b0)begin
vin_process_discontinuous #(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS),
	.DSIZE				(W5_SIZE),
	.FIFO_DEPTH			(256),
	.DETAL				(W5_DELTA		),
	.FLIPPING			(W5_FLIPPING	)
)vin_process_inst5(
/*	input						*/	.pclk				(w5_clk					),
/*	input						*/	.prst_n             (w5_rst_n				),
/*	input						*/	.vsync              (w5_vsync   			),
/*	input						*/	.de                 (w5_de      			),
/*	output						*/	.wait_for_data		(w5_wait_for_data       ),
/*	input [DSIZE-1:0]			*/	.indata             (w5_indata  			),
/*	input [ADDR_BITS-1:0]		*/	.baseaddr           (w5_baseaddr			),
/*	input [11:0]				*/	.video_width		(w5_video_width   		),
/*	input [11:0]				*/	.video_height		(w5_video_height  		),
	//-- mem interface
/*	input						*/	.mem_clk    		(phy_clk         		),
/*	input						*/	.mem_rst_n          (mem_rst_n              ),
/*	output 						*/	.wr_burst_req       (ch5_wr_burst_req       ),
/*	output[9:0] 				*/	.wr_burst_len       (ch5_wr_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      (ch5_wr_burst_addr      ),
/*	input 						*/	.wr_burst_data_req  (ch5_wr_burst_data_req  ),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      (ch5_wr_burst_data      ),
/*	input 						*/	.wr_burst_finish    (ch5_wr_burst_finish    )
);
end else begin
in_stream_process #(
	.MEM_DATA_BITS 		(64				),
	.ADDR_BITS			(ADDR_BITS      ),
	.DSIZE				(W5_SIZE        ),
	.FIFO_DEPTH			(256            )
)in_stream_process_inst5(
/*	input						*/	.stream_clk					(w5_stream_clk					),
/*	input						*/	.stream_rst_n               (w5_stream_rst_n                ),
/*	input						*/	.stream_in_sof              (w5_stream_in_sof               ),
/*	input						*/	.stream_in_vld              (w5_stream_in_vld               ),
/*	output						*/	.stream_out_wait_for_data   (w5_stream_out_wait_for_data    ),
/*	input [DSIZE-1:0]			*/	.stream_in_data             (w5_stream_in_data              ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr         (w5_stream_in_baseaddr          ),
/*	input [23:0]				*/	.stream_in_length           (w5_stream_in_length            ),
/*	//-- mem interface          */
/*	input						*/	.mem_clk    				(phy_clk         				),
/*	input						*/	.mem_rst_n          		(mem_rst_n              		),
/*	output 						*/	.wr_burst_req       		(ch5_wr_burst_req       		),
/*	output[9:0] 				*/	.wr_burst_len       		(ch5_wr_burst_len       		),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      		(ch5_wr_burst_addr      		),
/*	input 						*/	.wr_burst_data_req  		(ch5_wr_burst_data_req  		),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      		(ch5_wr_burst_data      		),
/*	input 						*/	.wr_burst_finish    		(ch5_wr_burst_finish    		)
);
end
end else begin
assign	ch5_wr_burst_req		= 1'b0;
assign	ch5_wr_burst_len		= 10'd0;
assign	ch5_wr_burst_addr		= {ADDR_BITS{1'b0}};
assign	ch5_wr_burst_data		= 64'd0;
end
endgenerate
generate
if(WRITE_PORTS[6] == 1'b1 )begin:WR_PORT_BLOCK_6
//--- vin port 6---
if(WR_MODE[6] == 1'b0)begin
vin_process_discontinuous #(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS),
	.DSIZE				(W6_SIZE),
	.FIFO_DEPTH			(512),  //<<< : 2016/5/6 下午3:44:51
	.DETAL				(W6_DELTA		),
	.FLIPPING			(W6_FLIPPING	)
)vin_process_inst6(
/*	input						*/	.pclk				(w6_clk					),
/*	input						*/	.prst_n             (w6_rst_n				),
/*	input						*/	.vsync              (w6_vsync   			),
/*	input						*/	.de                 (w6_de      			),
/*	output						*/	.wait_for_data		(w6_wait_for_data       ),
/*	input [DSIZE-1:0]			*/	.indata             (w6_indata  			),
/*	input [ADDR_BITS-1:0]		*/	.baseaddr           (w6_baseaddr			),
/*	input [11:0]				*/	.video_width		(w6_video_width   		),
/*	input [11:0]				*/	.video_height		(w6_video_height  		),
	//-- mem interface
/*	input						*/	.mem_clk    		(phy_clk         		),
/*	input						*/	.mem_rst_n          (mem_rst_n              ),
/*	output 						*/	.wr_burst_req       (ch6_wr_burst_req       ),
/*	output[9:0] 				*/	.wr_burst_len       (ch6_wr_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      (ch6_wr_burst_addr      ),
/*	input 						*/	.wr_burst_data_req  (ch6_wr_burst_data_req  ),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      (ch6_wr_burst_data      ),
/*	input 						*/	.wr_burst_finish    (ch6_wr_burst_finish    )
);
end else begin
in_stream_process #(
	.MEM_DATA_BITS 		(64				),
	.ADDR_BITS			(ADDR_BITS      ),
	.DSIZE				(W6_SIZE        ),
	.FIFO_DEPTH			(256            )
)in_stream_process_inst6(
/*	input						*/	.stream_clk					(w6_stream_clk					),
/*	input						*/	.stream_rst_n               (w6_stream_rst_n                ),
/*	input						*/	.stream_in_sof              (w6_stream_in_sof               ),
/*	input						*/	.stream_in_vld              (w6_stream_in_vld               ),
/*	output						*/	.stream_out_wait_for_data   (w6_stream_out_wait_for_data    ),
/*	input [DSIZE-1:0]			*/	.stream_in_data             (w6_stream_in_data              ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr         (w6_stream_in_baseaddr          ),
/*	input [23:0]				*/	.stream_in_length           (w6_stream_in_length            ),
/*	//-- mem interface          */
/*	input						*/	.mem_clk    				(phy_clk         				),
/*	input						*/	.mem_rst_n          		(mem_rst_n              		),
/*	output 						*/	.wr_burst_req       		(ch6_wr_burst_req       		),
/*	output[9:0] 				*/	.wr_burst_len       		(ch6_wr_burst_len       		),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      		(ch6_wr_burst_addr      		),
/*	input 						*/	.wr_burst_data_req  		(ch6_wr_burst_data_req  		),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      		(ch6_wr_burst_data      		),
/*	input 						*/	.wr_burst_finish    		(ch6_wr_burst_finish    		)
);
end
end else begin
assign	ch6_wr_burst_req		= 1'b0;
assign	ch6_wr_burst_len		= 10'd0;
assign	ch6_wr_burst_addr		= {ADDR_BITS{1'b0}};
assign	ch6_wr_burst_data		= 64'd0;
end
endgenerate
generate
if(WRITE_PORTS[7] == 1'b1 )begin:WR_PORT_BLOCK_7
//--- vin port 7---
if(WR_MODE[7] == 1'b0)begin
vin_process_discontinuous #(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS),
	.DSIZE				(W7_SIZE),
	.FIFO_DEPTH			(256),
	.DETAL				(W7_DELTA		),
	.FLIPPING			(W7_FLIPPING	)
)vin_process_inst7(
/*	input						*/	.pclk				(w7_clk					),
/*	input						*/	.prst_n             (w7_rst_n				),
/*	input						*/	.vsync              (w7_vsync   			),
/*	input						*/	.de                 (w7_de      			),
/*	output						*/	.wait_for_data		(w7_wait_for_data       ),
/*	input [DSIZE-1:0]			*/	.indata             (w7_indata  			),
/*	input [ADDR_BITS-1:0]		*/	.baseaddr           (w7_baseaddr			),
/*	input [11:0]				*/	.video_width		(w7_video_width   		),
/*	input [11:0]				*/	.video_height		(w7_video_height  		),
	//-- mem interface
/*	input						*/	.mem_clk    		(phy_clk         		),
/*	input						*/	.mem_rst_n          (mem_rst_n              ),
/*	output 						*/	.wr_burst_req       (ch7_wr_burst_req       ),
/*	output[9:0] 				*/	.wr_burst_len       (ch7_wr_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      (ch7_wr_burst_addr      ),
/*	input 						*/	.wr_burst_data_req  (ch7_wr_burst_data_req  ),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      (ch7_wr_burst_data      ),
/*	input 						*/	.wr_burst_finish    (ch7_wr_burst_finish    )
);
end else begin
in_stream_process #(
	.MEM_DATA_BITS 		(64				),
	.ADDR_BITS			(ADDR_BITS      ),
	.DSIZE				(W0_SIZE        ),
	.FIFO_DEPTH			(256            )
)in_stream_process_inst7(
/*	input						*/	.stream_clk					(w7_stream_clk					),
/*	input						*/	.stream_rst_n               (w7_stream_rst_n                ),
/*	input						*/	.stream_in_sof              (w7_stream_in_sof               ),
/*	input						*/	.stream_in_vld              (w7_stream_in_vld               ),
/*	output						*/	.stream_out_wait_for_data   (w7_stream_out_wait_for_data    ),
/*	input [DSIZE-1:0]			*/	.stream_in_data             (w7_stream_in_data              ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr         (w7_stream_in_baseaddr          ),
/*	input [23:0]				*/	.stream_in_length           (w7_stream_in_length            ),
/*	//-- mem interface          */
/*	input						*/	.mem_clk    				(phy_clk         				),
/*	input						*/	.mem_rst_n          		(mem_rst_n              		),
/*	output 						*/	.wr_burst_req       		(ch7_wr_burst_req       		),
/*	output[9:0] 				*/	.wr_burst_len       		(ch7_wr_burst_len       		),
/*	output[ADDR_BITS-1:0] 		*/	.wr_burst_addr      		(ch7_wr_burst_addr      		),
/*	input 						*/	.wr_burst_data_req  		(ch7_wr_burst_data_req  		),
/*	output[MEM_DATA_BITS - 1:0]	*/	.wr_burst_data      		(ch7_wr_burst_data      		),
/*	input 						*/	.wr_burst_finish    		(ch7_wr_burst_finish    		)
);
end
end else begin
assign	ch7_wr_burst_req		= 1'b0;
assign	ch7_wr_burst_len		= 10'd0;
assign	ch7_wr_burst_addr		= {ADDR_BITS{1'b0}};
assign	ch7_wr_burst_data		= 64'd0;
end
endgenerate

generate
if(READ_PORTS[0] == 1'b1)begin:RD_PORT_BLOCK_0
//--vout port 0 ----
if(RD_MODE[0]==1'b0)begin
vout_process_discontinuous #(
	.MEM_DATA_BITS 				(64         ),
	.ADDR_BITS					(25         ),
	.DSIZE						(R0_SIZE    ),
	.FIFO_DEPTH					(256        ),
	.DETAL						(R0_DELTA	)
)vout_process_inst0(
/*	input						*/	.pclk   					(r0_clk                     ),
/*	input						*/	.prst_n                     (r0_rst_n                   ),
/*	input						*/	.invsync                    (r0_vsync                   ),
/*	input						*/	.inhsync                    (r0_hsync                   ),
/*	input						*/	.inde                       (r0_de                      ),
/*	output						*/	.outvsync                   (r0_outvsync                ),
/*	output						*/	.outhsync                   (r0_outhsync                ),
/*	output						*/	.outde						(r0_outde                   ),
/*	output						*/	.out_not_ready				(r0_out_not_ready			),
/*	output[DSIZE-1:0]			*/	.outdata                    (r0_outdata                 ),
/*	output						*/	.outdata_vld				(r0_data_vld				),
/*	input [11:0]				*/	.video_width				(r0_video_width             ),
/*	input [11:0]				*/	.video_height               (r0_video_height			),
/*	input [ADDR_BITS-1:0]		*/	.video_baseaddr             (r0_baseaddr				),
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch0_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch0_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch0_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch0_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch0_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch0_rd_burst_finish		)
);
end else begin
out_stream_process #(
	.MEM_DATA_BITS 		(64			),
	.ADDR_BITS			(ADDR_BITS	),
	.DSIZE				(R0_SIZE	),
	.FIFO_DEPTH			(256		)
)out_stream_process_inst0(
/*	input						*/	.stream_clk					(r0_stream_clk  			),
/*	input						*/	.stream_rst_n           	(r0_stream_rst_n            ),
/*	input						*/	.stream_in_request      	(r0_stream_in_request       ),
/*	input						*/	.stream_in_read         	(r0_stream_in_read          ),
/*	output						*/	.stream_out_sof         	(r0_stream_out_sof          ),
/*	output						*/	.stream_out_read_sync   	(r0_stream_out_read_sync    ),
/*	output						*/	.stream_out_not_ready   	(r0_stream_out_not_ready    ),
/*	output[DSIZE-1:0]			*/	.stream_out_data        	(r0_stream_out_data         ),
/*	output						*/	.stream_out_vld         	(r0_stream_out_vld          ),
/*	input [23:0]				*/	.stream_in_length       	(r0_stream_in_length        ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr     	(r0_stream_in_baseaddr      ),
/*	output						*/	.stream_out_req_respond		(r0_stream_out_req_respond	),	//++++ A2
/*	output						*/	.stream_out_req_waiting		(r0_stream_out_req_waiting	),	//++++ A2
/*	output						*/	.stream_out_req_proc_fsh	(r0_stream_out_req_proc_fsh	),	//++++ A2
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch0_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch0_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch0_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch0_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch0_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch0_rd_burst_finish		)
);
end
end else begin
assign	ch0_rd_burst_req		= 1'b0;
assign	ch0_rd_burst_len		= 10'd0;
assign	ch0_rd_burst_addr		= {ADDR_BITS{1'b0}};
end
endgenerate

generate
if(READ_PORTS[1] == 1'b1 )begin:RD_PORT_BLOCK_1
//--vout port 1 ----
if(RD_MODE[1] == 1'b0)begin
vout_process_discontinuous #(
	.MEM_DATA_BITS 				(64         ),
	.ADDR_BITS					(25         ),
	.DSIZE						(R1_SIZE    ),
	.FIFO_DEPTH					(256        ),
	.DETAL						(R1_DELTA	)
)vout_process_inst1(
/*	input						*/	.pclk   					(r1_clk                     ),
/*	input						*/	.prst_n                     (r1_rst_n                   ),
/*	input						*/	.invsync                    (r1_vsync                   ),
/*	input						*/	.inhsync                    (r1_hsync                   ),
/*	input						*/	.inde                       (r1_de                      ),
/*	output						*/	.outvsync                   (r1_outvsync                ),
/*	output						*/	.outhsync                   (r1_outhsync                ),
/*	output						*/	.outde						(r1_outde                   ),
/*	output						*/	.out_not_ready				(r1_out_not_ready			),
/*	output[DSIZE-1:0]			*/	.outdata                    (r1_outdata                 ),
/*	output						*/	.outdata_vld				(r1_data_vld				),
/*	input [11:0]				*/	.video_width				(r1_video_width             ),
/*	input [11:0]				*/	.video_height               (r1_video_height			),
/*	input [ADDR_BITS-1:0]		*/	.video_baseaddr             (r1_baseaddr				),
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch1_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch1_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch1_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch1_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch1_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch1_rd_burst_finish		)
);
end else begin
out_stream_process #(
	.MEM_DATA_BITS 		(64			),
	.ADDR_BITS			(ADDR_BITS	),
	.DSIZE				(R1_SIZE	),
	.FIFO_DEPTH			(256		)
)out_stream_process_inst1(
/*	input						*/	.stream_clk					(r1_stream_clk  			),
/*	input						*/	.stream_rst_n           	(r1_stream_rst_n            ),
/*	input						*/	.stream_in_request      	(r1_stream_in_request       ),
/*	input						*/	.stream_in_read         	(r1_stream_in_read          ),
/*	output						*/	.stream_out_sof         	(r1_stream_out_sof          ),
/*	output						*/	.stream_out_read_sync   	(r1_stream_out_read_sync    ),
/*	output						*/	.stream_out_not_ready   	(r1_stream_out_not_ready    ),
/*	output[DSIZE-1:0]			*/	.stream_out_data        	(r1_stream_out_data         ),
/*	output						*/	.stream_out_vld         	(r1_stream_out_vld          ),
/*	input [23:0]				*/	.stream_in_length       	(r1_stream_in_length        ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr     	(r1_stream_in_baseaddr      ),
/*	output						*/	.stream_out_req_respond		(r1_stream_out_req_respond	),	//++++ A2
/*	output						*/	.stream_out_req_waiting		(r1_stream_out_req_waiting	),	//++++ A2
/*	output						*/	.stream_out_req_proc_fsh	(r1_stream_out_req_proc_fsh	),	//++++ A2
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch1_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch1_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch1_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch1_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch1_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch1_rd_burst_finish		)
);
end
end else begin
assign	ch1_rd_burst_req		= 1'b0;
assign	ch1_rd_burst_len		= 10'd0;
assign	ch1_rd_burst_addr		= {ADDR_BITS{1'b0}};
end
endgenerate
generate
if(READ_PORTS[2]==1'b1 )begin:RD_PORT_BLOCK_2
//--vout port 2 ----
if(RD_MODE[2]==1'b0)begin
vout_process_discontinuous #(
	.MEM_DATA_BITS 				(64         ),
	.ADDR_BITS					(25         ),
	.DSIZE						(R2_SIZE    ),
	.FIFO_DEPTH					(256        ),
	.DETAL						(R2_DELTA	)
)vout_process_inst2(
/*	input						*/	.pclk   					(r2_clk                     ),
/*	input						*/	.prst_n                     (r2_rst_n                   ),
/*	input						*/	.invsync                    (r2_vsync                   ),
/*	input						*/	.inhsync                    (r2_hsync                   ),
/*	input						*/	.inde                       (r2_de                      ),
/*	output						*/	.outvsync                   (r2_outvsync                ),
/*	output						*/	.outhsync                   (r2_outhsync                ),
/*	output						*/	.outde						(r2_outde                   ),
/*	output						*/	.out_not_ready				(r2_out_not_ready			),
/*	output[DSIZE-1:0]			*/	.outdata                    (r2_outdata                 ),
/*	output						*/	.outdata_vld				(r2_data_vld				),
/*	input [11:0]				*/	.video_width				(r2_video_width             ),
/*	input [11:0]				*/	.video_height               (r2_video_height			),
/*	input [ADDR_BITS-1:0]		*/	.video_baseaddr             (r2_baseaddr				),
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch2_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch2_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch2_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch2_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch2_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch2_rd_burst_finish		)
);
end else begin
out_stream_process #(
	.MEM_DATA_BITS 		(64			),
	.ADDR_BITS			(ADDR_BITS	),
	.DSIZE				(R2_SIZE	),
	.FIFO_DEPTH			(256		)
)out_stream_process_inst2(
/*	input						*/	.stream_clk					(r2_stream_clk  			),
/*	input						*/	.stream_rst_n           	(r2_stream_rst_n            ),
/*	input						*/	.stream_in_request      	(r2_stream_in_request       ),
/*	input						*/	.stream_in_read         	(r2_stream_in_read          ),
/*	output						*/	.stream_out_sof         	(r2_stream_out_sof          ),
/*	output						*/	.stream_out_read_sync   	(r2_stream_out_read_sync    ),
/*	output						*/	.stream_out_not_ready   	(r2_stream_out_not_ready    ),
/*	output[DSIZE-1:0]			*/	.stream_out_data        	(r2_stream_out_data         ),
/*	output						*/	.stream_out_vld         	(r2_stream_out_vld          ),
/*	input [23:0]				*/	.stream_in_length       	(r2_stream_in_length        ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr     	(r2_stream_in_baseaddr      ),
/*	output						*/	.stream_out_req_respond		(r2_stream_out_req_respond	),	//++++ A2
/*	output						*/	.stream_out_req_waiting		(r2_stream_out_req_waiting	),	//++++ A2
/*	output						*/	.stream_out_req_proc_fsh	(r2_stream_out_req_proc_fsh	),	//++++ A2
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch2_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch2_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch2_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch2_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch2_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch2_rd_burst_finish		)
);
end
end else begin
assign	ch2_rd_burst_req		= 1'b0;
assign	ch2_rd_burst_len		= 10'd0;
assign	ch2_rd_burst_addr		= {ADDR_BITS{1'b0}};
end
endgenerate
generate
if(READ_PORTS[3]==1'b1 )begin:RD_PORT_BLOCK_3
//--vout port 3 ----
if(RD_MODE[3]==1'b0)begin
vout_process_discontinuous #(
	.MEM_DATA_BITS 				(64         ),
	.ADDR_BITS					(25         ),
	.DSIZE						(R3_SIZE    ),
	.FIFO_DEPTH					(256        ),
	.DETAL						(R3_DELTA	)
)vout_process_inst3(
/*	input						*/	.pclk   					(r3_clk                     ),
/*	input						*/	.prst_n                     (r3_rst_n                   ),
/*	input						*/	.invsync                    (r3_vsync                   ),
/*	input						*/	.inhsync                    (r3_hsync                   ),
/*	input						*/	.inde                       (r3_de                      ),
/*	output						*/	.outvsync                   (r3_outvsync                ),
/*	output						*/	.outhsync                   (r3_outhsync                ),
/*	output						*/	.outde						(r3_outde                   ),
/*	output						*/	.out_not_ready				(r3_out_not_ready			),
/*	output[DSIZE-1:0]			*/	.outdata                    (r3_outdata                 ),
/*	output						*/	.outdata_vld				(r3_data_vld				),
/*	input [11:0]				*/	.video_width				(r3_video_width             ),
/*	input [11:0]				*/	.video_height               (r3_video_height			),
/*	input [ADDR_BITS-1:0]		*/	.video_baseaddr             (r3_baseaddr				),
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch3_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch3_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch3_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch3_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch3_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch3_rd_burst_finish		)
);
end else begin
out_stream_process #(
	.MEM_DATA_BITS 		(64			),
	.ADDR_BITS			(ADDR_BITS	),
	.DSIZE				(R3_SIZE	),
	.FIFO_DEPTH			(256		)
)out_stream_process_inst3(
/*	input						*/	.stream_clk					(r3_stream_clk  			),
/*	input						*/	.stream_rst_n           	(r3_stream_rst_n            ),
/*	input						*/	.stream_in_request      	(r3_stream_in_request       ),
/*	input						*/	.stream_in_read         	(r3_stream_in_read          ),
/*	output						*/	.stream_out_sof         	(r3_stream_out_sof          ),
/*	output						*/	.stream_out_read_sync   	(r3_stream_out_read_sync    ),
/*	output						*/	.stream_out_not_ready   	(r3_stream_out_not_ready    ),
/*	output[DSIZE-1:0]			*/	.stream_out_data        	(r3_stream_out_data         ),
/*	output						*/	.stream_out_vld         	(r3_stream_out_vld          ),
/*	input [23:0]				*/	.stream_in_length       	(r3_stream_in_length        ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr     	(r3_stream_in_baseaddr      ),
/*	output						*/	.stream_out_req_respond		(r3_stream_out_req_respond	),	//++++ A2
/*	output						*/	.stream_out_req_waiting		(r3_stream_out_req_waiting	),	//++++ A2
/*	output						*/	.stream_out_req_proc_fsh	(r3_stream_out_req_proc_fsh	),	//++++ A2
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch3_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch3_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch3_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch3_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch3_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch3_rd_burst_finish		)
);
end
end else begin
assign	ch3_rd_burst_req		= 1'b0;
assign	ch3_rd_burst_len		= 10'd0;
assign	ch3_rd_burst_addr		= {ADDR_BITS{1'b0}};
end
endgenerate
generate
if(READ_PORTS[4]==1'b1 )begin:RD_PORT_BLOCK_4
//--vout port 4 ----
if(RD_MODE[4]==1'b0)begin
vout_process_discontinuous #(
	.MEM_DATA_BITS 				(64         ),
	.ADDR_BITS					(25         ),
	.DSIZE						(R4_SIZE    ),
	.FIFO_DEPTH					(256        ),
	.DETAL						(R4_DELTA	)
)vout_process_inst4(
/*	input						*/	.pclk   					(r4_clk                     ),
/*	input						*/	.prst_n                     (r4_rst_n                   ),
/*	input						*/	.invsync                    (r4_vsync                   ),
/*	input						*/	.inhsync                    (r4_hsync                   ),
/*	input						*/	.inde                       (r4_de                      ),
/*	output						*/	.outvsync                   (r4_outvsync                ),
/*	output						*/	.outhsync                   (r4_outhsync                ),
/*	output						*/	.outde						(r4_outde                   ),
/*	output						*/	.out_not_ready				(r4_out_not_ready			),
/*	output[DSIZE-1:0]			*/	.outdata                    (r4_outdata                 ),
/*	output						*/	.outdata_vld				(r4_data_vld				),
/*	input [11:0]				*/	.video_width				(r4_video_width             ),
/*	input [11:0]				*/	.video_height               (r4_video_height			),
/*	input [ADDR_BITS-1:0]		*/	.video_baseaddr             (r4_baseaddr				),
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch4_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch4_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch4_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch4_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch4_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch4_rd_burst_finish		)
);
end else begin
out_stream_process #(
	.MEM_DATA_BITS 		(64			),
	.ADDR_BITS			(ADDR_BITS	),
	.DSIZE				(R4_SIZE	),
	.FIFO_DEPTH			(256		)
)out_stream_process_inst4(
/*	input						*/	.stream_clk					(r4_stream_clk  			),
/*	input						*/	.stream_rst_n           	(r4_stream_rst_n            ),
/*	input						*/	.stream_in_request      	(r4_stream_in_request       ),
/*	input						*/	.stream_in_read         	(r4_stream_in_read          ),
/*	output						*/	.stream_out_sof         	(r4_stream_out_sof          ),
/*	output						*/	.stream_out_read_sync   	(r4_stream_out_read_sync    ),
/*	output						*/	.stream_out_not_ready   	(r4_stream_out_not_ready    ),
/*	output[DSIZE-1:0]			*/	.stream_out_data        	(r4_stream_out_data         ),
/*	output						*/	.stream_out_vld         	(r4_stream_out_vld          ),
/*	input [23:0]				*/	.stream_in_length       	(r4_stream_in_length        ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr     	(r4_stream_in_baseaddr      ),
/*	output						*/	.stream_out_req_respond		(r4_stream_out_req_respond	),	//++++ A2
/*	output						*/	.stream_out_req_waiting		(r4_stream_out_req_waiting	),	//++++ A2
/*	output						*/	.stream_out_req_proc_fsh	(r4_stream_out_req_proc_fsh	),	//++++ A2
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch4_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch4_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch4_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch4_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch4_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch4_rd_burst_finish		)
);
end
end else begin
assign	ch4_rd_burst_req		= 1'b0;
assign	ch4_rd_burst_len		= 10'd0;
assign	ch4_rd_burst_addr		= {ADDR_BITS{1'b0}};
end
endgenerate
generate
if(READ_PORTS[5]==1'b1)begin:RD_PORT_BLOCK_5
//--vout port 5 ----
if(RD_MODE[5]==1'b0)begin
vout_process_discontinuous #(
	.MEM_DATA_BITS 				(64         ),
	.ADDR_BITS					(25         ),
	.DSIZE						(R5_SIZE    ),
	.FIFO_DEPTH					(256        ),
	.DETAL						(R5_DELTA	)
)vout_process_inst5(
/*	input						*/	.pclk   					(r5_clk                     ),
/*	input						*/	.prst_n                     (r5_rst_n                   ),
/*	input						*/	.invsync                    (r5_vsync                   ),
/*	input						*/	.inhsync                    (r5_hsync                   ),
/*	input						*/	.inde                       (r5_de                      ),
/*	output						*/	.outvsync                   (r5_outvsync                ),
/*	output						*/	.outhsync                   (r5_outhsync                ),
/*	output						*/	.outde						(r5_outde                   ),
/*	output						*/	.out_not_ready				(r5_out_not_ready			),
/*	output[DSIZE-1:0]			*/	.outdata                    (r5_outdata                 ),
/*	output						*/	.outdata_vld				(r5_data_vld				),
/*	input [11:0]				*/	.video_width				(r5_video_width             ),
/*	input [11:0]				*/	.video_height               (r5_video_height			),
/*	input [ADDR_BITS-1:0]		*/	.video_baseaddr             (r5_baseaddr				),
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch5_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch5_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch5_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch5_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch5_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch5_rd_burst_finish		)
);
end else begin
out_stream_process #(
	.MEM_DATA_BITS 		(64			),
	.ADDR_BITS			(ADDR_BITS	),
	.DSIZE				(R5_SIZE	),
	.FIFO_DEPTH			(256		)
)out_stream_process_inst5(
/*	input						*/	.stream_clk					(r5_stream_clk  			),
/*	input						*/	.stream_rst_n           	(r5_stream_rst_n            ),
/*	input						*/	.stream_in_request      	(r5_stream_in_request       ),
/*	input						*/	.stream_in_read         	(r5_stream_in_read          ),
/*	output						*/	.stream_out_sof         	(r5_stream_out_sof          ),
/*	output						*/	.stream_out_read_sync   	(r5_stream_out_read_sync    ),
/*	output						*/	.stream_out_not_ready   	(r5_stream_out_not_ready    ),
/*	output[DSIZE-1:0]			*/	.stream_out_data        	(r5_stream_out_data         ),
/*	output						*/	.stream_out_vld         	(r5_stream_out_vld          ),
/*	input [23:0]				*/	.stream_in_length       	(r5_stream_in_length        ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr     	(r5_stream_in_baseaddr      ),
/*	output						*/	.stream_out_req_respond		(r5_stream_out_req_respond	),	//++++ A2
/*	output						*/	.stream_out_req_waiting		(r5_stream_out_req_waiting	),	//++++ A2
/*	output						*/	.stream_out_req_proc_fsh	(r5_stream_out_req_proc_fsh	),	//++++ A2
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch5_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch5_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch5_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch5_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch5_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch5_rd_burst_finish		)
);
end
end else begin
assign	ch5_rd_burst_req		= 1'b0;
assign	ch5_rd_burst_len		= 10'd0;
assign	ch5_rd_burst_addr		= {ADDR_BITS{1'b0}};
end
endgenerate
generate
if(READ_PORTS[6]==1'b1 )begin:RD_PORT_BLOCK_6
//--vout port 6 ----
if(RD_MODE[6]==1'b0)begin
vout_process_discontinuous #(
	.MEM_DATA_BITS 				(64         ),
	.ADDR_BITS					(25         ),
	.DSIZE						(R6_SIZE    ),
	.FIFO_DEPTH					(256        ),
	.DETAL						(R6_DELTA	)
)vout_process_inst6(
/*	input						*/	.pclk   					(r6_clk                     ),
/*	input						*/	.prst_n                     (r6_rst_n                   ),
/*	input						*/	.invsync                    (r6_vsync                   ),
/*	input						*/	.inhsync                    (r6_hsync                   ),
/*	input						*/	.inde                       (r6_de                      ),
/*	output						*/	.outvsync                   (r6_outvsync                ),
/*	output						*/	.outhsync                   (r6_outhsync                ),
/*	output						*/	.outde						(r6_outde                   ),
/*	output						*/	.out_not_ready				(r6_out_not_ready			),
/*	output[DSIZE-1:0]			*/	.outdata                    (r6_outdata                 ),
/*	output						*/	.outdata_vld				(r6_data_vld				),
/*	input [11:0]				*/	.video_width				(r6_video_width             ),
/*	input [11:0]				*/	.video_height               (r6_video_height			),
/*	input [ADDR_BITS-1:0]		*/	.video_baseaddr             (r6_baseaddr				),
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch6_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch6_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch6_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch6_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch6_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch6_rd_burst_finish		)
);
end else begin
out_stream_process #(
	.MEM_DATA_BITS 		(64			),
	.ADDR_BITS			(ADDR_BITS	),
	.DSIZE				(R6_SIZE	),
	.FIFO_DEPTH			(256		)
)out_stream_process_inst6(
/*	input						*/	.stream_clk					(r6_stream_clk  			),
/*	input						*/	.stream_rst_n           	(r6_stream_rst_n            ),
/*	input						*/	.stream_in_request      	(r6_stream_in_request       ),
/*	input						*/	.stream_in_read         	(r6_stream_in_read          ),
/*	output						*/	.stream_out_sof         	(r6_stream_out_sof          ),
/*	output						*/	.stream_out_read_sync   	(r6_stream_out_read_sync    ),
/*	output						*/	.stream_out_not_ready   	(r6_stream_out_not_ready    ),
/*	output[DSIZE-1:0]			*/	.stream_out_data        	(r6_stream_out_data         ),
/*	output						*/	.stream_out_vld         	(r6_stream_out_vld          ),
/*	input [23:0]				*/	.stream_in_length       	(r6_stream_in_length        ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr     	(r6_stream_in_baseaddr      ),
/*	output						*/	.stream_out_req_respond		(r6_stream_out_req_respond	),	//++++ A2
/*	output						*/	.stream_out_req_waiting		(r6_stream_out_req_waiting	),	//++++ A2
/*	output						*/	.stream_out_req_proc_fsh	(r6_stream_out_req_proc_fsh	),	//++++ A2
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch6_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch6_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch6_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch6_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch6_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch6_rd_burst_finish		)
);
end
end else begin
assign	ch6_rd_burst_req		= 1'b0;
assign	ch6_rd_burst_len		= 10'd0;
assign	ch6_rd_burst_addr		= {ADDR_BITS{1'b0}};
end
endgenerate
generate
if(READ_PORTS[7]==1'b1 )begin:RD_PORT_BLOCK_7
//--vout port 7 ----
if(RD_MODE[7]==1'b0)begin
vout_process_discontinuous #(
	.MEM_DATA_BITS 				(64         ),
	.ADDR_BITS					(25         ),
	.DSIZE						(R7_SIZE    ),
	.FIFO_DEPTH					(256        ),
	.DETAL						(R7_DELTA	)
)vout_process_inst7(
/*	input						*/	.pclk   					(r7_clk                     ),
/*	input						*/	.prst_n                     (r7_rst_n                   ),
/*	input						*/	.invsync                    (r7_vsync                   ),
/*	input						*/	.inhsync                    (r7_hsync                   ),
/*	input						*/	.inde                       (r7_de                      ),
/*	output						*/	.outvsync                   (r7_outvsync                ),
/*	output						*/	.outhsync                   (r7_outhsync                ),
/*	output						*/	.outde						(r7_outde                   ),
/*	output						*/	.out_not_ready				(r7_out_not_ready			),
/*	output[DSIZE-1:0]			*/	.outdata                    (r7_outdata                 ),
/*	output						*/	.outdata_vld				(r7_data_vld				),
/*	input [11:0]				*/	.video_width				(r7_video_width             ),
/*	input [11:0]				*/	.video_height               (r7_video_height			),
/*	input [ADDR_BITS-1:0]		*/	.video_baseaddr             (r7_baseaddr				),
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch7_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch7_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch7_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch7_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch7_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch7_rd_burst_finish		)
);
end else begin
out_stream_process #(
	.MEM_DATA_BITS 		(64			),
	.ADDR_BITS			(ADDR_BITS	),
	.DSIZE				(R7_SIZE	),
	.FIFO_DEPTH			(256		)
)out_stream_process_inst7(
/*	input						*/	.stream_clk					(r7_stream_clk  			),
/*	input						*/	.stream_rst_n           	(r7_stream_rst_n            ),
/*	input						*/	.stream_in_request      	(r7_stream_in_request       ),
/*	input						*/	.stream_in_read         	(r7_stream_in_read          ),
/*	output						*/	.stream_out_sof         	(r7_stream_out_sof          ),
/*	output						*/	.stream_out_read_sync   	(r7_stream_out_read_sync    ),
/*	output						*/	.stream_out_not_ready   	(r7_stream_out_not_ready    ),
/*	output[DSIZE-1:0]			*/	.stream_out_data        	(r7_stream_out_data         ),
/*	output						*/	.stream_out_vld         	(r7_stream_out_vld          ),
/*	input [23:0]				*/	.stream_in_length       	(r7_stream_in_length        ),
/*	input [ADDR_BITS-1:0]		*/	.stream_in_baseaddr     	(r7_stream_in_baseaddr      ),
/*	output						*/	.stream_out_req_respond		(r7_stream_out_req_respond	),	//++++ A2
/*	output						*/	.stream_out_req_waiting		(r7_stream_out_req_waiting	),	//++++ A2
/*	output						*/	.stream_out_req_proc_fsh	(r7_stream_out_req_proc_fsh	),	//++++ A2
	//-- ddr ---
/*	input						*/	.mem_clk  					(phy_clk                    ),
/*	input						*/	.mem_rst_n            		(mem_rst_n                  ),
/*	output 						*/	.rd_burst_req               (ch7_rd_burst_req           ),
/*	output[9:0] 				*/	.rd_burst_len               (ch7_rd_burst_len           ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (ch7_rd_burst_addr          ),
/*	input 						*/	.rd_burst_data_valid        (ch7_rd_burst_data_valid	),
/*	input[MEM_DATA_BITS - 1:0] 	*/	.rd_burst_data              (ch7_rd_burst_data          ),
/*	input 						*/	.rd_burst_finish            (ch7_rd_burst_finish		)
);
end
end else begin
assign	ch7_rd_burst_req		= 1'b0;
assign	ch7_rd_burst_len		= 10'd0;
assign	ch7_rd_burst_addr		= {ADDR_BITS{1'b0}};
end
endgenerate
mem_ctrl_verb
#(
	.MEM_DATA_BITS		(64),
	.ADDR_BITS			(ADDR_BITS)
)
mem_ctrl_m0(
	.rst_n						(rst_n),
	.source_clk					(sys_clk),
	.phy_clk					(phy_clk),
	.aux_half_rate_clk			(),
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
	.ch0_wr_burst_req			(ch0_wr_burst_req),
	.ch0_wr_burst_len			(ch0_wr_burst_len),
	.ch0_wr_burst_addr			(ch0_wr_burst_addr),
	.ch0_wr_burst_data_req		(ch0_wr_burst_data_req),
	.ch0_wr_burst_data			(ch0_wr_burst_data),
	.ch0_wr_burst_finish		(ch0_wr_burst_finish),

	.ch1_wr_burst_req			(ch1_wr_burst_req),
	.ch1_wr_burst_len			(ch1_wr_burst_len),
	.ch1_wr_burst_addr			(ch1_wr_burst_addr),
	.ch1_wr_burst_data_req		(ch1_wr_burst_data_req),
	.ch1_wr_burst_data			(ch1_wr_burst_data),
	.ch1_wr_burst_finish		(ch1_wr_burst_finish),

	.ch2_wr_burst_req			(ch2_wr_burst_req),
	.ch2_wr_burst_len			(ch2_wr_burst_len),
	.ch2_wr_burst_addr			(ch2_wr_burst_addr),
	.ch2_wr_burst_data_req		(ch2_wr_burst_data_req),
	.ch2_wr_burst_data			(ch2_wr_burst_data),
	.ch2_wr_burst_finish		(ch2_wr_burst_finish),

	.ch3_wr_burst_req			(ch3_wr_burst_req),
	.ch3_wr_burst_len			(ch3_wr_burst_len),
	.ch3_wr_burst_addr			(ch3_wr_burst_addr),
	.ch3_wr_burst_data_req		(ch3_wr_burst_data_req),
	.ch3_wr_burst_data			(ch3_wr_burst_data),
	.ch3_wr_burst_finish		(ch3_wr_burst_finish),

	.ch4_wr_burst_req			(ch4_wr_burst_req),
	.ch4_wr_burst_len			(ch4_wr_burst_len),
	.ch4_wr_burst_addr			(ch4_wr_burst_addr),
	.ch4_wr_burst_data_req		(ch4_wr_burst_data_req),
	.ch4_wr_burst_data			(ch4_wr_burst_data),
	.ch4_wr_burst_finish		(ch4_wr_burst_finish),

	.ch5_wr_burst_req			(ch5_wr_burst_req),
	.ch5_wr_burst_len			(ch5_wr_burst_len),
	.ch5_wr_burst_addr			(ch5_wr_burst_addr),
	.ch5_wr_burst_data_req		(ch5_wr_burst_data_req),
	.ch5_wr_burst_data			(ch5_wr_burst_data),
	.ch5_wr_burst_finish		(ch5_wr_burst_finish),

	.ch6_wr_burst_req			(ch6_wr_burst_req),
	.ch6_wr_burst_len			(ch6_wr_burst_len),
	.ch6_wr_burst_addr			(ch6_wr_burst_addr),
	.ch6_wr_burst_data_req		(ch6_wr_burst_data_req),
	.ch6_wr_burst_data			(ch6_wr_burst_data),
	.ch6_wr_burst_finish		(ch6_wr_burst_finish),

	.ch7_wr_burst_req			(ch7_wr_burst_req),
	.ch7_wr_burst_len			(ch7_wr_burst_len),
	.ch7_wr_burst_addr			(ch7_wr_burst_addr),
	.ch7_wr_burst_data_req		(ch7_wr_burst_data_req),
	.ch7_wr_burst_data			(ch7_wr_burst_data),
	.ch7_wr_burst_finish		(ch7_wr_burst_finish),

	/////////////////////////////////////
	.mem_cs_n					(mem_cs_n),
	.mem_cke					(mem_cke),
	.mem_addr					(mem_addr),
	.mem_ba						(mem_ba),
	.mem_ras_n					(mem_ras_n),
	.mem_cas_n					(mem_cas_n),
	.mem_we_n					(mem_we_n),
	.mem_clk					(mem_clk),
	.mem_clk_n					(mem_clk_n),
	.mem_dm						(mem_dm),
	.mem_dq						(mem_dq),
	.mem_dqs					(mem_dqs),
	.mem_odt					(mem_odt)
);



endmodule
