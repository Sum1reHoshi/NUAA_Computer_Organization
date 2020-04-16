module ext #(parameter WIDTH = 16, extWIDTH = 32)(a, b, ExtOp);
    input[WIDTH - 1:0] a;
    input ExtOp;
    
    output[extWIDTH - 1:0] b;

    assign b = ExtOp ? {{extWIDTH - WIDTH{a[WIDTH - 1]}}, a} : 
                {{extWIDTH - WIDTH{1'b0}}, a};

endmodule