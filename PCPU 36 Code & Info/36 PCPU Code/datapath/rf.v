module rf(Clk, WrEn, Ra, Rb, Rw, busW, busA, busB, R31Wr, R31);

	input Clk, WrEn, R31Wr;
	input[4:0] Ra, Rb, Rw;
	input[31:0] busW;
	input[31:2] R31;
	
	output[31:0] busA, busB;
	reg[31:0] regs[0:31];

	integer i;
	initial begin		
		for (i = 0; i < 32; i = i + 1) regs[i] = 0;
	end
	always @(negedge Clk)	begin
		if(WrEn)  regs[Rw] <= busW;	
		if(R31Wr) regs[31] <= {R31, 2'b0};
	end
	assign busA = (Ra != 5'd0) ? regs[Ra]: 32'd0;
	assign busB = (Rb != 5'd0) ? regs[Rb]: 32'd0;
	
endmodule 
