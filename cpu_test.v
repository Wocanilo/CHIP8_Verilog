`timescale 1ns / 1ps
module cpu_test;

	input clk;
	input [7:0] read_data, salida;

	reg test_clk;


	// "Conectamos" las salidas de nuestra prueba a las entradas de la memoria
	assign clk = test_clk;

	cpu uut(.clk(clk), .salida(salida));

	always begin
		#5 test_clk = ~test_clk;
	end


	initial begin
		test_clk = 1;

		$dumpfile("memory.vcd");
		$dumpvars(0, cpu_test);
		$monitor("clk=%b, salida=%b", clk, salida);


		#100 $finish;
	end

endmodule
