//without OverFlow
module regfile(addr, we, busW, Rw, Ra, Rb, clk, PC, REGSop, busA, busB);
    input[31:0] busW, addr, PC;
    input[4:0] Rw, Ra, Rb;
    input clk, we;
    input[2:0] REGSop;

    output[31:0] busA, busB;

    reg[31:0] regs[31:0];
    
    integer i;    

    initial
    begin
        for(i = 0; i < 32 ; i = i + 1)
   	    regs[i] = 32'b0;
    end

    always@(posedge clk)
    begin
        if(we)
        begin
            case(REGSop)
            //lb
            3'b001:
            begin
		    if(Rw != 0)
		    begin
                case(addr[1:0])
                    2'b00: regs[Rw] <= {{24{busW[7]}}, busW[7:0]};
                    2'b01: regs[Rw] <= {{24{busW[15]}}, busW[15:8]};
                    2'b10: regs[Rw] <= {{24{busW[23]}}, busW[23:16]};
                    2'b11: regs[Rw] <= {{24{busW[31]}}, busW[31:24]};
                endcase
		    end
            end
        //lbu
        3'b010:
            begin
		    if(Rw != 0)
		    begin
                case(addr[1:0])
                2'b00: regs[Rw] <= {{24'b0}, busW[7:0]};
                2'b01: regs[Rw] <= {{24'b0}, busW[15:8]};
                2'b10: regs[Rw] <= {{24'b0}, busW[23:16]};
                2'b11: regs[Rw] <= {{24'b0}, busW[31:24]};
                endcase
		    end
            end
        //jal
        3'b011: regs[31] <= PC + 4;
        //jalr
        3'b100: regs[31] <= PC + 4;
        default: 
	    if(Rw != 0)
	    begin
	        regs[Rw] <= busW; //normal
	    end
        endcase
        end
    end

    assign busA = (Ra == 0) ? 0 : regs[Ra];
    assign busB = (Rb == 0) ? 0 : regs[Rb];

endmodule