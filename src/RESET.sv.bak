module RESET #(parameter enable_state =0)
  (input logic CLK, input logic RST_in, output logic RST_out);

   logic n_rst_in1;
   logic n_rst_in2;

   logic p_rst_in1;
   logic p_rst_in2;
   
   
    always_ff @(posedge CLK or negedge RST_in)
     begin
	if(!RST_in)
	  n_rst_in1 <= 0;
	else
	  n_rst_in1 <= 1;
     end
 
  always_ff @(posedge CLK or negedge RST_in)
     begin
	if(!RST_in)
	  n_rst_in2 <= 0;
	else
	  n_rst_in2 <= n_rst_in1;

     end

   always_ff @(posedge CLK or posedge RST_in)
     begin
	if(RST_in)
	  p_rst_in1 <= 1;
	else
	  p_rst_in1 <= 0;
     end
 
  always_ff @(posedge CLK or posedge RST_in)
     begin
	if(RST_in)
	  p_rst_in2 <= 1;
	else
	  p_rst_in2 <= p_rst_in1;

     end
   assign RST_out = (enable_state == 0)? n_rst_in2:p_rst_in2;
   
   endmodule