module ALU (A, B, ALUctr, Zero, Result);

  input[31:0] A,B;
  input[3:0] ALUctr;
  
  output Zero;
  output reg[31:0] Result;
  
  wire [31:0] temp = {1'b1, {31{1'b0}}};
  //the first place of temp is 1, rest is 0
  //it XORs with a or b to get the framshift
  //this allows us to use < to compare the size directly
  //because < can only compare unsigned numbers normally
  wire [31:0] SLTA = A ^ temp;            
  wire [31:0] SLTB = B ^ temp;
  
  assign Zero = ((Result == 0)? 1 : 0);

  always@(*)
  begin
     case (ALUctr)
      4'b0000 : Result = A + B;  //ADDU
      4'b0001 : Result = A - B;  //SUBU
      4'b0010 : Result = (SLTA < SLTB) ? 1 : 0;  //SLT
      4'b0011 : Result = A & B;  //AND
      4'b0100 : Result = ~ ( A | B); //NOR
      4'b0101 : Result = A | B;  //OR
      4'b0110 : Result = A ^ B;  //XOR
      4'b0111 : Result = B << A; //SLL
      4'b1000 : Result = B >> A; //SRL
      4'b1001 : Result = (A < B) ? 1 : 0;  //SLTU
      4'b1010 : Result = (B[31] == 0) ? B >> A : ~((~B) >> A); //SRA
      4'b1011 : Result = {B[15:0], 16'd0}; //LUI
    endcase
  end

endmodule
