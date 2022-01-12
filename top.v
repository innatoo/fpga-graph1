/*con questo software riesco a leggere gli ingressi e a scrivere i valori sulla parte alfanumerica
nella visualizzazione ho una freccia verso l'alto se il bit e zero e in basso se e'1

*/


module top(CLK, SCK, MOSI, MISO, SSEL,PIN_14,PIN_15,PIN_16,PIN_17,PIN_18,LED,PIN_13,PIN_12,PIN_20,PIN_10,PIN_8,PIN_9,PIN_7);
input CLK,PIN_8;
output LED;
output PIN_10,PIN_20,PIN_12,PIN_13,PIN_14,PIN_15,PIN_16,PIN_17,PIN_18,PIN_9,PIN_7;

input SCK, SSEL, MOSI;
output MISO;

wire clkpresc;
assign PIN_18 = clkpresc;
assign LED =clkpresc;
assign USBPU = 0;
wire stat;
wire go;
wire res;
wire [7:0]char0;
wire [7:0]char1;
wire [7:0]char2;
wire [7:0]char3;
wire [7:0]char4;
wire [7:0]char5;
wire [7:0]char6;
wire [7:0] char;
wire [7:0] letter;
wire [4:0]parola;
wire [7:0] valore;
wire [7:0] address;
wire   [0:31] intasty;
wire [7:0]bar0;
wire [7:0]bar1;
wire [7:0]bar2;
wire [7:0]bar3;
wire [7:0]bar4;
wire [7:0]bar5;
wire [7:0]bar6;
wire [7:0]bar7;
wire [0:8*4-1] st1;
wire [0:8*4-1] st2;
wire [0:8*4-1] st2;
wire [0:8*4-1] st3;
wire [0:8*4-1] st4;
wire [0:8*4-1] st5;
wire [0:8*4-1] st6;
wire [0:8*4-1] st7;
wire [0:8*4-1] st8;
wire quadA,quadB;
wire [0:8] conn;
assign  bar0 =4;
//assign  bar1 =conn;
assign  bar2 =31;
assign  bar3 =2;
assign  bar4 =0;
assign  bar5 =0;
assign  bar6 =1;
assign  bar7 =22;


assign st1 ={"A","B",7'b 0011000,quadA,7'b 0011000,quadB};
assign st2 ={"A","B",7'b 0011000,quadA,7'b 0011000,quadB};
assign st3 ="ff#4";
assign st4 ="%$#4";
assign st5 ="Sen5";
assign st6 ="c@A6";
assign st7 ="^*{7";
assign st8 ="Pip8";

tasty miatastiera(.CLK(clkpresc) , .pinin(PIN_8),.load(PIN_9),.gsclk1(PIN_7),.bar(intasty));
prescaler mioclk(.clk_in(CLK),.clk_out(clkpresc));
  graph miograph (.CLK(clkpresc) ,.gsdo(PIN_20), .gsclk(PIN_12), .gload(PIN_13),.val1(conn),.val2(conn),.val3(bar2),.val4(bar3),.val5(bar4),.val6(bar5),
  .val7(bar6),.val8(bar7),.str1(st1),.str2(st2),.str3(st3),.str4(st4),.str5(st5),.str6(st6),.str7(st7),.str8(st8) ,.tasty(intasty));
quad mio_quad(.clk(CLK), .quadA(quadB), .quadB(quadA), .count(conn));
scopp mioscopp(.clk(clkpresc), .quadA(quadA), .quadB(quadB), .tast(intasty));
SPI_slave mio_spi(.CLK(CLK), .SCK(SCK), .MOSI(MOSI), .MISO(MISO), .SSEL(SSEL), .VAL(conn));
// funziona tutto . comando il display in tutte le parti e leggo da
//tastiera gli input mi manca di aggiungere la parte spi per poter mettere valori o leggere valori
//devo riprendere il driver char device  e rivedere gli ingressi dal raspberry
//
//
//
//
//
//
//
//
//
//

endmodule
