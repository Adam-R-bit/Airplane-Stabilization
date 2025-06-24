
module AirplaneStabilizer2(
	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,

	//////////// Accelerometer //////////
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,

	//////////// Arduino //////////
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,

	//////////// GPIO, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO
);
	
	wire [7:0] data_out_accel;
	reg r_start_accel, r_LED9;
	wire done_accel;
	wire start_accel;
	
	assign LEDR[0] = data_out_accel[0];
	assign LEDR[1] = data_out_accel[1];
	assign LEDR[2] = data_out_accel[2];
	assign LEDR[3] = data_out_accel[3];
	assign LEDR[4] = data_out_accel[4];
	assign LEDR[5] = data_out_accel[5];
	assign LEDR[6] = data_out_accel[6];
	assign LEDR[7] = data_out_accel[7];
	
	assign start_accel = r_start_accel;
	assign LEDR[8] = done_accel;
	assign LEDR[9] = r_LED9;
	
	spiAccelerometerMaster accel (
		.clk(MAX10_CLK1_50),
		.sdo(GSENSOR_SDO),
		.start(start_accel),
		.sdi(GSENSOR_SDI),
		.CS(GSENSOR_CS_N),
		.sclk(GSENSOR_SCLK),
		.data_out(data_out_accel),
		.done(done_accel)
	);
	
	always@(posedge MAX10_CLK1_50) begin
		if(!KEY[0]) begin
			r_start_accel <= 1;
			r_LED9 <= 1;
		end else begin
			r_start_accel <= 0;
			r_LED9 <= 0;
		end
	end

	//begin pwm out test
	wire [7:0] position;
	
	assign position[0] = SW[0];
	assign position[1] = SW[1];
	assign position[2] = SW[2];
	assign position[3] = SW[3];
	assign position[4] = SW[4];
	assign position[5] = SW[5];
	assign position[6] = SW[6];
	assign position[7] = SW[7];
	
	
	pwm_gen(
		.clk(MAX10_CLK1_50),
		.position(position),
		.pwm_out(GPIO[0])
	);

endmodule
