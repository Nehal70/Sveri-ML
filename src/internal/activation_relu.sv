module activation_relu #(
    parameter WIDTH = 32
)(
    input  logic signed [WIDTH-1:0] in_data,
    output logic signed [WIDTH-1:0] out_data
);

    // plain relu with signed compare
    assign out_data = (in_data > '0) ? in_data : '0;

endmodule