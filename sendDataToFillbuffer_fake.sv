module sendDataToFillbuffer_fake(clock,inputPio,outputPio);
   input  wire       clock;
   output reg[31:0]  inputPio;
   input  wire[31:0] outputPio;
   reg [63:0] x=  64'h0000000003e44970;     
   reg [63:0] one=64'h0000000010000000; 
   reg [7:0]  count=8'h00;
   always @(posedge clock) begin
      if(count==8'h00) begin
         if(outputPio==32'h00000006) begin
            x=(((x*64'h0000000040000000)>>28) *(one-x))>>28;
            inputPio= 32'h00450000|x[31:16];
         end
         else if(outputPio==32'h00000003) begin
            inputPio= 32'h00480000|x[15:0];
         end
      end
      count=count+8'h01;
      if(count==8'h28) begin
         count=8'h00;
      end
   end
endmodule