module AirplaneStabilizer3(
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
	wire [15:0] pitchFull;
	wire [7:0] pitch = pitchFull[15:8];
	
	assign LEDR[0] = pitch[0];
	assign LEDR[1] = pitch[1];
	assign LEDR[2] = pitch[2];
	assign LEDR[3] = pitch[3];
	assign LEDR[4] = pitch[4];
	assign LEDR[5] = pitch[5];
	assign LEDR[6] = pitch[6];
	assign LEDR[7] = pitch[7];
	

	
	accelDataOut (
		.GSENSOR_SDO(GSENSOR_SDO),
		.MAX10_CLK1_50(MAX10_CLK1_50),
		
		.GSENSOR_SDI(GSENSOR_SDI),
		.GSENSOR_CS_N(GSENSOR_CS_N),
		.GSENSOR_SCLK(GSENSOR_SCLK),
		
		.x(),
		.y(),
		.z(),
		.pitch(),
		.roll(),
		.test(pitchFull)
	);
	
	
	displayThreeDigNum (
		.num(pitch),
		.clk(MAX10_CLK1_50),
		
		.dig1(HEX0),
		.dig2(HEX1),
		.dig3(HEX2)
	);
endmodule