module reciveAndSendMessage(clock,inputPio, outputPio,led);
   input  wire clock;
   input  wire [31:0] inputPio;
   output reg  [31:0] outputPio;
   output reg led;

   reg [31:0] stage=32'h00000000;
   reg resetStage=1'b1;
   always @(posedge clock) begin 
      if(inputPio==32'h00000001 && stage==32'h00000000) begin
         led=1'b1;
         resetStage=1'b0;
         outputPio=32'h00020000;  
      end
       else if(inputPio==32'h00000201 && stage !=32'h00000000) begin
         outputPio=32'h00030000|stage;
         resetStage=1'b1;
       end       
       else if (inputPio!=32'h00000001 && stage==32'h00000000) begin
          led=1'b0;       
       end
       
   end
   always @(negedge clock) begin
      if(resetStage==1'b0) begin
         stage=stage+32'h00000001;
      end
      else begin
         stage=32'h00000000;
      end   
   end
endmodule