module dm_4k(addr, din, we, clk, dout, memRead) ;
	input[11:0] addr;  // address bus  ,[11:2] -> [11:0]
    input[31:0] din;   // 32-bit input data
    input[1:0] we;    // memory write enable
    input clk;   // clock
    input[1:0] memRead;

	output reg[31:0] dout;  // 32-bit memory output

	reg[31:0] dm[1023:0];

	integer i;

	initial begin
		for (i = 0; i < 1024; i = i + 1)
			dm[i] = 32'h0000_0000;
	end
	
	always@(negedge clk)//second half write
	begin
		if (we == 2'b01 && memRead == 2'b00) dm[ addr[11:2] ] <= din; //SW
		else if (we == 2'b10 && memRead == 2'b00)		//SB
		begin
			if (addr[1:0] == 2'b00) dm[ addr[11:2] ][7:0] <= din[7:0];  else 
			if (addr[1:0] == 2'b01) dm[ addr[11:2] ][15:8] <= din[7:0]; else 
			if (addr[1:0] == 2'b10) dm[ addr[11:2] ][23:16] <= din[7:0];else 
			if (addr[1:0] == 2'b11) dm[ addr[11:2] ][31:24] <= din[7:0];
		end 
	end

	wire [7:0] d0 = dm[ addr[11:2] ][7:0];  //dm read by byte
	wire [7:0] d1 = dm[ addr[11:2] ][15:8];
	wire [7:0] d2 = dm[ addr[11:2] ][23:16];
	wire [7:0] d3 = dm[ addr[11:2] ][31:24];

	always@(*) begin
		if (memRead == 2'b00 && we == 2'b00)
		begin
			assign dout = 32'b0;
		end 
		else if (memRead == 2'b01 && we == 2'b00)	//lw
		begin
			assign dout = dm[ addr[11:2] ];
		end 
		else if (memRead == 2'b10 && we == 2'b00) 	//lb
		begin
			if (addr[1:0] == 2'b00)					//read 1st byte
			begin
				assign dout = { {24{d0[7]}}, d0};
			end 
			else if (addr[1:0] == 2'b01)			//read 2nd byte
			begin
				assign dout = { {24{d1[7]}}, d1};
			end 
			else if (addr[1:0] == 2'b10)			//read 3rd byte
			begin
				assign dout = { {24{d2[7]}}, d2};
			end 
			else if (addr[1:0] == 2'b11)			//read 4th byte
			begin
				assign dout = { {24{d3[7]}}, d3};
			end
		end 
		else if (memRead == 2'b11 && we == 2'b00)	//lbu
		begin
			if (addr[1:0] == 2'b00)					//read 1st byte unsigned
			begin			
				assign dout = { 24'b0, d0};
			end 
			else if (addr[1:0] == 2'b01) 
			begin
				assign dout = { 24'b0, d1};
			end 
			else if (addr[1:0] == 2'b10) 
			begin
				assign dout = { 24'b0, d2};
			end 
			else if (addr[1:0] == 2'b11) 
			begin
				assign dout = { 24'b0, d3};
			end
		end
	end
endmodule 