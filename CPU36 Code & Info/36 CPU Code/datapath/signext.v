module signext #(parameter WIDTH = 16, extWIDTH = 32)(a, b);
    input[WIDTH - 1:0] a;
    
    output[extWIDTH - 1:0] b;

    assign b = {{extWIDTH - WIDTH{a[WIDTH - 1]}}, a};

endmodule