module BranchBubbleUnit(ID_Ra, ID_Rb, Ex_RegWr, Ex_Rw, Mem_RegWr, Mem_MemtoReg, Mem_Rw,
						BranchBubble, ID_Branch, ID_Jump);

	input[4:0] ID_Ra, ID_Rb, Ex_Rw, Mem_Rw;
	input Ex_RegWr, Mem_RegWr, Mem_MemtoReg;
	input[2:0]	ID_Branch;
	input[1:0] ID_Jump;

	output reg BranchBubble;

	initial begin
		BranchBubble = 0;
	end

	always @(*) begin
		if (ID_Branch == 3'b000) begin //no Branch
			if (ID_Jump == 2'b10) begin //JR JALR
				if (((Ex_RegWr == 1) && (Ex_Rw != 0 && Ex_Rw == ID_Ra)) || 
				    ((Mem_MemtoReg == 1) && (Mem_Rw != 0 && Mem_Rw == ID_Ra))) begin
				  	BranchBubble <= 1;
				end else begin
				 	BranchBubble <= 0; 	
				end 		
			end
			else begin
				BranchBubble <= 0;
			end
		end else if (ID_Branch == 3'b001 || ID_Branch == 3'b010) begin //beq,bne
			if (((Ex_RegWr == 1) && (Ex_Rw != 0 && (Ex_Rw == ID_Ra || Ex_Rw == ID_Rb))) || 
			    ((Mem_MemtoReg == 1) && (Mem_Rw != 0 && (Mem_Rw == ID_Ra || Mem_Rw == ID_Rb)))) begin 
			  	BranchBubble <= 1;
			end else begin
			 	BranchBubble <= 0; 	
			end 
		end else begin //bgez, bltz, bgtz, blez
			if (((Ex_RegWr == 1) && (Ex_Rw != 0 && Ex_Rw == ID_Ra)) ||
			    ((Mem_MemtoReg == 1) && (Mem_Rw != 0 && Mem_Rw == ID_Ra))) begin
			  	BranchBubble <= 1;
			end else begin
			 	BranchBubble <= 0;
			end 						
		end
	end
	
endmodule
 	