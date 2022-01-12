module quad(clk, quadA, quadB, count);
input clk, quadA, quadB;
output [7:0] count;



reg [2:0] quadA_delayed, quadB_delayed;
always @(posedge clk) quadA_delayed <= {quadA_delayed[1:0], quadA};
always @(posedge clk) quadB_delayed <= {quadB_delayed[1:0], quadB};

wire count_enable = quadA_delayed[1] ^ quadA_delayed[2] ^ quadB_delayed[1] ^ quadB_delayed[2];
wire count_direction = quadA_delayed[1] ^ quadB_delayed[2];
reg [9:0] count1;
reg [7:0] count;


initial begin
            count =7;
            count1=100;
         end

always @(posedge clk)
begin
  if(count_enable)
  begin
    if(count_direction) count1<=count1+1; else count1<=count1-1;
  end
  count[7:0]<=count1[9:2];
end

endmodule
