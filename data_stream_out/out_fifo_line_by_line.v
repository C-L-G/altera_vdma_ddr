/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
Version: VERA.0.0
creaded: 2015/6/4 10:05:56
madified:
***********************************************/
`timescale 1ns/1ps
module out_fifo_line_by_line #(
	parameter[9:0]				BURST_LEN		= 10'd128,
	parameter					MEM_DATA_BITS	= 64,
	parameter					ADDR_BITS		= 25,
	parameter					FIFO_DEPTH		= 256,		//"512"
	parameter					DETAL			= 8
)(
	input						rclk,
	input						rst_n,

	input						rd_req,
	output[63:0]				rd_data,
	input						rd_data_en,
	input [ADDR_BITS-1:0]		baseaddr,
	output						fifo_empty,
	input						req_end,
	input [23:0]				ddr_line_length,
	input [11:0]				ddr_col_length,
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
wire					sync_req;
wire					sync_req_end;
wire[23:0]				sync_length;
wire[11:0]				sync_column;
wire[ADDR_BITS-1:0]		sync_base;
//---->> CROSS CLOCK <<------------

//cross_clk_sync #(
//	.DSIZE    (2)
//)cross_clk_sync_req(
//	mem_clk,
//	mem_rst_n,
//	{rd_req,req_end},
//	{sync_req,sync_req_end}
//);

broaden_and_cross_clk
broaden_and_cross_sync_reg(
		.rclk     			(mem_clk        ),
		.rd_rst_n 			(mem_rst_n      ),
		.wclk     			(rclk           ),
		.wr_rst_n 			(rst_n          ),
		.d        			(rd_req      ),
		.q         			(sync_req	)
);

broaden_and_cross_clk
broaden_and_cross_sync_reg_end(
		.rclk     			(mem_clk        ),
		.rd_rst_n 			(mem_rst_n      ),
		.wclk     			(rclk           ),
		.wr_rst_n 			(rst_n          ),
		.d        			(req_end      ),
		.q         			(sync_req_end	)
);

/*
cross_clk_sync #(
	.DSIZE    (ADDR_BITS)
)cross_clk_base(
	mem_clk,
	mem_rst_n,
	baseaddr,
	sync_base
);

cross_clk_sync #(
	.DSIZE    (24)
)cross_clk_line_len(
	mem_clk,
	mem_rst_n,
	ddr_line_length,
	sync_length
);

cross_clk_sync #(
	.DSIZE    (12)
)cross_clk_col_len(
	mem_clk,
	mem_rst_n,
	ddr_col_length,
	sync_column
);
*/
//----<< CROSS CLOCK >>------------
//---->> LATCH BLOCK <<------------

latch_data #(
	.DSIZE		(ADDR_BITS)
)latch_addr(
	.enable		(rd_req		),
	.in         (baseaddr       ),
	.out        (sync_base	    )
);

latch_data #(
	.DSIZE		(24)
)latch_length(
	.enable		(rd_req			),
	.in         (ddr_line_length   	),
	.out        (sync_length     	)
);

latch_data #(
	.DSIZE		(12)
)latch_col_length(
	.enable		(rd_req			),
	.in         (ddr_col_length   	),
	.out        (sync_column	  	)
);

//----<< LATCH BLOCK >>------------

reg	[23:0]				sync_data_len;
always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		sync_data_len	<= {24{1'b0}};
	end else if(sync_req) begin
		sync_data_len	<= sync_length	;
	end else begin
		sync_data_len	<= sync_data_len ;
end end

wire sync_req_falliing;
wire sync_req_raising;
edge_generator #(
	.MODE	("BEST")   // FAST NORMAL BEST
)edge_sync_req_inst(
	.clk		(mem_clk      ),
	.rst_n      (mem_rst_n    ),
	.in         (sync_req     ),
	.raising    (sync_req_raising),
	.falling    (sync_req_falliing)
);

localparam		DW		= (FIFO_DEPTH == 256)? 8 : ( (FIFO_DEPTH == 512)? 9 : 8) ;
wire[DW-1:0]	rdusedw,wrusedw;
wire			fifo_full;
reg				arst_fifo;
wire			sync_rst_fifo;
reg				clear_odd;			//if BURST is odd like 9,and fifo will receive 10, so ignore last one

broaden_and_cross_clk
broaden_and_cross_clk_rst_fifo(
		.rclk     			(rclk           ),
		.rd_rst_n 			(1'b1           ),
		.wclk     			(mem_clk        ),
		.wr_rst_n 			(mem_rst_n      ),
		.d        			(arst_fifo      ),
		.q         			(sync_rst_fifo	)
);

generate
if(FIFO_DEPTH	== 256)
vin_frame_buffer_ctrl_fifo_256_64 vin_frame_buffer_ctrl_fifo_256_64_m0(
//	.aclr		(!rst_n || arst_fifo),
	.aclr		(!rst_n || sync_rst_fifo),
	.data		(rd_burst_data),
	.rdclk		(rclk),
	.rdreq		(rd_data_en),
	.wrclk		(mem_clk),
	.wrreq		(rd_burst_data_valid && !clear_odd),
	.q			(rd_data),
	.rdempty	(fifo_empty	),
	.rdusedw	(rdusedw),
	.wrfull		(fifo_full),
	.wrusedw	(wrusedw));
else if(FIFO_DEPTH == 512)
frame_buffer_ctrl_fifo_512_64 frame_buffer_ctrl_fifo_512_64_m0(
//	.aclr		(!rst_n || arst_fifo),
	.aclr		(!rst_n || sync_rst_fifo),
	.data		(rd_burst_data),
	.rdclk		(rclk),
	.rdreq		(rd_data_en),
	.wrclk		(mem_clk),
	.wrreq		(rd_burst_data_valid && !clear_odd),
	.q			(rd_data),
	.rdempty	(fifo_empty	),
	.rdusedw	(rdusedw),
	.wrfull		(fifo_full),
	.wrusedw	(wrusedw));
endgenerate


reg							pro_short;
reg							pro_tail;
reg [9:0]					tail_len;
reg							line_enough;

//-- generate signal for state mch
reg		fifo_have_enough_space;
always@(posedge mem_clk,negedge mem_rst_n)
	if(~mem_rst_n)	fifo_have_enough_space	<= 1'b0;
	else 			fifo_have_enough_space	<= (wrusedw < (({DW{1'b1}}-6'd0)-BURST_LEN)) && !fifo_full;

////------

reg [4:0]			cstate,nstate;
localparam			IDLE		= 5'd0,
					LATENCY		= 5'd1,
					FRAME		= 5'd2,
					REQING		= 5'd3,
					SEND_REQ	= 5'd4,
					BURSTING	= 5'd5,
					BURST_END	= 5'd6,
					NEED_TAIL	= 5'd18,
					REQ_TAIL	= 5'd7,
					SEND_TAIL	= 5'd8,
					BURST_TAIL	= 5'd9,
					TAIL_END	= 5'd10,
					REQ_SHORT	= 5'd11,
					SEND_SHORT  = 5'd12,
					BURST_SHORT = 5'd13,
					SHORT_END	= 5'd14,
					LINE_START	= 5'd17,
					LINE_END	= 5'd15,
					FRAME_END	= 5'd16,
					NOP			= 5'd19;

always@(posedge mem_clk,negedge mem_rst_n)
	if(~mem_rst_n)		cstate	= NOP;
	else if(sync_req)	cstate	= IDLE;
	else				cstate	= nstate;


always@(*)
	case(cstate)
	IDLE:			nstate	= LATENCY;
	LATENCY:		nstate	= FRAME;
	FRAME: if(fifo_empty)
	       			nstate	= LINE_START;
	       	else    nstate	= FRAME;
	LINE_START:if(pro_short)
					nstate	= REQ_SHORT;
			else	nstate	= REQING;
	//-->>  normal <<---
	REQING:	if(fifo_have_enough_space)
					nstate	= SEND_REQ;
			else	nstate	= REQING;
	SEND_REQ:if(rd_burst_data_valid)
					nstate	= BURSTING;
			else	nstate	= SEND_REQ;
	BURSTING:if(rd_burst_finish)
					nstate	= BURST_END;
			else	nstate	= BURSTING;
	BURST_END:if(sync_req_end)
					nstate	= FRAME_END;
			else	nstate	= NEED_TAIL;
	NEED_TAIL:if(pro_tail)
					nstate	= REQ_TAIL;
			else	nstate	= REQING;
	//--<< normal >>----
	//-->> TAIL <<------
	REQ_TAIL:if(fifo_have_enough_space)
					nstate	= SEND_TAIL;
			else	nstate	= REQ_TAIL;
	SEND_TAIL:if(rd_burst_data_valid)
					nstate	= BURST_TAIL;
			else	nstate	= SEND_TAIL;
	BURST_TAIL:if(rd_burst_finish)
					nstate	= TAIL_END;
			else	nstate	= BURST_TAIL;
	TAIL_END:		nstate	= LINE_END;
	//-->> SHORT <<-----
	REQ_SHORT:if(fifo_have_enough_space)
					nstate	= SEND_SHORT;
			else	nstate	= REQ_SHORT;
	SEND_SHORT:if(rd_burst_data_valid)
					nstate	= BURST_SHORT;
			else	nstate	= SEND_SHORT;
	BURST_SHORT:if(rd_burst_finish)
					nstate	= SHORT_END;
			else	nstate	= BURST_SHORT;
	SHORT_END:		nstate	= LINE_END;
	//--<< SHORT >>------
	LINE_END:if(sync_req_end || line_enough)
					nstate	= FRAME_END;
			else	nstate	= LINE_START;
	FRAME_END:		nstate	= FRAME_END;
	default:		nstate	= FRAME_END;
	endcase

reg							burst_req	;
reg [9:0]      				burst_len	;
reg [ADDR_BITS-1:0]      	burst_addr	;
reg             			read_finish	;
reg [ADDR_BITS-1:0]			address		;


always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		burst_req		<= 1'b0;
	//	burst_len		<= 10'd0;
	//	burst_addr		<= {ADDR_BITS{1'b0}};
	end else begin
		case(nstate)
		SEND_REQ:begin
			burst_req		<= 1'b1;
		//	burst_len		<= BURST_LEN;
		//	burst_addr		<= address;
		end
		SEND_TAIL,SEND_SHORT:begin
			burst_req		<= 1'b1;
		//	burst_len		<= tail_len;
		//	burst_addr		<= address;
		end
		default:begin
			burst_req		<= 1'b0;
		//	burst_len		<= 10'd0;
		//	burst_addr		<= {ADDR_BITS{1'b0}};
		end
		endcase
end end

always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		burst_len		<= 10'd0;
	end else begin
		case(nstate)
		REQING,SEND_REQ,BURSTING:begin
			burst_len		<= BURST_LEN;
		end
		REQ_TAIL,REQ_SHORT,
		BURST_TAIL,BURST_SHORT,
		SEND_TAIL,SEND_SHORT:begin
			burst_len		<= tail_len;
		end
		default:begin
			burst_len		<= 10'd0;
		end
		endcase
end end

always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		burst_addr		<= {ADDR_BITS{1'b0}};
	end else begin
		case(nstate)
		REQING,REQ_TAIL,REQ_SHORT,
		BURSTING,BURST_TAIL,BURST_SHORT,
		SEND_REQ,SEND_TAIL,SEND_SHORT:begin
			burst_addr		<= address;
		end
		default:begin
			burst_addr		<= burst_addr;
		end
		endcase
end end

always@(posedge mem_clk,negedge mem_rst_n)begin:GEN_ADDR_BLOCK
reg [DETAL-1:0]		offsize_addr;
	if(~mem_rst_n)begin
		address			<= {ADDR_BITS{1'b0}};
		offsize_addr	<= {DETAL{1'b0}};
	end else begin
		case(nstate)
		FRAME:begin
				address			<= sync_base;
				offsize_addr	<= sync_base[DETAL-1:0];
		end
		BURST_END:	address			<= address + BURST_LEN;
		TAIL_END,SHORT_END:
					address	<= address + tail_len;
		LINE_END:	address	<= {address[ADDR_BITS-1:DETAL],offsize_addr} + (1'b1<<DETAL);
		default:;
		endcase
end end


always@(posedge mem_clk,negedge mem_rst_n)begin:GEN_DATA_COUNTER
reg	[23:0]		dcnt;
	if(~mem_rst_n)begin
		dcnt	<= 24'd0;
	end else begin
		case(nstate)
		FRAME:		dcnt	<= sync_data_len;
		BURST_END:	dcnt	<= dcnt - BURST_LEN;
		TAIL_END,SHORT_END:
					dcnt	<= dcnt - tail_len;
		LINE_END,LINE_START:
					dcnt	<= sync_data_len;
		default:	dcnt	<= dcnt;
		endcase

		case(nstate)
		FRAME:		tail_len	<= sync_data_len[9:0];
		NEED_TAIL:	tail_len	<= dcnt[9:0];
		default:	tail_len	<= tail_len;
		endcase

		case(nstate)
		LINE_START:	pro_tail	<= 1'b0;
		NEED_TAIL:	pro_tail	<= dcnt	<= BURST_LEN;
		TAIL_END:	pro_tail	<= 1'b0;
		default:	pro_tail	<= pro_tail;
		endcase

		case(nstate)
		FRAME:		pro_short	<= sync_data_len <= BURST_LEN;
		default:	pro_short	<= pro_short;
		endcase

end end

always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		arst_fifo		<= 1'b0;
	end else
		case(nstate)
		FRAME:	arst_fifo	<= 1'b1;
		default:arst_fifo	<= 1'b0;
		endcase
end

always@(posedge mem_clk,negedge mem_rst_n)begin:GEN_COL_CNT
reg [11:0]		col_cnt;
reg [11:0]		lock_col;
	if(~mem_rst_n)begin
		col_cnt		<= 12'd0;
		line_enough	<= 1'b0;
		lock_col	<= 12'd0;
	end else begin
		lock_col	<= sync_req? sync_column : lock_col;
		line_enough	<= col_cnt >= (lock_col - 1'b1);		//if this is last line
		case(nstate)
		IDLE,FRAME_END,FRAME:
						col_cnt		<= 12'd0;
		LINE_END:		col_cnt		<= col_cnt + 1'b1;
		default:;
		endcase
end end

always@(posedge mem_clk,negedge mem_rst_n)begin:GEN_CLEAR_ODD
reg	[9:0]		send_len;
reg [9:0]		ocnt;
	if(~mem_rst_n)begin
		send_len	<= 10'd0;
		clear_odd	<= 1'b0;
		ocnt		<= 10'd0;
	end else begin
		ocnt		<= ocnt + rd_burst_data_valid;
		clear_odd	<= (ocnt >= send_len) || ((ocnt == (send_len-1'b1)) & rd_burst_data_valid);
		case(nstate)
		SEND_REQ:begin
			send_len	<= BURST_LEN;
			clear_odd	<= 1'b0;
			ocnt		<= 10'd0;
		end
		SEND_TAIL,SEND_SHORT:begin
			send_len	<= tail_len;
			clear_odd	<= 1'b0;
			ocnt		<= 10'd0;
		end
		BURST_END,TAIL_END,SHORT_END:begin
			clear_odd	<= 1'b0;
			ocnt		<= 10'd0;
		end
		default:;
		endcase
end end

//----->> <<---------

////------

assign	rd_burst_req   	= burst_req   ;
assign	rd_burst_len    = burst_len   ;
assign	rd_burst_addr   = burst_addr  ;

endmodule
