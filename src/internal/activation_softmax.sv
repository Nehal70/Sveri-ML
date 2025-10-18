// softmax over a vector using exp lut and fixed-point normalization
module activation_softmax #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    parameter LENGTH = 16,
    parameter LUT_SIZE = 256
)(
    input  logic signed [WIDTH-1:0] in_data   [0:LENGTH-1],
    output logic signed [WIDTH-1:0] out_data  [0:LENGTH-1]
);

    // small exp lut for stability and speed
    logic [WIDTH-1:0] exp_lut [0:LUT_SIZE-1];

    // find max for numerical stability
    logic signed [WIDTH-1:0] max_val;
    integer i;
    always_comb begin
        max_val = in_data[0];
        for (i = 1; i < LENGTH; i++) begin
            if (in_data[i] > max_val)
                max_val = in_data[i];
        end
    end

    // compute exponentials using lut
    logic [WIDTH-1:0] exp_vals [0:LENGTH-1];
    logic [7:0] lut_index;
    genvar gi;
    generate
        for (gi = 0; gi < LENGTH; gi++) begin : exp_loop
            logic signed [WIDTH-1:0] shifted;
            always_comb begin
                shifted = in_data[gi] - max_val;
                if (shifted < -((WIDTH>(FRAC_BITS+7)) ? (1 << (FRAC_BITS + 7)) : (1 << (WIDTH-1))))
                    lut_index = 0;
                else if (shifted > ((WIDTH>(FRAC_BITS+7)) ? (1 << (FRAC_BITS + 7)) : (1 << (WIDTH-1))))
                    lut_index = LUT_SIZE-1;
                else
                    lut_index = (shifted >>> (FRAC_BITS - 8)) + (LUT_SIZE / 2);
            end
            assign exp_vals[gi] = exp_lut[lut_index];
        end
    endgenerate

    // sum of exponentials
    logic signed [WIDTH+16-1:0] sum_exp;
    integer j;
    always_comb begin
        sum_exp = '0;
        for (j = 0; j < LENGTH; j++) begin
            sum_exp += exp_vals[j];
        end
    end

    // normalize each exponential by the sum
    genvar k;
    generate
        for (k = 0; k < LENGTH; k++) begin : norm_loop
            // scale numerator to preserve frac bits, then divide
            // note: division is resource-heavy but keeps code straightforward here
            logic signed [WIDTH+FRAC_BITS-1:0] scaled_num;
            assign scaled_num = $signed({{FRAC_BITS{1'b0}}, exp_vals[k]});
            assign out_data[k] = (sum_exp != 0) ? (scaled_num / sum_exp) : '0;
        end
    endgenerate

    // rough exp lut values in q16 for e^x over a small window
    initial begin
        exp_lut[0]   = 0;
        exp_lut[1]   = 1;
        exp_lut[2]   = 1;
        exp_lut[3]   = 1;
        exp_lut[4]   = 1;
        exp_lut[5]   = 2;
        exp_lut[6]   = 2;
        exp_lut[7]   = 2;
        exp_lut[8]   = 3;
        exp_lut[9]   = 3;
        // ... populate more points for better accuracy in real use ...
        exp_lut[246] = 45746;
        exp_lut[247] = 47176;
        exp_lut[248] = 48660;
        exp_lut[249] = 50199;
        exp_lut[250] = 51795;
        exp_lut[251] = 53449;
        exp_lut[252] = 55163;
        exp_lut[253] = 56939;
        exp_lut[254] = 58779;
        exp_lut[255] = 60684;
    end

endmodule

