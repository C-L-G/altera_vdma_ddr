/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
Version: VERA.1.0 : 2015/8/25 15:25:13
	create 'start_state_flag'
creaded: 2015/6/8 16:25:41
madified:
***********************************************/
`timescale 1ns/1ps
module video16bit_out_discontinuous #(
	parameter	ADDR_BITS	= 25
)(
	//-- video interface----
	input						pclk,
	input						prst_n,
	input						invsync,
	input						inhsync,
	input						inde,
	output						outvsync,
	output						outhsync,
	output						outde,
	output						out_valid,
	output[15:0]				outdata,
	input [23:0]				video_width,
	input [11:0]				video_height,
	input [ADDR_BITS-1:0]		video_baseaddr,
	output						fifo_empty,
	// ddr mem ctrl interface --
	output						rd_req,
	input [63:0]				rd_data,
	output						rd_data_en,
	output[ADDR_BITS-1:0]		baseaddr,
	output[23:0]				ddr_line_length,
	output[11:0]				ddr_col_length,
	input						sync_fifo_empty,  	// it is alreay in the field of 'pclk'
	output						req_end
);
//wire		vblk	= 1'b0;
assign		fifo_empty		= sync_fifo_empty;
wire		fifo_empty_d2;	//empty signal may be ahead of 2 clock relato data
cross_clk_sync #(
	.DSIZE    	(1),
	.LAT		(2)
)cross_fifo_daley(
	pclk,
	prst_n,
	sync_fifo_empty,
	fifo_empty_d2
);


wire			vsync_raising,vsync_falling;

edge_generator #(
	.MODE	("NORMAL")   // FAST NORMAL BEST
)edge_generator_inst(
	.clk		(pclk         ),
	.rst_n      (prst_n       ),
	.in         (invsync      ),
	.raising    (vsync_raising),
	.falling    (vsync_falling)
);

reg [ADDR_BITS-1:0]	sync_video_baseaddr;
always@(posedge pclk,negedge prst_n)
	if(~prst_n)		sync_video_baseaddr	<= video_baseaddr;
//	else if(vsync_falling)
	else if(invsync)
					sync_video_baseaddr	<= video_baseaddr;
	else			sync_video_baseaddr	<= sync_video_baseaddr;


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

reg				line_enough;
reg				one_line_end;

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
	FRAME:	nstate	= BLKPIX;
	BLKPIX: if(inde)	nstate	= PIX1;	else	nstate	= BLKPIX;
	PIX1:	if(inde)	nstate	= PIX2;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX1;
	PIX2:	if(inde)	nstate	= PIX3;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX2;
	PIX3:	if(inde)	nstate	= PIX4;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX3;
	PIX4:	if(inde)	nstate	= PIX1;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX4;
	PIX5:	if(inde)	nstate	= PIX6;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX5;
	PIX6:	if(inde)	nstate	= PIX7;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX6;
	PIX7:	if(inde)	nstate	= PIX8;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX7;
	PIX8:	if(inde)	nstate	= PIX1;	else if(one_line_end)	nstate	= LEND; else nstate	= PIX8;
	LEND:	if(line_enough)				nstate	= FEND;	else	nstate	= BLKPIX;
	FEND:	nstate	= FEND;
	default:nstate	= IDLE;
	endcase

//----->> COLUMN LENGTH <<-----------
reg [23:0]		sync_width;

always@(posedge pclk,negedge prst_n)
	if(~prst_n)	sync_width	<= 24'd0;
	else if(invsync)
				sync_width	<= video_width;
	else		sync_width	<= sync_width;


reg [11:0]					col_length;
reg	[11:0]					ddr_width_len;
always@(posedge pclk,negedge prst_n)
	if(~prst_n)	col_length	<= 12'd0;
	else if(invsync)
				col_length	<= video_height;
	else		col_length	<= col_length;

always@(posedge pclk,negedge prst_n)
	if(~prst_n)	ddr_width_len	<= 12'd0;
	else	ddr_width_len	<= sync_width/4 + (|sync_width[1:0]);	//false path


//always@(posedge pclk,negedge prst_n)begin:COLUMN_COUNTER
//reg [11:0]		width_cnt;
//	if(~prst_n)begin
//		width_cnt		<= 12'd0;
//		one_line_end	<= 1'b0;
//	end else if(invsync)begin
//		width_cnt		<= 12'd0;
//		one_line_end	<= 1'b0;
//	end else begin
//		if(width_cnt >= sync_width)begin
//					width_cnt	<= 12'd0;
//		end else begin
//			if(inde)	width_cnt	<= width_cnt + 1'b1;
//			else		width_cnt	<= width_cnt;
//		end
//		one_line_end	<= width_cnt == sync_width;
//end end

always@(posedge pclk,negedge prst_n)begin:COLUMN_COUNTER
reg [11:0]		width_cnt;
reg             almost_full,full;
	if(~prst_n)begin
		width_cnt		<= 12'd0;
		one_line_end	<= 1'b0;
        almost_full     <= 1'b0;
        full            <= 1'b0;
	end else if(invsync)begin
		width_cnt		<= 12'd0;
		one_line_end	<= 1'b0;
        almost_full     <= 1'b0;
        full            <= 1'b0;
	end else begin
        almost_full     <= width_cnt >= (sync_width-1'b1);
        full            <= width_cnt >= sync_width;
		if(full)begin
					width_cnt	<= 12'd0;
		end else begin
			if(inde)begin
            	if(almost_full)
                        width_cnt	<= 12'd0;
                else    width_cnt	<= width_cnt + 1'b1;
			end else    width_cnt	<= width_cnt;
		end
		one_line_end	<= width_cnt == sync_width;
end end

//-----<< COLUMN LENGTH >>-----------
reg							read_req	;
reg [23:0]			     	dlength	;
reg [ADDR_BITS-1:0]      	base_addr	;
reg							read_req_end;

always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		read_req	<= 1'b0;
		dlength		<= {24{1'b0}};
		base_addr	<= {ADDR_BITS{1'b0}};
		read_req_end<= 1'b0;
	end else begin
		read_req	<= 1'b0;
		read_req_end<= 1'b0;
//		base_addr	<= video_baseaddr;
		base_addr	<= base_addr;
		dlength		<= ddr_width_len;
	case(nstate)
	FRAME:begin
		read_req	<= 1'b1;
		read_req_end<= 1'b0;
		base_addr	<= sync_video_baseaddr;
	end
	FEND:begin
		read_req_end<= 1'b1;
	end
	default:;
	endcase
end end

always@(posedge pclk,negedge prst_n)begin:COLUMN_CNT
reg [11:0]		col_cnt;
	if(~prst_n)begin
		col_cnt		<= 12'd0;
		line_enough	<= 1'b0;
	end else begin
		line_enough	<= col_cnt >= (col_length - 1'b1); //if this is last line
		case(nstate)
		IDLE,FRAME:	col_cnt	<= 12'd0;
		LEND:		col_cnt	<= col_cnt + 1'b1;
		default:;
		endcase
end end

reg		read_data_en;

always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		read_data_en		<= 1'b0;
	end else begin
		read_data_en		<= 1'b0;
		case(nstate)
		PIX1:	read_data_en		<= inde;
		default:;
		endcase
end end

reg [3:0]		next_state [3:1];
always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		next_state[1]	<= IDLE;
		next_state[2]	<= IDLE;
		next_state[3]	<= IDLE;
	end else begin
		next_state[1]	<= nstate;
		next_state[2]	<= next_state[1];
		next_state[3]	<= next_state[2];
end end

reg [63:0]		data_buf;

always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		data_buf	<= 64'd0;
	end else begin
		case(next_state[2])		//data latency 2 clock
		PIX1:	data_buf	<= rd_data;
		default:;
		endcase
end end

reg				data_vld;
always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		data_vld	<= 1'b0;
	end else begin
	//empty maybe dont go ahead of data. Should think about that
		case(next_state[2])
		PIX1:		data_vld	<= !fifo_empty_d2;
		PIX2,PIX3,PIX4:
					data_vld	<= data_vld;
		default:	data_vld	<= 1'b0;
		endcase

end end


wire			cp_de;

cross_clk_sync #(
	.DSIZE    	(1),
	.LAT		(3)
)latency_de_sync(
	pclk,
	prst_n,
	inde,
	cp_de
);
reg [15:0]		cp_data;

always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)begin
		cp_data	<= 16'd0;
	end else begin
		cp_data	<= 16'd0;
		if(cp_de && !read_req)
			case(next_state[3])
			PIX1:	cp_data	<= data_buf[48+:16];
			PIX2:	cp_data	<= data_buf[32+:16];
			PIX3:	cp_data	<= data_buf[16+:16];
			PIX4:	cp_data	<= data_buf[ 0+:16];
			default:;
			endcase
		else		cp_data	<= 16'd0;
end end

reg				cp_vld;
always@(posedge pclk,negedge prst_n)begin
	if(~prst_n)	cp_vld	<= 1'b0;
	else begin
	//	cp_vld	<= 1'b0;
		if(cp_de)
			case(next_state[3])
			PIX1:	cp_vld	<= data_vld;
			PIX2:	cp_vld	<= data_vld;
			PIX3:	cp_vld	<= data_vld;
			PIX4:	cp_vld	<= data_vld;
			default:;
			endcase
		else		cp_vld	<= 1'b0;
end end



cross_clk_sync #(
	.DSIZE    	(3),
	.LAT		(4)
)latency_sync(
	pclk,
	prst_n,
	{invsync,inhsync,inde},
	{outvsync,outhsync,outde}
);

//assign	outde		= read_data_en;
assign	rd_data_en	= read_data_en	;
assign	outdata		= cp_data     	;
assign	out_valid	= cp_vld		;


assign	rd_req			= read_req	;
//assign	baseaddr		= base_addr	;
assign	baseaddr		= sync_video_baseaddr;
assign	ddr_line_length	= dlength	;
assign	req_end			= read_req_end;
assign	ddr_col_length	= col_length;

endmodule
