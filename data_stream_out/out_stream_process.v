/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
---------------------------------------------
Version: VREA.1.0                           |
	calu detal from line length             |
Version: VERA.2.0 : 2015/11/12 10:45:39     |
	create some useful signals for status   |
---::vout_process_discontinuous_A2::---------
Version: VERA.0.0 : 2015/12/11 9:50:04
creaded: 2015/6/4 14:55:19
madified:
***********************************************/
`timescale 1ns/1ps
module out_stream_process #(
	parameter		MEM_DATA_BITS 	= 64,
	parameter		ADDR_BITS		= 25,
	parameter		DSIZE			= 24,
	parameter		FIFO_DEPTH		= 256
)(
	input						stream_clk,
	input						stream_rst_n,
	input						stream_in_request,
	input						stream_in_read,
	output						stream_out_sof,
	output						stream_out_read_sync,
	output						stream_out_not_ready,
	output[DSIZE-1:0]			stream_out_data,
	output						stream_out_vld,
	input [23:0]				stream_in_length,
	input [ADDR_BITS-1:0]		stream_in_baseaddr,
	output						stream_out_req_respond,		//++++ A2
	output						stream_out_req_waiting,		//++++ A2
	output						stream_out_req_proc_fsh,	//++++ A2
	//-- ddr ---
	input						mem_clk,
	input						mem_rst_n,
	output 						rd_burst_req,
	output[9:0] 				rd_burst_len,
	output[ADDR_BITS-1:0] 		rd_burst_addr,
	input 						rd_burst_data_valid,
	input[MEM_DATA_BITS - 1:0] 	rd_burst_data,
	input 						rd_burst_finish
);

wire					rd_req    ;
wire[63:0]				rd_data   ;
wire					rd_data_en;
wire					fifo_empty;
wire[ADDR_BITS-1:0]		baseaddr  ;
wire[23:0]				ddr_line_length ;
wire[11:0]				ddr_col_length	;
wire					req_end		;

generate
if(DSIZE == 24)
video24bit_out_discontinuous_A2 #(
	.ADDR_BITS			(25				)
)video_out_line_by_line_inst(
	//-- video interface----
/*	input					*/	.pclk						(stream_clk       			),
/*	input					*/	.prst_n                     (stream_rst_n     			),
/*	input					*/	.invsync                    (stream_in_request			),
/*	input					*/	.inhsync                    (1'b0       				),
/*	input					*/	.inde                       (stream_in_read   			),
/*	output					*/	.outvsync                   (stream_out_sof   			),
/*	output					*/	.outhsync                   (		      				),
/*	output					*/	.outde                      (stream_out_read_sync       ),
/*	output					*/	.out_valid					(stream_out_vld   			),
/*	output[23:0]			*/	.outdata                    (stream_out_data       		),
/*	input [23:0]			*/	.video_width				(stream_in_length    		),
/*	input [11:0]			*/	.video_height				(12'd1						),
/*	input [ADDR_BITS-1:0]	*/	.video_baseaddr             (stream_in_baseaddr			),
/*	output					*/	.fifo_empty					(stream_out_not_ready 		),
/*	output					*/	.req_respond				(stream_out_req_respond		),//++++ A2
/*	output					*/	.req_waiting				(stream_out_req_waiting		),//++++ A2
/*	output					*/	.req_proc_fsh				(stream_out_req_proc_fsh	),//++++ A2
	// ddr mem ctrl interface --
/*	output					*/	.rd_req						(rd_req		   	),
/*	input [63:0]			*/	.rd_data                    (rd_data       	),
/*	output					*/	.rd_data_en					(rd_data_en	   	),
/*	output[ADDR_BITS-1:0]	*/	.baseaddr                   (baseaddr      	),
/*	output[23:0]			*/	.ddr_line_length            (ddr_line_length),
								.ddr_col_length				(ddr_col_length	),
/*	input					*/	.sync_fifo_empty			(fifo_empty	   	),
/*	output					*/	.req_end					(req_end		)
);
else if (DSIZE == 8)
video8bit_out_discontinuous_A2 #(
	.ADDR_BITS			(25				)
)video_out_line_by_line_inst(
	//-- video interface----
/*	input					*/	.pclk						(stream_clk       			),
/*	input					*/	.prst_n                     (stream_rst_n     			),
/*	input					*/	.invsync                    (stream_in_request			),
/*	input					*/	.inhsync                    (1'b0       				),
/*	input					*/	.inde                       (stream_in_read   			),
/*	output					*/	.outvsync                   (stream_out_sof   			),
/*	output					*/	.outhsync                   (		      				),
/*	output					*/	.outde                      (stream_out_read_sync       ),
/*	output					*/	.out_valid					(stream_out_vld   			),
/*	output[23:0]			*/	.outdata                    (stream_out_data       		),
/*	input [23:0]			*/	.video_width				(stream_in_length    		),
/*	input [11:0]			*/	.video_height				(12'd1						),
/*	input [ADDR_BITS-1:0]	*/	.video_baseaddr             (stream_in_baseaddr			),
/*	output					*/	.fifo_empty					(stream_out_not_ready 		),
/*	output					*/	.req_respond				(stream_out_req_respond		),//++++ A2
/*	output					*/	.req_waiting				(stream_out_req_waiting		),//++++ A2
/*	output					*/	.req_proc_fsh				(stream_out_req_proc_fsh	),//++++ A2
	// ddr mem ctrl interface --
/*	output					*/	.rd_req						(rd_req		   	),
/*	input [63:0]			*/	.rd_data                    (rd_data       	),
/*	output					*/	.rd_data_en					(rd_data_en	   	),
/*	output[ADDR_BITS-1:0]	*/	.baseaddr                   (baseaddr      	),
/*	output[23:0]			*/	.ddr_line_length            (ddr_line_length),
								.ddr_col_length				(ddr_col_length	),
/*	input					*/	.sync_fifo_empty			(fifo_empty	   	),
/*	output					*/	.req_end					(req_end		)
);
else if (DSIZE == 16)
video16bit_out_discontinuous_A2 #(
	.ADDR_BITS			(25				)
)video_out_line_by_line_inst(
	//-- video interface----
/*	input					*/	.pclk						(stream_clk       			),
/*	input					*/	.prst_n                     (stream_rst_n     			),
/*	input					*/	.invsync                    (stream_in_request			),
/*	input					*/	.inhsync                    (1'b0       				),
/*	input					*/	.inde                       (stream_in_read   			),
/*	output					*/	.outvsync                   (stream_out_sof   			),
/*	output					*/	.outhsync                   (		      				),
/*	output					*/	.outde                      (stream_out_read_sync       ),
/*	output					*/	.out_valid					(stream_out_vld   			),
/*	output[23:0]			*/	.outdata                    (stream_out_data       		),
/*	input [23:0]			*/	.video_width				(stream_in_length    		),
/*	input [11:0]			*/	.video_height				(12'd1						),
/*	input [ADDR_BITS-1:0]	*/	.video_baseaddr             (stream_in_baseaddr			),
/*	output					*/	.fifo_empty					(stream_out_not_ready 		),
/*	output					*/	.req_respond				(stream_out_req_respond		),//++++ A2
/*	output					*/	.req_waiting				(stream_out_req_waiting		),//++++ A2
/*	output					*/	.req_proc_fsh				(stream_out_req_proc_fsh	),//++++ A2
	// ddr mem ctrl interface --
/*	output					*/	.rd_req						(rd_req		   	),
/*	input [63:0]			*/	.rd_data                    (rd_data       	),
/*	output					*/	.rd_data_en					(rd_data_en	   	),
/*	output[ADDR_BITS-1:0]	*/	.baseaddr                   (baseaddr      	),
/*	output[23:0]			*/	.ddr_line_length            (ddr_line_length),
								.ddr_col_length				(ddr_col_length	),
/*	input					*/	.sync_fifo_empty			(fifo_empty	   	),
/*	output					*/	.req_end					(req_end		)
);
else if (DSIZE == 32)
video32bit_out_discontinuous_A2 #(
	.ADDR_BITS			(25				)
)video_out_line_by_line_inst(
	//-- video interface----
/*	input					*/	.pclk						(stream_clk       			),
/*	input					*/	.prst_n                     (stream_rst_n     			),
/*	input					*/	.invsync                    (stream_in_request			),
/*	input					*/	.inhsync                    (1'b0       				),
/*	input					*/	.inde                       (stream_in_read   			),
/*	output					*/	.outvsync                   (stream_out_sof   			),
/*	output					*/	.outhsync                   (		      				),
/*	output					*/	.outde                      (stream_out_read_sync       ),
/*	output					*/	.out_valid					(stream_out_vld   			),
/*	output[23:0]			*/	.outdata                    (stream_out_data       		),
/*	input [23:0]			*/	.video_width				(stream_in_length    		),
/*	input [11:0]			*/	.video_height				(12'd1						),
/*	input [ADDR_BITS-1:0]	*/	.video_baseaddr             (stream_in_baseaddr			),
/*	output					*/	.fifo_empty					(stream_out_not_ready 		),
/*	output					*/	.req_respond				(stream_out_req_respond		),//++++ A2
/*	output					*/	.req_waiting				(stream_out_req_waiting		),//++++ A2
/*	output					*/	.req_proc_fsh				(stream_out_req_proc_fsh	),//++++ A2
	// ddr mem ctrl interface --
/*	output					*/	.rd_req						(rd_req		   	),
/*	input [63:0]			*/	.rd_data                    (rd_data       	),
/*	output					*/	.rd_data_en					(rd_data_en	   	),
/*	output[ADDR_BITS-1:0]	*/	.baseaddr                   (baseaddr      	),
/*	output[23:0]			*/	.ddr_line_length            (ddr_line_length),
								.ddr_col_length				(ddr_col_length	),
/*	input					*/	.sync_fifo_empty			(fifo_empty	   	),
/*	output					*/	.req_end					(req_end		)
);
endgenerate


out_fifo_line_by_line #(
	.BURST_LEN					(100				),
	.ADDR_BITS					(ADDR_BITS			),
	.MEM_DATA_BITS				(MEM_DATA_BITS      ),
	.FIFO_DEPTH					(FIFO_DEPTH			),
	.DETAL						(16					)
)out_fifo_line_by_line_inst(
/*	input					*/		.rclk						(stream_clk       	),
/*	input					*/		.rst_n                      (stream_rst_n     	),
/*	input					*/		.rd_req                     (rd_req             ),
/*	output[63:0]			*/		.rd_data                    (rd_data            ),
/*	input					*/		.rd_data_en					(rd_data_en			),
/*	input [ADDR_BITS-1:0]	*/		.baseaddr                   (baseaddr           ),
/*	output					*/		.fifo_empty					(fifo_empty			),
/*	input					*/		.req_end					(req_end			),
/*	input [23:0]			*/		.ddr_line_length            (ddr_line_length	),
/*	input [11:0]			*/		.ddr_col_length				(ddr_col_length		),
    //-- ddr ---
/*	input						*/	.mem_clk					(mem_clk			),
/*	input						*/	.mem_rst_n            		(mem_rst_n          ),
/*	output 						*/	.rd_burst_req               (rd_burst_req       ),
/*	output[9:0] 				*/	.rd_burst_len               (rd_burst_len       ),
/*	output[ADDR_BITS-1:0] 		*/	.rd_burst_addr              (rd_burst_addr      ),
/*	input 						*/	.rd_burst_data_valid		(rd_burst_data_valid),
/*	input[MEM_DATA_BITS - 1:0]	*/	.rd_burst_data              (rd_burst_data      ),
/*	input 						*/	.rd_burst_finish            (rd_burst_finish    )
);

endmodule
