`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:26:42 12/13/2018 
// Design Name: 
// Module Name:    memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module memory(
	input clk,
	input wire [7:0] addr, // Dirección de memoria
	output reg [15:0] read_data // Contenido leido
	);
	
	reg [7:0] mem [0:4096]; // Declaración de memoria
	
	initial begin
		read_data <= 'b0000000000000000;

		$display("Loading rom.");
		$readmemb("Chip8Test.b", mem, 0); // Cargamos la rom en memoria
	end

	always @(posedge clk) 
		begin
			read_data <= {mem[addr], mem[addr + 1]};
		end
		
endmodule
