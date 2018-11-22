`timescale 1ns / 1ps
module test_memory;

	wire memwrite;
	input clk;
	wire [0:7] addr, write_data, read_data;

	reg [0:7] test_addr, test_write_data;
	reg test_memwrite;
	reg test_clk;

	// "Conectamos" las salidas de nuestra prueba a las entradas de la memoria
	assign memwrite = test_memwrite;
	assign addr = test_addr;
	assign write_data = test_write_data;
	assign clk = test_clk;

	eight_bit_memory uut(.addr(addr), .write_data(write_data), .memwrite(memwrite), .read_data(read_data), .clk(clk));

	always
		#10 test_clk = ~test_clk;


	initial begin
		test_addr = 0;
		test_write_data = 2;
		//test_memwrite = 1;
		test_clk = 1;
		
		#5 test_memwrite = 0;
		$dumpfile("memory.vcd");
		$dumpvars(0, test_memory);
		$monitor("memwrite=%b, clk=%b, addr=%b, write_data=%b, read_data=%b", memwrite, clk, addr, write_data, read_data);
		#5 test_addr = test_addr + 1;
		#200 $finish;
	end

endmodule
