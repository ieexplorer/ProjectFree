`timescale 1ps/1ps

module CONTROL_tb();
	logic clock;
	logic rst;
	logic [15:0]vga_addr;
	logic vga_en;
	logic [7:0]vga_data;
	logic [7:0]vga_data_n;
	always #10ns clock = ~clock;

	CONTROL control (.CLK(clock) ,.RST(rst),.VGA_ADDR(vga_addr),.VGA_EN(vga_en),.VGA_DATA(vga_data), .VGA_DATA_N(vga_data_n));
	 initial begin: ENTREES
	    clock = 0;
	    rst = 1;
		 vga_addr ='0;
		repeat (50)
			begin
				@(posedge clock);  
			end
		rst = 0;
		   
	 end
	 always_ff @(posedge clock or posedge rst)
		if(rst) vga_addr<= '0;
		else vga_addr <= vga_addr + 1'b1;
endmodule