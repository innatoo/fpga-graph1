module scopp(clk, quadA, quadB, tast);
input clk;
output quadA, quadB;
input [31:0] tast;
assign quadA =tast[25];
assign quadB =tast[24];
endmodule
