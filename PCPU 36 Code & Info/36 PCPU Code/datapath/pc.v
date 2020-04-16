module pc(NPC, Clk, Reset, PC, hazard, BranchBubble);

	input[31:2] NPC;
	input Clk;
	input Reset;
	input hazard;
	input BranchBubble;
	
	output reg[31:2] PC;
	
	initial begin
		PC = 30'd0;
	end

	always@(posedge Clk)
	begin
		if (hazard == 0 && BranchBubble == 0) 
		begin
			if (Reset == 1)
				 PC <= 30'h0c00;
			else PC <= NPC;
		end
	end
	
endmodule
