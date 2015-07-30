module freq_divider(clk, clk_local, rst_n);

	//frequency divider, here we make 4MHz clock to local time, we do this by a counter
	input clk; 
	input rst_n;
	output clk_local;
	
	reg[6:0] cnt;
	
	always @(negedge clk or negedge rst_n)
		if(!rst_n) cnt <= 7'd1;
		else if(cnt < 7'd127) cnt <= cnt + 1'd1;
		else cnt <= 7'd1;
	
	assign  clk_local = ( cnt <= 7'd63) ? 1'b0 : 1'b1;
		
	
	
endmodule 