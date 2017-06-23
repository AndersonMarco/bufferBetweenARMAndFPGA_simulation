module main (LEDR);
   input wire [9:0] LEDR;
   wire  [31:0] inputPio;
   wire [31:0] outputPio;

   wire [7:0]  address_a;      //to write
   wire  [7:0]  address_b;      //to read
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
endmodule