`timescale 1ns / 1ps
module four_bit_shift_register(
    input clk,
    output reg [3:0] number
    );
	
	initial
		begin
			number = 1;
		end
		
	always @(posedge clk)
		begin
			number <= {number << 1, number[2] ^ number[3]};
		end
			


endmodule
