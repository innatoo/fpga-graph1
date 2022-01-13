module graph(CLK ,gsdo, gsclk, gload,val1,val2,val3,val4,val5,val6,val7,val8,str1,str2,str3,str4,str5,str6,str7,str8,tasty);
input CLK;
output gsdo,gsclk,gload;
input   [0:7] val1,val2,val3,val4,val5,val6,val7,val8;
input [8*4-1:0] str1,str2,str3,str4,str5,str6,str7,str8;
input [31:0]tasty;
reg [7:0] gcount ;

reg [31:0] regbar;
reg [7:0] cntspi,cnt,cntrl,valcnt,valcnv;
reg [0:47] barsend;
reg[7:0] ind;
reg[7:0] ser,drain,kio;
wire[0:7]val[7:0];                  //cambiato in wire da reg
reg  [0:7] bar [0:66]; //[7:0];
reg[7:0] test1,test2,test3,test4;
reg [15:0] trip;
reg flag;
wire [7:0] graph1,graph2,graph3,graph4;

initial begin
        ind<=00;
        gcount <=00;
        valcnt<=00;
        cntspi <=00;
        cnt <=00;
        gsclk <= 1'b0;
        gload <=1'b0;

            bar[35]<="o";
            bar[36]<="a";
            bar[37]<="i";
            bar[38]<="C";
            bar[39]<="#";
            bar[40]<="#";

                   end

always @(negedge CLK) begin

  if (ind>7)ind<=00;
  case (ind)
        0 :kio =0;
        1 :kio =4;
        2 :kio =8;
        3 :kio =12;
        4 :kio =16;
        5 :kio =20;
        6 :kio =24;
        7 :kio =28;
