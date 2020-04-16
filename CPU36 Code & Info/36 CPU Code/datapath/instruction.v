module instruction(ins, op, rs, rt, rd, shamt, func, imm16, target);
    input[31:0] ins;

    output[5:0] op, func;
    output[4:0] rs, rt, rd, shamt;
    output[15:0] imm16;
    output[25:0] target;

    assign op = ins[31:26];
    assign rs = ins[25:21];
    assign rt = ins[20:16];
    assign rd = ins[15:11];
    assign shamt = ins[10:6];
    assign func = ins[5:0];
    assign imm16 = ins[15:0];
    assign target = ins[25:0];
endmodule