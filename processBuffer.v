module processBuffer(clock,addressAtBuffer,dataAtBuffer,fillBuffer,fillingFirstPosition,fillingFinalPosition,msgToFillBufferWasReceived,componentTofillBufferIsBotting,error);
   input  wire clock;   
   output reg  [7:0]   addressAtBuffer=8'h00;
   input  wire [31:0]  dataAtBuffer;
   output reg          fillBuffer;
   input  wire         fillingFirstPosition;
   input  wire         fillingFinalPosition;
   input  wire         msgToFillBufferWasReceived;
   input  wire         componentTofillBufferIsBotting;
   output reg error;
   
 
   reg [15:0] count=16'h0000;
   reg eraseCount=1'b0;
   reg [31:0] intValue=32'h00000000;
   reg firstPass=1'b1;
   always @(posedge clock) begin 
      if(componentTofillBufferIsBotting==1'b0) begin
         /*if(count==16'h4264) begin
            eraseCount=1'b1;
            addressAtBuffer=addressAtBuffer+8'h01;
         end  */
         if(count==16'h0118) begin
            eraseCount=1'b1;
            addressAtBuffer=addressAtBuffer+8'h01;
         end
         else if(count==16'h0000 && addressAtBuffer==8'h00) begin
            if(fillingFirstPosition==1'b1) begin
               error=1'b1;                
            end
            else begin              
               fillBuffer=1'b1;               
            end
            
         end                 
         if(count==16'h0000 && addressAtBuffer==8'h80) begin
            if(fillingFinalPosition==1'b1) begin
               error=1'b1;   
            end 
            else begin                     
               fillBuffer=1'b1;
            end
         end
         if(count==16'h0000) begin
            eraseCount=1'b0;            
         end
      end
      if(msgToFillBufferWasReceived==1'b1) begin
         fillBuffer=1'b0;
      end
   end
   always @(negedge clock) begin
      if(eraseCount==1'b0 && componentTofillBufferIsBotting==1'b0) begin
         count<=count+16'h01;
      end
      else begin
         count<=16'h00;
      end
   end
endmodule