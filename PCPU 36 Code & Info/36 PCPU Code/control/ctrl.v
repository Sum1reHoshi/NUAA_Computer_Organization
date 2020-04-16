
module ctrl(clk, op, func, 
			ALUctr, Branch, Jump, RegDst, ALUsrc, MemtoReg, RegWr, 
			MemWr, ExtOp, MemRead, ALUshf, R31Wr, Rb);//Rb for bltz and bgez

	input clk;
	input[5:0] op, func;
	input[4:0] Rb;

	output reg[3:0] ALUctr;
	output reg[2:0] Branch;
	output reg[1:0] Jump, MemWr, MemRead;
	output reg RegDst, ALUsrc, MemtoReg, RegWr, ExtOp, ALUshf, R31Wr; 
	//R31Wr is sign about REGS[31] can be write or not

    initial 
		{ALUctr, Branch, Jump, RegDst, ALUsrc, MemtoReg, RegWr, MemWr, ExtOp, MemRead, ALUshf}
		<= 19'b0;

	always @(*)begin
		if (op == 6'b000011 || (op == 6'b000000 && func == 6'b001001)) 
			R31Wr = 1;//000011jal,0010001jalr
		else R31Wr = 0;
		case (op)
			6'b000000:begin//jr and jalr
				if (func == 6'b001000 || func == 6'b001001)
					{ALUctr, Branch, RegDst, ALUsrc, MemtoReg, RegWr, MemWr, ExtOp, MemRead, ALUshf, Jump}
					<= 19'b10;
				else //another R-type
				begin
					{Branch, Jump, ALUsrc, MemtoReg, MemWr, ExtOp, MemRead, RegDst, RegWr}
					<= 14'b11;
					ALUshf = (func == 6'b000000) || (func == 6'b000010) || (func == 6'b000011);
					case (func)
						6'b100001:ALUctr = 4'b0000;	//addu
						6'b100011:ALUctr = 4'b0001;	//subu
						6'b101010:ALUctr = 4'b0010;	//slt
						6'b100100:ALUctr = 4'b0011;	//and
						6'b100111:ALUctr = 4'b0100;	//nor
						6'b100101:ALUctr = 4'b0101;	//or
						6'b100110:ALUctr = 4'b0110;	//xor
						6'b101011:ALUctr = 4'b1001;	//sltu
						6'b000100:ALUctr = 4'b0111;	//sllv
						6'b000111:ALUctr = 4'b1010;	//srav
						6'b000110:ALUctr = 4'b1000;	//srlv
						6'b000000:ALUctr = 4'b0111;	//sll
						6'b000010:ALUctr = 4'b1000;	//srl
						6'b000011:ALUctr = 4'b1010;	//sra
						6'b001000:ALUctr = 4'b0000;	//jr
						6'b001001:ALUctr = 4'b0000;	//jalr
						default:ALUctr = 4'b0000;	//default
					endcase 
				end//end another R-type
			end//end R-type
			6'b001001:begin//addiu
				{Branch, Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ALUsrc, ExtOp, RegWr}
				<= 15'b111;
				ALUctr = 4'b0000;
			end
			6'b001111:begin//lui
				{Branch, Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ExtOp, ALUsrc, RegWr}
				<= 15'b11;
				ALUctr = 4'b1011;
			end 
			6'b001010:begin//slti
				{Branch, Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ALUsrc, RegWr, ExtOp}
				<= 15'b111;
				ALUctr = 4'b0010;
			end
			6'b001011:begin//sltiu
				{Branch, Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ALUsrc, RegWr, ExtOp}
				<= 15'b111;
				ALUctr = 4'b1001;
			end
			6'b001100:begin//andi
				{Branch, Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ExtOp, ALUsrc, RegWr}
				<= 15'b11;
				ALUctr = 4'b0011;
			end
			6'b001101:begin//ori
				{Branch, Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ExtOp, ALUsrc, RegWr}
				<= 15'b11;
				ALUctr = 4'b0101;
			end
			6'b001110:begin//xori
				{Branch, Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ExtOp, ALUsrc, RegWr}
				<= 15'b11;
				ALUctr = 4'b0110;
			end
			6'b000100:begin//beq
				{Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ALUsrc, RegWr, Branch, ExtOp}
				<= 15'b11;
				ALUctr = 4'b0000;
			end
			6'b000101:begin//bne
				{Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ALUsrc, RegWr, Branch, ExtOp}
				<= 15'b101;
				ALUctr = 4'b0000;
			end
			6'b000001:begin//bltz==bgez=6'b000001
				if (Rb == 5'b00001)      Branch = 3'b011;//bgez
				else if (Rb == 5'b00000) Branch = 3'b110;//blez
				{Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ALUsrc, RegWr, ExtOp}
				<= 12'b101;
				ALUctr = 4'b0000;
			end
			6'b000111:begin//bgtz
				{Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ALUsrc, RegWr, Branch, ExtOp}
				<= 15'b1001;
				ALUctr = 4'b0000;
			end
			6'b000110:begin//blez
				{Jump, RegDst, MemtoReg, MemWr, MemRead, ALUshf, ALUsrc, RegWr, Branch, ExtOp}
				<= 15'b1011;
				ALUctr = 4'b0000;
			end
			6'b100011:begin//lw
				{Jump, RegDst, MemWr, ALUshf, Branch, ALUsrc, MemtoReg, RegWr, ExtOp, MemRead}
				<= 15'b111101;
				ALUctr = 4'b0000;
			end
			6'b101011:begin//sw
				{Jump, RegDst, ALUshf, Branch, MemtoReg, RegWr, MemRead, ALUsrc, ExtOp, MemWr}
				<= 15'b1101;
				ALUctr = 4'b0000;
			end
			6'b100000:begin//lb
				{Jump, RegDst, MemWr, ALUshf, Branch, ALUsrc, MemtoReg, RegWr, ExtOp, MemRead}
				<= 15'b111110;
				ALUctr = 4'b0000;
			end
			6'b100100:begin//lbu
				{Jump, RegDst, MemWr, ALUshf, Branch, ALUsrc, MemtoReg, RegWr, ExtOp, MemRead}
				<= 15'b111111;
				ALUctr = 4'b0000;
			end
			6'b101000:begin//sb
				{Jump, RegDst, ALUshf, Branch, MemtoReg, RegWr, MemRead, ALUsrc, ExtOp, MemWr}
				<= 15'b1110;
				ALUctr = 4'b0000;
			end
			6'b000010:begin//j
				{RegDst, ALUshf, Branch, MemtoReg, RegWr, MemRead, ALUsrc, ExtOp, MemWr, Jump}
				<= 15'b1;
				ALUctr = 4'b0000;
			end
			6'b000011:begin//jal
				{RegDst, ALUshf, Branch, MemtoReg, RegWr, MemRead, ALUsrc, ExtOp, MemWr, Jump}
				<= 15'b1;
				ALUctr = 4'b0000;
			end
			default:begin
				{RegDst, ALUshf, Branch, MemtoReg, RegWr, MemRead, ALUsrc, ExtOp, MemWr, Jump}
				<= 15'b0;
				ALUctr = 4'b0000;				
			end
		endcase
	end
endmodule 