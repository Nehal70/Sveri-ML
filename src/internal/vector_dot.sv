module vector_dot #(WIDTH = 32, LEN = 8) (
    input logic [WIDTH-1:0] a[LEN-1:0], // first input vector of length LEN with each element having WIDTH bits
    input logic [WIDTH-1:0] b[LEN-1:0], // second input vector of length LEN with each element having WIDTH bits
    output logic [WIDTH-1:0] dot_product // output that is the dot product of the two vectors
);

    // generating element wise multpliers to perform element wise multiplication for corresponding elements in our input vectors
    genvar i;
    generate
        for (i = 0; i < LEN; i++) begin : mul_loop
            multiplier #(.WIDTH(WIDTH)) multiplier_inst (
                .a(a[i]),
                .b(b[i]),
                .product(product[i])
            );
        end
    endgenerate

    // adding up all the element-wise products to get the dot product
    assign dot_product = product[0] + product[1] + product[2] + product[3] + product[4] + product[5] + product[6] + product[7];

endmodule
