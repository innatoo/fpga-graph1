//-- prescaler.v
//-- clk_in: input clock signal
//-- clk_out: output clock signal, lower frequency
module prescaler(input clk_in, output clk_out);
wire clk_in;
wire clk_out;

//-- Number of bits of the prescaler (default)


//-- Register for implementing the N bit counter
reg [20:0] count3 = 0;

//-- The most significant bit goes through the output
assign clk_out = count3[4];

//-- Counter: increases upon a rising edge
always @(posedge(clk_in)) begin
  count3 <= count3 + 1;
end

endmodule
