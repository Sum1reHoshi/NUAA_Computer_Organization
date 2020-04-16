module Mem_Wr(Clk, Mem_dout, Mem_alu_result, Mem_Rw, Mem_RegWr, Mem_MemtoReg, Wr_dout,
			  Wr_alu_result, Wr_Rw, Wr_RegWr, Wr_MemtoReg, Mem_busA, Wr_busA, Mem_Rd,
			  Mem_busB, Mem_PC, Wr_Rd, Wr_busB, Wr_PC);

    input Clk, Mem_RegWr, Mem_MemtoReg;
    input[31:0] Mem_dout, Mem_alu_result, Mem_busA, Mem_busB;
    input[4:0]  Mem_Rw, Mem_Rd;
    input[31:2] Mem_PC;

    output reg[31:0] Wr_dout, Wr_alu_result, Wr_busA, Wr_busB;
    output reg[4:0]  Wr_Rw, Wr_Rd;
    output reg Wr_RegWr, Wr_MemtoReg;
    output reg[31:2] Wr_PC;

    initial 
    begin
    	{Wr_dout, Wr_alu_result, Wr_busA, Wr_busB, Wr_Rw, Wr_Rd, Wr_RegWr,
		Wr_MemtoReg, Wr_PC}
		<=170'b0;
    end

    always @(posedge Clk)
    begin
    	{Wr_dout, Wr_alu_result, Wr_Rw, Wr_RegWr, Wr_MemtoReg, Wr_busA, Wr_Rd,
		Wr_busB, Wr_PC}
    	<=
		{Mem_dout, Mem_alu_result, Mem_Rw, Mem_RegWr, Mem_MemtoReg, Mem_busA, Mem_Rd,
		Mem_busB, Mem_PC};
    end
endmodule
