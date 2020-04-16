module controller(op, func, Rt, RegWr, ALUSrc, RegDst, MemtoReg, MemWr, Branch, Jump, ExtOp, Rtype, ALUctr, NPCop, DMop, REGSop);
    input[5:0] op, func;
    input[4:0] Rt;

    output RegWr, ALUSrc, RegDst, MemtoReg, MemWr, Branch, Jump, ExtOp, Rtype;
    output[4:0] ALUctr;
    output[3:0] NPCop;
    output DMop;
    output[2:0] REGSop;

    wire[4:0] FuncOp, ALUop;

    //--------------------------------------------------------------------------
    //Instruction Sign
    wire r_addu = func[5] & !func[4] & !func[3] & !func[2] & !func[1] & func[0];
    wire r_subu = func[5] & !func[4] & !func[3] & !func[2] & func[1] & func[0];
    wire r_slt = func[5] & !func[4] & func[3] & !func[2] & func[1] & !func[0];
    wire r_and = func[5] & !func[4] & !func[3] & func[2] & !func[1] & !func[0];
    wire r_nor = func[5] & !func[4] & !func[3] & func[2] & func[1] & func[0];
    wire r_or = func[5] & !func[4] & !func[3] & func[2] & !func[1] & func[0];
    wire r_xor = func[5] & !func[4] & !func[3] & func[2] & func[1] & !func[0];
    wire r_sll = !func[5] & !func[4] & !func[3] & !func[2] & !func[1] & !func[0];
    wire r_srl = !func[5] & !func[4] & !func[3] & !func[2] & func[1] & !func[0];
    wire r_sltu = func[5] & !func[4] & func[3] & !func[2] & func[1] & func[0];
    wire r_jalr = !func[5] & !func[4] & func[3] & !func[2] & !func[1] & func[0];
    wire r_jr = !func[5] & !func[4] & func[3] & !func[2] & !func[1] & !func[0];
    wire r_sllv = !func[5] & !func[4] & !func[3] & func[2] & !func[1] & !func[0];
    wire r_sra = !func[5] & !func[4] & !func[3] & !func[2] & func[1] & func[0];
    wire r_srav = !func[5] & !func[4] & !func[3] & func[2] & func[1] & func[0];
    wire r_srlv = !func[5] & !func[4] & !func[3] & func[2] & func[1] & !func[0];

    wire i_addiu = !op[5] & !op[4] & op[3] & !op[2] & !op[1] & op[0];
    wire i_beq = !op[5] & !op[4] & !op[3] & op[2] & !op[1] & !op[0];
    wire i_bne = !op[5] & !op[4] & !op[3] & op[2] & !op[1] & op[0];
    wire i_lw = op[5] & !op[4] & !op[3] & !op[2] & op[1] & op[0];
    wire i_sw = op[5] & !op[4] & op[3] & !op[2] & op[1] & op[0];
    wire i_lui = !op[5] & !op[4] & op[3] & op[2] & op[1] & op[0];
    wire i_slti = !op[5] & !op[4] & op[3] & !op[2] & op[1] & !op[0];
    wire i_sltiu = !op[5] & !op[4] & op[3] & !op[2] & op[1] & op[0];
    wire i_bgez = !op[5] & !op[4] & !op[3] & !op[2] & !op[1] & op[0];
    wire i_bgtz = !op[5] & !op[4] & !op[3] & op[2] & op[1] & op[0];
    wire i_blez = !op[5] & !op[4] & !op[3] & op[2] & op[1] & !op[0];
    wire i_bltz = !op[5] & !op[4] & !op[3] & !op[2] & !op[1] & op[0];
    wire i_lb = op[5] & !op[4] & !op[3] & !op[2] & !op[1] & !op[0];
    wire i_lbu = op[5] & !op[4] & !op[3] & op[2] & !op[1] & !op[0];
    wire i_sb = op[5] & !op[4] & op[3] & !op[2] & !op[1] & !op[0];
    wire i_andi = !op[5] & !op[4] & op[3] & op[2] & !op[1] & !op[0];
    wire i_ori = !op[5] & !op[4] & op[3] & op[2] & !op[1] & op[0];
    wire i_xori = !op[5] & !op[4] & op[3] & op[2] & op[1] & !op[0];

    wire j_j = !op[5] & !op[4] & !op[3] & !op[2] & op[1] & !op[0];
    wire j_jal = !op[5] & !op[4] & !op[3] & !op[2] & op[1] & op[0];

    //--------------------------------------------------------------------------
    //SIGNctrl
    assign Rtype = !op[5] & !op[4] & !op[3] & !op[2] & !op[1] & !op[0];
    assign Branch = i_beq | i_bne | i_bgez | i_bgtz | i_blez | i_bltz;
    assign Jump = j_j | j_jal;
    assign RegDst = Rtype;
    assign ALUSrc = i_addiu | i_lw | i_sw | i_lui | i_slti | i_sltiu | i_lb | i_lbu | i_sb | i_andi | i_ori | i_xori;
    assign MemtoReg = i_lw | i_lb | i_lbu;
    assign RegWr = Rtype | i_addiu | i_lw | i_lui | i_slti | i_sltiu | i_lb | i_lbu | i_andi | i_ori | i_xori | j_jal;
    assign MemWr = i_sw | i_sb;
    assign ExtOp = i_addiu | i_lw | i_sw | i_slti | i_sltiu | i_lb | i_lbu | i_sb;

    //--------------------------------------------------------------------------
    //ALUctrl
    assign FuncOp[4] = 1'b0;
    assign FuncOp[3] = r_srl | r_sltu | r_jalr | r_jr | r_sllv | r_sra | r_srav | r_srlv;
    assign FuncOp[2] = r_nor | r_or | r_xor | r_sll | r_sllv | r_sra | r_srav | r_srlv;
    assign FuncOp[1] = r_slt | r_and | r_xor | r_sll | r_jalr | r_jr | r_srav | r_srlv;
    assign FuncOp[0] = r_subu | r_and | r_or | r_sll | r_sltu | r_jr | r_sra | r_srlv;

    assign ALUop[4] = i_lui;
    assign ALUop[3] = i_sltiu | j_jal;
    assign ALUop[2] = i_ori | i_xori;
    assign ALUop[1] = i_slti | i_andi | i_xori | j_jal;
    assign ALUop[0] = i_beq | i_bne | i_sltiu | i_andi | i_ori; 
    
    assign ALUctr = Rtype ? FuncOp : ALUop;
    
    //--------------------------------------------------------------------------
    //NPCctrl
    assign NPCop[3] = Rtype & (r_jr | r_jalr);
    assign NPCop[2] = (i_bgez && Rt == 5'b1) | i_bgtz | i_blez | (i_bltz && Rt == 5'b0);
    assign NPCop[1] =  i_beq | i_bne | i_blez | (i_bltz && Rt == 5'b0);
    assign NPCop[0] = j_jal | i_bne | i_bgtz | (i_bltz && Rt == 5'b0);

    //--------------------------------------------------------------------------
    //DMctrl
    assign DMop = i_sb;

    //--------------------------------------------------------------------------
    //REGSctrl
    assign REGSop[2] = r_jalr;
    assign REGSop[1] = i_lbu | j_jal;
    assign REGSop[0] = i_lb | j_jal;

endmodule