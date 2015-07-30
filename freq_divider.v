module freq_divider(clk, clk_local, rst_n, flag);

	//frequency divider, here we make 4MHz clock to local time, we do this by a counter, and localize clk
	input clk,flag;  // flag is indicated the signal start(1) or signal stop(0)
	input rst_n;
	output clk_local;
	
	reg[7:0] cnt;
	
	always @(negedge clk or negedge rst_n or negedge flag)
		if(!rst_n) cnt <= 8'd0;
		else if (!flag) cnt <= 8'd0;
		else if(cnt <= 8'd127) cnt <= cnt + 1'd1;
		else cnt <= 8'd1;
	
	assign  clk_local = ( cnt <= 8'd64) ? 1'b0 : 1'b1;
		
	
	
endmodule 