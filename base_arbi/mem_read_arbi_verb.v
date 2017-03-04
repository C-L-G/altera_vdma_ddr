/*读仲裁模块，使用轮训方式仲裁，清晰易懂*/
module mem_read_arbi_verb
#(
	parameter 	MEM_DATA_BITS 	= 32,
	parameter 	ADDR_BITS		= 25,
	parameter	PINTS			= 8
)
(
	input 						rst_n,
	input 						mem_clk,
	input 						ch0_rd_burst_req,
	input[9:0] 					ch0_rd_burst_len,
	input[ADDR_BITS-1:0] 		ch0_rd_burst_addr,
	output 						ch0_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch0_rd_burst_data,
	output 						ch0_rd_burst_finish,
	
	input 						ch1_rd_burst_req,
	input[9:0] 					ch1_rd_burst_len,
	input[ADDR_BITS-1:0] 		ch1_rd_burst_addr,
	output 						ch1_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch1_rd_burst_data,
	output 						ch1_rd_burst_finish,
	
	input 						ch2_rd_burst_req,
	input[9:0] 					ch2_rd_burst_len,
	input[ADDR_BITS-1:0] 		ch2_rd_burst_addr,
	output 						ch2_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch2_rd_burst_data,
	output 						ch2_rd_burst_finish,
	
	input 						ch3_rd_burst_req,
	input[9:0] 					ch3_rd_burst_len,
	input[ADDR_BITS-1:0] 		ch3_rd_burst_addr,
	output 						ch3_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch3_rd_burst_data,
	output 						ch3_rd_burst_finish,

	input 						ch4_rd_burst_req,
	input[9:0] 					ch4_rd_burst_len,
	input[ADDR_BITS-1:0] 		ch4_rd_burst_addr,
	output 						ch4_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch4_rd_burst_data,
	output 						ch4_rd_burst_finish,
	
	input 						ch5_rd_burst_req,
	input[9:0] 					ch5_rd_burst_len,
	input[ADDR_BITS-1:0] 		ch5_rd_burst_addr,
	output 						ch5_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch5_rd_burst_data,
	output 						ch5_rd_burst_finish,
	
	input 						ch6_rd_burst_req,
	input[9:0] 					ch6_rd_burst_len,
	input[ADDR_BITS-1:0] 		ch6_rd_burst_addr,
	output 						ch6_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch6_rd_burst_data,
	output 						ch6_rd_burst_finish,
	
	input 						ch7_rd_burst_req,
	input[9:0] 					ch7_rd_burst_len,
	input[ADDR_BITS-1:0] 		ch7_rd_burst_addr,
	output 						ch7_rd_burst_data_valid,
	output[MEM_DATA_BITS - 1:0] ch7_rd_burst_data,
	output 						ch7_rd_burst_finish,
	///////////////////////////////////////////
	output reg 					rd_burst_req,
	output reg[9:0] 			rd_burst_len,
	output reg[ADDR_BITS-1:0] 	rd_burst_addr,
	input 						rd_burst_data_valid,
	input[MEM_DATA_BITS - 1:0] 	rd_burst_data,
	input 						rd_burst_finish	
);

reg[6:0] read_state = 7'd0;
reg[6:0] read_state_next = 7'd0;
reg[15:0] cnt_timer = 15'd0;
localparam IDLE = 6'd0;

localparam CH0_CHECK 	= 7'd1;
localparam CH0_BEGIN 	= 7'd2;
localparam CH0_READ 	= 7'd3;
localparam CH0_END 		= 7'd4;

localparam CH1_CHECK 	= 7'd5;
localparam CH1_BEGIN 	= 7'd6;
localparam CH1_READ 	= 7'd7;
localparam CH1_END 		= 7'd8;

localparam CH2_CHECK 	= 7'd9;
localparam CH2_BEGIN 	= 7'd10;
localparam CH2_READ		= 7'd11;
localparam CH2_END 		= 7'd12;

localparam CH3_CHECK 	= 7'd13;
localparam CH3_BEGIN 	= 7'd14;
localparam CH3_READ 	= 7'd15;
localparam CH3_END 		= 7'd16;

