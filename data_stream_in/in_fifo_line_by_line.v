/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
Version: VERA.0.0
creaded: 2015/6/3 13:21:39
madified:
***********************************************/
`timescale 1ns/1ps
module in_fifo_line_by_line #(
	parameter					MEM_DATA_BITS	= 64,
	parameter					ADDR_BITS		= 25,
	parameter					FIFO_DEPTH		= 256,		//"512"
	parameter					BURST_LEN		= 128,
	parameter					DETAL			= 8,
	parameter					FLIPPING		= "FALSE"
)(
	input						inclk,
	input [ADDR_BITS-1:0]		baseaddr,		// dont need sync to mem_clk
	input						loadbase,
	input [23:0]				ddr_line_length,
	input [11:0]				ddr_col_length,
	output						fifo_empty,
 	input						arst_fifo,
	input [MEM_DATA_BITS - 1:0] indata,
	input						wr_en,
	//-- mem interface
	input						mem_clk,
	input						mem_rst_n,
	output 						wr_burst_req,
	output[9:0] 				wr_burst_len,
	output[ADDR_BITS-1:0] 		wr_burst_addr,
	input 						wr_burst_data_req,
	output[MEM_DATA_BITS - 1:0]	wr_burst_data,
	input 						wr_burst_finish

);

wire				sync_loadbase;
wire[ADDR_BITS-1:0]	sync_baseaddr;
wire[23:0]			sync_line_length;
wire				sync_fifo_empty;
wire				afifo_empty;
wire[11:0]			sync_column;

//------------->> CROSS CLOCK BLOCK <<----------------
cross_clk_sync #(
	.DSIZE    	(1)
)cross_clk_load_false_path(
	mem_clk,
	mem_rst_n,
	loadbase,
	sync_loadbase
);


cross_clk_sync #(
	.DSIZE    	(1)
)cross_clk_empty(
	inclk,
	1'b1,
	afifo_empty,
	sync_fifo_empty
);
/*
cross_clk_sync #(
	.DSIZE    	(ADDR_BITS)
)cross_clk_addr_false_path(
	mem_clk,
	mem_rst_n,
	baseaddr,
	sync_baseaddr
);

cross_clk_sync #(
	.DSIZE    	(24)
)cross_clk_len_false_path(
	mem_clk,
	mem_rst_n,
	ddr_line_length,
	sync_line_length
);


wire[11:0]				sync_column;
cross_clk_sync #(
	.DSIZE    (12)
)cross_clk_col_len(
	mem_clk,
	mem_rst_n,
	ddr_col_length,
	sync_column
);
*/
//-------------<< CROSS CLOCK BLOCK >>----------------
//------------->> LACTH BLOCK <<----------------

latch_data #(
	.DSIZE		(ADDR_BITS)
)latch_addr(
	.enable		(loadbase		),
	.in         (baseaddr       ),
	.out        (sync_baseaddr  )
);

latch_data #(
	.DSIZE		(24)
)latch_length(
	.enable		(loadbase			),
	.in         (ddr_line_length   	),
	.out        (sync_line_length  	)
);

latch_data #(
	.DSIZE		(12)
)latch_col_length(
	.enable		(loadbase			),
	.in         (ddr_col_length   	),
	.out        (sync_column	  	)
);

//-------------<< LACTH BLOCK >>----------------
//-------------->> FIFO BLOCK <<-----------------------
assign	fifo_empty	= sync_fifo_empty;
localparam		DW		= (FIFO_DEPTH == 256)? 8 : ( (FIFO_DEPTH == 512)? 9 : 8) ;
wire[DW-1:0]	rdusedw,wrusedw;

generate
if(FIFO_DEPTH == 256)
vin_frame_buffer_ctrl_fifo_256_64 vin_frame_buffer_ctrl_fifo_256_64_m0(
	.aclr		(arst_fifo),
	.data		(indata),
	.rdclk		(mem_clk),
	.rdreq		(wr_burst_data_req),
	.wrclk		(inclk),
	.wrreq		(wr_en),
	.q			(wr_burst_data),
	.rdempty	(afifo_empty),
	.rdusedw	(rdusedw),
	.wrfull		(),
	.wrusedw	(wrusedw));
else if(FIFO_DEPTH == 512)
frame_buffer_ctrl_fifo_512_64 frame_buffer_ctrl_fifo_512_64_m0(
	.aclr		(arst_fifo),
	.data		(indata),
	.rdclk		(mem_clk),
	.rdreq		(wr_burst_data_req),
	.wrclk		(inclk),
	.wrreq		(wr_en),
	.q			(wr_burst_data),
	.rdempty	(afifo_empty),
	.rdusedw	(rdusedw),
	.wrfull		(),
	.wrusedw	(wrusedw));
endgenerate
//--------------<< FIFO BLOCK >>-----------------------

//---- generate signal for state mch
reg			pro_short;
reg			pro_tail;
reg [23:0]	remain_cnt;
reg			line_enough;


reg		fifo_get_enough_data;
always@(posedge mem_clk,negedge mem_rst_n)
	if(~mem_rst_n)	fifo_get_enough_data	<= 1'b0;
	else if(pro_short)			fifo_get_enough_data	<= (rdusedw >= sync_line_length);
	else if(pro_tail)			fifo_get_enough_data	<= (rdusedw >= remain_cnt);
	else						fifo_get_enough_data	<= (rdusedw >= BURST_LEN) && !afifo_empty;


////---------

reg [4:0]		cstate,nstate;

localparam		IDLE		= 5'd0  ,
				FRAME		= 5'd1  ,
				LINE_START	= 5'd2  ,
				REQ_WAIT	= 5'd3  ,
				REQING		= 5'd4  ,
				BURSTING	= 5'd5  ,
				BURST_END	= 5'd6  ,
				JUMP_TAIL	= 5'd7  ,
				TAIL_WAIT	= 5'd8  ,
				REQ_TAIL	= 5'd9  ,
				BURST_TAIL	= 5'd10 ,
				TAIL_END	= 5'd11 ,
				SHORT_WAIT	= 5'd12 ,
				REQ_SHORT	= 5'd13 ,
				BURST_SHORT	= 5'd14 ,
				SHORT_END	= 5'd15 ,
				LINE_END	= 5'd16 ,
				FRAME_END	= 5'd17	,
				NOP			= 5'd19	;


always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)	cstate	<= NOP;
	else if(sync_loadbase)
					cstate	<= IDLE;
	else 			cstate	<= nstate;
end

always@(*)
	case(cstate)
	IDLE:								nstate	= FRAME;
	FRAME:								nstate	= LINE_START;
	LINE_START:if(pro_short)			nstate	= SHORT_WAIT;	else	nstate	= REQ_WAIT;
	//--->><<-------
	REQ_WAIT:if(fifo_get_enough_data)	nstate	= REQING;		else	nstate	= REQ_WAIT;
	REQING:	if(wr_burst_data_req)		nstate	= BURSTING;		else	nstate	= REQING;
	BURSTING:if(wr_burst_finish)		nstate	= BURST_END;	else	nstate	= BURSTING;
	BURST_END:							nstate	= JUMP_TAIL;
	JUMP_TAIL:if(pro_tail)				nstate	= TAIL_WAIT;	else	nstate	= REQ_WAIT;
	//--->><<-------
	TAIL_WAIT:if(fifo_get_enough_data)	nstate	= REQ_TAIL;		else	nstate	= TAIL_WAIT;
	REQ_TAIL:if(wr_burst_data_req)		nstate	= BURST_TAIL;	else	nstate	= REQ_TAIL;
	BURST_TAIL:if(wr_burst_finish)		nstate	= TAIL_END;		else	nstate	= BURST_TAIL;
	TAIL_END:							nstate	= LINE_END;
	//--->><<-------
	SHORT_WAIT:if(fifo_get_enough_data)	nstate	= REQ_SHORT;	else	nstate	= SHORT_WAIT;
	REQ_SHORT:if(wr_burst_data_req)		nstate	= BURST_SHORT;	else	nstate	= REQ_SHORT;
	BURST_SHORT:if(wr_burst_finish)		nstate	= SHORT_END;	else	nstate	= BURST_SHORT;
	SHORT_END:							nstate	= LINE_END;
	//--->><<------
	LINE_END:if(line_enough)			nstate	= FRAME_END;	else	nstate	= LINE_START;
	FRAME_END:							nstate	= FRAME_END;
	default:							nstate	= FRAME_END;
	endcase

//---------<< state block >>-----------
reg						burst_req;
reg [9:0]				burst_length;
reg [ADDR_BITS-1:0]		burst_addr;
reg [ADDR_BITS-1:0]		address;

always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		burst_req		<= 1'b0;
		burst_length	<= 10'd0;
		burst_addr		<= {ADDR_BITS{1'b0}};
	end else begin
		case(nstate)
		FRAME:begin
			burst_req		<= 1'b0;
			burst_length	<= 10'd0;
			burst_addr		<= {ADDR_BITS{1'b0}};
		end
		//--->><<----
		REQING:begin
			burst_req		<= 1'b1;
			burst_length	<= BURST_LEN;
			burst_addr		<= address;
		end
		BURSTING:begin
			burst_req		<= 1'b0;
		end
		//--->><<----
		REQ_TAIL:begin
			burst_req		<= 1'b1;
			burst_length	<= remain_cnt[9:0];
			burst_addr		<= address;
		end
		BURST_TAIL:begin
			burst_req		<= 1'b0;
		end
		//--->><<----
		REQ_SHORT:begin
			burst_req		<= 1'b1;
			burst_length	<= remain_cnt[9:0];
			burst_addr		<= address;
		end
		BURST_SHORT:begin
			burst_req		<= 1'b0;
		end
		BURST_END,TAIL_END,SHORT_END:begin
			burst_req		<= 1'b0;
		end
		default:;
		endcase
end end


always@(posedge mem_clk,negedge mem_rst_n)begin:GEN_ADDR_BLOCK
reg [DETAL-1:0]		offsize_addr;
reg	[11:0]			col_arigen;
	if(~mem_rst_n)begin
		address			<= 10'd0;
		offsize_addr	<= {DETAL{1'b0}};
		col_arigen		<= 12'd0;
	end else begin
//		if(sync_loadbase)begin
//			if(FLIPPING == "FALSE")
//					address			<= sync_baseaddr;
//			else if(FLIPPING == "TRUE")
//					address			<= sync_baseaddr + (sync_column << DETAL);
//			else	address			<= sync_baseaddr;
//			offsize_addr	<= sync_baseaddr[DETAL-1:0];
//		end else
			col_arigen			<= sync_column-1'b1;
			case(nstate)
			FRAME:begin
				offsize_addr	<= sync_baseaddr[DETAL-1:0];
				if(FLIPPING == "FALSE")
						address			<= sync_baseaddr;
				else if(FLIPPING == "TRUE")
						address			<= sync_baseaddr + (col_arigen << DETAL);
				else	address			<= sync_baseaddr;
			end
			BURST_END:	address		<= address + BURST_LEN;
			TAIL_END:	address		<= address;
			SHORT_END:	address		<= address;
			LINE_END:begin
				if(FLIPPING == "FALSE")
						address		<= {address[ADDR_BITS-1:DETAL],offsize_addr} + (1'b1<<DETAL);
				else if(FLIPPING == "TRUE")
						address		<= {address[ADDR_BITS-1:DETAL],offsize_addr} - (1'b1<<DETAL);
				else	address		<= {address[ADDR_BITS-1:DETAL],offsize_addr} + (1'b1<<DETAL);
			end
			default:;
			endcase
end end

always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		pro_short	<= 1'b0;
	end else begin
		case(nstate)
		FRAME:		pro_short	<= sync_line_length <= BURST_LEN;
		default:	pro_short	<= pro_short;
		endcase
end end

always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		remain_cnt	<= 24'hFFFF_FF;
	end else begin
		case(nstate)
		FRAME:		remain_cnt	<= sync_line_length;
		BURST_END:	remain_cnt	<= remain_cnt - BURST_LEN;
		TAIL_END,SHORT_END,LINE_END:
					remain_cnt	<= sync_line_length;
		default:;
		endcase
end end

always@(posedge mem_clk,negedge mem_rst_n)begin
	if(~mem_rst_n)begin
		pro_tail	<= 1'b0;
	end else begin
		case(nstate)
		FRAME,LINE_START,TAIL_END,LINE_END:
					pro_tail	<= 1'b0;
		BURST_END,JUMP_TAIL:
					pro_tail	<= remain_cnt <= BURST_LEN;
		default:	pro_tail	<= pro_tail;
		endcase
end end

always@(posedge mem_clk,negedge mem_rst_n)begin:GEN_COL_CNT
reg [11:0]		col_cnt;
reg [11:0]		lock_col;
	if(~mem_rst_n)begin
		col_cnt		<= 12'd0;
		line_enough	<= 1'b0;
		lock_col	<= 12'd0;
	end else begin
		lock_col	<= sync_loadbase? sync_column : lock_col;
		line_enough	<= col_cnt >= (lock_col - 1'b1);		//if this is last line
		case(nstate)
		IDLE,FRAME_END,FRAME:
						col_cnt		<= 12'd0;
		LINE_END:		col_cnt		<= col_cnt + 1'b1;
		default:;
		endcase
end end

//---<< >>-----



assign		wr_burst_req	= burst_req;
assign		wr_burst_len	= burst_length;
assign		wr_burst_addr	= burst_addr;

endmodule
