module vector_add #(parameter WIDTH = 32, parameter LEN = 8) (
    input logic [WIDTH-1:0] a[LEN-1:0], // first input vector of length LEN with each element having WIDTH bits
    input logic [WIDTH-1:0] b[LEN-1:0], // second input vector of length LEN with each element having WIDTH bits
    output logic [WIDTH-1:0] sum[LEN-1:0] // output vector that adds the first and second vector's elements index wise
);

    // generating element wise addition using our internal adder module
    genvar i;
    generate
        for (i = 0; i < LEN; i++) begin : add_loop
            adder #(.WIDTH(WIDTH)) adder_inst ( //for each element in the vectors, create an adder module called 'adder_inst' of width WIDTH (width of each element in the vectors)
                .a(a[i]),
                .b(b[i]),
                .sum(sum[i])
            );
        end
    endgenerate

endmodule
