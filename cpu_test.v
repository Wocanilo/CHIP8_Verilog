`timescale 1ns / 1ps
module cpu_test(

	input clk
	);
	reg test_clk;


	// "Conectamos" las salidas de nuestra prueba a las entradas de la memoria
	assign clk = test_clk;

	CPU uut(.clk(clk));

	always begin
		#5 test_clk = ~test_clk;
	end


	initial begin
		test_clk = 1;

		$dumpfile("memory.vcd");
		$dumpvars(0, cpu_test);


		#200 $finish;
	end

endmodule
