module testbench();

    reg clk, rst;

    initial
    begin
        clk = 1'b0;
        rst = 1'b1;
  	#50 rst = 1'b0;
    end

    always #25 clk = ~clk;

    mips mips(clk, rst);
    
endmodule