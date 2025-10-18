# Verilator Makefile for SystemVerilog ML Library Tests
# Usage: make test_all, make test_vector_ops, etc.

VERILATOR = verilator
VERILATOR_FLAGS = --cc --exe --build --trace
VERILATOR_INCLUDES = -I../src/api -I../src/internal

# test targets
test_vector_ops: test_vector_ops.sv
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module test_vector_ops $(VERILATOR_INCLUDES) test_vector_ops.sv
	./obj_dir/Vtest_vector_ops

test_linear_reg: test_linear_regression.sv
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module test_linear_regression $(VERILATOR_INCLUDES) test_linear_regression.sv
	./obj_dir/Vtest_linear_regression

test_logistic_reg: test_logistic_regression.sv
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module test_logistic_regression $(VERILATOR_INCLUDES) test_logistic_regression.sv
	./obj_dir/Vtest_logistic_regression

test_activations: test_activations.sv
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module test_activations $(VERILATOR_INCLUDES) test_activations.sv
	./obj_dir/Vtest_activations

test_fully_connected: test_fully_connected.sv
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module test_fully_connected $(VERILATOR_INCLUDES) test_fully_connected.sv
	./obj_dir/Vtest_fully_connected

test_integration: test_integration.sv
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module test_integration $(VERILATOR_INCLUDES) test_integration.sv
	./obj_dir/Vtest_integration

# run all tests
test_all: test_vector_ops test_linear_reg test_logistic_reg test_activations test_fully_connected test_integration
	@echo "All tests completed!"

# clean build artifacts
clean:
	rm -rf obj_dir

# help
help:
	@echo "Available targets:"
	@echo "  test_vector_ops     - test vector operations"
	@echo "  test_linear_reg     - test linear regression"
	@echo "  test_logistic_reg   - test logistic regression"
	@echo "  test_activations    - test activation functions"
	@echo "  test_fully_connected - test fully connected layer"
	@echo "  test_integration    - test end-to-end integration"
	@echo "  test_all           - run all tests"
	@echo "  clean              - clean build artifacts"
	@echo "  help               - show this help"
