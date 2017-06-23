`timescale  1ns/1ns
module  clockgen_fake (clk_out);
   reg clk;   
   output wire clk_out;   
   initial clk=1;
	assign clk_out=clk;
   always begin
	#10 clk=~clk;
	
   end	
endmodule