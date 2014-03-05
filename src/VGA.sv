module VGA #(parameter HDISP = 640, VDISP = 480)
   (input logic clk, 
 input logic 	    rst,
 input logic		 VGA_EN 
 output logic 	    VGA_CLK,
 output logic 	    VGA_HS,
 output logic 	    VGA_VS, 
 output logic 	    VGA_BLANK, 
 output logic 	    VGA_SYNC, 
 output logic [7:0] VGA_R, 
 output logic [7:0] VGA_G, 
 output logic [7:0] VGA_B
 output logic [7:0] ram_data
 output logic [15:0] ram_addr);
// VGA_SYNC Useless 
  assign VGA_SYNC = 0;
//Clock for the VGA, replaced by pll
assign VGA_CLK = clk;
//Paramters for the image
   localparam HFP    = 16;
   localparam HPULSE = 96;
   localparam HBP = 48;
   localparam HSM = HFP + HPULSE + HBP + HDISP;
   localparam H_SIZE = $clog2(HSM) ;
   
   localparam VFP = 11;
   localparam VPULSE =2;
   localparam VBP =31;
   localparam VSM = VFP + VPULSE + VBP + VDISP;
   localparam V_SIZE = $clog2(VSM) ;
    
   logic  rst_intern;
  
// Image information
	localparam IMAGE_PIXEL = 256;
	localparam IMAGE_LINE = 256;
	localparam IMAGE_PIXEL_st = 0;
	localparam IMAGE_LINE_st = 0;
	localparam IMAGE_PIXEL_end = IMAGE_PIXEL + IMAGE_PIXEL_st -1;
	localparam IMAGE_LINE_end = IMAGE_LINE + IMAGE_LINE_st -1;
// Generation of reset signal   
   RESET #(.enable_state(1)) reset_VGA(.CLK(VGA_CLK),
													.RST_in(rst),
													.RST_out(rst_intern));
// RAM of the image
	logic[15 : 0] ram_addr;

	logic[7 : 0] ram_data;

// Counter for the line et field
   logic  [H_SIZE-1 : 0] counter_pixel;
   logic  [V_SIZE-1 : 0] counter_line  ;
   
// Instance of the PLL
  
// Counter for the pixel
   always_ff @(posedge VGA_CLK or posedge rst_intern )
    	if(rst_intern) counter_pixel <= '0;
		else
			if (!VGA_EN) counter_pixel <= '0
			else
				if(counter_pixel == (HSM - 1) ) counter_pixel <= '0;
				else counter_pixel <= counter_pixel + 1'b1;
    

// Counter for the line
   always_ff @(posedge VGA_CLK or posedge rst_intern)
	if(rst_intern) counter_line <= '0;
	else
	  if( (counter_line == (VSM - 1)) && (counter_pixel == (HSM -1) ) ) counter_line <= '0;
	  else if(counter_pixel == (HSM -1) ) 
	         counter_line <= counter_line + 1'b1;
	       else counter_line <= counter_line;

//Address for the IMAGE_RAM
	assign ram_addr = {counter_line[7:0], counter_pixel[7:0] };
	
// Generation for signal VGA_HS
   always_ff @(posedge VGA_CLK )
     begin
     if( ( counter_pixel < (HDISP+HFP) ) ||  ( ( counter_pixel > ( HDISP+HFP+HPULSE-1 ) ) ) )
       VGA_HS <= 1;
     else VGA_HS <= 0;
   end
// Generation for signal VGA_BLANK   
   always_ff @(posedge VGA_CLK )
     begin
    if  ( (counter_pixel < (HDISP)) && (counter_line < (VDISP)) ) 
      VGA_BLANK <= 1;
    else
      VGA_BLANK <= 0;
   end

// Generation for signal VGA_VS
    always_ff @(posedge VGA_CLK )
      begin
     if( (counter_line < (VDISP+VFP)) || (counter_line > (VDISP+VFP+VPULSE-1)) )
       VGA_VS <= 1;
     else
       VGA_VS <= 0;
       end
// Generation for signal VGA_RED
					  					 
     always_ff @(posedge VGA_CLK or posedge rst_intern )
				       	 if(rst_intern) VGA_R <='0;
					 else if(counter_pixel < IMAGE_PIXEL_st+1 | counter_pixel > IMAGE_PIXEL_end+1)VGA_R <= '0;
					    else if(counter_line < IMAGE_LINE_st+1 | counter_line > IMAGE_LINE_end+1) VGA_R <= '0;
					         else VGA_R <= ram_data;
				
 // Generation for signal VGA_GREEN
					  					 
     always_ff @(posedge VGA_CLK or posedge rst_intern )
				       	 if(rst_intern) VGA_G<='0;
					 else if(counter_pixel < IMAGE_PIXEL_st+1 | counter_pixel > IMAGE_PIXEL_end+1)VGA_G <= '0;
					    else if(counter_line < IMAGE_LINE_st+1 | counter_line > IMAGE_LINE_end+1) VGA_G <= '0;
					         else VGA_G <= ram_data;
					
 // Generation for signal VGA_BLEU
					  					 
      always_ff @(posedge VGA_CLK or posedge rst_intern )
				       	 if(rst_intern) VGA_B <='0;
					 else if(counter_pixel < IMAGE_PIXEL_st+1 | counter_pixel > IMAGE_PIXEL_end+1)VGA_B <= '0;
					    else if(counter_line < IMAGE_LINE_st+1 | counter_line > IMAGE_LINE_end+1) VGA_B<= '0;
					         else VGA_B <= ram_data;
				
endmodule 
