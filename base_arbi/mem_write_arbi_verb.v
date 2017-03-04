/*写仲裁模块，使用轮训方式仲裁，清晰易懂*/
module mem_write_arbi_verb
#(
	parameter MEM_DATA_BITS = 32,
	parameter ADDR_BITS		= 25,
	parameter PINTS			= 8	
)
(
	input rst_n,
	input mem_clk,
	
	input 							ch0_wr_burst_req,
	input[9:0] 						ch0_wr_burst_len,
	input[ADDR_BITS-1:0] 			ch0_wr_burst_addr,
	output 							ch0_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 		ch0_wr_burst_data,
	output 							ch0_wr_burst_finish,
	
	input 							ch1_wr_burst_req,
	input[9:0] 						ch1_wr_burst_len,
	input[ADDR_BITS-1:0] 			ch1_wr_burst_addr,
	output 							ch1_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 		ch1_wr_burst_data,
	output 							ch1_wr_burst_finish,
	
	input 							ch2_wr_burst_req,
	input[9:0] 						ch2_wr_burst_len,
	input[ADDR_BITS-1:0] 			ch2_wr_burst_addr,
	output 							ch2_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 		ch2_wr_burst_data,
	output 							ch2_wr_burst_finish,
	
	input 							ch3_wr_burst_req,
	input[9:0] 						ch3_wr_burst_len,
	input[ADDR_BITS-1:0] 			ch3_wr_burst_addr,
	output 							ch3_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 		ch3_wr_burst_data,
	output 							ch3_wr_burst_finish,

	input 							ch4_wr_burst_req,
	input[9:0] 						ch4_wr_burst_len,
	input[ADDR_BITS-1:0] 			ch4_wr_burst_addr,
	output 							ch4_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 		ch4_wr_burst_data,
	output 							ch4_wr_burst_finish,
	
	input 							ch5_wr_burst_req,
	input[9:0] 						ch5_wr_burst_len,
	input[ADDR_BITS-1:0] 			ch5_wr_burst_addr,
	output 							ch5_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 		ch5_wr_burst_data,
	output 							ch5_wr_burst_finish,
	
	input 							ch6_wr_burst_req,
	input[9:0] 						ch6_wr_burst_len,
	input[ADDR_BITS-1:0] 			ch6_wr_burst_addr,
	output 							ch6_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 		ch6_wr_burst_data,
	output 							ch6_wr_burst_finish,
	
	input 							ch7_wr_burst_req,
	input[9:0] 						ch7_wr_burst_len,
	input[ADDR_BITS-1:0] 			ch7_wr_burst_addr,
	output 							ch7_wr_burst_data_req,
	input[MEM_DATA_BITS - 1:0] 		ch7_wr_burst_data,
	output 							ch7_wr_burst_finish,
	
	output reg 						wr_burst_req,
	output reg[9:0] 				wr_burst_len,
	output reg[ADDR_BITS-1:0] 		wr_burst_addr,
	input 							wr_burst_data_req,
	output reg[MEM_DATA_BITS - 1:0] wr_burst_data,
	input							wr_burst_finish	
);

reg[6:0] write_state = 7'd0;
reg[6:0] write_state_next = 7'd0;
reg[15:0] cnt_timer = 16'd0;
localparam IDLE = 6'd0;

localparam CH0_CHECK 	= 6'd1;
localparam CH0_BEGIN 	= 6'd2;
localparam CH0_WRITE 	= 6'd3;
localparam CH0_END 		= 6'd4;

localparam CH1_CHECK 	= 6'd5;
localparam CH1_BEGIN 	= 6'd6;
localparam CH1_WRITE 	= 6'd7;
localparam CH1_END 		= 6'd8;

localparam CH2_CHECK 	= 6'd9;
localparam CH2_BEGIN 	= 6'd10;
localparam CH2_WRITE 	= 6'd11;
localparam CH2_END 		= 6'd12;

