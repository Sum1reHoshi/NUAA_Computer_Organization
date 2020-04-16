//next pc
module NPC(PC, target, imm16, Jump, Branch, Zero, NPCop, busA, NPC);
    input[31:0] PC, busA;
    input[25:0] target;
    input[15:0] imm16;
    input[3:0] NPCop;
    input Jump, Branch, Zero;

    output[31:0] NPC;

    wire[29:0] imm30;
    signext #(16,30) signext(imm16, imm30);
    wire[31:0] imm32;
    assign imm32 = {imm30, 2'b00};

    //focus!
    //wire[31:0] PCadd4 = PC + 4;         //Branch delay slot
    //focus!

    wire[31:0] nAddr = PC + 4;          //no-J
    //wire[31:0] bAddr = PCadd4 + imm32;  //Branch
    wire[31:0] bAddr = PC + imm32;  //Branch
    //wire[31:0] jAddr = {PCadd4[31:28], target, 2'b00};  //Jump
    wire[31:0] jAddr = {PC[31:28], target, 2'b00};  //Jump

    reg[31:0] temp;

    always@(*)
    begin
        case(NPCop)
        4'b0000: temp = Jump ? jAddr : nAddr;        //j
        4'b0001: temp = Jump ? jAddr : nAddr;        //jal
        4'b0010: temp = (Zero && Branch) ? bAddr : nAddr;        //beq
        4'b0011: temp = (!Zero && Branch) ? bAddr : nAddr;       //bne
        4'b0100: temp = (busA[31] == 0) ? bAddr : nAddr;   //bgez
        4'b0101: temp = (Branch && busA != 0 && busA[31] == 0) ? bAddr : nAddr;	  //bgtz
        // temp = (Branch && busA != 0 && busA[31] == 0) ? bAddr : nAddr;
        4'b0110: temp = (Branch && (busA == 0 || busA[31] == 1)) ? bAddr : nAddr;   //blez
        // temp = (Branch && (busA == 0 || busA[31] == 1)) ? B_NPC : N_NPC;	
        4'b0111: temp = (busA[31] == 1) ? bAddr : nAddr;     //bltz
        4'b1000: temp = busA;    //jr jalr
        default: temp = nAddr;   //nextPC
        endcase
    end

    assign NPC = temp;
    // PC = PC + 1
    // PC = PC + 1 + signExt[imm16]
    // PC = PC[31:28] + target
    //assign NPC = Jump ? jAddr :
    //    Branch & Zero ? bAddr : nAddr;
endmodule