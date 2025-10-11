`include "../internal/vector_add.sv"
`include "../internal/vector_sub.sv"
`include "../internal/vector_dot.sv"

module vector_ops #(
    parameter WIDTH = 32,
    parameter LENGTH = 16,
    parameter THRESHOLD = 0
)(
    input  logic signed [WIDTH-1:0] a [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] b [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] scalar,
    input  logic [2:0] op,
    output logic signed [WIDTH-1:0] vector_result [0:LENGTH-1],
    output logic signed [(2*WIDTH)-1:0] dot_result,
    output logic signed [WIDTH-1:0] reduction_result
);

    // to store vector addition result
    logic signed [WIDTH-1:0] add_res [0:LENGTH-1];
    // to store vector subtraction result
    logic signed [WIDTH-1:0] sub_res [0:LENGTH-1];
    // to store vector element-wise multiplication result
    logic signed [WIDTH-1:0] mul_res [0:LENGTH-1];
    // to store vector scaling result for element-wise multiplication with specified scalar
    logic signed [WIDTH-1:0] scale_res [0:LENGTH-1];
    // to store vector thresholding result
    logic signed [WIDTH-1:0] threshold_res [0:LENGTH-1];

    // use internal helper for vector addition
    vector_add #(.WIDTH(WIDTH), .LEN(LENGTH)) vector_add_inst (
        .a(a),
        .b(b),
        .sum(add_res)
    );

    // use internal helper for vector subtraction
    vector_sub #(.WIDTH(WIDTH), .LEN(LENGTH)) vector_sub_inst (
        .a(a),
        .b(b),
        .diff(sub_res)
    );

    // use internal helper for vector dot product
    vector_dot #(.WIDTH(WIDTH), .LEN(LENGTH)) vector_dot_inst (
        .a(a),
        .b(b),
        .dot_product(dot_accum)
    );

    genvar i;
    generate
        for (i = 0; i < LENGTH; i++) begin : vector_ops_loop
            //computing mul_res
            assign mul_res[i]      = a[i] * b[i];

            //computing scaled vector
            assign scale_res[i]    = a[i] * scalar;

            //computing thresholding result
            assign threshold_res[i]= (a[i] > THRESHOLD) ? a[i] : '0;
        end
    endgenerate

    // vector reduction
    logic signed [(WIDTH+ $clog2(LENGTH)):0] reduce_accum;
    always_comb begin
        reduce_accum = '0;
        for (j = 0; j < LENGTH; j++) begin
            reduce_accum += a[j];
        end
    end

    assign reduction_result = reduce_accum[WIDTH-1:0];

    // selecting operation
    assign vector_result = (op == 3'b000) ? add_res :
                           (op == 3'b001) ? sub_res :
                           (op == 3'b010) ? mul_res :
                           (op == 3'b011) ? scale_res :
                           (op == 3'b100) ? threshold_res :
                           '0;

    assign dot_result = (op == 3'b101) ? dot_accum : '0;

endmodule
