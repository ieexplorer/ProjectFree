// ============================================================================
// Copyright (c) 2013 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Mon Jul  1 14:21:10 2013
// ============================================================================

//`define ENABLE_DDR3
//`define ENABLE_HPS
//`define ENABLE_HSMC

module SocKit_golden_top(

      ///////// AUD /////////
      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_I2C_SCLK,
      inout              AUD_I2C_SDAT,
      output             AUD_MUTE,
      output             AUD_XCK,
	
`ifdef ENABLE_DDR3
      ///////// DDR3 /////////
      output      [14:0] DDR3_A,
      output      [2:0]  DDR3_BA,
      output             DDR3_CAS_n,
      output             DDR3_CKE,
      output             DDR3_CK_n,
      output             DDR3_CK_p,
      output             DDR3_CS_n,
      output      [3:0]  DDR3_DM,
      inout       [31:0] DDR3_DQ,
      inout       [3:0]  DDR3_DQS_n,
      inout       [3:0]  DDR3_DQS_p,
      output             DDR3_ODT,
      output             DDR3_RAS_n,
      output             DDR3_RESET_n,
      input              DDR3_RZQ,
      output             DDR3_WE_n,
`endif /*ENABLE_DDR3*/

      ///////// FAN /////////
      output             FAN_CTRL,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      input              HPS_CONV_USB_n,
      output      [14:0] HPS_DDR3_A,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_n,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_n,
      output             HPS_DDR3_CK_p,
      output             HPS_DDR3_CS_n,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_n,
      inout       [3:0]  HPS_DDR3_DQS_p,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_n,
      output             HPS_DDR3_RESET_n,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_n,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_n,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout       [3:0]  HPS_FLASH_DATA,
      output             HPS_FLASH_DCLK,
      output             HPS_FLASH_NCSO,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C_CLK,
      inout              HPS_I2C_SDA,
      inout       [3:0]  HPS_KEY,
      inout              HPS_LCM_BK,
      output             HPS_LCM_D_C,
      output             HPS_LCM_RST_N,
      input              HPS_LCM_SPIM_CLK,
      output             HPS_LCM_SPIM_MOSI,
      output             HPS_LCM_SPIM_SS,
      output      [3:0]  HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      output             HPS_SPIM_SS,
      input       [3:0]  HPS_SW,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

`ifdef ENABLE_HSMC
      ///////// HSMC /////////
      input       [2:1]  HSMC_CLKIN_n,
      input       [2:1]  HSMC_CLKIN_p,
      output      [2:1]  HSMC_CLKOUT_n,
      output      [2:1]  HSMC_CLKOUT_p,
      output             HSMC_CLK_IN0,
      output             HSMC_CLK_OUT0,
      inout       [3:0]  HSMC_D,
      input       [7:0]  HSMC_GXB_RX_p,
      output      [7:0]  HSMC_GXB_TX_p,
      input              HSMC_REF_CLK_p,
      inout       [16:0] HSMC_RX_n,
      inout       [16:0] HSMC_RX_p,
      output             HSMC_SCL,
      inout              HSMC_SDA,
      inout       [16:0] HSMC_TX_n,
      inout       [16:0] HSMC_TX_p,
`endif /*ENABLE_HSMC*/

      ///////// IRDA /////////
      input              IRDA_RXD,
		
      ///////// KEY /////////
      input       [3:0]  KEY,

      ///////// LED /////////
      output      [3:0]  LED,
		
      ///////// OSC /////////
      input              OSC_50_B3B,
      input              OSC_50_B4A,
      input              OSC_50_B5B,
      input              OSC_50_B8A,

      ///////// PCIE /////////
      input              PCIE_PERST_n,
      output             PCIE_WAKE_n,
	
      ///////// RESET /////////
      input              RESET_n,

      ///////// SI5338 /////////
      inout              SI5338_SCL,
      inout              SI5338_SDA,
	   
      ///////// SW /////////
      input       [3:0]  SW,

      ///////// TEMP /////////
      output             TEMP_CS_n,
      output             TEMP_DIN,
      input              TEMP_DOUT,
      output             TEMP_SCLK,
	
      ///////// USB /////////
      input              USB_B2_CLK,
      inout       [7:0]  USB_B2_DATA,
      output             USB_EMPTY,
      output             USB_FULL,
      input              USB_OE_n,
      input              USB_RD_n,
      input              USB_RESET_n,
      inout              USB_SCL,
      inout              USB_SDA,
      input              USB_WR_n,
		
      ///////// VGA /////////
      output      [7:0]  VGA_B,
      output             VGA_BLANK_n,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_n,
      output             VGA_VS
);



		
//=======================================================
// Pins useless
//=======================================================
   assign AUD_DACDAT 	= 		1'bz;
	assign AUD_ADCLRCK 	= 		1'bz;
	assign AUD_I2C_SCLK 	= 		1'bz;
	assign AUD_I2C_SDAT 	= 		1'bz;
	assign AUD_MUTE 		= 		1'bz;
	assign AUD_XCK 		= 		1'bz;
	assign AUD_BCLK 		=		1'bz;
	assign AUD_DACLRCK 	= 		1'bz;
	
	assign USB_B2_DATA 	= 		1'bz;
	assign USB_EMPTY 		= 		1'bz;
	assign USB_FULL 		= 		1'bz;
   assign USB_SCL 		= 		1'bz;
	assign USB_SDA 		= 		1'bz;
	
	assign TEMP_CS_n 		= 		1'bz;
	assign TEMP_DIN	   = 		1'bz;
	assign TEMP_SCLK		=		1'bz;
	//assign LED[3:1] 		= 		3'b000;
	
	assign PCIE_WAKE_n 	= 		1'bz;
	
	assign SI5338_SCL 	= 		1'bz;
	assign SI5338_SDA 	= 		1'bz;
	
	assign FAN_CTRL	   = 		1'bz;
