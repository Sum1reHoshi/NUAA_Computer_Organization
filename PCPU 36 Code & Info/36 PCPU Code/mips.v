module mips(clk,  rst);
	//DEFINE
	input	clk ;   // clock
	input	rst ;// reset
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//IF DEFINE

	wire[31:2] NPC, PC, PC_plus_4, B_PC;
	wire[31:0] IF_ins;
	wire Branch_ok, BranchBubble, R31Wr;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//ID DEFINE

 	wire[31:0] ID_ins, ID_busA,  ID_busA_mux2, ID_busB,  ID_busB_mux2;
    wire[31:2] ID_B_PC;
    wire[4:0] ID_Ra, ID_Rb, ID_Rw, ID_shf;
    wire[31:0] ID_imm16Ext;
    wire[15:0] ID_imm16;
	//CONTROLL SIGN
	wire ID_RegWr, ID_RegDst, ID_ExtOp, ID_ALUsrc;
	wire[2:0] ID_Branch;
	wire[1:0] ID_Jump, ID_MemWr, ID_MemRead;
	wire ID_MemtoReg, ID_ALUshf;
	wire[3:0] ID_ALUctr;
  
	wire[4:0] ID_rd;
	wire[31:2] ID_PC;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//EX DEFINE

	wire[31:0] Ex_busB_mux3, Ex_alu_result, Ex_busA, Ex_busB;//Ex
	wire Ex_Zero;
	wire[4:0] Ex_Ra, Ex_Rb, Ex_Rw, Ex_Rw_mux2, Ex_shf, Ex_rd;
	wire[31:0] Ex_shfExt, Ex_imm16Ext, Ex_busA_mux3, Ex_alu_busA, Ex_alu_busB;
	wire Ex_RegWr, Ex_RegDst, Ex_ALUsrc, Ex_MemtoReg, Ex_ALUshf;
	wire[1:0] Ex_MemWr, Ex_MemRead;
	wire[3:0] Ex_ALUctr;
	wire[31:2] Ex_PC;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MEM DEFINE

	wire[31:0] Mem_dout, Mem_alu_result, Mem_busB, Mem_busA;
	wire[4:0] Mem_Rw, Mem_rd;
	wire Mem_RegWr, Mem_MemtoReg, Mem_Zero;
	wire[1:0] Mem_MemWr, Mem_MemRead;
	wire[31:2] Mem_PC;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //WR DEFINE

	wire[31:0] Wr_dout, Wr_alu_result, Wr_busW, Wr_busA, Wr_busW_mux2_dout, Wr_busB;
	wire[4:0] Wr_Rw, Wr_rd;
	wire  Wr_RegWr, Wr_MemtoReg;
	wire[31:2] Wr_PC;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//FORWARDING DEFINE

	wire[1:0] forwardA, forwardB;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//HAZARD DEFINE

	wire hazard;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  	//IF BLOCK

	pc pc(.NPC(NPC), .Clk(clk), .Reset(rst), .PC(PC), .hazard(hazard), .BranchBubble(BranchBubble));
	
	npc npc(.PC_plus_4(PC_plus_4), .PC_br(ID_B_PC[31:2]+ ID_imm16Ext[29:0]), .PC_jump01( {ID_B_PC[31:28], ID_ins[25:0]} ), 
            .PC_jump10(ID_busA_mux2[31:2]), .Branch_ok(Branch_ok), .Jump(ID_Jump), .NPC(NPC));

 	assign PC_plus_4 = PC + 1;
	assign B_PC = PC;
	
	im_4k im_4k( .addr(PC[31:2]), .dout(IF_ins));

	IF_ID IF_id(clk, rst, ID_Jump, Branch_ok, hazard, IF_ins, ID_ins, B_PC, ID_B_PC, BranchBubble, PC, ID_PC); 
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//ID BLOCK

	assign ID_Ra = ID_ins[25:21];
	assign ID_Rb = ID_ins[20:16];
	assign ID_Rw = ID_ins[15:11];
	assign ID_imm16 = ID_ins[15:0];
	assign ID_shf = ID_ins[10:6];
	assign ID_rd = ID_ins[15:11];
	
	ctrl ctrl(.clk(clk), .op(ID_ins[31:26]), .func(ID_ins[5:0]), .ALUctr(ID_ALUctr), .Branch(ID_Branch), .Jump(ID_Jump), .RegDst(ID_RegDst), 
              .ALUsrc(ID_ALUsrc), .MemtoReg(ID_MemtoReg), .RegWr(ID_RegWr), .MemWr(ID_MemWr), .ExtOp(ID_ExtOp), .MemRead(ID_MemRead), .ALUshf(ID_ALUshf),  
              .R31Wr(R31Wr), .Rb(ID_Rb));

	rf rf(.Clk(clk), .WrEn(Wr_RegWr), .Ra(ID_Ra), .Rb(ID_Rb), .Rw(Wr_Rw), .busW(Wr_busW), 
  		  .busA(ID_busA), .busB(ID_busB), .R31Wr(R31Wr), .R31(ID_B_PC+30'b1));	//REGS[31] = B_PC + 1

	SignExt16 SignExt16(.ExtOp(ID_ExtOp), .a(ID_imm16), .y(ID_imm16Ext));
  	
	BranchForwardingUnit BranchForwardingUnit(.ID_Ra(ID_Ra), .ID_Rb(ID_Rb), .Mem_Rw(Mem_Rw), .Mem_RegWr(Mem_RegWr), .Mem_MemtoReg(Mem_MemtoReg), 
                        					  .BranchForwardA(BranchForwardA), .BranchForwardB(BranchForwardB));

	MUX2 MUX2_ID_busA(ID_busA, Mem_alu_result, BranchForwardA, ID_busA_mux2);

	MUX2 MUX2_ID_busB(ID_busB, Mem_alu_result, BranchForwardB, ID_busB_mux2);

	branchOrNot BranchOrNot(ID_busA_mux2, ID_busB_mux2, ID_Branch, Branch_ok);
    
	BranchBubbleUnit BranchBubbleUnit(.ID_Ra(ID_Ra), .ID_Rb(ID_Rb), .Ex_RegWr(Ex_RegWr), .Ex_Rw(Ex_Rw_mux2),  .Mem_RegWr(Mem_RegWr), 
                                      .Mem_MemtoReg(Mem_MemtoReg), .Mem_Rw(Mem_Rw), .BranchBubble(BranchBubble),  .ID_Branch(ID_Branch), 
                                      .ID_Jump(ID_Jump) );

	HazardDetectionUnit HazardDetectionUnit(Ex_MemtoReg & Ex_RegWr, Ex_Rw_mux2, ID_Ra, ID_Rb, hazard);

	ID_Ex ID_ex(clk, hazard, BranchBubble, ID_busA, ID_busB, ID_Ra, ID_Rb, ID_Rw, ID_imm16Ext,  ID_RegWr, ID_RegDst, ID_ALUsrc, 
                ID_MemWr, ID_MemtoReg, ID_ALUctr, ID_MemRead, ID_shf, ID_ALUshf, Ex_busA, Ex_busB, Ex_Ra, Ex_Rb, Ex_Rw, Ex_imm16Ext, 
                Ex_RegWr, Ex_RegDst, Ex_ALUsrc, Ex_MemWr, Ex_MemtoReg, Ex_ALUctr, Ex_MemRead, Ex_shf, Ex_ALUshf, ID_rd, ID_PC, Ex_rd, Ex_PC);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//EX BLOCK

	MUX2 #(5) MUX2_RegDst(Ex_Rb, Ex_Rw, Ex_RegDst, Ex_Rw_mux2);

	forwardingUnit forwardingUnit(Ex_Ra, Ex_Rb, Mem_Rw, Mem_RegWr, Wr_Rw, Wr_RegWr, forwardA, forwardB);
    
	SignExt5 SignExt5(.a(Ex_shf), .y(Ex_shfExt));

	MUX3  MUX3_alu_busA(Ex_busA, Wr_busW, Mem_alu_result, forwardA, Ex_busA_mux3);

	MUX2  MUX2_ALUshf_busA(Ex_busA_mux3, Ex_shfExt, Ex_ALUshf, Ex_alu_busA);

	MUX3  MUX3_alu_busB(Ex_busB, Wr_busW, Mem_alu_result, forwardB, Ex_busB_mux3);

	MUX2  MUX2_ALUsrc(Ex_busB_mux3, Ex_imm16Ext, Ex_ALUsrc, Ex_alu_busB);

	ALU	ALU(Ex_alu_busA, Ex_alu_busB, Ex_ALUctr, Ex_Zero, Ex_alu_result);
	

	Ex_Mem Ex_mem(clk, Ex_Zero, Ex_alu_result, Ex_busB_mux3, Ex_Rw_mux2, Ex_RegWr, Ex_MemWr, Ex_MemtoReg, Mem_Zero, Mem_alu_result, 
                   Mem_busB, Mem_Rw, Mem_RegWr, Mem_MemWr, Mem_MemtoReg, Ex_MemRead, Mem_MemRead, Ex_busA_mux3, 
                   Mem_busA, Ex_rd, Ex_PC, Mem_rd, Mem_PC);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//MEM BLOCK

	dm_4k	dm_4k(.addr(Mem_alu_result[11:0]), .din(Mem_busB), .we(Mem_MemWr), .clk(clk), .dout(Mem_dout), .memRead(Mem_MemRead));

	Mem_Wr Mem_wr(clk, Mem_dout, Mem_alu_result, Mem_Rw, Mem_RegWr, Mem_MemtoReg, Wr_dout, Wr_alu_result, Wr_Rw, Wr_RegWr, Wr_MemtoReg, 
                   Mem_busA, Wr_busA, 
                   Mem_rd, Mem_busB, Mem_PC, Wr_rd, Wr_busB, Wr_PC);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//WR BLOCK

	MUX2	MUX2_Wr_dout(Wr_alu_result, Wr_dout, Wr_MemtoReg, Wr_busW_mux2_dout);
	
	assign Wr_busW = Wr_busW_mux2_dout;

endmodule
