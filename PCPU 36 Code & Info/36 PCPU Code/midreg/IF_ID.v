module IF_ID(Clk, Reset, ID_Jump, Branch_ok, hazard, IF_ins, ID_ins,
             B_PC, ID_B_PC, BranchBubble, PC, ID_PC);

    input Clk, Reset, hazard, Branch_ok, BranchBubble;
    input[1:0] ID_Jump;
    input[31:0] IF_ins;
    input[31:2] B_PC,PC;

    output reg[31:0] ID_ins;
    output reg[31:2] ID_B_PC, ID_PC;

    initial 
    begin
    	{ID_ins, ID_B_PC, ID_PC}<= 92'd0;
    end

    always @(posedge Clk)
    begin
    	if (!Reset) 
    	begin 
        	if (hazard || BranchBubble) 
        	begin

        	end 
        	else if (Branch_ok || ID_Jump) 
	            {ID_ins, ID_B_PC, ID_PC} <= {32'd0, B_PC, PC};
        	else 
				{ID_ins, ID_B_PC, ID_PC} <= {IF_ins, B_PC, PC};
		end
    end
endmodule
