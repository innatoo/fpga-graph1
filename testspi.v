module SPI_slave(CLK, SCK, MOSI, MISO, SSEL, LED, VAL);
input CLK;
input  [7:0] VAL;
input SCK, SSEL, MOSI;
output MISO;

output LED;
// sync SCK to the FPGA clock using a 3-bits shift register
reg [2:0] SCKr;  always @(posedge CLK) SCKr <= {SCKr[1:0], SCK};
wire SCK_risingedge = (SCKr[2:1]==2'b01);  // now we can detect SCK rising edges
wire SCK_fallingedge = (SCKr[2:1]==2'b10);  // and falling edges

// same thing for SSEL
reg [2:0] SSELr;  always @(posedge CLK) SSELr <= {SSELr[1:0], SSEL};
wire SSEL_active = ~SSELr[1];  // SSEL is active low
wire SSEL_startmessage = (SSELr[2:1]==2'b10);  // message starts at falling edge
wire SSEL_endmessage = (SSELr[2:1]==2'b01);  // message stops at rising edge

// and for MOSI
reg [1:0] MOSIr;  always @(posedge CLK) MOSIr <= {MOSIr[0], MOSI};
wire MOSI_data = MOSIr[1];



//  Now receiving data from the SPI bus is easy.

// we handle SPI in 8-bits format, so we need a 3 bits counter to count the bits as they come in
reg [2:0] bitcnt0;

reg [1:0] cnt0;
reg [1:0] cnt1;
reg byte_received;  // high when a byte has been received
reg [7:0] byte_data_received;
reg [7:0] reg_data_rec [1:0];

always @(posedge CLK)
begin
  if(~SSEL_active)begin
    bitcnt0 <= 3'b000;
    cnt0 <= 2'b00;

      end
  else
  if(SCK_risingedge)
  begin
    bitcnt0 <= bitcnt0 + 3'b001;


    // implement a shift-left register (since we receive the data MSB first)
    byte_data_received <= {byte_data_received[6:0], MOSI_data};
  end



 byte_received <= SSEL_active && SCK_risingedge && (bitcnt0==3'b111);
 if (byte_received) begin
                          cnt0 <= cnt0 +8'h01;
                          if (cnt0 ==8'h00)reg_data_rec [0] <= byte_data_received;
                            if (cnt0 ==8'h01)reg_data_rec [1] <= byte_data_received;
                      end
end


// we use the LSB of the data received to control an LED
reg LED;
always @(posedge CLK) if(byte_received) LED <= byte_data_received[0];



reg [7:0] byte_data_sent;


// always @(posedge CLK) if(SSEL_startmessage) cnt<=8'h00;  // count the messages

always @(posedge CLK)
begin
  if(SSEL_active)
                begin

                    if(SSEL_startmessage) byte_data_sent <=8'hce;
                    if(SSEL_startmessage) cnt1<=8'h00;
    // byte_data_sent <= cnt;  // first byte sent in a message is the message count
                    else
                        if(SCK_fallingedge)
                                          begin
                                              if(bitcnt0==3'b000) begin
                                                                        cnt1 <= cnt1 +8'h01;
                                                                        if (cnt1 ==8'h00)   byte_data_sent <=8'haa;
                                                                        if (cnt1 ==8'h01)   byte_data_sent <=reg_data_rec[0] ;
                                                                        if (cnt1 ==8'h02)   byte_data_sent <=VAL;

                                                                  end
                                              else     byte_data_sent <= {byte_data_sent[6:0], 1'b0};

                                          end
                  end

end
// we assume that there is only one slave on the SPI bus
// so we don't bother with a tri-state buffer for MISO
// otherwise we would need to tri-state MISO when SSEL is inactive
assign MISO = byte_data_sent[7];  // send MSB first
endmodule