endcase
if (flag ==1'b1)begin
                  bar[(kio)]<=graph1;
                  bar[(kio+1)]<=graph2;
                  bar[(kio+2)]<=graph3;
                  bar[(kio+3)]<=graph4;
                  flag <=1'b0;
              end

if (valcnt==0)begin
                  valcnv<=val[(ind)];
                  valcnt<=valcnt+1;
              end
if (valcnt==1)begin
                  if  (cntrl<32 )begin
                                      regbar[0] <=1'b1;
                                      if (valcnv >=cntrl) regbar[cntrl]<=1'b1;
                                      else  regbar[cntrl]<=1'b0;
                                      valcnt<=valcnt+1;
                                  end
                  else begin
                            valcnt<=3;
                            cntrl <=1;
                            flag <=1'b1;
                       end
              end
if (valcnt==2)begin
                  cntrl <=cntrl+1;
                  valcnt<=1;
              end;

if(valcnt==3)begin
                  ind<=ind+1;
                  valcnt<=0;
             end



if (gcount >=4)ser<=12;
 else ser<=00;

            if (gcount==18) begin
                                gcount<=00;
                                drain <= 8'b00000001;
                            end

            if (gcount <8) begin
                    barsend[40:47]<=bar[(gcount+ser)];
                    barsend[39:32]<=bar[(gcount+4+ser)];
                    barsend[24:31]<=bar[(gcount+8+ser)]; //1 barra  primi 2 in basso a destra
                    barsend[23:16]<=bar[(gcount+12+ser)]; //ultima barra
                    barsend[15:8] <=drain;
                    barsend[7:0]  <= 8'b00001000; //disabilito la scrittura alfanumerica
                      end



            if (gcount ==8) begin
                            barsend[47:40]<=8'b00000000;
                            barsend[39:32]<=8'b00011111;
                            barsend[24:31]  <= 8'b01010010;
                            barsend[23:16] <=8'b01010010;
                            barsend[15:8] <= 8'b00000000;
                            barsend[7:0] <= 8'b00000000;
                    end


                                                                                             //da qui scrivo sui caratteri

            if (gcount ==9) begin
                            barsend[47:40]<= str1[7:0];        //sopra     posizione carattere    [ 4 ] [ 3 ] [ 2 ] [ 1 ] scrivo il primo carattere
                            barsend[39:32]<= str2[7:0];        //primo carattere per tutti                                                        // di tutti i display
                            barsend[31:24]<= str3[7:0]; //  d0 d1 d2 d3 d4 d5 d6 0
                            barsend[23:16] <= str4[7:0]; //      codici ascii k K    +0
                            barsend[15:8] <= 8'b00000000;
                            barsend[7:0] <= 8'b00000100;
                    end                      //xxxxEwAA
            if (gcount ==10) begin
                            barsend[47:40]<= str5[7:0];                   //sotto
                            barsend[39:32]<= str6[7:0];
                            barsend[31:24]<= str7[7:0];
                            barsend[23:16]<= str8[7:0];
                            barsend[15:8] <= 8'b00000000;
                            barsend[7:0] <= 8'b00000000;
                    end
            if (gcount ==11) begin
                            barsend[47:40]<= str1[15:8];                  //sopra
                            barsend[39:32]<= str2[15:8]; //secondo carattere
                            barsend[31:24]<= str3[15:8]; //&  t    ####################
                            barsend[23:16]<= str4[15:8];
                            barsend[15:8] <= 8'b00000000;
                            barsend[7:0]  <= 8'b00000101;
                    end
            if (gcount ==12) begin
                            barsend[47:40]<= str5[15:8];                   //sotto
                            barsend[39:32]<= str6[15:8];
                            barsend[31:24]<= str7[15:8];
                            barsend[23:16]<= str8[15:8];
                            barsend[15:8] <= 8'b00000000;
                            barsend[7:0]  <= 8'b00000001;
                    end
            if (gcount ==13) begin
                                barsend[47:40]<= {7'b 0011000,tasty[25]};   //str1[23:16];                         //sopra
                                barsend[39:32]<= str2[23:16];  //terzo carattere
                                barsend[31:24]<= str3[23:16];  //&    n
                                barsend[23:16]<= str4[23:16];
                                barsend[15:8] <= 8'b00000000;
                                barsend[7:0]  <= 8'b00000110;
                        end
            if (gcount ==14) begin
                                  barsend[47:40]<= str5[23:16];                      //sotto
                                  barsend[39:32]<= str6[23:16];
                                  barsend[31:24]<= str7[23:16];
                                  barsend[23:16]<= str8[23:16];
                                  barsend[15:8] <= 8'b00000000;
                                  barsend[7:0]  <= 8'b00000010;
                          end
             if (gcount ==15) begin
                                   barsend[47:40]<={7'b 0011000,tasty[24]};   // str1[31:24];                  //sopra
                                   barsend[39:32]<= str2[31:24];   //quarto carattere
                                   barsend[31:24]<= str3[31:24]; //&
                                   barsend[23:16] <= str4[31:24];
                                   barsend[15:8] <= 8'b00000000;
                                   barsend[7:0]  <= 8'b00000111;
                            end
            if (gcount ==16) begin
                                  barsend[47:40]<= str5[31:24];            //sotto
                                  barsend[39:32]<= str6[31:24];
                                  barsend[31:24]<= str7[31:24];
                                  barsend[23:16]<= str8[31:24];
                                  barsend[15:8] <= 8'b00000000;
                                  barsend[7:0]  <= 8'b00000011;
                          end
            if (gcount ==17) begin                                  // deseleziono il wr dellidriver alfanumerici

                                  barsend[15:8] <= 8'b00000000;
                                  barsend[7:0]  <= 8'b00001000;
                          end








              if (cnt ==0) begin                      //lo considero inizio del clock
                                gsclk <= 1'b0;
                                cnt <=cnt+1;
                              end
              if (cnt==1) begin
                               gsdo <=    {barsend[cntspi]};
                               cnt <=cnt+1;
                            end

              if (cnt ==2) begin
                                gsclk <= 1'b1;
                                cnt <=cnt+1;
                            end

                if (cnt ==3) begin
                                    cntspi <=cntspi +1;
                                    if (cntspi ==47) begin
                                                          gload <=1'b0;
                                                          cnt <=cnt+1;
                                                      end
                                    else cnt <=00;
                              end


                if (cnt ==4) begin                      //lo considero inizio del clock
                                  gload <=1'b1;
                                  cnt <= cnt+1;
                                  gcount <=gcount+1;
                                  cntspi <=00;
                                  drain<= drain<<1;
                              end

                  if (cnt ==5) begin                      //lo considero inizio del clock
                                    gload <=1'b1;
                                    cnt <= 00;
                                    cntspi <=00;
                                end
      end
      assign graph1[0] =regbar[0];//1 default
      assign graph2[0] =regbar[1];//1
      assign graph3[0] =regbar[2];
      assign graph4[0] =regbar[3];
      assign graph1[1] =regbar[4];
      assign graph2[1] =regbar[5];
      assign graph3[1] =regbar[6];
      assign graph4[1] =regbar[7];//fino qui  1
      assign graph1[2] =regbar[8];
      assign graph2[2] =regbar[9];
      assign graph3[2] =regbar[10];
      assign graph4[2] =regbar[11];
      assign graph1[3] =regbar[12];
      assign graph2[3] =regbar[13];
      assign graph3[3] =regbar[14];
      assign graph4[3] =regbar[15];
      assign graph1[4] =regbar[16];
      assign graph2[4] =regbar[17];
      assign graph3[4] =regbar[18];
      assign graph4[4] =regbar[19];
      assign graph1[5] =regbar[20];
      assign graph2[5] =regbar[21];
      assign graph3[5] =regbar[22];
      assign graph4[5] =regbar[23];
      assign graph1[6] =regbar[24];
      assign graph2[6] =regbar[25];
      assign graph3[6] =regbar[26];
      assign graph4[6] =regbar[27];
      assign graph1[7] =regbar[28];
      assign graph2[7] =regbar[29];
      assign graph3[7] =regbar[30];
      assign graph4[7] =regbar[31];
assign val[0] =val1;
assign val[1] =val2;
assign val[2] =val3;
assign val[3] =val4;
assign val[4] =val5;
assign val[5] =val6;
assign val[6] =val7;
assign val[7] =val8;

endmodule
