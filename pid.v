module pid (
	input wire clk,
	input wire signed [7:0] current_position,
	input wire signed [7:0] desired_position,
	output wire pwm_out
);
	parameter Kp = 1;
	parameter Ki = 1;
	parameter Kd = -1;
	
	parameter clk_cycles = 500;				//how many clock cycles the clock divider counts; also controls the depth of past_err
	
	reg [7:0] output_pid;
	wire [7:0] output_pos;
	
	reg signed [7:0] current_error;
	reg signed [7:0] derivative_error;
	reg signed [7:0] integral_error = 0;
	reg signed [7:0] output_pid;
	
	reg [3:0] clk_cnt = 0;
	
	reg [7:0] past_err [0:clk_cycles - 1];
	
	assign output_pos = 90 + output_pid;

	
	always@(posedge clk) begin
		if(clk_cnt == clk_cycles) begin
			
			//Raw error calc
			current_error <= desired_position - current_position;
			
			
			//Integral error calc
			for(i = 0; i < 8; i = i + 1) begin
				integral_error <= integral_error + past_err[i];
			end
			
			
			//Derivative error calc
			derivative_error <= (past_err[clk_cycles - 1] - past_err[0]) / 4;
			
			//Add errors together
			output_pid <= Kp * current_error;
			output_pid <= output_pos + Ki * integral_error;
			output_pid <= output_pos + Kd * derivative_error;
		end else begin
		
			current_error <= desired_position - current_position;
			past_err[clk_cnt] <= current_error;
			
			integral_error <= 0;
			
			clk_cnt <= clk_cnt + 1;
		end
	end
	
	pwm_gen (
		.clk(clk),
		.position(output_pos),
		.pwm_out(pwm_out)
	);
endmodule