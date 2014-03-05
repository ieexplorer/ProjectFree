`timescale 1ps/1ps

module CONTROL_tb();
	logic clock;
	logic nrst;
	always #10ns clock = ~clock;

	CONTROL control (.CLK(clock) ,.NRST(nrst));
	 initial begin: ENTREES
	    clock = 0;
	    nrst = 0;
		repeat (50)
			begin
				@(posedge clock);  
			end
		nrst = 1;
	 end
endmodule