localparam CH3_CHECK 	= 6'd13;
localparam CH3_BEGIN 	= 6'd14;
localparam CH3_WRITE 	= 6'd15;
localparam CH3_END 		= 6'd16;

localparam CH4_CHECK 	= 6'd1+7'd16;
localparam CH4_BEGIN 	= 6'd2+7'd16;
localparam CH4_WRITE 	= 6'd3+7'd16;
localparam CH4_END 		= 6'd4+7'd16;

localparam CH5_CHECK 	= 6'd5+7'd16;
localparam CH5_BEGIN 	= 6'd6+7'd16;
localparam CH5_WRITE 	= 6'd7+7'd16;
localparam CH5_END 		= 6'd8+7'd16;

localparam CH6_CHECK 	= 6'd9 +7'd16;
localparam CH6_BEGIN 	= 6'd10+7'd16;
localparam CH6_WRITE 	= 6'd11+7'd16;
localparam CH6_END 		= 6'd12+7'd16;

localparam CH7_CHECK 	= 6'd13+7'd16;
localparam CH7_BEGIN 	= 6'd14+7'd16;
localparam CH7_WRITE 	= 6'd15+7'd16;
localparam CH7_END 		= 6'd16+7'd16;

reg wr_burst_finish_d0;
reg wr_burst_finish_d1;
always@(posedge mem_clk)
begin
	wr_burst_finish_d0 <= wr_burst_finish;
	wr_burst_finish_d1 <= wr_burst_finish_d0;
end

