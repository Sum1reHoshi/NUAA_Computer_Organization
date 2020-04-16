module branchOrNot(busA, busB, Branch, Branch_flag);

	input[31:0] busA;
	input[31:0] busB;
	input[2:0] Branch;

	output reg Branch_flag;

	initial begin
		Branch_flag = 0;
	end

	always @(*) begin
		case(Branch)
			3'b000:Branch_flag = 0;
			3'b001:Branch_flag = (busA == busB);
			3'b010:Branch_flag = (busA != busB);
			3'b011:Branch_flag = (busA[31] == 1'b0);
			3'b100:Branch_flag = (busA[31] == 1'b0 && busA != 32'b0);
			3'b101:Branch_flag = (busA[31] == 1'b1 || busA == 32'b0);
			3'b110:Branch_flag = (busA[31] == 1'b1);
		endcase
	end
	
endmodule