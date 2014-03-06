module MCE(A,B,MAX,MIN);

input [7:0] A;
input [7:0] B;
output [7:0] MAX;
output [7:0] MIN;

assign MAX=(A>=B)?A:B;//compare without always final
assign MIN=(A>=B)?B:A;
endmodule
