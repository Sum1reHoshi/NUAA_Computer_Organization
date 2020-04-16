module ID_Ex(Clk, hazard, BranchBubble, ID_busA, ID_busB, ID_ra, ID_rb,
             ID_rw, ID_imm16Ext, ID_RegWr, ID_RegDst, ID_ALUsrc, ID_MemWr, ID_MemtoReg,
             ID_ALUctr, ID_MemRead, ID_shf, ID_ALUshf, Ex_busA, Ex_busB, Ex_ra,
             Ex_rb, Ex_rw, Ex_imm16Ext, Ex_RegWr, Ex_RegDst, Ex_ALUsrc, Ex_MemWr,
             Ex_MemtoReg, Ex_ALUctr, Ex_MemRead, Ex_shf, Ex_ALUshf,
             ID_rd, ID_PC,
             Ex_rd, Ex_PC
             );

        input Clk, hazard, BranchBubble;
        input ID_RegWr, ID_RegDst, ID_ALUsrc, ID_MemtoReg, ID_ALUshf;
        input[31:0] ID_busA, ID_busB, ID_imm16Ext;
        input[4:0] ID_ra, ID_rb, ID_rw, ID_shf, ID_rd;
        input[1:0] ID_MemWr, ID_MemRead; 
	    input[3:0] ID_ALUctr;
        input[31:2] ID_PC;

        output reg[4:0] Ex_ra, Ex_rb, Ex_rw, Ex_rd, Ex_shf;
        output reg[31:0] Ex_busA, Ex_busB, Ex_imm16Ext;
        output reg Ex_RegWr, Ex_RegDst, Ex_ALUsrc, Ex_MemtoReg, Ex_ALUshf;
        output reg[1:0] Ex_MemWr, Ex_MemRead;
	    output reg[3:0] Ex_ALUctr;
        output reg[31:2] Ex_PC;

	    initial 
	    begin
	   		{Ex_ra, Ex_rb, Ex_rw, Ex_rd, Ex_shf, Ex_busA, Ex_busB, 
            Ex_imm16Ext, Ex_RegWr, Ex_RegDst, Ex_ALUsrc, Ex_MemtoReg, Ex_ALUshf, Ex_MemWr,
            Ex_MemRead, Ex_ALUctr, Ex_PC}
            <=163'b0;
	    end
        always@(posedge Clk)
        begin
             if (hazard || BranchBubble) begin
                {Ex_RegWr, Ex_RegDst, Ex_ALUsrc, Ex_MemWr, Ex_MemtoReg, Ex_ALUctr, Ex_MemRead, Ex_ALUshf,
                 Ex_rd, Ex_PC}
                <= 48'd0;
             end else begin
                {Ex_ra, Ex_rb, Ex_rw, Ex_busA, Ex_busB, Ex_imm16Ext, Ex_shf,
                 Ex_RegWr, Ex_RegDst, Ex_ALUsrc, Ex_MemWr, Ex_MemtoReg, Ex_ALUctr, Ex_MemRead,
                 Ex_ALUshf, Ex_rd, Ex_PC}
                 <=
                {ID_ra, ID_rb, ID_rw, ID_busA, ID_busB, ID_imm16Ext, ID_shf,
                 ID_RegWr, ID_RegDst, ID_ALUsrc, ID_MemWr, ID_MemtoReg, ID_ALUctr, ID_MemRead,
                 ID_ALUshf, ID_rd, ID_PC};
             end 
        end
endmodule