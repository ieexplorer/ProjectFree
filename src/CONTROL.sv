module CONTROL #(parameter D_WIDTH=8,
									A_WIDTH=16)
					(input logic CLK, 
					input logic NRST,
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
	// RAM for the photo after filter
		logic ram_wren;
		logic [A_WIDTH-1 : 0] ram_addr;
		assign ram_addr = address_count -1'b1 ;
		logic [D_WIDTH-1 : 0] ram_data_in;
		logic [D_WIDTH-1 : 0] ram_data_out;
		
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
					.nRST(NRST),
					.CLK(CLK),
					.DO(median_data_out),
					.DSO(median_out_en));
	//States 
	enum logic[2:0]{idle,write_direct,filter_charge,result_wait,write_filter} cstate,nstate;
	//counter charger
	logic [3 : 0] charge_counter;
	
		always_ff @(posedge CLK or negedge NRST)
			if(!NRST) cstate <= idle;
				else cstate <= nstate;
		
		always_ff @(posedge CLK or NRST)
			if(!NRST) 
				address_count	<= '0;
			else
				if(nstate == write_direct | nstate == write_filter)
					if(address_count == '1)		
						address_count <= '0;
					 else 
						address_count <= address_count + 1'b1;
				else	
					address_count <= address_count;
					
		always_ff @(posedge CLK or negedge NRST)
				if(!NRST) charge_counter <='0;
				else
					if(nstate == filter_charge && charge_counter != 4'd9) charge_counter <= charge_counter + 1'b1;
					else	
						if(charge_counter == 4'd9) charge_counter <= '0;
						else charge_counter <= charge_counter;
						
		always_comb 
			begin
				if(!NRST) 
									nstate <= idle;
			else	
				begin
					case(cstate)
						idle:		if(address_count[A_WIDTH-1 : A_WIDTH_HALF]=='0 
									|| address_count[A_WIDTH-1 : A_WIDTH_HALF]=='1 
									|| address_count[A_WIDTH_HALF-1 : 0]=='0
									||address_count[A_WIDTH_HALF-1 : 0]=='0)	nstate <= write_direct;
									else		nstate<= filter_charge;
						write_direct:	nstate <= idle;
						filter_charge:	if(charge_counter == 4'd9)	nstate <= result_wait;
										else	nstate <= filter_charge;
						result_wait:	if(median_out_en)	nstate <= write_filter;
										else	nstate <= result_wait;
						write_filter: nstate <= idle;
					endcase
				end
			end
			
		//Signal for the Median Charge Enable
		always_ff @(posedge CLK or negedge NRST)
				if(!NRST) median_in_en <= 0;
				else if(nstate ==  filter_charge) median_in_en <= 1;
					  else median_in_en <= 0;
		
		//Signal for the write enable of ram
		always_ff @(posedge CLK or negedge NRST)
			if(!NRST) ram_wren <= 0;
			else 
			//Here we should at the end of the writing state for the data from rom
				if(nstate == write_direct || nstate == write_filter) ram_wren <= 1;
				else ram_wren <= 0;
						
		//Signal for the Ram input data ,use combine logic
		always_comb//ff @(posedge CLK or negedge NRST)
			if(!NRST) ram_data_in <= '0;
			else
				if(cstate ==idle) ram_data_in <= ram_data_in;
				else
					if(cstate == write_direct) ram_data_in <= rom_data_out;
					else	 
							if(cstate == write_filter) ram_data_in <= median_data_out;
								else ram_data_in <= ram_data_in;
		//Signal for the Rom address 
		always_ff @(posedge CLK or negedge NRST)
			if(!NRST) rom_addr = '0;
				else 
					if(nstate == write_direct || nstate == write_filter) rom_addr <= address_count;
					else
							if(nstate == filter_charge) 
								begin
								case(charge_counter)
								3'd0: rom_addr <= address_count;
								3'd1: rom_addr <= address_count - 9'd257;
								3'd2: rom_addr <= address_count - 9'd256;
								3'd3: rom_addr <= address_count - 9'd255;
								3'd4: rom_addr <= address_count - 1'b1;
								3'd5: rom_addr <= address_count + 1'b1;
								3'd6: rom_addr <= address_count + 9'd255;
								3'd7: rom_addr <= address_count + 9'd256;
								3'd1: rom_addr <= address_count + 9'd257;
								default: rom_addr <= address_count;
								endcase
								end
						    else 
								rom_addr <= address_count;
				
endmodule					
					