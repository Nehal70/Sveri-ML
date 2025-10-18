module activation_leaky_relu #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    // alpha should be provided in fixed-point with FRAC_BITS fractional bits
    parameter logic signed [WIDTH-1:0] ALPHA = 32'sd655  // ~0.01 in Q16
)(
    input  logic signed [WIDTH-1:0] in_data,
    output logic signed [WIDTH-1:0] out_data
);

    // leaky relu: x if x > 0, else alpha * x

    logic signed [WIDTH-1:0] alpha_mul;

    // use fixed-point helper for alpha * x
    // keeping it simple and readable
    fixed_point #(
        .WIDTH(WIDTH),
        .FRAC_BITS(FRAC_BITS)
    ) mul_alpha_inst (
        .a(in_data),
        .b(ALPHA),
        .add_res(),
        .mul_res(alpha_mul)
    );

    assign out_data = (in_data > '0) ? in_data : alpha_mul;

endmodule

