`include "../internal/fully_connected.sv"

// api wrapper for fully connected layer with optional activation
module ml_fully_connected #(
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

    // simple wrapper around internal fully connected layer
    fully_connected #(
        .WIDTH(WIDTH),
        .FRAC_BITS(FRAC_BITS),
        .IN_LENGTH(IN_LENGTH),
        .OUT_LENGTH(OUT_LENGTH)
    ) fc (
        .weights(weights),
        .inputs(inputs),
        .biases(biases),
        .outputs(outputs)
    );

endmodule

