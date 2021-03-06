module MEDIAN(DI,DSI,nRST,CLK,DO,DSO);
	enum logic[2:0]{idle_ex,step_ex0,step_ex1,step_ex2,step_ex3,step_ex4,out_ex} cstate_ex,nstate_ex;
	logic [3:0] counter;
   input [7:0] DI;
	input DSI;
	input nRST;
	input CLK;
	//Data output
	output reg[7:0]DO;
	//Output signal of control
	output reg DSO;
	//Intern signal of control
	logic BYP;
	logic nrst_median;
	//Module reused
	MED #(.WIDTH(8),.NUM(9)) MED_INS (.DI(DI),.DSI(DSI),.BYP(BYP),.CLK(CLK),.DO(DO));
	//reset #(.enable_state(0)) RESET_MEDIAN(.CLK(CLK), .RST_in(nRST), .rst_out(nrst_median));
	
	//Counter 
	always @(posedge CLK or negedge nRST)
		begin
		if(!nRST)	counter <= 4'b0000;
	//	else if(DSI)	counter <= 4'b0000;
				else
				if(counter[3]) counter <= '0;
					else
					if(cstate_ex == out_ex) counter <= '0;
					else if(cstate_ex == idle_ex && counter == 4'b0111) counter <='0; 
					else if(cstate_ex == step_ex4 && counter == 4'b0011) counter <= 4'b0000;
						else counter <= counter + 4'b0001;
		end
		
	//State Machine for cstate_ex
	always_ff @(posedge CLK or negedge nRST)
		begin
		  	if(!nRST) cstate_ex<=out_ex;
			else
			     cstate_ex<=nstate_ex;
		end

   always_comb
		begin		
			if(!nRST) 
									nstate_ex <= out_ex;
			else	
			begin
				case(cstate_ex)
					idle_ex:		if(!DSI)	nstate_ex <= step_ex0;
									else		nstate_ex <= idle_ex;
					step_ex0:	if(counter[3])	nstate_ex <= step_ex1;
									else	nstate_ex <= step_ex0;
					step_ex1:	if(counter[3])	nstate_ex <= step_ex2;
									else	nstate_ex <= step_ex1;
					step_ex2:	if(counter[3])	nstate_ex <= step_ex3;
									else	nstate_ex <= step_ex2;
					step_ex3:	if(counter[3])	nstate_ex <= step_ex4;
									else	nstate_ex <= step_ex3;
					step_ex4:	if(counter[1] & counter[0])	nstate_ex <= out_ex;
									else	nstate_ex <= step_ex4;
				//This is the state at the end of a period, we can't jump back to the idle easily. 
				//Otherwise, there is the risk of missing charging the data
				
					out_ex:		if(DSI) nstate_ex <= idle_ex;
									else	nstate_ex <= out_ex;
					endcase
				end
		end
	always @(posedge CLK or negedge nRST)
		begin
			if(!nRST)
				DSO<=0;
			else	
				begin
					if((cstate_ex==step_ex4)&&(counter == 4'b0011) )
							DSO<=1;
				else
							DSO<=0;
					
				end
   	end
//Signal of control		BYP
	always_ff @(posedge CLK or negedge nRST)
		begin
			if(nRST== 0)
				begin
					BYP <= 1;
				end
			else	

				begin
						case(cstate_ex)
						idle_ex : begin if (counter == 4'b0000 || counter == 4'b0001|| counter == 4'b0111) BYP <=0;
											else if(nstate_ex == step_ex0) BYP <= 0;
												else
													BYP <= 1;
									 end
						step_ex0: begin if(counter[2] & counter[1] & counter[0]) BYP <= 1;
												else BYP<=0;end
						step_ex1: begin if(counter ==4'b0111 | counter ==4'b0110 ) BYP <= 1;
												else BYP<=0;end
						step_ex2: begin if(counter ==4'b0111 | counter ==4'b0110 | counter ==4'b0101) BYP <= 1;
												else BYP<=0;end		
						step_ex3: begin if(counter ==4'b0111 | counter ==4'b0110 | counter ==4'b0101 | counter == 4'b0100  )BYP <= 1;
												else BYP<=0;end	
						step_ex4: begin  BYP <= 0;end	
						out_ex  : BYP <= 0;
					//	default: BYP <= 1;		
						endcase
				end
		end

		endmodule
	