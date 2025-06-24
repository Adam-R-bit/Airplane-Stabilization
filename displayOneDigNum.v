module displayOneDigNum(
	input [3:0] numIn,
	input clk,
	output reg [7:0] sevenSeg
);
	always@(posedge clk) begin
		case(numIn)
			0: begin
				sevenSeg[0] <= 1;
				sevenSeg[1] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[3] <= 1;
				sevenSeg[4] <= 1;
				sevenSeg[5] <= 1;
				sevenSeg[6] <= 0;
				sevenSeg[7] <= 0;
			end
			
			1: begin
				sevenSeg[1] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[3] <= 0;
				sevenSeg[4] <= 0;
				sevenSeg[5] <= 0;
				sevenSeg[6] <= 0;
				sevenSeg[7] <= 0;
				sevenSeg[0] <= 0;
			end
			
			2: begin
				sevenSeg[0] <= 1;
				sevenSeg[1] <= 1;
				sevenSeg[6] <= 1;
				sevenSeg[4] <= 1;
				sevenSeg[3] <= 1;
				sevenSeg[2] <= 0;
				sevenSeg[5] <= 0;
				sevenSeg[7] <= 0;
			end
			
			3: begin
				sevenSeg[0] <= 1;
				sevenSeg[1] <= 1;
				sevenSeg[6] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[3] <= 1;
				sevenSeg[4] <= 0;
				sevenSeg[5] <= 0;
				sevenSeg[7] <= 0;
			end
			
			4: begin
				sevenSeg[5] <= 1;
				sevenSeg[6] <= 1;
				sevenSeg[1] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[0] <= 0;
				sevenSeg[3] <= 0;
				sevenSeg[4] <= 0;
				sevenSeg[7] <= 0;
			end
			
			5: begin
				sevenSeg[0] <= 1;
				sevenSeg[5] <= 1;
				sevenSeg[6] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[3] <= 1;
				sevenSeg[1] <= 0;
				sevenSeg[4] <= 0;
				sevenSeg[7] <= 0;
			end
			
			6: begin
				sevenSeg[5] <= 1;
				sevenSeg[4] <= 1;
				sevenSeg[3] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[6] <= 1;
				sevenSeg[0] <= 0;
				sevenSeg[1] <= 0;
				sevenSeg[7] <= 0;
			end
			
			7: begin
				sevenSeg[0] <= 1;
				sevenSeg[1] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[3] <= 0;
				sevenSeg[4] <= 0;
				sevenSeg[5] <= 0;
				sevenSeg[6] <= 0;
				sevenSeg[7] <= 0;
			end
			
			8: begin
				sevenSeg[0] <= 1;
				sevenSeg[1] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[3] <= 1;
				sevenSeg[4] <= 1;
				sevenSeg[5] <= 1;
				sevenSeg[6] <= 1;
				sevenSeg[7] <= 0;
			end
			
			9: begin
				sevenSeg[0] <= 1;
				sevenSeg[5] <= 1;
				sevenSeg[6] <= 1;
				sevenSeg[1] <= 1;
				sevenSeg[2] <= 1;
				sevenSeg[3] <= 0;
				sevenSeg[4] <= 0;
				sevenSeg[7] <= 0;
			end
		endcase
	end
endmodule