always@(posedge mem_clk or negedge rst_n)
begin
	if(~rst_n)
		write_state <= IDLE;
	else if(cnt_timer > 16'd8000)
		write_state <= IDLE;
	else
		write_state <= write_state_next;
end

always@(posedge mem_clk or negedge rst_n)
begin
	if(~rst_n)
		cnt_timer <= 16'd0;
	else if(write_state == CH0_CHECK)
		cnt_timer <= 16'd0;
	else
		cnt_timer <= cnt_timer + 16'd1;
end

always@(*)
begin
	case(write_state)
		IDLE:
			write_state_next <= CH0_CHECK;
		//---->> 0 - 3 <<---
		CH0_CHECK:
			if(ch0_wr_burst_req  && ch0_wr_burst_len != 10'd0)
				write_state_next <= CH0_BEGIN;
			else
				write_state_next <= CH1_CHECK;
		CH0_BEGIN:
			write_state_next <= CH0_WRITE;
		CH0_WRITE:
			if(wr_burst_finish_d1)
				write_state_next <= CH0_END;
			else
				write_state_next <= CH0_WRITE;
		CH0_END:
			write_state_next <= CH1_CHECK;
		//	
		CH1_CHECK:
			if(ch1_wr_burst_req && ch1_wr_burst_len != 10'd0)
				write_state_next <= CH1_BEGIN;
			else
				write_state_next <= (PINTS!=2)? CH2_CHECK : CH0_CHECK;
		CH1_BEGIN:
			write_state_next <= CH1_WRITE;
		CH1_WRITE:
			if(wr_burst_finish_d1)
				write_state_next <= CH1_END;
			else
				write_state_next <= CH1_WRITE;
		CH1_END:
			write_state_next <= (PINTS!=2)? CH2_CHECK : CH0_CHECK;
		//	
		CH2_CHECK:
			if(ch2_wr_burst_req && ch2_wr_burst_len != 10'd0)
				write_state_next <= CH2_BEGIN;
			else
				write_state_next <= (PINTS!=3)? CH3_CHECK : CH0_CHECK;
		CH2_BEGIN:
			write_state_next <= CH2_WRITE;
		CH2_WRITE:
			if(wr_burst_finish_d1)
				write_state_next <= CH2_END;
			else
				write_state_next <= CH2_WRITE;
		CH2_END:
			write_state_next <= (PINTS!=3)? CH3_CHECK : CH0_CHECK;
		//	
		CH3_CHECK:
			if(ch3_wr_burst_req && ch3_wr_burst_len != 10'd0)
				write_state_next <= CH3_BEGIN;
			else
				write_state_next <= (PINTS!=4)? CH4_CHECK : CH0_CHECK;
		CH3_BEGIN:
			write_state_next <= CH3_WRITE;
		CH3_WRITE:
			if(wr_burst_finish_d1)
				write_state_next <= CH3_END;
			else
				write_state_next <= CH3_WRITE;
		CH3_END:
			write_state_next <= (PINTS!=4)? CH4_CHECK : CH0_CHECK;
		//---<< 0 - 3 >>---
		//---->> 0 - 3 <<---
		CH4_CHECK:
			if(ch4_wr_burst_req  && ch4_wr_burst_len != 10'd0)
				write_state_next <= CH4_BEGIN;
			else
				write_state_next <= (PINTS!=5)? CH5_CHECK : CH0_CHECK;
		CH4_BEGIN:
			write_state_next <= CH4_WRITE;
		CH4_WRITE:
			if(wr_burst_finish_d1)
				write_state_next <= CH4_END;
			else
				write_state_next <= CH4_WRITE;
		CH4_END:
			write_state_next <= (PINTS!=5)? CH5_CHECK : CH0_CHECK;
		//	
		CH5_CHECK:
			if(ch5_wr_burst_req && ch5_wr_burst_len != 10'd0)
				write_state_next <= CH5_BEGIN;
			else
				write_state_next <= (PINTS!=6)? CH6_CHECK : CH0_CHECK;
		CH5_BEGIN:
			write_state_next <= CH5_WRITE;
		CH5_WRITE:
			if(wr_burst_finish_d1)
				write_state_next <= CH5_END;
			else
				write_state_next <= CH5_WRITE;
		CH5_END:
			write_state_next <= (PINTS!=6)? CH6_CHECK : CH0_CHECK;
		//	
		CH6_CHECK:
			if(ch6_wr_burst_req && ch6_wr_burst_len != 10'd0)
				write_state_next <= CH6_BEGIN;
			else
				write_state_next <= (PINTS!=7)? CH7_CHECK : CH0_CHECK;
		CH6_BEGIN:
			write_state_next <= CH6_WRITE;
		CH6_WRITE:
			if(wr_burst_finish_d1)
				write_state_next <= CH6_END;
			else
				write_state_next <= CH6_WRITE;
		CH6_END:
			write_state_next <= (PINTS!=7)? CH7_CHECK : CH0_CHECK;
		//	
		CH7_CHECK:
			if(ch7_wr_burst_req && ch7_wr_burst_len != 10'd0)
				write_state_next <= CH7_BEGIN;
			else
				write_state_next <= CH0_CHECK;
		CH7_BEGIN:
			write_state_next <= CH7_WRITE;
		CH7_WRITE:
			if(wr_burst_finish_d1)
				write_state_next <= CH7_END;
			else
				write_state_next <= CH7_WRITE;
		CH7_END:
			write_state_next <= CH0_CHECK;
		//---<< 0 - 3 >>---
		default:
			write_state_next <= IDLE;
	endcase
end

always@(posedge mem_clk or negedge rst_n)
begin
	if(~rst_n)
		begin
			wr_burst_len <= 10'd0;
			wr_burst_addr <= {ADDR_BITS{1'b0}};
		end
	else
		begin
			case(write_state)
				CH0_BEGIN:
					begin
						wr_burst_len <= ch0_wr_burst_len;
						wr_burst_addr <= ch0_wr_burst_addr;
					end
				CH1_BEGIN:
					begin
						wr_burst_len <= ch1_wr_burst_len;
						wr_burst_addr <= ch1_wr_burst_addr;
					end
				CH2_BEGIN:
					begin
						wr_burst_len <= ch2_wr_burst_len;
						wr_burst_addr <= ch2_wr_burst_addr;
					end
				CH3_BEGIN:
					begin
						wr_burst_len <= ch3_wr_burst_len;
						wr_burst_addr <= ch3_wr_burst_addr;
					end				
				CH4_BEGIN:
					begin
						wr_burst_len <= ch4_wr_burst_len;
						wr_burst_addr <= ch4_wr_burst_addr;
					end
				CH5_BEGIN:
					begin
						wr_burst_len <= ch5_wr_burst_len;
						wr_burst_addr <= ch5_wr_burst_addr;
					end
				CH6_BEGIN:
					begin
						wr_burst_len <= ch6_wr_burst_len;
						wr_burst_addr <= ch6_wr_burst_addr;
					end
				CH7_BEGIN:
					begin
						wr_burst_len <= ch7_wr_burst_len;
						wr_burst_addr <= ch7_wr_burst_addr;
					end				
				default:
					begin
						wr_burst_len <= wr_burst_len;
						wr_burst_addr <= wr_burst_addr;
					end
			endcase
		end
end

always@(posedge mem_clk or negedge rst_n)
begin
	if(~rst_n)
		wr_burst_req <= 1'b0;
	else if(	write_state == CH0_BEGIN || write_state == CH1_BEGIN || write_state == CH2_BEGIN || write_state == CH3_BEGIN || 
				write_state == CH4_BEGIN || write_state == CH5_BEGIN || write_state == CH6_BEGIN || write_state == CH7_BEGIN)
		wr_burst_req <= 1'b1;
	else if(wr_burst_data_req)
		wr_burst_req <= 1'b0;
	else
		wr_burst_req <= wr_burst_req;
end
always@(*)
begin
	case(write_state)
		CH0_WRITE:
			wr_burst_data <= ch0_wr_burst_data;
		CH1_WRITE:
			wr_burst_data <= ch1_wr_burst_data;
		CH2_WRITE:
			wr_burst_data <= ch2_wr_burst_data;
		CH3_WRITE:
			wr_burst_data <= ch3_wr_burst_data;
		CH4_WRITE:
			wr_burst_data <= ch4_wr_burst_data;
		CH5_WRITE:
			wr_burst_data <= ch5_wr_burst_data;
		CH6_WRITE:
			wr_burst_data <= ch6_wr_burst_data;
		CH7_WRITE:
			wr_burst_data <= ch7_wr_burst_data;	
		default:
			wr_burst_data <= {MEM_DATA_BITS{1'd0}};
	endcase
end
//--->> 0 - 3 <<----
assign ch0_wr_burst_finish = (write_state == CH0_END);
assign ch1_wr_burst_finish = (write_state == CH1_END);
assign ch2_wr_burst_finish = (write_state == CH2_END);
assign ch3_wr_burst_finish = (write_state == CH3_END);

assign ch0_wr_burst_data_req = (write_state == CH0_WRITE) ? wr_burst_data_req : 1'b0;
assign ch1_wr_burst_data_req = (write_state == CH1_WRITE) ? wr_burst_data_req : 1'b0;
assign ch2_wr_burst_data_req = (write_state == CH2_WRITE) ? wr_burst_data_req : 1'b0;
assign ch3_wr_burst_data_req = (write_state == CH3_WRITE) ? wr_burst_data_req : 1'b0;
//--->> 4 - 7 <<----
assign ch4_wr_burst_finish = (write_state == CH4_END);
assign ch5_wr_burst_finish = (write_state == CH5_END);
assign ch6_wr_burst_finish = (write_state == CH6_END);
assign ch7_wr_burst_finish = (write_state == CH7_END);

assign ch4_wr_burst_data_req = (write_state == CH4_WRITE) ? wr_burst_data_req : 1'b0;
assign ch5_wr_burst_data_req = (write_state == CH5_WRITE) ? wr_burst_data_req : 1'b0;
assign ch6_wr_burst_data_req = (write_state == CH6_WRITE) ? wr_burst_data_req : 1'b0;
assign ch7_wr_burst_data_req = (write_state == CH7_WRITE) ? wr_burst_data_req : 1'b0;

endmodule 