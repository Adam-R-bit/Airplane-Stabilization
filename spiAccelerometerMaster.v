module spiAccelerometerMaster(
	input wire clk,		//50 Mhz
	input wire sdo,
	input wire start,
	input wire [5:0] address,			//0x32 = X-Axis LSB, 0x37 = Z-axis MSB, 0x00 = DEVID
	input wire read_write,				//1 for read, 0 for write
	input wire multi_byte,				//1 for multi-byte, 0 for single-byte
	input wire [7:0] data,
	
	output wire sdi,
	output wire CS,
	output wire sclk,
	output reg[7:0] data_out,
	output wire done,
  	output wire [2:0] byte_cnt_out
);
	parameter clk_cycles = 50; 			//50 Mhz / 2 Mhz = 25 hz maybe 1 Mhz??? find out
	
  	localparam IDLE = 0, START = 1, WRITE_ADDR = 2, READ = 3, DONE = 4, WAIT = 5, WRITE_DATA = 6;
  
	reg r_sdi, r_done, r_start_prev;		//sdi means send data to the accelerometer, sdo vice versa
  	reg r_sclk = 1;
	reg r_CS = 1;
	reg [15:0] clk_cnt = 0;
  	reg [2:0] bit_cnt = 7;
	reg [2:0] state = IDLE;
	reg [2:0] next_state = IDLE;
	reg [2:0] byte_cnt = 0;
  
  	wire start_rising;
	
  	assign start_rising = start & ~r_start_prev;
  
	assign sclk = r_sclk;
	assign sdi = r_sdi;
	assign done = r_done;
	assign CS = r_CS;
	assign byte_cnt_out = byte_cnt;
  	
	
	
	always@(posedge clk) begin
      if(start_rising)
			state <= START;
		if(clk_cnt == clk_cycles) begin
          if(~sclk) begin					//check for rising edge
				clk_cnt <= 0;
				case(state)
				
					IDLE: begin
						r_CS <= 1;
						r_done <= 0;
					end
					
					WAIT: begin
						state <= next_state;
					end
					
					START: begin
						r_CS <= 0;
						bit_cnt <= 7;
						state <= WRITE_ADDR;
					end
					
					READ: begin
						data_out[bit_cnt] <= sdo;
						if(bit_cnt == 0) begin
							r_done <= 1;
							if(multi_byte == 0) begin		// check if multibyte is off
								state <= WAIT;
								next_state <= DONE;
							end else begin						// check if multibyte is on
								byte_cnt <= byte_cnt + 1;
								
								if(byte_cnt == 6) begin		// if last register read
									byte_cnt <= 0;
									state <= WAIT;
									next_state <= DONE;
								end
							end
						end else begin
							r_done <= 0;
						end
						bit_cnt <= bit_cnt - 1;
					end
					
					DONE: begin
						r_CS <= 1;
						r_done <= 1;
						state <= IDLE;
					end
				
				endcase
				
				r_sclk <= ~r_sclk;
			end else begin 					//check for falling edge
				clk_cnt <= 0;
				
				case(state)
				
					WRITE_ADDR: begin
						if (bit_cnt == 0) begin
							 r_sdi <= address[0];
							 
							 if(read_write)
								next_state <= READ;
							 else
								next_state <= WRITE_DATA;
							
							 state <= WAIT;       
							 bit_cnt <= bit_cnt - 1;
						end else begin
							 if (bit_cnt <= 5)
								  r_sdi <= address[bit_cnt];
							 else if (bit_cnt == 6)
								  r_sdi <= multi_byte;
							 else if (bit_cnt == 7)
								  r_sdi <= read_write;

							 bit_cnt <= bit_cnt - 1;
						end
					end
					
					WRITE_DATA: begin
						if (bit_cnt == 0) begin
							 r_sdi <= data[0];
							 next_state <= DONE;
							 state <= WAIT;       
							 bit_cnt <= bit_cnt - 1;
						end else begin
							 r_sdi <= data[bit_cnt];
							 bit_cnt <= bit_cnt - 1;
						end
					end
					
					WAIT: begin
						state <= next_state;
					end
				
				endcase

				r_sclk <= ~r_sclk;
			end
		end else begin
			clk_cnt <= clk_cnt + 1;
		end
	end
  
  always@(posedge clk) begin
    r_start_prev = start;
  end
endmodule