//=======================================================
//  REG/WIRE declarations
//=======================================================
		wire pll_rst;
		assign pll_rst = ~KEY[0];
		wire pll_lock;
		wire vga_clk;
		wire VGA_CLK_INV;
		assign VGA_CLK = VGA_CLK_INV;
		wire vga_rst;
		wire[7:0] ram_data;
		wire[7:0] rom_data;
		wire [15:0] ram_addr;
		wire vga_en;
//=======================================================
//  Structural coding
//=======================================================
VGA_PLL vga_pll (.refclk(OSC_50_B5B), 
						.rst(pll_rst), 
						.outclk_0(vga_clk),
						.locked(pll_lock));
						
TEST_PLL test_pll(.clk(vga_clk),
						.PLL_LOCK(pll_lock),
						.nrst(KEY[0]),
						.led(LED[0]));

RESET #(.enable_state(1)) reset_vga(.CLK(vga_clk),
												.PLL_LOCK(pll_lock),
												.RST_in(~KEY[0]),
												.RST_out(vga_rst));
	
VGA vga_ins(.clk(vga_clk),
				.PLL_LOCK(pll_lock),
				.rst(vga_rst),
				.VGA_EN(vga_en),
				.VGA_CLK(VGA_CLK_INV),
				.VGA_HS(VGA_HS),
				.VGA_VS(VGA_VS),
				.VGA_BLANK(VGA_BLANK_n),
				.VGA_SYNC(VGA_SYNC_n),
				.VGA_R(VGA_R),
				.VGA_G(VGA_G),
				.VGA_B(VGA_B),
				.RAM_DATA(ram_data),
				.RAM_ADDR(ram_addr),
				.ROM_DATA(rom_data)
				);
CONTROL control_ins(	.CLK(vga_clk),
							.PLL_LOCK(pll_lock),
							.RST(vga_rst),
							.VGA_ADDR(ram_addr),
							.VGA_DATA(ram_data),
							.VGA_DATA_N(rom_data),
							.VGA_EN(vga_en)
							);
							
assign LED[1] = vga_en;
assign LED[3:2] = 2'b00;


endmodule
