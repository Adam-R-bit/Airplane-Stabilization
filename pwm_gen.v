module pwm_gen(
	input wire clk,		//50mhz
  	input wire [7:0] position,
	output wire pwm_out
);
	
	parameter cycles_per_period = 1000000;
	reg r_pwm_out;
	
	reg [16:0] on_cycles;
	reg [19:0] total_completed_cycles = 0;
	
	assign pwm_out = r_pwm_out;
	
	
	always@(posedge clk) begin
		if(position <= 180) begin
			if(total_completed_cycles < on_cycles) begin
				r_pwm_out <= 1;
				total_completed_cycles <= total_completed_cycles + 1;
			end else if(total_completed_cycles < 1000000) begin
				r_pwm_out <= 0;
				total_completed_cycles <= total_completed_cycles + 1;
			end else
				total_completed_cycles <= 0;
		end
	end
	
	always@(posedge clk) begin
		on_cycles <= 50000 + 288 * position;
	end
endmodule