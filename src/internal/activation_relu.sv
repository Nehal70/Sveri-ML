module activation_relu #(WIDTH = 32) (
    input logic signed [WIDTH-1:0] input_data,
    input logic signed [WIDTH-1:0] output_data
);

    assign output_data = (input_data > 0) ? input_data : 0;

endmodule