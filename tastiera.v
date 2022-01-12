
module tasty (CLK,pinin,load,gsclk1,bar);
input pinin;
input CLK;
output   load,gsclk1;

output [0:31] bar ;
reg [7:0] cnt1,cntin;

initial begin
            gsclk1 <=1'b1;
            cnt1<=00;
            load<=1'b0;
            cntin<=00;
         end

always @(negedge CLK) begin


if (cnt1 ==0) begin                      //lo considero inizio del clock
                  gsclk1 <= 1'b0;
                  cnt1 <=cnt1+1;

                end

if (cnt1 ==1) begin
                  load<=1'b1;
                  bar[cntin]<=pinin;
                  cnt1 <=cnt1+1;
              end
if (cnt1 ==2) begin
                    gsclk1 <= 1'b1;
                    cnt1 <=cnt1+1;
                    cntin<=cntin+1;
              end
if (cnt1 ==3) begin
                    if (cntin >31) begin
                                        load<=1'b0;
                                        cntin<=00;
                                        cnt1<=00;
                                    end
                    else    cnt1<=00;
                end
end
endmodule
