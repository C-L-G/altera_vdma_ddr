/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
Version: VERA.0.0
creaded: 2015/6/3 9:59:50
madified:
***********************************************/
`timescale 1ns/1ps
module video24bit_in_discontinuous #(
	parameter		ADDR_BITS		= 25,
	parameter		BROADEN_LOAD	= "FALSE"
)(
	input						pclk,
	input						prst_n,
	input						vsync,
	input						de,
	input [23:0]				indata,
	input						invalid,
	input [ADDR_BITS-1:0]		baseaddr,
	output						fifo_empty,
	input [23:0]				video_width,
	input [11:0]				video_height,

	output						wr_fifo_en,
	output[63:0]				wr_data,
	input						sync_fifo_empty, // it is alreay in the field of 'pclk'
	output						arst_fifo,
	output						loadbase,
	output[ADDR_BITS-1:0]		ddr_baseaddr,
	output[23:0]				ddr_line_length,
	output[11:0]				ddr_col_length

);

assign	fifo_empty	= sync_fifo_empty;

wire		vsync_raising;
wire		vsync_falling;
edge_generator #(
	.MODE	("BEST")   // FAST NORMAL BEST
)edge_vsync_inst(
	.clk		(pclk	      ),
	.rst_n      (prst_n	      ),
	.in         (vsync        ),
	.raising    (vsync_raising),
	.falling    (vsync_falling)
);

wire		start_state_flag;
cross_clk_sync #(
	.DSIZE    	(1),
	.LAT		(4)
)start_state_flag_inst(
	pclk,
	prst_n,
	vsync_falling,
	start_state_flag
);

reg [ADDR_BITS-1:0]			sync_baseaddr;
always@(posedge pclk,negedge prst_n)
	if(~prst_n)		sync_baseaddr	<= {ADDR_BITS{1'b0}};
	else if(vsync_falling)
					sync_baseaddr	<= baseaddr;
	else			sync_baseaddr	<= sync_baseaddr;

//------------>> CALU LENGTH <<------------------
reg [23:0]		sync_width;
reg [11:0]		sync_height;

always@(posedge pclk,negedge prst_n)
	if(~prst_n)	sync_width	<= video_width;
	else if(vsync)
				sync_width	<= video_width;
	else		sync_width	<= sync_width;

always@(posedge pclk,negedge prst_n)
	if(~prst_n)	sync_height	<= video_height;
	else if(vsync)
				sync_height	<= video_height;
	else		sync_height	<= sync_height;

reg [23:0]		calu_len;
always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)	calu_len	<= sync_width /4 + sync_width/8 + |sync_width[1:0];
	else if(vsync)
				calu_len	<= sync_width /4 + sync_width/8 + |sync_width[1:0];
	else		calu_len	<= calu_len;
end

reg				one_line_end;
always@(posedge pclk,negedge prst_n)begin:COLUMN_COUNTER
reg [23:0]		width_cnt;
	if(~prst_n)begin
		width_cnt		<= 24'd0;
		one_line_end	<= 1'b0;
	end else if(vsync)begin
		width_cnt		<= 24'd0;
		one_line_end	<= 1'b0;
	end else begin
		if(width_cnt >= sync_width)begin
					width_cnt	<= 24'd0;
		end else begin
			if(de)	width_cnt	<= width_cnt + 1'b1;
			else	width_cnt	<= width_cnt;
		end
		one_line_end	<= width_cnt == sync_width;
end end
//------------<< CALU LENGTH >>------------------

reg [23:0]		f64_p1,f64_p2;
reg	[23:0]		s64_p2,s64_p3;
reg [23:0]		t64_p2,t64_p3;

reg [15:0]		f64_p3;
reg [7:0]		s64_p1,s64_p4;
reg [15:0]		t64_p1;
reg				broaden_req_fsh;
reg				line_enough;

reg [3:0]		cstate,nstate;
localparam		IDLE	= 4'd0,
				FRAME	= 4'd1,
				PIX1	= 4'd2,
				PIX2	= 4'd3,
				PIX3	= 4'd4,
				PIX4	= 4'd5,
				PIX5	= 4'd6,
				PIX6	= 4'd7,
				PIX7	= 4'd8,
				PIX8	= 4'd9,
				FEND	= 4'd10,
				BLKPIX	= 4'd11,
				LEND	= 4'd12;
always@(posedge pclk,negedge prst_n)
	if(~prst_n)	cstate	<= IDLE;
	else if(vsync_raising)
				cstate	<= IDLE;
	else		cstate	<= nstate;

always@(*)
	case(cstate)
	IDLE:	if(start_state_flag)
					nstate	= FRAME;
			else	nstate	= IDLE;
	FRAME:	if(BROADEN_LOAD == "FALSE")
					nstate	= BLKPIX;
			else if(BROADEN_LOAD == "TRUE")
					if(broaden_req_fsh)
							nstate	= BLKPIX;
					else	nstate	= FRAME;
			else	nstate	= FRAME;
	BLKPIX: if(de)			nstate	= PIX1;	else	nstate	= BLKPIX;
	PIX1:	if(de)			nstate	= PIX2;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX1;
	PIX2:	if(de)			nstate	= PIX3;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX2;
	PIX3:	if(de)			nstate	= PIX4;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX3;
	PIX4:	if(de)			nstate	= PIX5;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX4;
	PIX5:	if(de)			nstate	= PIX6;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX5;
	PIX6:	if(de)			nstate	= PIX7;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX6;
	PIX7:	if(de)			nstate	= PIX8;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX7;
	PIX8:	if(de)			nstate	= PIX1;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX8;
	LEND:	if(line_enough)	nstate	= FEND;	else	nstate	= BLKPIX;
	FEND:	nstate	= FEND;
	default:nstate	= IDLE;
	endcase

reg	[3:0]		pstate;
always@(posedge pclk,negedge prst_n)
	if(~prst_n)	pstate	<= IDLE;
	else		pstate	<= nstate;

reg					pre_is_blk	= 1'b1;
reg					reset_fifo;
reg					loadaddr;
reg [ADDR_BITS-1:0]	address;

always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin			//

	end else begin
		case(nstate)
		PIX1:	f64_p1		<= de? indata			: f64_p1;
		PIX2:	f64_p2		<= de? indata			: f64_p2;
		PIX3:begin
				f64_p3		<= de? indata[23:8]		: f64_p3;
				s64_p1		<= de? indata[7:0]		: s64_p1;
		end
		PIX4:	s64_p2		<= de? indata			: s64_p2;
		PIX5:	s64_p3		<= de? indata			: s64_p3;
		PIX6:begin
				s64_p4		<= de? indata[23:16]	: s64_p4;
				t64_p1		<= de? indata[15:0]		: t64_p1;
		end
		PIX7:	t64_p2		<= de? indata			: t64_p2;
		PIX8:	t64_p3		<= de? indata			: t64_p3;
		default:;
		endcase
end end


always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		reset_fifo		<= 1'b0;
		loadaddr		<= 1'b0;
		address			<= {ADDR_BITS{1'b0}};
	end else begin
		reset_fifo		<= 1'b0;
		loadaddr		<= 1'b0;
		address			<= address;
		case(nstate)
		FRAME:begin
			reset_fifo		<= 1'b1;
			loadaddr		<= 1'b1;
//			address			<= baseaddr;
			address			<= sync_baseaddr;
		end
		default:;
		endcase
end end

reg		wr_first_reg	;
reg		wr_second_reg   ;
reg		wr_third_reg	;

always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		pre_is_blk		<= 1'b1;
		wr_first_reg	<= 1'b0;
		wr_second_reg	<= 1'b0;
		wr_third_reg	<= 1'b0;
	end else begin
		wr_first_reg	<= 1'b0;
		wr_second_reg	<= 1'b0;
		wr_third_reg	<= 1'b0;
		case(nstate)
		IDLE:;
		BLKPIX:	pre_is_blk		<= 1'b1;
		PIX1:	pre_is_blk		<= 1'b0;
		PIX3:	wr_first_reg	<= de;
		PIX6:	wr_second_reg	<= de;
		PIX8:begin
				wr_third_reg	<= de;
				pre_is_blk		<= 1'b0;
		end
		FEND:	;
		default:;
		endcase
end end

reg		wr_tail_first;
reg		wr_tail_second;
reg		wr_tail_third;
always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		wr_tail_first	<= 1'b0;
		wr_tail_second	<= 1'b0;
		wr_tail_third	<= 1'b0;
	end else begin
		wr_tail_first	<= 1'b0;
		wr_tail_second	<= 1'b0;
		wr_tail_third	<= 1'b0;
		case(pstate)
		PIX1,PIX2:		wr_tail_first	<= nstate == LEND;
		PIX3,PIX4,PIX5:	wr_tail_second	<= nstate == LEND;
		PIX6,PIX7:		wr_tail_third	<= nstate == LEND;
		default:	;
		endcase
end end

always@(posedge pclk,negedge prst_n)begin:BROADEN_BLCOK
reg	[3:0]	cnt;
	if(~prst_n)begin
		cnt				<= 4'd0;
		broaden_req_fsh	<= 1'b0;
	end else begin
		broaden_req_fsh	<= cnt > 4'd4;
		case(nstate)
		FRAME:	cnt		<= cnt + 1'b1;
		default:cnt		<= 4'd0;
		endcase
end end

always@(posedge pclk,negedge prst_n)begin:LINE_CNT_BLCOK
reg	[11:0]	col_cnt;
	if(~prst_n)begin
		col_cnt			<= 4'd0;
		line_enough		<= 1'b0;
	end else begin
		line_enough		<= col_cnt >= (sync_height - 1'b1);		//if this is last line
		case(nstate)
		IDLE,FRAME,FEND:
					col_cnt	<= 12'd0;
		LEND:		col_cnt	<= col_cnt + 1'b1;
		default:;
		endcase
end end

//------<< STATE >>----------

reg	[63:0]		outdata;
reg				ovalid;

always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		outdata	<= 64'd0;
		ovalid	<= 1'b0;
	end else begin
		ovalid	<= 	wr_first_reg || wr_second_reg || wr_third_reg ||
					wr_tail_first||wr_tail_second || wr_tail_third ;
		if(wr_first_reg || wr_tail_first)
				outdata	<= {f64_p1,f64_p2,f64_p3};
		else if (wr_second_reg || wr_tail_second)
				outdata	<= {s64_p1,s64_p2,s64_p3,s64_p4};
		else if (wr_third_reg || wr_tail_third)
				outdata	<= {t64_p1,t64_p2,t64_p3};
		else 	outdata	<= 64'd0;
end end

//--- set IO

assign	wr_fifo_en		= ovalid;
assign	wr_data			= outdata;
assign	arst_fifo		= reset_fifo;
assign	loadbase		= loadaddr;
assign	ddr_baseaddr	= address;
assign	ddr_line_length	= calu_len;
assign	ddr_col_length	= sync_height;
endmodule