localparam CH4_CHECK 	= 7'd1+7'd16;
localparam CH4_BEGIN 	= 7'd2+7'd16;
localparam CH4_READ 	= 7'd3+7'd16;
localparam CH4_END 		= 7'd4+7'd16;

localparam CH5_CHECK 	= 6'd5+7'd16;
localparam CH5_BEGIN 	= 6'd6+7'd16;
localparam CH5_READ 	= 6'd7+7'd16;
localparam CH5_END 		= 6'd8+7'd16;

localparam CH6_CHECK 	= 6'd9 +7'd16;
localparam CH6_BEGIN 	= 6'd10+7'd16;
localparam CH6_READ 	= 6'd11+7'd16;
localparam CH6_END 		= 6'd12+7'd16;

localparam CH7_CHECK 	= 6'd13+7'd16;
localparam CH7_BEGIN 	= 6'd14+7'd16;
localparam CH7_READ 	= 6'd15+7'd16;
localparam CH7_END 		= 6'd16+7'd16;


always@(posedge mem_clk or negedge rst_n)
begin
	if(~rst_n)
		read_state <= IDLE;
	else if(cnt_timer > 16'd8000)
		read_state <= IDLE;
	else
		read_state <= read_state_next;
end

always@(posedge mem_clk or negedge rst_n)
begin
	if(~rst_n)
		cnt_timer <= 16'd0;
	else if(read_state == CH0_CHECK)
		cnt_timer <= 16'd0;
	else
		cnt_timer <= cnt_timer + 16'd1;
end

always@(*)
begin
	case(read_state)
		IDLE:
			read_state_next <= CH0_CHECK;
		//-------->> 0-3 <<----------
		CH0_CHECK:
			if(ch0_rd_burst_req && ch0_rd_burst_len != 10'd0)
				read_state_next <= CH0_BEGIN;
			else
				read_state_next <= CH1_CHECK;
		CH0_BEGIN:
			read_state_next <= CH0_READ;
		CH0_READ:
			if(rd_burst_finish)
				read_state_next <= CH0_END;
			else
				read_state_next <= CH0_READ;
		CH0_END:
			read_state_next <= CH1_CHECK;
		//	
		CH1_CHECK:
			if(ch1_rd_burst_req && ch1_rd_burst_len != 10'd0)
				read_state_next <= CH1_BEGIN;
			else
				read_state_next <= (PINTS!=2)? CH2_CHECK : CH0_CHECK;
		CH1_BEGIN:
			read_state_next <= CH1_READ;
		CH1_READ:
			if(rd_burst_finish)
				read_state_next <= CH1_END;
			else
				read_state_next <= CH1_READ;
		CH1_END:
			read_state_next <= (PINTS!=2)? CH2_CHECK : CH0_CHECK;
		//	
		CH2_CHECK:
			if(ch2_rd_burst_req  && ch2_rd_burst_len != 10'd0)
				read_state_next <= CH2_BEGIN;
			else
				read_state_next <= (PINTS!=3)? CH3_CHECK : CH0_CHECK;
		CH2_BEGIN:
			read_state_next <= CH2_READ;
		CH2_READ:
			if(rd_burst_finish)
				read_state_next <= CH2_END;
			else
				read_state_next <= CH2_READ;
		CH2_END:
			read_state_next <= (PINTS!=3)? CH3_CHECK : CH0_CHECK;
		//	
		CH3_CHECK:
			if(ch3_rd_burst_req  && ch3_rd_burst_len != 10'd0)
				read_state_next <= CH3_BEGIN;
			else
				read_state_next <= (PINTS!=4)? CH4_CHECK : CH0_CHECK;
		CH3_BEGIN:
			read_state_next <= CH3_READ;
		CH3_READ:
			if(rd_burst_finish)
				read_state_next <= CH3_END;
			else
				read_state_next <= CH3_READ;
		CH3_END:
			read_state_next <= (PINTS!=4)? CH4_CHECK : CH0_CHECK;	
		//----<< 0 - 3>> -----	
		//-------->> 4 - 7 <<----------
		CH4_CHECK:
			if(ch4_rd_burst_req && ch4_rd_burst_len != 10'd0)
				read_state_next <= CH4_BEGIN;
			else
				read_state_next <= (PINTS!=5)? CH5_CHECK : CH0_CHECK;
		CH4_BEGIN:
			read_state_next <= CH4_READ;
		CH4_READ:
			if(rd_burst_finish)
				read_state_next <= CH4_END;
			else
				read_state_next <= CH4_READ;
		CH4_END:
			read_state_next <= (PINTS!=5)? CH5_CHECK : CH0_CHECK;
		//	
		CH5_CHECK:
			if(ch5_rd_burst_req && ch5_rd_burst_len != 10'd0)
				read_state_next <= CH5_BEGIN;
			else
				read_state_next <= (PINTS!=6)? CH6_CHECK : CH0_CHECK;
		CH5_BEGIN:
			read_state_next <= CH5_READ;
		CH5_READ:
			if(rd_burst_finish)
				read_state_next <= CH5_END;
			else
				read_state_next <= CH5_READ;
		CH5_END:
			read_state_next <= (PINTS!=6)? CH6_CHECK : CH0_CHECK;
		//	
		CH6_CHECK:
			if(ch6_rd_burst_req  && ch6_rd_burst_len != 10'd0)
				read_state_next <= CH6_BEGIN;
			else
				read_state_next <= (PINTS!=7)? CH7_CHECK : CH0_CHECK;
		CH6_BEGIN:
			read_state_next <= CH6_READ;
		CH6_READ:
			if(rd_burst_finish)
				read_state_next <= CH6_END;
			else
				read_state_next <= CH6_READ;
		CH6_END:
			read_state_next <= (PINTS!=7)? CH7_CHECK : CH0_CHECK;
		//	
		CH7_CHECK:
			if(ch7_rd_burst_req  && ch7_rd_burst_len != 10'd0)
				read_state_next <= CH7_BEGIN;
			else
				read_state_next <= CH0_CHECK;
		CH7_BEGIN:
			read_state_next <= CH7_READ;
		CH7_READ:
			if(rd_burst_finish)
				read_state_next <= CH7_END;
			else
				read_state_next <= CH7_READ;
		CH7_END:
			read_state_next <= CH0_CHECK;	
		//----<< 4 - 7>> -----	
		default:
			read_state_next <= IDLE;
	endcase
end

always@(posedge mem_clk or negedge rst_n)
begin
	if(~rst_n)
		begin
			rd_burst_len <= 10'd0;
			rd_burst_addr <= {ADDR_BITS{1'b0}};  
		end
	else
		begin
			case(read_state)
				CH0_BEGIN:
					begin
						rd_burst_len <= ch0_rd_burst_len;
						rd_burst_addr <= ch0_rd_burst_addr;
					end
				CH1_BEGIN:
					begin
						rd_burst_len <= ch1_rd_burst_len;
						rd_burst_addr <= ch1_rd_burst_addr;
					end
				CH2_BEGIN:
					begin
						rd_burst_len <= ch2_rd_burst_len;
						rd_burst_addr <= ch2_rd_burst_addr;
					end
				CH3_BEGIN:
					begin
						rd_burst_len <= ch3_rd_burst_len;
						rd_burst_addr <= ch3_rd_burst_addr;
					end
				CH4_BEGIN:
					begin
						rd_burst_len <= ch4_rd_burst_len;
						rd_burst_addr <= ch4_rd_burst_addr;
					end
				CH5_BEGIN:
					begin
						rd_burst_len <= ch5_rd_burst_len;
						rd_burst_addr <= ch5_rd_burst_addr;
					end
				CH6_BEGIN:
					begin
						rd_burst_len <= ch6_rd_burst_len;
						rd_burst_addr <= ch6_rd_burst_addr;
					end
				CH7_BEGIN:
					begin
						rd_burst_len <= ch7_rd_burst_len;
						rd_burst_addr <= ch7_rd_burst_addr;
					end
				default:
					begin
						rd_burst_len <= rd_burst_len;
						rd_burst_addr <= rd_burst_addr;
					end
			endcase
		end
end

always@(posedge mem_clk or negedge rst_n)
begin
	if(~rst_n)
		rd_burst_req <= 1'b0;
	else if(read_state == 	CH0_BEGIN || read_state == CH1_BEGIN || read_state == CH2_BEGIN || read_state == CH3_BEGIN ||
			read_state ==	CH4_BEGIN || read_state == CH5_BEGIN || read_state == CH6_BEGIN || read_state == CH7_BEGIN)
		rd_burst_req <= 1'b1;
	else if(rd_burst_data_valid || read_state == CH0_CHECK  || read_state == CH1_CHECK  
								|| read_state == CH2_CHECK  || read_state == CH3_CHECK
								|| read_state == CH4_BEGIN  || read_state == CH5_BEGIN 
								|| read_state == CH6_BEGIN  || read_state == CH7_BEGIN)
		rd_burst_req <= 1'b0;
	else
		rd_burst_req <= rd_burst_req;
end
//---->> 0 -3 <<----
assign ch0_rd_burst_finish = (read_state == CH0_END);
assign ch1_rd_burst_finish = (read_state == CH1_END);
assign ch2_rd_burst_finish = (read_state == CH2_END);
assign ch3_rd_burst_finish = (read_state == CH3_END);

assign ch0_rd_burst_data_valid = (read_state == CH0_READ || read_state == CH0_END) ? rd_burst_data_valid : 1'b0;
assign ch1_rd_burst_data_valid = (read_state == CH1_READ || read_state == CH1_END) ? rd_burst_data_valid : 1'b0;
assign ch2_rd_burst_data_valid = (read_state == CH2_READ || read_state == CH2_END) ? rd_burst_data_valid : 1'b0;
assign ch3_rd_burst_data_valid = (read_state == CH3_READ || read_state == CH3_END) ? rd_burst_data_valid : 1'b0;

assign ch0_rd_burst_data = (read_state == CH0_READ) ? rd_burst_data : {MEM_DATA_BITS{1'd0}};
assign ch1_rd_burst_data = (read_state == CH1_READ) ? rd_burst_data : {MEM_DATA_BITS{1'd0}};
assign ch2_rd_burst_data = (read_state == CH2_READ) ? rd_burst_data : {MEM_DATA_BITS{1'd0}};
assign ch3_rd_burst_data = (read_state == CH3_READ) ? rd_burst_data : {MEM_DATA_BITS{1'd0}};
//------<< 0 - 3 >>----
//------>> 4 - 7 <<---- 
assign ch4_rd_burst_finish = (read_state == CH4_END);
assign ch5_rd_burst_finish = (read_state == CH5_END);
assign ch6_rd_burst_finish = (read_state == CH6_END);
assign ch7_rd_burst_finish = (read_state == CH7_END);

assign ch4_rd_burst_data_valid = (read_state == CH4_READ || read_state == CH4_END) ? rd_burst_data_valid : 1'b0;
assign ch5_rd_burst_data_valid = (read_state == CH5_READ || read_state == CH5_END) ? rd_burst_data_valid : 1'b0;
assign ch6_rd_burst_data_valid = (read_state == CH6_READ || read_state == CH6_END) ? rd_burst_data_valid : 1'b0;
assign ch7_rd_burst_data_valid = (read_state == CH7_READ || read_state == CH7_END) ? rd_burst_data_valid : 1'b0;

assign ch4_rd_burst_data = (read_state == CH4_READ) ? rd_burst_data : {MEM_DATA_BITS{1'd0}};
assign ch5_rd_burst_data = (read_state == CH5_READ) ? rd_burst_data : {MEM_DATA_BITS{1'd0}};
assign ch6_rd_burst_data = (read_state == CH6_READ) ? rd_burst_data : {MEM_DATA_BITS{1'd0}};
assign ch7_rd_burst_data = (read_state == CH7_READ) ? rd_burst_data : {MEM_DATA_BITS{1'd0}};
//------<< 4 - 7 >>----
endmodule 