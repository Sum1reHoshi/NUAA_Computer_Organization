module dm_4k(addr, din, we, clk, DMop, dout) ;
    
    input [31:0] addr ; // address bus
    input [31:0] din ; // 32-bit input data
    input we ; // memory write enable
    input clk ; // clock
    input DMop;

    output [31:0] dout ; // 32-bit memory output

    reg [31:0] dm[1023:0];

    integer i;
    initial
    begin
	for(i = 0; i < 1024; i = i + 1)
	    dm[i] = 32'b0;
    end

    always@(posedge clk)
    begin
        if(we)
        begin
            if(DMop == 1'b1)
            begin
                if(addr[1:0] == 2'b00)
            	    dm[addr[11:2]][7:0] <= din[7:0]; 
	        if(addr[1:0] == 2'b01)
         	    dm[addr[11:2]][15:8] <= din[7:0];
	        if(addr[1:0] == 2'b10)
           	    dm[addr[11:2]][23:16] <= din[7:0];   
	        if(addr[1:0] == 2'b11)
           	    dm[addr[11:2]][31:24] <= din[7:0];
            end
            else 
                dm[addr[11:2]] <= din;
        end
    end

    assign dout = dm[addr[11:2]];

endmodule