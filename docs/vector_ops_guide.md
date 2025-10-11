# Vector Operations API - User Guide

## Overview

The `vector_ops` module provides a comprehensive interface for vector arithmetic operations commonly used in machine learning and signal processing applications. This module supports element-wise operations, dot products, vector reduction, and thresholding operations.

## Module Interface

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

## Operation Codes

| Operation Code | Operation | Description |
|----------------|-----------|-------------|
| `3'b000` | Vector Addition | Element-wise addition of vectors a and b |
| `3'b001` | Vector Subtraction | Element-wise subtraction of vectors a and b |
| `3'b010` | Element-wise Multiplication | Element-wise multiplication of vectors a and b |
| `3'b011` | Vector Scaling | Multiply each element of vector a by scalar |
| `3'b100` | Vector Thresholding | Apply threshold function to vector a |
| `3'b101` | Dot Product | Compute dot product of vectors a and b |
| `3'b110` | Vector Reduction | Sum all elements of vector a |

## Usage Examples

### 1. Vector Addition

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

### 2. Vector Subtraction

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

### 3. Element-wise Multiplication

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

### 4. Vector Scaling

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

### 5. Vector Thresholding 

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

### 6. Dot Product

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

### 7. Vector Reduction (Sum)

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

## Complete Example: Neural Network Layer

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

## Parameter Guidelines

### WIDTH Parameter
- **8-bit**: Suitable for small neural networks, image processing
- **16-bit**: Good balance of precision and resource usage
- **32-bit**: High precision, suitable for most applications
- **64-bit**: Maximum precision, use for critical computations

### LENGTH Parameter
- **4-8**: Small feature vectors, simple operations
- **16-32**: Medium-sized vectors, typical neural network layers
- **64-128**: Large vectors, complex feature extraction
- **256+**: Very large vectors, use with caution (resource intensive)

### THRESHOLD Parameter
- **0**: ReLU activation (most common)
- **Negative values**: Leaky ReLU-like behavior
- **Positive values**: Custom thresholding for feature selection

## Performance Considerations

1. **Combinational Logic**: All operations are combinational, providing immediate results
2. **Parallel Execution**: Multiple operations can run simultaneously
3. **Resource Usage**: Larger vectors require more hardware resources
4. **Timing**: Consider timing constraints for large vectors

## Common Use Cases

- **Neural Network Layers**: Forward propagation, activation functions
- **Signal Processing**: Filtering, feature extraction
- **Image Processing**: Convolution operations, normalization
- **Machine Learning**: Feature scaling, gradient computation
- **Control Systems**: State estimation, filtering

## Troubleshooting

### Common Issues:
1. **Bit Width Overflow**: Ensure sufficient bit width for operations
2. **Array Indexing**: Use 0-based indexing `[0:LENGTH-1]`
3. **Operation Selection**: Verify correct operation codes
4. **Parameter Mismatch**: Ensure consistent WIDTH and LENGTH parameters

### Debug Tips:
- Use simulation to verify operation results
- Check bit widths match between connected modules
- Verify operation codes are correct for intended functionality
- Test with known input values to validate outputs
