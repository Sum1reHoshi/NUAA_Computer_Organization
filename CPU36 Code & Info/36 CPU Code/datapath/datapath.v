module datapath(clk, rst, RegDst, ALUsrc, MemtoReg, RegWr, MemWr, Branch, Jump, ExtOp, Rtype, ALUctr, NPCop, DMop, REGSop, op, func, Rt);

    input clk, rst, RegDst, ALUsrc, MemtoReg, RegWr, MemWr, Branch, Jump, ExtOp, Rtype;
    input[4:0] ALUctr;
    input[3:0] NPCop;
    input DMop;
    input[2:0] REGSop;

    output[5:0] op, func;
    output[4:0] Rt;

    wire[31:0] PC, NPC;
    wire[31:0] instructions;
    pc pc(NPC, PC, rst, clk);
    im_4k im(PC[11:2], instructions);

    wire[4:0] Rs, Rt, Rd, shamt;
    wire[15:0] imm16;
    wire[25:0] target;
    instruction instruction(instructions, op, Rs, Rt, Rd, shamt, func, imm16, target);

    wire[31:0] Result;
    wire[31:0] busW, busA, busB;
    wire[4:0] Rw, Ra, Rb;
    assign Rw = RegDst ? Rd : Rt;
    assign Ra = Rs;
    assign Rb = Rt;
    regfile regfile(Result, RegWr, busW, Rw, Ra, Rb, clk, PC, REGSop, busA, busB);

    wire[31:0] imm32;
    ext ext(imm16, imm32, ExtOp);

    wire[31:0] tempBus;
    assign tempBus = ALUsrc ? imm32 : busB;
    wire Zero;
    alu alu(busA, tempBus, ALUctr, shamt, Result, Zero);

    wire[31:0] dout;
    dm_4k dm(Result, busB, MemWr, clk, DMop, dout);
    assign busW = MemtoReg ? dout : Result;

    NPC npc(PC, target, imm16, Jump, Branch, Zero, NPCop, busA, NPC);
endmodule