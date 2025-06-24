module displayThreeDigNum(
	input [7:0] num,
	input clk,
	
	output [7:0] dig1,
	output [7:0] dig2,
	output [7:0] dig3
);
	reg [3:0] num1 = 0;
	reg [3:0] num2 = 0;
	reg [3:0] num3 = 0;
	reg [7:0] totalNum = 0;
	
	displayOneDigNum one(
		.numIn(num1),
		.clk(clk),
		.sevenSeg(dig1)
	);
	displayOneDigNum two(
		.numIn(num2),
		.clk(clk),
		.sevenSeg(dig2)
	);
	displayOneDigNum three(
		.numIn(num3),
		.clk(clk),
		.sevenSeg(dig3)
	);
	
	always@(posedge clk) begin
		if(totalNum > num) begin
			totalNum <= 0;
		end else if(totalNum != num) begin
		totalNum <= totalNum + 1;
			if(num1 != 9) begin
				num1 <= num1 + 1;
			end else begin
				num1 <= 0;
				if(num2 != 9) begin
					num2 <= num2 + 1;
				end else begin
					num2 <= 0;
					num3 <= num3 + 1;
				end
			end
		end
	end
endmodule