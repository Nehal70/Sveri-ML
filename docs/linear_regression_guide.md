# Linear Regression API - User Guide

## Overview

The `ml_linear_regression` module implements a complete linear regression computation in hardware. It performs the mathematical operation: `y = w₁x₁ + w₂x₂ + ... + wₙxₙ + b`, where `w` are weights, `x` are inputs, and `b` is the bias term. This module is optimized for machine learning applications and uses fixed-point arithmetic for efficient hardware implementation.

## Module Interface

```systemverilog
module ml_linear_regression #(
    parameter WIDTH = 32,              // Bit width of vector elements
    parameter FRAC_BITS = 16,          // Fractional bits for fixed-point arithmetic
    parameter LENGTH = 16              // Vector length (number of features)
)(
    input  logic signed [WIDTH-1:0] weights [0:LENGTH-1],  // Weight vector
    input  logic signed [WIDTH-1:0] inputs  [0:LENGTH-1], // Input feature vector
    input  logic signed [WIDTH-1:0] bias,                  // Bias term
    output logic signed [WIDTH-1:0] result                 // Linear regression output
);
```

## Parameters

### WIDTH Parameter
- **8-bit**: Suitable for small neural networks, basic applications
- **16-bit**: Good balance of precision and resource usage
- **32-bit**: High precision, suitable for most applications (recommended)
- **64-bit**: Maximum precision, use for critical computations

### FRAC_BITS Parameter
- **8-bit**: Lower precision, faster computation
- **16-bit**: Good balance of precision and performance (recommended)
- **24-bit**: High precision, more resource intensive
- **28-bit**: Very high precision, maximum for 32-bit WIDTH

### LENGTH Parameter
- **4-8**: Small feature vectors, simple models
- **16-32**: Medium-sized vectors, typical neural network layers
- **64-128**: Large vectors, complex feature extraction
- **256+**: Very large vectors, use with caution (resource intensive)

## How It Works

The linear regression module performs the following steps:

1. **Dot Product Calculation**: Computes `weights · inputs` using the internal `vector_dot` module
2. **Fixed-Point Scaling**: Scales the result using the internal `fixed_point` module
3. **Bias Addition**: Adds the bias term using fixed-point arithmetic
4. **Output**: Provides the final linear regression result

## Usage Examples

### Basic Linear Regression

```systemverilog
module simple_regression (
    input  logic clk,
    input  logic rst_n,
    input  logic signed [31:0] weights [0:3],
    input  logic signed [31:0] inputs  [0:3],
    input  logic signed [31:0] bias,
    output logic signed [31:0] prediction
);

    // Instantiate linear regression module
    ml_linear_regression #(
        .WIDTH(32),
        .FRAC_BITS(16),
        .LENGTH(4)
    ) regression_inst (
        .weights(weights),
        .inputs(inputs),
        .bias(bias),
        .result(prediction)
    );

endmodule
```

### Neural Network Layer

```systemverilog
module neural_layer #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    parameter LENGTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic signed [WIDTH-1:0] input_features [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] layer_weights [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] layer_bias,
    output logic signed [WIDTH-1:0] layer_output
);

    // Linear transformation
    ml_linear_regression #(
        .WIDTH(WIDTH),
        .FRAC_BITS(FRAC_BITS),
        .LENGTH(LENGTH)
    ) linear_layer (
        .weights(layer_weights),
        .inputs(input_features),
        .bias(layer_bias),
        .result(layer_output)
    );

endmodule
```

### Multiple Linear Regression

