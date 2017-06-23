`timescale  1ns/1ns
module simulation_tb;
   wire CLOCK_50;
   
   
   wire  [31:0] inputPio;
   wire [31:0] outputPio;

   wire [7:0]  address_a;      //to write
   reg  [7:0]  address_b;      //to read
   wire [31:0] data_a;  
   reg  [31:0] data_b;         //not used
   wire        wren_a; 
   wire        wren_b;        //always 0
   wire [31:0] q_a;           //not used
   wire [31:0] q_b; 
    
   clockgen_fake clock(CLOCK_50);
   
   SdRambuffer buffer_dut(address_a, address_b, CLOCK_50, data_a, data_b, wren_a, wren_b, q_a, q_b);
   
    
    
   wire  workingAtFirstPosition;
   wire  workingAtFinalPosition;
   wire  fillBuffer;
   wire  msgToFillBufferWasReceived;
   wire componentTofillBufferIsBotting;
   fillBuffer fill_dut(CLOCK_50,inputPio, outputPio,address_a,data_a, wren_a, workingAtFirstPosition,workingAtFinalPosition,fillBuffer,msgToFillBufferWasReceived,componentTofillBufferIsBotting);
   
   processBuffer proc_dut(CLOCK_50,address_b,data_b,fillBuffer,workingAtFirstPosition,workingAtFinalPosition,msgToFillBufferWasReceived,componentTofillBufferIsBotting,LEDR);
   sendDataToFillbuffer_fake sendDataToFillbuffer_dut(CLOCK_50,inputPio,outputPio);
   reg [63:0] x=  64'h0000000003e44970;  
   reg [63:0] one=64'h0000000010000000;  
   initial begin
      //write data at memory================================================ 
      integer i;
      /*for( i = 0; i <= 512; i++ ) begin
         #800 if(outputPio==32'h00000006) begin
                     #800 x=(((x*64'h0000000040000000)>>28) *(one-x))>>28;
                     inputPio= 32'h00450000|x[31:16];
                     
                  end
                  else begin
                     #800;
                  end
                  
                  if(outputPio==32'h00000003) begin
                     #800 inputPio= 32'h00480000|x[15:0];
                     
                  end
                  else begin
                     #800;
                  end
      end*/
      //end=================================================================
      for( i = 0; i <  256; i++ ) begin 
         #800;
      end
      x=  64'h0000000003e44970;     
      for( i = 0; i <  512; i++ ) begin       
          #339920 x=(((x*64'h0000000040000000)>>28) *(one-x))>>28;           
      end
      
       $stop;
   end
  
endmodule