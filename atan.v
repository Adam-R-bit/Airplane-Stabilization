module atan(
	input wire signed [15:0] x,
	output reg signed [15:0] out
);

	parameter signed [15:0] INV_3 = 16'sd5461; // 1/3 in Q1.14
	parameter signed [15:0] INV_5 = 16'sd3277; // 1/5 in Q1.14
	parameter signed [15:0] INV_7 = 16'sd2340; // 1/7 in Q1.14
	
	
	// x^2 = x * x → Q2.28
	wire signed [31:0] x2_full = x * x;			//Q2.28
	wire signed [15:0] x2 = x2_full >>> 14	;  // Q1.14


	wire signed [31:0] x3_scaled = x2 * x;		 // Q2.28
	wire signed [47:0] term1 = x3_scaled * INV_3;  // Q3.42

	wire signed [47:0] x5_full = x3_scaled * x2; 	// Q3.42
	wire signed [31:0] x5_scaled = x5_full >>> 14; 	// Q2.28
	wire signed [47:0] term2 = x5_scaled * INV_5;	// Q3.42


	wire signed [47:0] x7_full = x5_scaled * x2;		// Q3.42
	wire signed [31:0] x7_scaled = x7_full >>> 14;	// Q2.28
	wire signed [47:0] term3 = x7_scaled * INV_7;	// Q3.42

	wire signed [47:0] x_scaled = x <<< 28; 			// Q3.42
	wire signed [47:0] result = x_scaled - term1 + term2 - term3;		//Q3.42

	always @(*) begin
	  out <= result >>> 28; // Back to Q1.14
	end

	
endmodule