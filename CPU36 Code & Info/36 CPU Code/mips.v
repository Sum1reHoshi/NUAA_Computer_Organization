module mips(clk, rst);
    input clk ; // clock
    input rst ;// reset

    wire[5:0] op, func;
    wire[4:0] Rt;
    wire[4:0] ALUctr;
    wire[3:0] NPCop;
    wire DMop;
    wire[2:0] REGSop;
    wire RegWr, ALUSrc, RegDst, MemtoReg, MemWr, Branch, Jump, ExtOp, Rtype;

    controller controller(op, func, Rt, RegWr, ALUSrc, RegDst, MemtoReg, MemWr, Branch, Jump, ExtOp, Rtype, ALUctr, NPCop, DMop, REGSop);
    datapath datapath(clk, rst, RegDst, ALUSrc, MemtoReg, RegWr, MemWr, Branch, Jump, ExtOp, Rtype, ALUctr, NPCop, DMop, REGSop, op, func, Rt);
endmodule