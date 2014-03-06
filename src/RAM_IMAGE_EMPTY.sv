//Follow the refernece of sync_rom.sv ELEC222 of Telecom ParisTech and the RAM example of Altera

module RAM_IMAGE_EMPTY  #( parameter d_width = 8,
                     parameter a_width = 16)
                   ( input logic clock,
                     input logic wren,
                     input logic [d_width-1:0] data,
                     input logic [a_width-1:0] address,
                     output logic [d_width-1:0] q
                     );
		
	logic [d_width-1:0] mem [0:2**a_width-1];		
	logic [a_width-1:0] addr_reg ;

always_ff @(posedge clock)
begin
    
    if (wren) 
        mem[address] <= data;
        addr_reg <= address;
end
assign q = mem[addr_reg]; 

endmodule