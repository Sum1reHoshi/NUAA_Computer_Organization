module alu(busA, busB, ALUctr, shamt, Result, Zero);
    input[4:0] ALUctr;
    input[31:0] busA, busB;
    input[4:0] shamt;

    output[31:0] Result;
    output Zero;

    reg[31:0] Result;

    always@(busA or busB or ALUctr)
    begin
        case (ALUctr)
            5'b00000:Result <= busA + busB;   //addu
            5'b00001:Result <= busA - busB;   //subu
            5'b00010:Result <= busA < busB;   //slt
            5'b00011:Result <= busA & busB;   //and
            5'b00100:Result <= ~(busA | busB); //nor
            5'b00101:Result <= busA | busB;  //or
            5'b00110:Result <= busA ^ busB;   //xor
            5'b00111:Result <= busB << shamt; //sll
            5'b01000:Result <= busB >> shamt; //srl
            5'b01001:Result <= (busA < busB) ? 1 : 0; //sltu
        //    5'b01010: jalr
        //    5'b01011: jr
            5'b01100:Result <= busB << busA;    //sllv
            5'b01101:Result <= ($signed(busB)) >>> shamt; //sra
            5'b01110:Result <= ($signed(busB)) >>> busA;  //srav
            5'b01111:Result <= busB >> busA;    //srlv
            5'b10000:Result <= busB << 16;  //lui
        endcase 
    end

    assign Zero = (Result == 0);

endmodule