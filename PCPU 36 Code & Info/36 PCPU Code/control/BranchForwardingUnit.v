module BranchForwardingUnit(ID_Ra, ID_Rb, Mem_Rw, Mem_RegWr, Mem_MemtoReg, BranchForwardA, BranchForwardB);

	input[4:0] ID_Ra, ID_Rb, Mem_Rw;
	input Mem_MemtoReg, Mem_RegWr;

	output reg BranchForwardA, BranchForwardB;

	initial begin
		BranchForwardA = 0;
		BranchForwardB = 0;
	end

	always @(*) begin
		if (Mem_RegWr == 1 && Mem_Rw != 0 && Mem_Rw == ID_Ra)
			 BranchForwardA <= 1; 
		else 
			 BranchForwardA <= 0;
		if (Mem_RegWr == 1 && Mem_Rw != 0 && Mem_Rw == ID_Rb)
			 BranchForwardB <= 1; 
		else 
		     BranchForwardB <= 0;
	end
	
endmodule