# Sveri-ML : SystemVerilog ML Library

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![SystemVerilog](https://img.shields.io/badge/SystemVerilog-2017-blue.svg)](https://ieeexplore.ieee.org/document/8299595)
[![FPGA](https://img.shields.io/badge/FPGA-Compatible-green.svg)](https://en.wikipedia.org/wiki/Field-programmable_gate_array)

A comprehensive hardware-optimized machine learning library for SystemVerilog, designed for FPGA and ASIC implementation. This library provides efficient fixed-point arithmetic operations, vector processing, and machine learning algorithms optimized for hardware acceleration.

Exepected Completion : 17th October

## 🚀 Features

### ✅ Currently Available

- **Vector Operations**: Complete suite of vector arithmetic operations
- **Linear Regression**: Hardware-optimized linear regression implementation
- **Logistic Regression**: Binary and multi-class classification with sigmoid activation
- **Fixed-Point Arithmetic**: Efficient numerical computation with configurable precision
- **Modular Design**: Reusable components for complex machine learning systems
- **Hardware Optimized**: Designed for FPGA and ASIC implementation

### 🔮 Coming Soon

- **Activation Functions**: Comprehensive activation function library
- **Neural Network Layers**: Complete neural network layer implementations
- **Pipeline Module**: Flexible pipeline system for connecting ML components

## 📚 Documentation

- **[Complete User Guide](docs/user_guide.md)** - Comprehensive API documentation
- **[Vector Operations Guide](docs/vector_ops_guide.md)** - Detailed vector operations documentation
- **[API Reference](docs/api_reference.md)** - Technical API specifications

## 🏗️ Architecture

### Library Structure

```
src/
├── api/                    # User-facing API modules
│   ├── vector_ops.sv       # Vector operations interface
│   ├── linear_regression.sv # Linear regression implementation
│   └── logistic_regression.sv # Logistic regression implementation
├── internal/               # Internal building blocks
│   ├── adder.sv           # Basic adder module
│   ├── multiplier.sv      # Basic multiplier module
│   ├── fixed_point.sv     # Fixed-point arithmetic
│   ├── vector_add.sv      # Vector addition
│   ├── vector_sub.sv      # Vector subtraction
│   ├── vector_dot.sv      # Vector dot product
│   ├── activation_relu.sv # ReLU activation function
│   └── activation_sigmoid.sv # Sigmoid activation function
└── tb/                    # Testbenches
```

### Design Philosophy

- **Modularity**: Each component has a single responsibility
- **Reusability**: Internal modules are reused across API modules
- **Efficiency**: Optimized for hardware implementation
- **Flexibility**: Parameterizable for different use cases
- **Consistency**: Uniform interface across all modules

## 🛠️ Installation

### Prerequisites

- SystemVerilog simulator (ModelSim, VCS, Verilator, etc.)
- FPGA synthesis tools (Vivado, Quartus, etc.)
- Basic understanding of SystemVerilog

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/systemverilog-ml-library.git
   cd systemverilog-ml-library
   ```

2. **Include modules in your project**:
   ```systemverilog
   `include "src/api/vector_ops.sv"
   `include "src/api/linear_regression.sv"
   `include "src/api/logistic_regression.sv"
   ```

3. **Instantiate modules**:
   ```systemverilog
   // Vector addition example
   vector_ops #(.WIDTH(32), .LENGTH(8)) vec_ops (
       .a(input_vector_a),
       .b(input_vector_b),
       .scalar(32'd0),
       .op(3'b000),  // Addition
       .vector_result(result_vector),
       .dot_result(),
       .reduction_result()
   );
   ```

## 📖 Usage Examples

### Vector Operations

```systemverilog
module vector_processor (
    input  logic clk,
    input  logic rst_n,
    input  logic signed [31:0] vector_a [0:7],
    input  logic signed [31:0] vector_b [0:7],
    output logic signed [31:0] result [0:7]
);

    vector_ops #(.WIDTH(32), .LENGTH(8)) processor (
        .a(vector_a),
        .b(vector_b),
        .scalar(32'd0),
        .op(3'b000),  // Addition
        .vector_result(result),
        .dot_result(),
        .reduction_result()
    );

endmodule
```

### Linear Regression

```systemverilog
module linear_predictor (
    input  logic clk,
    input  logic rst_n,
    input  logic signed [31:0] weights [0:15],
    input  logic signed [31:0] features [0:15],
    input  logic signed [31:0] bias,
    output logic signed [31:0] prediction
);

    ml_linear_regression #(
        .WIDTH(32),
        .FRAC_BITS(16),
        .LENGTH(16)
    ) predictor (
        .weights(weights),
        .inputs(features),
        .bias(bias),
        .result(prediction)
    );

endmodule
```

### Logistic Regression

```systemverilog
module binary_classifier (
    input  logic clk,
    input  logic rst_n,
    input  logic signed [31:0] weights [0:7],
    input  logic signed [31:0] features [0:7],
    input  logic signed [31:0] bias,
    output logic signed [31:0] probability,
    output logic classification
);

    ml_binary_classifier #(
        .WIDTH(32),
        .FRAC_BITS(16),
        .LENGTH(8),
        .THRESHOLD(0.5)
    ) classifier (
        .weights(weights),
        .inputs(features),
        .bias(bias),
        .probability(probability),
        .classification(classification)
    );

endmodule
```

## 🔮 Roadmap

### Phase 1: Core ML Operations ✅
- [x] Vector operations (addition, subtraction, multiplication, scaling)
- [x] Linear regression
- [x] Logistic regression
- [x] Fixed-point arithmetic

### Phase 2: Activation Functions 🚧
- [ ] **Activation Functions Module**: Comprehensive activation function library
  - ReLU, Leaky ReLU, ELU, Swish
  - Tanh, Sigmoid, Softmax
  - Custom activation functions
  - Hardware-optimized implementations

### Phase 3: Neural Network Layers 🚧
- [ ] **Neural Network Layer Module**: Complete neural network implementations
  - Fully connected layers
  - Convolutional layers (1D, 2D)
  - Pooling layers (Max, Average)
  - Batch normalization
  - Dropout layers

### Phase 4: Pipeline System 🚧
- [ ] **Pipeline Module**: Flexible pipeline system for connecting ML components
  - Component chaining
  - Data flow management
  - Pipeline optimization
  - Dynamic reconfiguration

## 🎯 Use Cases

### Machine Learning
- **Neural Networks**: Building blocks for deep learning
- **Classification**: Binary and multi-class classification
- **Regression**: Linear and non-linear regression
- **Feature Engineering**: Vector operations for feature processing

### Signal Processing
- **Filtering**: Linear and non-linear filtering
- **Pattern Recognition**: Signal classification
- **Anomaly Detection**: Outlier identification
- **Feature Extraction**: Signal feature computation

### Control Systems
- **State Estimation**: Kalman filtering and observers
- **Control Laws**: Linear and non-linear control
- **Adaptive Systems**: Self-tuning controllers
- **Real-time Processing**: Low-latency control

## ⚡ Performance

### Hardware Efficiency
- **Combinational Logic**: Single-cycle operations
- **Parallel Processing**: Vector operations in parallel
- **Resource Optimization**: Efficient multiplier and adder usage
- **Timing Closure**: Optimized for high-frequency operation

### Scalability
- **Parameterizable**: Configurable bit widths and vector lengths
- **Modular**: Easy to scale and extend
- **Pipeline-friendly**: Designed for pipelined implementations
- **Multi-instance**: Support for parallel processing

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Add tests** for new functionality
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to the branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Code Style

- Follow SystemVerilog 2017 standards
- Use meaningful parameter and signal names
- Include comprehensive comments
- Maintain consistent indentation
- Add testbenches for new modules

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **SystemVerilog Community**: For the excellent language standard
- **FPGA Vendors**: For providing excellent synthesis tools
- **Open Source Community**: For inspiration and best practices
- **Contributors**: For their valuable contributions

## 📞 Support

- **Documentation**: Check our [User Guide](docs/user_guide.md)
- **Issues**: Report bugs and request features on [GitHub Issues](https://github.com/yourusername/systemverilog-ml-library/issues)
- **Discussions**: Join our [GitHub Discussions](https://github.com/yourusername/systemverilog-ml-library/discussions)
- **Email**: Contact us at [your-email@example.com](mailto:your-email@example.com)

## 📊 Statistics

![GitHub stars](https://img.shields.io/github/stars/yourusername/systemverilog-ml-library?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/systemverilog-ml-library?style=social)
![GitHub issues](https://img.shields.io/github/issues/yourusername/systemverilog-ml-library)
![GitHub pull requests](https://img.shields.io/github/issues-pr/yourusername/systemverilog-ml-library)

---

**Built with ❤️ for the SystemVerilog and Machine Learning communities**
