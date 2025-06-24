module accelDataOut(
	input wire GSENSOR_SDO,
	input wire MAX10_CLK1_50,
	
	output wire GSENSOR_SDI,
	output wire GSENSOR_CS_N,
	output wire GSENSOR_SCLK,
	
	output [15:0] x,
	output [15:0] y,
	output [15:0] z,
	output [15:0] pitch,
	output [15:0] roll,
	
	output [15:0] test
);
	wire [7:0] data_out_accel;
	reg r_start_accel;
	reg [25:0] clk_cnt = 0;
	wire done_accel;
	wire start_accel;
	wire [5:0] in_addr;
	reg [5:0] r_in_addr;
	wire read_write;
	reg r_read_write = 1;
	wire multi_byte;
	reg r_multi_byte = 0;
	wire [7:0] data;
	reg [7:0] r_data = 8'b00001000;
	reg meas_enab = 0;
	wire [2:0] byte_cnt;
	
	reg [7:0] x0;
	reg [7:0] x1;
	reg [7:0] y0;
	reg [7:0] y1;
	reg [7:0] z0;
	reg [7:0] z1;
	
	assign x = { x1, x0 };
	assign y = { y1, y0 };
	assign z = { z1, z0 };
	
	
	assign start_accel = r_start_accel;
	assign read_write = r_read_write;
	assign multi_byte = r_multi_byte;
	assign data = r_data;
	assign in_addr = r_in_addr;
	
	spiAccelerometerMaster accel (
		.clk(MAX10_CLK1_50),
		.sdo(GSENSOR_SDO),
		.start(start_accel),
		.address(in_addr),
		.read_write(read_write),
		.multi_byte(multi_byte),
		.data(data),
		.sdi(GSENSOR_SDI),
		.CS(GSENSOR_CS_N),
		.sclk(GSENSOR_SCLK),
		.data_out(data_out_accel),
		.done(done_accel),
		.byte_cnt_out(byte_cnt)
	);
	
	
	//parameter clk_cycles = 62500;
	parameter clk_cycles = 1000000;
	
	always@(posedge MAX10_CLK1_50) begin
		if(clk_cnt == clk_cycles) begin
			if(~meas_enab) begin
				r_read_write <= 0;
				r_multi_byte <= 0;
				r_in_addr <= 6'b101101;
				meas_enab <= 1;
				r_start_accel <= 1;
			end else begin
			
				if(byte_cnt == 0) begin			// if the read has not started, trigger a start pulse
					r_start_accel <= 1;
				end else begin						// if read has already started, do not trigger a start pulse
					r_start_accel <= 0;
				end
				
				r_read_write <= 1;
				r_multi_byte <= 1;
				r_in_addr <= 6'b110010;
			end
			
			clk_cnt <= 0;
		end else begin
			r_start_accel <= 0;
			clk_cnt <= clk_cnt + 1;
		end
		
		
		
		
		if(done_accel) begin					// if the spi protocol indicates done, write the appropriate byte out
													// NOTE: if the read being performed is not a multi-byte read, nothing will be written to x, y, or z
			case(byte_cnt)
				1: x0 <= data_out_accel;
				
				2: x1 <= data_out_accel;
				
				3: y0 <= data_out_accel;
				
				4: y1 <= data_out_accel;
				
				5: z0 <= data_out_accel;
				
				6: z1 <= data_out_accel;
			endcase
				
		end

	end
	
	// This next section is only to compute the pitch and roll from existing data	
	
	wire [31:0] atan_in_pitch = (x << 16) / z;
	wire [31:0] atan_in_roll = (y << 16) / z;
	
	assign test = atan_in_pitch;
	
	atan pitch_atan(
		.x(atan_in_pitch[31:16]),
		.out(pitch)
	);
	
	atan roll_atan(
		.x(atan_in_roll[31:16]),
		.out(roll)
	);
endmodule