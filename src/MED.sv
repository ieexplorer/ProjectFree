module MED #(parameter WIDTH=8,NUM=9)
				(DI,DSI,BYP,CLK,DO);
//interface of the module final version
	input [WIDTH-1:0]DI;
	input DSI;
	input BYP;
	input CLK;
	output [WIDTH-1:0] DO;
	logic [WIDTH-1:0] DO;

	//intermediate variable 
	wire [WIDTH-1:0] MCE_MIN;
	wire [WIDTH-1:0] MCE_MAX;

	logic [WIDTH-1:0] REG[NUM-2:0];//register
	logic[31:0] i;
	MCE MCE_INS(.A(DO),.B(REG[NUM-2]),.MAX(MCE_MAX),.MIN(MCE_MIN));

	//part for the register 2-7
	always @(posedge CLK)
		begin
			for(i=NUM-2;i>0;i--)
				begin
					REG[i]<=REG[i-1];
				end
		end
	//first input register
	always @(posedge CLK)
		begin
			REG[0]<=DI;
			if(DSI==0)	REG[0]<=MCE_MIN;
		end
		
	//output part
	always @(posedge CLK)
	begin
		DO<=MCE_MAX;
		if(BYP==1) DO<=REG[NUM-2];
	end
endmodule
