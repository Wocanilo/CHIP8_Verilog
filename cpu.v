module cpu(
	input clk,
	output [7:0] salida,
	input rst // Permite establecer los registros y el contador a cero
);

reg[7:0] registers[0:15];
reg [7:0]pc; //Program counter
reg carry; // Separamos el contador de carry de los registros.
reg skip; // Permite saltar la siguiente instrucción

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
	for (i=0; i < 15; i = i + 1) begin
		registers[i] = 0;
	end
	pc = 0;
	op = 0;
	arg_x = 0;
	arg_y = 0;
	arg_z = 0;
	carry = 0;
	skip = 0;
end

reg [15:0]instruction_debug = 0;


// Permite reiniciar la CPU 
always @(rst) begin
	for (i=0; i < 15; i = i + 1) begin
		registers[i] = 0;
	end
	pc = 0;
	op = 0;
	arg_x = 0;
	arg_y = 0;
	arg_z = 0;
	carry = 0;
	skip = 0;
end

always @(posedge clk) begin
	$monitor("clk=%b, PC=%hex, INSTRUCTION=%hex, V1=%b, V2=%b, V3=%b, V4=%b, carry=%b, skip=%b", clk, pc, instruction_debug, registers[1], registers[2], registers[3], registers[4], carry, skip);
	instruction_debug <= {op, arg_x, arg_y, arg_z};
	// Aumentamos el PC. Cada instruccion son 2 bytes
	pc <= pc + 2;

	//TODO: Eliminar uso de máscaras para obtener las instrucciones.
	// Obtenemos la instrucción
	op <= ('b11110000 & ROM[pc]) >> 4; // Los primeros 4 bits son el opcode
	arg_x <= ('b00001111 & ROM[pc]); // Los siguientes 4 bits son el primer 'argumento'

	arg_y <= ('b11110000 & ROM[pc + 1]) >> 4; // Los primeros 4 bits segundo 'argumento'
	arg_z <= ('b00001111 & ROM[pc + 1]); // Los siguientes 4 bits son el tercer 'argumento'


	// Explicacion de las instrucciones de: http://devernay.free.fr/hacks/chip8/C8TECH10.HTM
	if(skip == 0)
		begin
			case(op)
				4'd1: pc <= {arg_x, arg_y, arg_z}; // 1nnn - Jump to location nnn.
				4'd3: if (registers[arg_x] == {arg_y, arg_z}) skip <= 1;  // The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
				4'd6: registers[arg_x] <= {arg_y, arg_z}; // The interpreter puts the value kk into register Vx.
				4'd7: registers[arg_x] <= registers[arg_x] + {arg_y, arg_z}; // Adds the value kk to the value of register Vx, then stores the result in Vx. 
				4'd8: 
					case(arg_z)
						4'd0: registers[arg_x] <= registers[arg_y]; // Stores the value of register Vy in register Vx.
						4'd1: registers[arg_x] <= registers[arg_x] | registers[arg_y]; // Performs a bitwise OR on the values of Vx and Vy, then stores the result in Vx.
						4'd2: registers[arg_x] <= registers[arg_x] & registers[arg_y]; // Performs a bitwise AND on the values of Vx and Vy, then stores the result in Vx.
						4'd3: registers[arg_x] <= registers[arg_x] ^ registers[arg_y]; // Performs a bitwise exclusive OR on the values of Vx and Vy, then stores the result in Vx.
						4'd4: {carry, registers[arg_x]} = registers[arg_x] + registers[arg_y]; // he values of Vx and Vy are added together. If the result is greater than 8 bits VF is set to 1, otherwise 0.
						4'd5: {carry, registers[arg_x]} = registers[arg_x] - registers[arg_y]; // If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
						4'd6: //  If the least-significant bit of Vx is 1, then VF is set to 1, otherwise 0. Then Vx is divided by 2.
							begin
								carry = 'b00000001 & registers[arg_x];
								registers[arg_x] = registers[arg_x] >> 1;
							end
						4'd7: {carry, registers[arg_x]} = registers[arg_y] - registers[arg_x]; //  If Vy > Vx, then VF is set to 1, otherwise 0. Then Vx is subtracted from Vy, and the results stored in Vx.
						4'hE: //  If the most-significant bit of Vx is 1, then VF is set to 1, otherwise to 0. Then Vx is multiplied by 2.
							begin
								carry = 'b00000001 & registers[arg_x];
								registers[arg_x] = registers[arg_x] << 1;
							end
					endcase
				4'hC: 
					begin // Implementar número aleatorio
						registers[arg_x] = 'b00001001 & {arg_y, arg_z};
					end

			endcase
		end
		else skip <= 0;

end



endmodule
	
