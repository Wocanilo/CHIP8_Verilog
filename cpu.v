module cpu(
	input clk,
	output [7:0] salida
);

reg[7:0] registers[0:16];
reg [7:0]pc; //Program counter

//Instrucciones
reg [3:0]op; 
reg [3:0]arg_x;
reg [3:0]arg_y;
reg [3:0]arg_z; 


//Memoria
reg [7:0] ROM [3327:0]; // Declaración de memoria de 3328 Bytes

integer i;

initial begin
	for (i=0; i < 3328; i = i + 1) begin
		ROM[i] = 0;
	end
	$display("Loading rom.");
	$readmemb("Chip8Test.b", ROM); // Cargamos la rom en memoria
end

//Fin Memoria

initial begin
	pc = 0; // Establecemos el PC a 0.
	//NOP
	op = 0;
	arg_x = 0;
	arg_y = 0;
	arg_z = 0;
end


reg [15:0]instruction_debug = 0;

always @(posedge clk) begin
	$monitor("clk=%b, PC=%hex, INSTRUCTION=%hex, registro_0=%hex, registro_1=%hex, carry=%b", clk, pc, instruction_debug, registers[0], registers[1], registers[16]);
	instruction_debug <= {op, arg_x, arg_y, arg_z};
	// Aumentamos el PC. Cada instruccion son 2 bytes
	pc <= pc + 2;

	//TODO: Eliminar uso de máscaras para obtener las instrucciones.
	// Obtenemos la instrucción
	op <= ('b11110000 & ROM[pc]) >> 4; // Los primeros 4 bits son el opcode
	arg_x <= ('b00001111 & ROM[pc]); // Los siguientes 4 bits son el primer 'argumento'

	arg_y <= ('b11110000 & ROM[pc + 1]) >> 4; // Los primeros 4 bits segundo 'argumento'
	arg_z <= ('b00001111 & ROM[pc + 1]); // Los siguientes 4 bits son el tercer 'argumento'

	case(op)
		4'd1: pc <= {arg_x, arg_y, arg_z}; // 1nnn - Jump to location nnn.
		4'd3: if (registers[arg_x] == {arg_y, arg_z}) pc <= pc + 2; // ?
		4'd6: registers[arg_x] <= {arg_y, arg_z}; // The interpreter puts the value kk into register Vx.
		4'd7: registers[arg_x] <= registers[arg_x] + {arg_y, arg_z}; // Adds the value kk to the value of register Vx, then stores the result in Vx. 
		4'd8: 
			case(arg_z)
				4'd0: registers[arg_x] <= registers[arg_y]; // Stores the value of register Vy in register Vx.
				4'd1: registers[arg_x] <= registers[arg_x] | registers[arg_y]; // Performs a bitwise OR on the values of Vx and Vy, then stores the result in Vx.
				4'd2: registers[arg_x] <= registers[arg_x] & registers[arg_y]; // Performs a bitwise AND on the values of Vx and Vy, then stores the result in Vx.
				4'd3: registers[arg_x] <= registers[arg_x] ^ registers[arg_y]; // Performs a bitwise exclusive OR on the values of Vx and Vy, then stores the result in Vx.
				4'd4: {registers[16], registers[arg_x]} = registers[arg_x] + registers[arg_y]; // he values of Vx and Vy are added together. If the result is greater than 8 bits VF is set to 1, otherwise 0.
				4'd5: {registers[16], registers[arg_x]} = registers[arg_x] - registers[arg_y]; // If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
			endcase

	endcase


end



endmodule
	
