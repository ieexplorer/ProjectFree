module CONTROL #(parameter D_WIDTH=8,
									A_WIDTH=16)
					(input logic CLK, 
					input logic RST,
					input logic [A_WIDTH-1 : 0] VGA_ADDR,
					output logic VGA_EN,
					output logic [D_WIDTH-1 : 0] VGA_DATA
					);
		localparam A_WIDTH_HALF = A_WIDTH / 2;
	// adress for counter test
		logic [A_WIDTH - 1 : 0] address_count;
	// ROM for the photo with noise	
		logic rom_wren;
		assign rom_wren = 0;
		logic [A_WIDTH-1 : 0] rom_addr;
		logic [D_WIDTH-1 : 0] rom_data_in;
		assign rom_data_in = '0;
		logic [D_WIDTH-1 : 0] rom_data_out;
		
		RAM_IMAGE #( .d_width(D_WIDTH),
						.a_width(A_WIDTH)) rom_image
									  (.clock(CLK),
									  .wren(rom_wren),
									  .data(rom_data_in),
									  .address(rom_addr),
									  .q(rom_data_out)
									  );
	
	//States 
	enum logic[2:0]{idle,write_direct,filter_charge,result_wait,write_filter,finish} cstate,nstate;
	// RAM for the photo after filter
		logic ram_wren;
		logic [A_WIDTH-1 : 0] ram_addr;
		//For the control of Ram address
		assign ram_addr = (cstate == finish)?VGA_ADDR:(address_count -1'b1) ;
		logic [D_WIDTH-1 : 0] ram_data_in;
		logic [D_WIDTH-1 : 0] ram_data_out;
		assign VGA_DATA = ram_data_out;
		RAM_IMAGE_EMPTY #( .d_width(D_WIDTH),
						.a_width(A_WIDTH)) ram_image
									  (.clock(CLK),
									  .wren(ram_wren),
									  .data(ram_data_in),
									  .address(ram_addr),
									  .q(ram_data_out)
									  );
	
	//MEDIAN
	logic median_in_en;
	logic median_out_en;
	logic [D_WIDTH-1 : 0] median_data_out;
	MEDIAN median(.DI(rom_data_out),
					.DSI(median_in_en),
					.nRST(~RST),
					.CLK(CLK),
					.DO(median_data_out),
					.DSO(median_out_en));
	
	//counter charger
	logic [3 : 0] charge_counter;
	
		always_ff @(posedge CLK or posedge RST)
			if(RST) cstate <= idle;
				else cstate <= nstate;
	//address counter	
		always_ff @(posedge CLK or posedge RST)
			if(RST) 
				address_count	<= '0;
			else
				if(nstate == write_direct | nstate == write_filter)
					if(address_count == '1)		
						address_count <= '0;
					 else 
						address_count <= address_count + 1'b1;
				else	
					address_count <= address_count;
		//State Machine 			
		always_ff @(posedge CLK or posedge RST)
				if(RST) charge_counter <='0;
				else
					if(nstate == filter_charge && charge_counter != 4'd9) charge_counter <= charge_counter + 1'b1;
					else	
						if(charge_counter == 4'd9) charge_counter <= '0;
						else charge_counter <= charge_counter;
						
		always_comb 
			begin
				if(RST) 
									nstate <= idle;
			else	
				begin
					case(cstate)
						idle:		if(address_count[A_WIDTH-1 : A_WIDTH_HALF]=='0 
									|| address_count[A_WIDTH-1 : A_WIDTH_HALF]=='1 
									|| address_count[A_WIDTH_HALF-1 : 0]=='0
									||address_count[A_WIDTH_HALF-1 : 0]=='1)	nstate <= write_direct;
									else nstate<= filter_charge;
						write_direct:	if(address_count == 4'd0)nstate <= finish;
											else nstate <= idle;
						filter_charge:	if(charge_counter == 4'd9)	nstate <= result_wait;
										else	nstate <= filter_charge;
						result_wait:	if(median_out_en)	nstate <= write_filter;
										else	nstate <= result_wait;
						write_filter: nstate <= idle;
						finish: nstate <=finish;
					endcase
				end
			end
			
		//Signal for the Median Charge Enable
		always_ff @(posedge CLK or posedge RST)
				if(RST) median_in_en <= 0;
				else if(nstate ==  filter_charge) median_in_en <= 1;
					  else median_in_en <= 0;
		
		//Signal for the write enable of ram
		always_ff @(posedge CLK or posedge RST)
			if(RST) ram_wren <= 0;
			else 
			//Here we should at the end of the writing state for the data from rom
				if(nstate == write_direct || nstate == write_filter) ram_wren <= 1;
				else ram_wren <= 0;
						
		//Signal for the Ram input data ,use combine logic
		always_comb//ff @(posedge CLK or negedge RST)
			if(RST) ram_data_in <= '0;
			else
				if(cstate ==idle) ram_data_in <= '0;
				else
					if(cstate == write_direct) ram_data_in <= rom_data_out;
					else	 
							if(cstate == write_filter) ram_data_in <= median_data_out;
								else ram_data_in <= '0;
		//Signal for the Rom address 
		always_ff @(posedge CLK or posedge RST)
			if(RST) rom_addr = '0;
				else 
					if(cstate ==finish) rom_addr <= VGA_ADDR;
					else
						if(nstate == idle) rom_addr <= address_count;
						else
							if(nstate == write_direct || nstate == write_filter) rom_addr <= address_count;
							else
								if(nstate == filter_charge) 
									begin
									case(charge_counter)
									4'd0: rom_addr <= address_count - 9'd257;
									4'd1: rom_addr <= address_count - 9'd256 ;
									4'd2: rom_addr <= address_count - 9'd255;
									4'd3: rom_addr <= address_count - 1'b1;
									4'd4: rom_addr <= address_count + 1'b1;
									4'd5: rom_addr <= address_count + 9'd255;
									4'd6: rom_addr <= address_count + 9'd256;
									4'd7: rom_addr <= address_count + 9'd257;
									4'd8: rom_addr <= address_count ;
									4'd9: rom_addr <= address_count;
									default: rom_addr <= address_count;
									endcase
									end
						    else 
								rom_addr <= address_count;
				//VGA_EN
				always_ff @(posedge CLK or posedge RST)
					if(RST) VGA_EN <= 0;
						else
							if(cstate == finish) VGA_EN <= 1;
								else VGA_EN <= 0;
				
endmodule					
					