```systemverilog
module multi_output_regression #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    parameter INPUT_LENGTH = 8,
    parameter OUTPUT_LENGTH = 4
)(
    input  logic clk,
    input  logic rst_n,
    input  logic signed [WIDTH-1:0] input_features [0:INPUT_LENGTH-1],
    input  logic signed [WIDTH-1:0] weights [0:OUTPUT_LENGTH-1][0:INPUT_LENGTH-1],
    input  logic signed [WIDTH-1:0] biases [0:OUTPUT_LENGTH-1],
    output logic signed [WIDTH-1:0] predictions [0:OUTPUT_LENGTH-1]
);

    genvar i;
    generate
        for (i = 0; i < OUTPUT_LENGTH; i++) begin : regression_loop
            ml_linear_regression #(
                .WIDTH(WIDTH),
                .FRAC_BITS(FRAC_BITS),
                .LENGTH(INPUT_LENGTH)
            ) regression_inst (
                .weights(weights[i]),
                .inputs(input_features),
                .bias(biases[i]),
                .result(predictions[i])
            );
        end
    endgenerate

endmodule
```

## Fixed-Point Arithmetic Details

### Number Representation
The module uses fixed-point arithmetic where numbers are represented as:
- **Integer part**: `WIDTH - FRAC_BITS` bits
- **Fractional part**: `FRAC_BITS` bits

### Example with WIDTH=32, FRAC_BITS=16:
- **Range**: -32,768 to 32,767.9999847412109375
- **Resolution**: 1/65536 ≈ 0.0000152587890625
- **Example**: 0x00010000 represents 1.0

### Scaling Process
1. **Dot Product**: Computed with full precision (64-bit intermediate result)
2. **Scaling**: Result is scaled down by `FRAC_BITS` positions
3. **Rounding**: Proper rounding is applied to maintain accuracy
4. **Saturation**: Results are clamped to prevent overflow

## Performance Characteristics

### Timing
- **Combinational Logic**: All operations complete in one clock cycle
- **No Pipeline Delays**: Immediate results when inputs change
- **Critical Path**: Determined by dot product and scaling operations

### Resource Usage
- **Multipliers**: `LENGTH` multipliers for dot product
- **Adders**: Tree of adders for accumulation
- **Logic**: Scaling and bias addition logic

### Scalability
- **Small Vectors (LENGTH ≤ 8)**: Very efficient, suitable for most applications
- **Medium Vectors (LENGTH ≤ 32)**: Good performance, moderate resource usage
- **Large Vectors (LENGTH > 64)**: Consider pipelining for timing closure

## Common Use Cases

### Machine Learning Applications
- **Neural Network Layers**: Fully connected layers
- **Linear Regression**: Direct regression modeling
- **Feature Transformation**: Linear feature combinations
- **Dimensionality Reduction**: Linear projections

### Signal Processing
- **Filtering**: Linear filtering operations
- **Correlation**: Signal correlation calculations
- **Transformation**: Linear signal transformations

### Control Systems
- **State Estimation**: Linear state observers
- **Control Laws**: Linear control computations
- **Kalman Filtering**: Linear prediction steps

## Best Practices

### Parameter Selection
1. **WIDTH**: Choose based on required precision and available resources
2. **FRAC_BITS**: Balance between precision and range
3. **LENGTH**: Consider timing constraints and resource availability

### Input Preparation
1. **Normalization**: Ensure inputs are properly normalized
2. **Range Checking**: Verify inputs are within valid range
3. **Fixed-Point Format**: Ensure inputs use correct fixed-point format

### Output Handling
1. **Range Validation**: Check outputs are within expected range
2. **Overflow Detection**: Monitor for saturation conditions
3. **Post-Processing**: Apply additional scaling if needed

## Troubleshooting

### Common Issues
1. **Overflow**: Input values too large for fixed-point representation
2. **Underflow**: Input values too small, losing precision
3. **Timing Violations**: Critical path too long for target frequency
4. **Resource Exhaustion**: Too many multipliers for target device

### Debug Tips
1. **Simulation**: Use testbenches with known inputs/outputs
2. **Range Analysis**: Verify input/output ranges are appropriate
3. **Timing Analysis**: Check critical path timing
4. **Resource Analysis**: Monitor multiplier and adder usage

### Performance Optimization
1. **Pipeline**: Add pipeline stages for large vectors
2. **Parallelization**: Use multiple instances for parallel processing
3. **Precision**: Reduce precision where acceptable
4. **Architecture**: Consider different architectures for specific use cases
