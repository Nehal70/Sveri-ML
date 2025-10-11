# SystemVerilog ML Library - Complete User Guide

## Table of Contents
1. [Overview](#overview)
2. [Vector Operations API](#vector-operations-api)
3. [Linear Regression API](#linear-regression-api)
4. [Quick Reference](#quick-reference)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)

---

## Overview

The SystemVerilog ML Library provides hardware-optimized modules for machine learning and signal processing applications. The library includes comprehensive vector operations and linear regression functionality, all implemented using efficient fixed-point arithmetic.

### Key Features
- **Hardware-Optimized**: Designed for FPGA and ASIC implementation
- **Fixed-Point Arithmetic**: Efficient numerical computation
- **Modular Design**: Reusable components for complex systems
- **Comprehensive Operations**: Vector operations and linear regression
- **Parameterizable**: Configurable bit widths and vector lengths

---

## Vector Operations API

### Overview

The `vector_ops` module provides a comprehensive interface for vector arithmetic operations commonly used in machine learning and signal processing applications. This module supports element-wise operations, dot products, vector reduction, and thresholding operations.

### Module Interface

```systemverilog
module vector_ops #(
    parameter WIDTH = 32,              // Bit width of vector elements
    parameter LENGTH = 16,             // Vector length
    parameter THRESHOLD = 0            // Threshold value for thresholding operation
)(
    input  logic signed [WIDTH-1:0] a [0:LENGTH-1],        // First input vector
    input  logic signed [WIDTH-1:0] b [0:LENGTH-1],        // Second input vector
    input  logic signed [WIDTH-1:0] scalar,                // Scalar input for scaling operations
    input  logic [2:0] op,                                 // Operation selector
    output logic signed [WIDTH-1:0] vector_result [0:LENGTH-1],  // Vector result
    output logic signed [(2*WIDTH)-1:0] dot_result,        // Dot product result
    output logic signed [WIDTH-1:0] reduction_result       // Vector reduction result
);
```

### Operation Codes

| Operation Code | Operation | Description |
|----------------|-----------|-------------|
| `3'b000` | Vector Addition | Element-wise addition of vectors a and b |
| `3'b001` | Vector Subtraction | Element-wise subtraction of vectors a and b |
| `3'b010` | Element-wise Multiplication | Element-wise multiplication of vectors a and b |
| `3'b011` | Vector Scaling | Multiply each element of vector a by scalar |
| `3'b100` | Vector Thresholding | Apply threshold function to vector a |
| `3'b101` | Dot Product | Compute dot product of vectors a and b |
| `3'b110` | Vector Reduction | Sum all elements of vector a |

### Usage Examples

#### 1. Vector Addition

**Purpose**: Add corresponding elements of two vectors.

**Example**: `a = [2, 4, 6, 8]`, `b = [1, 3, 5, 7]` → `result = [3, 7, 11, 15]`

```systemverilog
// Instantiate the module
vector_ops #(.WIDTH(32), .LENGTH(4)) add_ops (
    .a(vector_a),           // Input vector a
    .b(vector_b),           // Input vector b
    .scalar(32'd0),         // Not used for addition
    .op(3'b000),            // Addition operation
    .vector_result(result), // Output vector
    .dot_result(),          // Not used
    .reduction_result()     // Not used
);
```

#### 2. Vector Subtraction

**Purpose**: Subtract corresponding elements of two vectors.

**Example**: `a = [10, 8, 6, 4]`, `b = [3, 2, 1, 0]` → `result = [7, 6, 5, 4]`

```systemverilog
vector_ops #(.WIDTH(32), .LENGTH(4)) sub_ops (
    .a(vector_a),
    .b(vector_b),
    .scalar(32'd0),
    .op(3'b001),            // Subtraction operation
    .vector_result(result),
    .dot_result(),
    .reduction_result()
);
```

#### 3. Element-wise Multiplication

**Purpose**: Multiply corresponding elements of two vectors.

**Example**: `a = [2, 3, 4, 5]`, `b = [3, 2, 1, 0]` → `result = [6, 6, 4, 0]`

```systemverilog
vector_ops #(.WIDTH(32), .LENGTH(4)) mul_ops (
    .a(vector_a),
    .b(vector_b),
    .scalar(32'd0),
    .op(3'b010),            // Element-wise multiplication
    .vector_result(result),
    .dot_result(),
    .reduction_result()
);
```

#### 4. Vector Scaling

**Purpose**: Multiply each element of a vector by a scalar value.

**Example**: `a = [2, 4, 6, 8]`, `scalar = 3` → `result = [6, 12, 18, 24]`

```systemverilog
vector_ops #(.WIDTH(32), .LENGTH(4)) scale_ops (
    .a(vector_a),
    .b(32'd0),             // Not used for scaling
    .scalar(32'd3),        // Scalar multiplier
    .op(3'b011),           // Scaling operation
    .vector_result(result),
    .dot_result(),
    .reduction_result()
);
```

#### 5. Vector Thresholding

**Purpose**: Apply threshold function to each element of a vector.

**Example**: `a = [-2, 0, 3, -1]`, `THRESHOLD = 0` → `result = [0, 0, 3, 0]`

```systemverilog
// ReLU activation (threshold = 0)
vector_ops #(.WIDTH(32), .LENGTH(4), .THRESHOLD(0)) relu_ops (
    .a(vector_a),
    .b(32'd0),             // Not used for thresholding
    .scalar(32'd0),
    .op(3'b100),           // Thresholding operation
    .vector_result(result),
    .dot_result(),
    .reduction_result()
);

// Custom threshold (e.g., threshold = 2)
vector_ops #(.WIDTH(32), .LENGTH(4), .THRESHOLD(2)) custom_thresh_ops (
    .a(vector_a),
    .b(32'd0),
    .scalar(32'd0),
    .op(3'b100),
    .vector_result(result),
    .dot_result(),
    .reduction_result()
);
```

#### 6. Dot Product

**Purpose**: Compute the dot product of two vectors (sum of element-wise products).

**Example**: `a = [2, 3, 4]`, `b = [1, 2, 3]` → `result = 2×1 + 3×2 + 4×3 = 20`

```systemverilog
vector_ops #(.WIDTH(32), .LENGTH(3)) dot_ops (
    .a(vector_a),
    .b(vector_b),
    .scalar(32'd0),
    .op(3'b101),           // Dot product operation
    .vector_result(),       // Not used for dot product
    .dot_result(result),    // Scalar result
    .reduction_result()
);
```

#### 7. Vector Reduction (Sum)

**Purpose**: Sum all elements of a vector.

**Example**: `a = [1, 2, 3, 4]` → `result = 1 + 2 + 3 + 4 = 10`

```systemverilog
vector_ops #(.WIDTH(32), .LENGTH(4)) reduce_ops (
    .a(vector_a),
    .b(32'd0),             // Not used for reduction
    .scalar(32'd0),
    .op(3'b110),           // Vector reduction operation
    .vector_result(),       // Not used for reduction
    .dot_result(),
    .reduction_result(result) // Scalar result
);
```

### Complete Example: Neural Network Layer

Here's a complete example showing how to use `vector_ops` in a neural network layer:

```systemverilog
module neural_layer #(
    parameter WIDTH = 32,
    parameter LENGTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic signed [WIDTH-1:0] input_vector [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] weights [0:LENGTH-1],
    input  logic signed [WIDTH-1:0] bias,
    output logic signed [WIDTH-1:0] output_vector [0:LENGTH-1]
);

    // Internal signals
    logic signed [WIDTH-1:0] weighted_sum [0:LENGTH-1];
    logic signed [WIDTH-1:0] biased_sum [0:LENGTH-1];
    logic signed [(2*WIDTH)-1:0] dot_product_result;
    logic signed [WIDTH-1:0] activation_input [0:LENGTH-1];

    // Step 1: Element-wise multiplication (weights * inputs)
    vector_ops #(.WIDTH(WIDTH), .LENGTH(LENGTH)) mul_ops (
        .a(input_vector),
        .b(weights),
        .scalar(32'd0),
        .op(3'b010),                    // Element-wise multiplication
        .vector_result(weighted_sum),
        .dot_result(),
        .reduction_result()
    );

    // Step 2: Vector reduction to get single weighted sum
    vector_ops #(.WIDTH(WIDTH), .LENGTH(LENGTH)) reduce_ops (
        .a(weighted_sum),
        .b(32'd0),
        .scalar(32'd0),
        .op(3'b110),                    // Vector reduction
        .vector_result(),
        .dot_result(),
        .reduction_result(dot_product_result[WIDTH-1:0])
    );

    // Step 3: Add bias (scalar addition)
    vector_ops #(.WIDTH(WIDTH), .LENGTH(1)) bias_ops (
        .a({dot_product_result[WIDTH-1:0]}),
        .b(32'd0),
        .scalar(bias),
        .op(3'b011),                    // Scalar addition
        .vector_result(biased_sum),
        .dot_result(),
        .reduction_result()
    );

    // Step 4: Apply ReLU activation
    vector_ops #(.WIDTH(WIDTH), .LENGTH(1), .THRESHOLD(0)) relu_ops (
        .a(biased_sum),
        .b(32'd0),
        .scalar(32'd0),
        .op(3'b100),                    // Thresholding (ReLU)
        .vector_result(output_vector),
        .dot_result(),
        .reduction_result()
    );

endmodule
```

---

## Linear Regression API

### Overview

The `ml_linear_regression` module implements a complete linear regression computation in hardware. It performs the mathematical operation: `y = w₁x₁ + w₂x₂ + ... + wₙxₙ + b`, where `w` are weights, `x` are inputs, and `b` is the bias term. This module is optimized for machine learning applications and uses fixed-point arithmetic for efficient hardware implementation.

### Module Interface

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

### How It Works

The linear regression module performs the following steps:

1. **Dot Product Calculation**: Computes `weights · inputs` using the internal `vector_dot` module
2. **Fixed-Point Scaling**: Scales the result using the internal `fixed_point` module
3. **Bias Addition**: Adds the bias term using fixed-point arithmetic
4. **Output**: Provides the final linear regression result

### Usage Examples

#### Basic Linear Regression

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

#### Neural Network Layer

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

#### Multiple Linear Regression

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

### Fixed-Point Arithmetic Details

#### Number Representation
The module uses fixed-point arithmetic where numbers are represented as:
- **Integer part**: `WIDTH - FRAC_BITS` bits
- **Fractional part**: `FRAC_BITS` bits

#### Example with WIDTH=32, FRAC_BITS=16:
- **Range**: -32,768 to 32,767.9999847412109375
- **Resolution**: 1/65536 ≈ 0.0000152587890625
- **Example**: 0x00010000 represents 1.0

#### Scaling Process
1. **Dot Product**: Computed with full precision (64-bit intermediate result)
2. **Scaling**: Result is scaled down by `FRAC_BITS` positions
3. **Rounding**: Proper rounding is applied to maintain accuracy
4. **Saturation**: Results are clamped to prevent overflow

---

## Quick Reference

### Parameter Guidelines

#### WIDTH Parameter
- **8-bit**: Suitable for small neural networks, image processing
- **16-bit**: Good balance of precision and resource usage
- **32-bit**: High precision, suitable for most applications (recommended)
- **64-bit**: Maximum precision, use for critical computations

#### LENGTH Parameter
- **4-8**: Small feature vectors, simple operations
- **16-32**: Medium-sized vectors, typical neural network layers
- **64-128**: Large vectors, complex feature extraction
- **256+**: Very large vectors, use with caution (resource intensive)

#### FRAC_BITS Parameter
- **8-bit**: Lower precision, faster computation
- **16-bit**: Good balance of precision and performance (recommended)
- **24-bit**: High precision, more resource intensive
- **28-bit**: Very high precision, maximum for 32-bit WIDTH

#### THRESHOLD Parameter
- **0**: ReLU activation (most common)
- **Negative values**: Leaky ReLU-like behavior
- **Positive values**: Custom thresholding for feature selection

### Operation Codes Summary

| Module | Operation | Code | Inputs Used | Output Used |
|--------|-----------|------|-------------|-------------|
| vector_ops | Addition | `3'b000` | a, b | vector_result |
| vector_ops | Subtraction | `3'b001` | a, b | vector_result |
| vector_ops | Element-wise Mult | `3'b010` | a, b | vector_result |
| vector_ops | Scaling | `3'b011` | a, scalar | vector_result |
| vector_ops | Thresholding | `3'b100` | a | vector_result |
| vector_ops | Dot Product | `3'b101` | a, b | dot_result |
| vector_ops | Reduction | `3'b110` | a | reduction_result |
| ml_linear_regression | Linear Regression | N/A | weights, inputs, bias | result |

---

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

### Performance Optimization
1. **Pipeline**: Add pipeline stages for large vectors
2. **Parallelization**: Use multiple instances for parallel processing
3. **Precision**: Reduce precision where acceptable
4. **Architecture**: Consider different architectures for specific use cases

---

## Troubleshooting

### Common Issues
1. **Bit Width Overflow**: Ensure sufficient bit width for operations
2. **Array Indexing**: Use 0-based indexing `[0:LENGTH-1]`
3. **Operation Selection**: Verify correct operation codes
4. **Parameter Mismatch**: Ensure consistent WIDTH and LENGTH parameters
5. **Overflow**: Input values too large for fixed-point representation
6. **Underflow**: Input values too small, losing precision
7. **Timing Violations**: Critical path too long for target frequency
8. **Resource Exhaustion**: Too many multipliers for target device

### Debug Tips
- Use simulation to verify operation results
- Check bit widths match between connected modules
- Verify operation codes are correct for intended functionality
- Test with known input values to validate outputs
- Use testbenches with known inputs/outputs
- Range Analysis: Verify input/output ranges are appropriate
- Timing Analysis: Check critical path timing
- Resource Analysis: Monitor multiplier and adder usage

### Performance Considerations
1. **Combinational Logic**: All operations are combinational, providing immediate results
2. **Parallel Execution**: Multiple operations can run simultaneously
3. **Resource Usage**: Larger vectors require more hardware resources
4. **Timing**: Consider timing constraints for large vectors

### Common Use Cases
- **Neural Network Layers**: Forward propagation, activation functions
- **Signal Processing**: Filtering, feature extraction
- **Image Processing**: Convolution operations, normalization
- **Machine Learning**: Feature scaling, gradient computation
- **Control Systems**: State estimation, filtering
- **Linear Regression**: Direct regression modeling
- **Feature Transformation**: Linear feature combinations
- **Dimensionality Reduction**: Linear projections
