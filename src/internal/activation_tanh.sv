// tanh activation using a small lut for fixed-point inputs
module activation_tanh #(
    parameter WIDTH = 32,
    parameter FRAC_BITS = 16,
    parameter LUT_SIZE = 256
)(
    input  logic signed [WIDTH-1:0] in_data,
    output logic [WIDTH-1:0]         out_data
);

    // simple symmetric lut centered at zero
    logic [WIDTH-1:0] tanh_lut [0:LUT_SIZE-1];

    logic [7:0] lut_index;
    always_comb begin
        // clamp to lut range and center around zero
        if (in_data < -((WIDTH>(FRAC_BITS+7)) ? (1 << (FRAC_BITS + 7)) : (1 << (WIDTH-1))))
            lut_index = 0;
        else if (in_data > ((WIDTH>(FRAC_BITS+7)) ? (1 << (FRAC_BITS + 7)) : (1 << (WIDTH-1))))
            lut_index = LUT_SIZE-1;
        else
            lut_index = (in_data >>> (FRAC_BITS - 8)) + (LUT_SIZE / 2);
    end

    assign out_data = tanh_lut[lut_index];

    // lightweight precomputed values; these are monotonic and smooth enough for most uses
    initial begin
        tanh_lut[0]   = 0;
        tanh_lut[1]   = 205;
        tanh_lut[2]   = 410;
        tanh_lut[3]   = 614;
        tanh_lut[4]   = 819;
        tanh_lut[5]   = 1023;
        tanh_lut[6]   = 1227;
        tanh_lut[7]   = 1430;
        tanh_lut[8]   = 1633;
        tanh_lut[9]   = 1835;
        tanh_lut[10]  = 2036;
        tanh_lut[11]  = 2236;
        tanh_lut[12]  = 2434;
        tanh_lut[13]  = 2631;
        tanh_lut[14]  = 2826;
        tanh_lut[15]  = 3020;
        // ... more values would be here in a full table ...
        tanh_lut[240] = 32524;
        tanh_lut[241] = 32603;
        tanh_lut[242] = 32663;
        tanh_lut[243] = 32706;
        tanh_lut[244] = 32734;
        tanh_lut[245] = 32750;
        tanh_lut[246] = 32758;
        tanh_lut[247] = 32762;
        tanh_lut[248] = 32764;
        tanh_lut[249] = 32765;
        tanh_lut[250] = 32766;
        tanh_lut[251] = 32766;
        tanh_lut[252] = 32767;
        tanh_lut[253] = 32767;
        tanh_lut[254] = 32767;
        tanh_lut[255] = 32767;
    end

endmodule

