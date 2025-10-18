// fully connected layer: y = W x + b
module fully_connected #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    parameter IN_LENGTH = 16,
    parameter OUT_LENGTH = 16
)(
    input  logic signed [WIDTH-1:0] weights [0:OUT_LENGTH-1][0:IN_LENGTH-1],
    input  logic signed [WIDTH-1:0] inputs  [0:IN_LENGTH-1],
    input  logic signed [WIDTH-1:0] biases  [0:OUT_LENGTH-1],
    output logic signed [WIDTH-1:0] outputs [0:OUT_LENGTH-1]
);

    // compute each output neuron using a dot product and bias add
    genvar o;
    generate
        for (o = 0; o < OUT_LENGTH; o++) begin : fc_loop
            logic signed [(2*WIDTH)-1:0] dot_full;
            logic signed [WIDTH-1:0]      dot_scaled;
            logic signed [WIDTH-1:0]      add_out;

            // dot product w_o . x
            vector_dot #(
                .WIDTH(WIDTH),
                .LEN(IN_LENGTH)
            ) dot_inst (
                .a(weights[o]),
                .b(inputs),
                .dot_product(dot_full)
            );

            // scale back to fixed-point width
            fixed_point #(
                .WIDTH(WIDTH),
                .FRAC_BITS(FRAC_BITS)
            ) scale_inst (
                .a(dot_full[WIDTH-1:0]),
                .b({{(WIDTH-1){1'b0}}, 1'b1}),
                .add_res(),
                .mul_res(dot_scaled)
            );

            // add bias
            fixed_point #(
                .WIDTH(WIDTH),
                .FRAC_BITS(FRAC_BITS)
            ) add_bias (
                .a(dot_scaled),
                .b(biases[o]),
                .add_res(add_out),
                .mul_res()
            );

            assign outputs[o] = add_out;
        end
    endgenerate

endmodule

