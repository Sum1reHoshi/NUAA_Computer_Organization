module mux #(parameter WIDTH = 32)(in1, in2, flag, out);

    input[WIDTH - 1:0] in1, in2;
    input flag;
    
    output[WIDTH - 1:0] out;

    assign out = flag ? in1 : in2;

endmodule