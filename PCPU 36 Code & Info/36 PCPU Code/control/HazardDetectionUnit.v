module HazardDetectionUnit(Ex_MemtoReg, Ex_Rw, ID_Ra, ID_Rb, hazard);

	input Ex_MemtoReg;
	input[4:0] Ex_Rw, ID_Ra, ID_Rb;

	output reg hazard;	

	initial hazard = 0;

	always@(*) begin
		if (Ex_MemtoReg != 0 && Ex_Rw != 0 && (Ex_Rw == ID_Rb || Ex_Rw == ID_Ra))
			  hazard <= 1;
		else  hazard <= 0;
	end

endmodule