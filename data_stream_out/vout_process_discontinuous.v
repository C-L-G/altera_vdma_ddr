/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
Version: VREA.1.0
	calu detal from line length
creaded: 2015/6/4 14:55:19
madified:
***********************************************/
`timescale 1ns/1ps
module vout_process_discontinuous #(
	parameter		MEM_DATA_BITS 	= 64,
	parameter		ADDR_BITS		= 25,
	parameter		DSIZE			= 24,
	parameter		FIFO_DEPTH		= 256,
	parameter		DETAL			= 8
)(
	input						pclk,
	input						prst_n,
	input						invsync,
	input						inhsync,
	input						inde,
	output						outvsync,
	output						outhsync,
	output						outde,
	output						out_not_ready,
	output[DSIZE-1:0]			outdata,
	output						outdata_vld,
	input [11:0]				video_width,
	input [11:0]				video_height,
	input [ADDR_BITS-1:0]		video_baseaddr,
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
wire					busy      ;
wire					frame_fsh ;
wire					fifo_empty;
wire[ADDR_BITS-1:0]		baseaddr  ;
wire[23:0]				ddr_line_length ;
wire[11:0]				ddr_col_length	;
wire					response  ;
wire					master_rst_fifo;
wire					req_end		;

generate
if(DSIZE == 24)
video24bit_out_discontinuous #(
	.ADDR_BITS			(25				)
)video_out_line_by_line_inst(
	//-- video interface----
/*	input					*/	.pclk						(pclk          	),
/*	input					*/	.prst_n                     (prst_n        	),
/*	input					*/	.invsync                    (invsync       	),
/*	input					*/	.inhsync                    (inhsync       	),
/*	input					*/	.inde                       (inde          	),
/*	output					*/	.outvsync                   (outvsync      	),
/*	output					*/	.outhsync                   (outhsync      	),
/*	output					*/	.outde                      (outde         	),
/*	output					*/	.out_valid					(outdata_vld   	),
/*	output[23:0]			*/	.outdata                    (outdata       	),
/*	input [23:0]			*/	.video_width				({12'd0,video_width}    ),
/*	input [11:0]			*/	.video_height				(video_height	),
/*	input [ADDR_BITS-1:0]	*/	.video_baseaddr             (video_baseaddr	),
/*	output					*/	.fifo_empty					(out_not_ready 	),
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
video8bit_out_discontinuous #(
	.ADDR_BITS			(25				)
)video_out_line_by_line_inst(
	//-- video interface----
/*	input					*/	.pclk						(pclk          	),
/*	input					*/	.prst_n                     (prst_n        	),
/*	input					*/	.invsync                    (invsync       	),
/*	input					*/	.inhsync                    (inhsync       	),
/*	input					*/	.inde                       (inde          	),
/*	output					*/	.outvsync                   (outvsync      	),
/*	output					*/	.outhsync                   (outhsync      	),
/*	output					*/	.outde                      (outde         	),
/*	output					*/	.out_valid					(outdata_vld   	),
/*	output[23:0]			*/	.outdata                    (outdata       	),
/*	input [23:0]			*/	.video_width				({12'd0,video_width}    ),
/*	input [11:0]			*/	.video_height				(video_height	),
/*	input [ADDR_BITS-1:0]	*/	.video_baseaddr             (video_baseaddr	),
/*	output					*/	.fifo_empty					(out_not_ready 	),
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
video16bit_out_discontinuous #(
	.ADDR_BITS			(25				)
)video_out_line_by_line_inst(
	//-- video interface----
/*	input					*/	.pclk						(pclk          	),
/*	input					*/	.prst_n                     (prst_n        	),
/*	input					*/	.invsync                    (invsync       	),
/*	input					*/	.inhsync                    (inhsync       	),
/*	input					*/	.inde                       (inde          	),
/*	output					*/	.outvsync                   (outvsync      	),
/*	output					*/	.outhsync                   (outhsync      	),
/*	output					*/	.outde                      (outde         	),
/*	output					*/	.out_valid					(outdata_vld   	),
/*	output[23:0]			*/	.outdata                    (outdata       	),
/*	input [23:0]			*/	.video_width				({12'd0,video_width}    ),
/*	input [11:0]			*/	.video_height				(video_height	),
/*	input [ADDR_BITS-1:0]	*/	.video_baseaddr             (video_baseaddr	),
/*	output					*/	.fifo_empty					(out_not_ready 	),
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
video32bit_out_discontinuous #(
	.ADDR_BITS			(25				)
)video_out_line_by_line_inst(
	//-- video interface----
/*	input					*/	.pclk						(pclk          	),
/*	input					*/	.prst_n                     (prst_n        	),
/*	input					*/	.invsync                    (invsync       	),
/*	input					*/	.inhsync                    (inhsync       	),
/*	input					*/	.inde                       (inde          	),
/*	output					*/	.outvsync                   (outvsync      	),
/*	output					*/	.outhsync                   (outhsync      	),
/*	output					*/	.outde                      (outde         	),
/*	output					*/	.out_valid					(outdata_vld   	),
/*	output[23:0]			*/	.outdata                    (outdata       	),
/*	input [23:0]			*/	.video_width				({12'd0,video_width}    ),
/*	input [11:0]			*/	.video_height				(video_height	),
/*	input [ADDR_BITS-1:0]	*/	.video_baseaddr             (video_baseaddr	),
/*	output					*/	.fifo_empty					(out_not_ready 	),
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
	.DETAL						(DETAL				)
)out_fifo_line_by_line_inst(
/*	input					*/		.rclk						(pclk               ),
/*	input					*/		.rst_n                      (prst_n             ),
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
