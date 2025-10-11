/**
 * @file logistic_regression.sv
 * @brief Modular logistic regression implementation for SystemVerilog ML Library
 * 
 * This module implements logistic regression using the sigmoid activation function.
 * It performs: y = sigmoid(w₁x₁ + w₂x₂ + ... + wₙxₙ + b)
 * where sigmoid(x) = 1 / (1 + e^(-x))
 * 
 * @author SystemVerilog ML Library
 * @version 1.0
 */

`include "../internal/fixed_point.sv"
`include "../internal/vector_dot.sv"
`include "../internal/activation_sigmoid.sv"

module ml_logistic_regression #(
    parameter WIDTH = 32,              // Bit width of vector elements
    parameter FRAC_BITS = 16,          // Fractional bits for fixed-point arithmetic
    parameter LENGTH = 16              // Vector length (number of features)
)(
    input  logic signed [WIDTH-1:0] weights [0:LENGTH-1],  // Weight vector
    input  logic signed [WIDTH-1:0] inputs  [0:LENGTH-1], // Input feature vector
    input  logic signed [WIDTH-1:0] bias,                  // Bias term
    output logic signed [WIDTH-1:0] result                 // Logistic regression output (0 to 1 range)
);

    // Internal signals
    logic signed [(2*WIDTH)-1:0] dot_product_full;
    logic signed [WIDTH-1:0] dot_product_fixed;
    logic signed [WIDTH-1:0] linear_output;
    logic signed [WIDTH-1:0] sigmoid_output;

    // Step 1: Compute linear combination using vector_dot module
    vector_dot #(.WIDTH(WIDTH), .LEN(LENGTH)) dot_product_inst (
        .a(weights),
        .b(inputs),
        .dot_product(dot_product_full)
    );

    // Step 2: Scale the dot product result using fixed_point module
    fixed_point #(.WIDTH(WIDTH), .FRAC_BITS(FRAC_BITS)) scale_dot_inst (
        .a(dot_product_full[WIDTH-1:0]),  // Use lower WIDTH bits of dot product
        .b(32'd1),                        // Multiply by 1 (just for scaling)
        .add_res(),                       // Not used
        .mul_res(dot_product_fixed)        // Get scaled result
    );

    // Step 3: Add bias using fixed_point module
    fixed_point #(.WIDTH(WIDTH), .FRAC_BITS(FRAC_BITS)) add_bias_inst (
        .a(dot_product_fixed),
        .b(bias),
        .add_res(linear_output),          // Get linear combination result
        .mul_res()                        // Not used
    );

    // Step 4: Apply sigmoid activation function
    activation_sigmoid #(.WIDTH(WIDTH), .FRAC_BITS(FRAC_BITS)) sigmoid_inst (
        .input_val(linear_output),
        .output_val(sigmoid_output)
    );

    assign result = sigmoid_output;

endmodule

/**
 * @brief Convenience wrapper for binary classification
 * 
 * This module provides a simplified interface for binary classification
 * with threshold-based decision making.
 */
module ml_binary_classifier #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    parameter LENGTH = 16,
    parameter THRESHOLD = 0.5           // Classification threshold
)(
    input  logic signed [WIDTH-1:0] weights [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] inputs  [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] bias,
    output logic signed [WIDTH-1:0] probability,  // Output probability (0 to 1)
    output logic classification                   // Binary classification result
);

    // Internal signals
    logic signed [WIDTH-1:0] logistic_result;
    logic signed [WIDTH-1:0] threshold_fixed;

    // Convert threshold to fixed-point representation
    assign threshold_fixed = THRESHOLD * (1 << FRAC_BITS);

    // Compute logistic regression
    ml_logistic_regression #(
        .WIDTH(WIDTH),
        .FRAC_BITS(FRAC_BITS),
        .LENGTH(LENGTH)
    ) logistic_inst (
        .weights(weights),
        .inputs(inputs),
        .bias(bias),
        .result(logistic_result)
    );

    assign probability = logistic_result;
    assign classification = (logistic_result > threshold_fixed) ? 1'b1 : 1'b0;

endmodule

/**
 * @brief Multi-class logistic regression using one-vs-all approach
 * 
 * This module implements multi-class classification by training multiple
 * binary classifiers and selecting the class with highest probability.
 */
module ml_multiclass_logistic #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    parameter FEATURE_LENGTH = 16,
    parameter NUM_CLASSES = 3           // Number of classes
)(
    input  logic signed [WIDTH-1:0] weights [0:NUM_CLASSES-1][0:FEATURE_LENGTH-1],
    input  logic signed [WIDTH-1:0] inputs  [0:FEATURE_LENGTH-1],
    input  logic signed [WIDTH-1:0] biases  [0:NUM_CLASSES-1],
    output logic signed [WIDTH-1:0] probabilities [0:NUM_CLASSES-1],
    output logic [$clog2(NUM_CLASSES)-1:0] predicted_class
);

    // Internal signals
    logic signed [WIDTH-1:0] class_probabilities [0:NUM_CLASSES-1];
    logic signed [WIDTH-1:0] max_probability;
    logic [$clog2(NUM_CLASSES)-1:0] max_class;

    // Generate multiple logistic regression instances
    genvar i;
    generate
        for (i = 0; i < NUM_CLASSES; i++) begin : logistic_loop
            ml_logistic_regression #(
                .WIDTH(WIDTH),
                .FRAC_BITS(FRAC_BITS),
                .LENGTH(FEATURE_LENGTH)
            ) logistic_inst (
                .weights(weights[i]),
                .inputs(inputs),
                .bias(biases[i]),
                .result(class_probabilities[i])
            );
        end
    endgenerate

    assign probabilities = class_probabilities;

    // Find the class with maximum probability
    integer j;
    always_comb begin
        max_probability = class_probabilities[0];
        max_class = 0;
        for (j = 1; j < NUM_CLASSES; j++) begin
            if (class_probabilities[j] > max_probability) begin
                max_probability = class_probabilities[j];
                max_class = j;
            end
        end
    end

    assign predicted_class = max_class;

endmodule
