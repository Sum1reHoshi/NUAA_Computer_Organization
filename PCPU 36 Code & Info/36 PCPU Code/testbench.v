module testbench();
	reg clk,rst;

	initial begin
		clk = 0;
		rst = 1;
		#25 rst = 0;
	end
	always #20 clk = ~clk;

	mips mips(clk,rst);
endmodule 