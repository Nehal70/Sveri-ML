`include "../internal/fixed_point.sv"
`include "../internal/vector_dot.sv"

module ml_linear_regression #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    parameter LENGTH = 16
)(
    input  logic signed [WIDTH-1:0] weights [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] inputs  [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] bias,
    output logic signed [WIDTH-1:0] result
);

    // Internal signals
    logic signed [(2*WIDTH)-1:0] dot_product_full;
    logic signed [WIDTH-1:0] dot_product_fixed;
    logic signed [WIDTH-1:0] bias_add_result;

    // Use vector_dot module for dot product calculation
    vector_dot #(.WIDTH(WIDTH), .LEN(LENGTH)) dot_product_inst (
        .a(weights),
        .b(inputs),
        .dot_product(dot_product_full)
    );

    // use fixed_point module for scaling the dot product result
    fixed_point #(.WIDTH(WIDTH), .FRAC_BITS(FRAC_BITS)) scale_dot_inst (
        .a(dot_product_full[WIDTH-1:0]),  // Use lower WIDTH bits of dot product
        .b(32'd1),                        // multiply by 1 so value doesn't change
        .add_res(),                       // dont need addition result from fixed point module
        .mul_res(dot_product_fixed)        // capture scaled result
    );

    // Use fixed_point module for adding bias
    fixed_point #(.WIDTH(WIDTH), .FRAC_BITS(FRAC_BITS)) add_bias_inst (
        .a(dot_product_fixed),         // dot product result
        .b(bias),                      // bias value
        .add_res(bias_add_result),        // only addition result needed
        .mul_res()                        // dont need multiplication result from fixed point module
    );

    assign result = bias_add_result;

endmodule
