module TEST_PLL(input logic clk, input logic nrst, output logic led);
logic [27 : 0] diviser;
	always_ff @(posedge clk)
		if(!nrst) diviser <='0;
			else if (diviser == 27'd25200000)	diviser <= '0;
				else	diviser <= diviser + 1'b1;
				
	always_ff @(posedge clk)
		if(!nrst)  led <= 1;
			else if (diviser == 27'd25200000)	led <= ~led;
				else	led <= led;
endmodule