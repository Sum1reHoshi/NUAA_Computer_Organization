//pc get ins
module pc(NPC, PC, rst, clk);
    input[31:0] NPC;
    input rst, clk;
    
    output[31:0] PC;

    reg[31:0] PC;

    initial
    begin
        PC <= 32'h0000_3000;
    end

    always@(posedge clk)
    begin
        PC <= rst ? 32'h0000_3000 : NPC;
    end

endmodule