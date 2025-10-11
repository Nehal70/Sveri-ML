module fixed_point #(
    parameter WIDTH = 32,          // Total bits (integer + fractional)
    parameter FRAC_BITS = 16       // fractional bits
)(
    input  logic signed [WIDTH-1:0] a,
    input  logic signed [WIDTH-1:0] b,
    output logic signed [WIDTH-1:0] add_res,
    output logic signed [WIDTH-1:0] mul_res
);

    // for addition output
    assign add_res = a + b;

    // Fixed-point multiplication
    logic signed [2*WIDTH-1:0] mul_full;
    assign mul_full = a * b;

    // Round and scale down product by fractional bits
    logic signed [2*WIDTH-1:0] mul_rounded;
    assign mul_rounded = mul_full + (1 << (FRAC_BITS - 1)); // rounding

    // Scale back to WIDTH bits
    logic signed [WIDTH-1:0] mul_scaled;
    assign mul_scaled = mul_rounded >>> FRAC_BITS;

    // Saturation function to clamp results within representable range
    function logic signed [WIDTH-1:0] saturate(input logic signed [WIDTH-1:0] val);
        if (val > $signed({1'b0, {(WIDTH-1){1'b1}}}))
            saturate = $signed({1'b0, {(WIDTH-1){1'b1}}});
        else if (val < $signed({1'b1, {(WIDTH-1){1'b0}}}))
            saturate = $signed({1'b1, {(WIDTH-1){1'b0}}});
        else
            saturate = val;
    endfunction

    assign mul_res = saturate(mul_scaled);

endmodule
