module Ex_Mem(Clk, Ex_Zero, Ex_alu_result, Ex_busB, Ex_Rw,Ex_RegWr, Ex_MemWr, Ex_MemtoReg,
			  Mem_Zero, Mem_alu_result, Mem_busB, Mem_Rw, Mem_RegWr, Mem_MemWr, Mem_MemtoReg,
			  Ex_MemRead, Mem_MemRead, Ex_busA_mux3, Mem_busA, Ex_cs, Ex_PC, Mem_cs, Mem_PC);

	input Clk, Ex_Zero, Ex_RegWr, Ex_MemtoReg;
	input[31:0] Ex_alu_result, Ex_busB, Ex_busA_mux3;
	input[4:0] Ex_Rw, Ex_cs;       
	input[1:0] Ex_MemWr, Ex_MemRead;
	input[31:2] Ex_PC;

	output reg Mem_Zero, Mem_RegWr, Mem_MemtoReg;
	output reg[31:0] Mem_alu_result, Mem_busB, Mem_busA;
	output reg[4:0] Mem_Rw, Mem_cs;
	output reg[1:0] Mem_MemWr, Mem_MemRead;
 	output reg[31:2] Mem_PC;

	initial 
	begin
		{Mem_Zero, Mem_alu_result, Mem_busB, Mem_Rw, Mem_RegWr, Mem_MemWr, Mem_MemtoReg,
		Mem_MemRead, Mem_busA, Mem_cs, Mem_PC}
		<= 151'b0;
	end

	always@(posedge Clk)
	begin
		{Mem_alu_result, Mem_busB, Mem_Rw, Mem_Zero, Mem_RegWr, Mem_MemWr, Mem_MemtoReg,
		Mem_MemRead, Mem_busA, Mem_cs, Mem_PC}
		<=
		{Ex_alu_result, Ex_busB, Ex_Rw, Ex_Zero, Ex_RegWr, Ex_MemWr, Ex_MemtoReg,
		Ex_MemRead, Ex_busA_mux3, Ex_cs,Ex_PC};
	end

endmodule