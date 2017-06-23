
module fillBuffer(clock,inputPio, outputPio,addressAtBuffer,dataAtBuffer, wren, workingAtFirstPosition, workingAtFinalPosition,fillBuffer,msgToFillBufferWasReceived,componentTofillBufferIsBotting);
   input  wire         clock;
   input  wire [31:0]  inputPio;   
   output reg  [31:0]  outputPio;   
   output reg  [7:0]   addressAtBuffer=8'h00;
   output reg  [31:0]  dataAtBuffer;
   output reg          wren;     
   output reg          workingAtFirstPosition=1'b1;                       
   output reg          workingAtFinalPosition=1'b0;
   input  wire         fillBuffer;         
   output reg          msgToFillBufferWasReceived=1'b0;
   output reg          componentTofillBufferIsBotting=1'b1;
   reg                 loadingInittialData=1'b1;
   reg                 writingAtMemory=1'b0;
   reg         [4:0]   nClocksAfterThatABlockMemoryWasReceived=4'h0;
   reg                 firstClock=1'b1;
   reg         [31:0]  outputPioValue;  
   reg                 reciveSecondBlockOfTheMsg=1'b0;
   reg                 receveNextMsg;
   always @(posedge clock) begin      
      if(firstClock==1'b1) begin
         outputPio<=32'h00000006;
         firstClock<=1'b0;
         workingAtFirstPosition<=1'b1;
         workingAtFinalPosition<=1'b0;
         reciveSecondBlockOfTheMsg<=1'b0;
         receveNextMsg<=1'b1;
      end  
      
      if(writingAtMemory==1'b0) begin                      
         if(inputPio[31:16]==16'h0045 && reciveSecondBlockOfTheMsg==1'b0) begin   
            dataAtBuffer[31:16]<=inputPio[15:0];
            outputPio<=32'h00000003;      
            reciveSecondBlockOfTheMsg<=1'b1;
         end            
         else if(inputPio[31:16]==16'h0048 && reciveSecondBlockOfTheMsg==1'b1) begin         
            dataAtBuffer[15:0]<=inputPio[15:0];
            nClocksAfterThatABlockMemoryWasReceived<=4'h0;                          
            if(loadingInittialData==1'b1) begin
               if(addressAtBuffer==8'hff) begin
                  outputPio<=32'h00000007;                  
                  loadingInittialData<=1'b0;
                  receveNextMsg<=1'b0;                  
               end
               else begin
                  outputPio<=32'h00000006;
                  receveNextMsg<=1'b1;                  
               end               
            end   
            else begin
               if(addressAtBuffer==8'h7f || addressAtBuffer==8'hff) begin
                  outputPio<=32'h00000007;
                  receveNextMsg<=1'b0;
               end
               else begin
                  outputPio<=32'h00000006;
                  receveNextMsg<=1'b1;
               end
            end                       
            writingAtMemory<=1'b1;              
            reciveSecondBlockOfTheMsg<=1'b0;
         end 
         else if(receveNextMsg==1'b0 && reciveSecondBlockOfTheMsg==1'b0) begin
            if(fillBuffer==1'b1) begin
               outputPio<=32'h00000006;
               receveNextMsg<=1'b1;
               reciveSecondBlockOfTheMsg<=1'b0;
               msgToFillBufferWasReceived<=1'b1;
               if(addressAtBuffer==8'h00) begin
                  workingAtFirstPosition<=1'b1;
                  workingAtFinalPosition<=1'b0;
               end
               else if(addressAtBuffer==8'h80) begin
                  workingAtFirstPosition<=1'b0;
                  workingAtFinalPosition<=1'b1;
               end
            end            
            else begin
               msgToFillBufferWasReceived<=1'b0;
               workingAtFirstPosition<=1'b0;
               workingAtFinalPosition<=1'b0;
            end  
         end
      end
      else if(nClocksAfterThatABlockMemoryWasReceived== 4'h0) begin
         wren=1'b1;
         nClocksAfterThatABlockMemoryWasReceived<=nClocksAfterThatABlockMemoryWasReceived+4'h1;
      end
      else if(nClocksAfterThatABlockMemoryWasReceived==4'h1) begin
         nClocksAfterThatABlockMemoryWasReceived<=nClocksAfterThatABlockMemoryWasReceived+4'h1;
      end 
      else if(nClocksAfterThatABlockMemoryWasReceived==4'h2) begin
         nClocksAfterThatABlockMemoryWasReceived<=nClocksAfterThatABlockMemoryWasReceived+4'h1;
         wren<=1'b0;         
      end
      else  begin        
         writingAtMemory<=1'b0;         
         if(addressAtBuffer!=8'hff) begin
            addressAtBuffer<=addressAtBuffer+8'h01;            
         end
         else begin
            addressAtBuffer<=8'h00;
            componentTofillBufferIsBotting<=1'b0;
         end         
      end
    end
   
endmodule