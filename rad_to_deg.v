module rad_to_deg (
    input  wire signed [15:0] rad_q14,   // Q1.14 radians
    output wire signed [15:0] deg_int    // plain‑integer degrees
);
    // 180/π ≈ 57.29577951 → 57.2958 × 2^14 = 938 735 (rounded)
    localparam signed [31:0] SCALE_Q14 = 32'sd938735;
    wire signed [31:0] rad_ext = {{16{rad_q14[15]}}, rad_q14};

    wire signed [63:0] product = rad_ext * SCALE_Q14;

    assign deg_int = product >>> 28;     // OR: product[43:28]
endmodule