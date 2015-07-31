module freq_divider(clk, clk_local, rst_n, signal, LED, case1, case2 ,case3, correct,flag7);

	//frequency divider, here we make 4MHz clock to local time, we do this by a counter, and localize clk
	input clk,signal;  // flag is indicated the signal start(1) or signal stop(0)
	input rst_n;
	output clk_local;
	output reg[9:0] LED;
		output reg case1;
		output reg case2;
		output reg case3;
		output reg correct;
	reg[9:0] Data;
	output reg flag7;
	integer counter;
	parameter frame1 = 2'd1, frame2 = 2'd2, frame3 = 2'd3;
	reg [1:0] state, next_state;
		
	
	reg[7:0] cnt;
	reg flag;
	reg[4:0] count;
	reg[7:0] data;

	
	initial count = 4'd0;
	initial flag = 1'd0;
	initial case1 = 1'd0;
	initial case2 = 1'd0;
	initial case3 = 1'd0;
	initial correct = 1'd0;
	
	always @(negedge clk or negedge rst_n)    //freq_divider
		if(!rst_n) cnt <= 8'd0;
		else if (flag == 1'b0) cnt <= 8'd0;
		else if (cnt <= 8'd127) cnt <= cnt + 1'd1;
		else cnt <= 8'd1;
	
	assign  clk_local = ( cnt <= 8'd64) ? 1'b0 : 1'b1;  // generate local clk
		
	//signal in => flag =1, count 10 => flag =0
	
	always @(negedge signal or posedge clk)   //reset flag, when a frame is over
		if(!signal) flag <= 1'b1; 
		else if (count == 4'd10) flag <= 1'b0;

		
	// design count
	always @(posedge clk_local or negedge flag or negedge rst_n)  //count bits
		if(!rst_n) count <= 4'd0;	
		else if (!flag) count <= 4'd0;
		else if (count <= 4'd10) count <= count + 4'd1;
		else count <= 4'd0;
		
		
	always @(posedge clk_local or negedge rst_n)   //Here is count, for counting 8
	begin
		if(!rst_n) counter <= 1;
		else if(counter <= 9) counter <= counter+1;
		else counter <= 1;
	end
	
always @(posedge clk_local or negedge rst_n) //temp, store current signal
	begin
	if(!rst_n) Data <= 10'b0000000000;
	else if (counter == 9) Data <= 10'b0000000000;
	else Data[counter] <= signal;	
	end

	

always @(posedge clk_local or negedge rst_n) //rst state
begin
	if(!rst_n) state <= frame1;
	else state <= next_state;
end

always @(posedge clk_local) //indicator, indicate this is bit7
	if(counter != 8) flag7 <= 1'd0;
	else flag7 <= 1'd1;
	
always @(posedge flag7)   
	case(state)
		frame1: begin
				case1 <= 1'd1;
			if(Data[8]) begin
			next_state <= frame2;
			end
			else begin
			next_state <= frame1;
			end
				end
		frame2: begin
				case2 <=1'd1;
			if(!Data[8]) begin
			next_state <= frame3;
			end
			else begin
			next_state <= frame1;
			end
				end
		frame3: begin
				case3 <=1'd1;
			if(!Data[8]) begin
			LED[1] <= Data[1];
			LED[2] <= Data[2];
			LED[3] <= Data[3];	
			LED[4] <= Data[4];
			LED[5] <= Data[5];
			LED[6] <= Data[6];
			LED[7] <= Data[7];	
			LED[8] <= Data[8];
			LED[9] <= Data[9];		
			
			correct <= 1'd1;
			next_state <= frame1;
			end
			else begin
			next_state <= frame1;
			end
				end
		default:begin
			next_state <= frame1;
			end
	endcase	

endmodule 