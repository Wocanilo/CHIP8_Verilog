module cpu(
	input clk,
	output [7:0] salida,
	input rst // Permite establecer los registros y el contador a cero
);

reg[7:0] registers[0:15];
reg [15:0]pc; //Program counter
reg carry; // Separamos el contador de carry de los registros.
reg skip; // Permite saltar la siguiente instrucción
reg [15:0]stack[0:16]; // Stack de 16bits y 16 niveles.
reg [3:0]stack_pointer; // Profundidad actual del stack.
reg [15:0]delay_timer;
reg [15:0] I;

//Instrucciones
reg [3:0]op; 
reg [3:0]arg_x;
reg [3:0]arg_y;
reg [3:0]arg_z; 


//Memoria
reg [7:0] ROM [0:4096]; // Declaración de memoria de 4096 Bytes

integer i;

initial begin
	for (i=0; i < 4096; i = i + 1) begin
		ROM[i] = 0;
	end
	$display("Loading rom.");
	$readmemb("Factorial.b", ROM, 512); // Cargamos la rom en memoria
end

//Fin Memoria

initial begin
	for (i=0; i < 15; i = i + 1) begin
		registers[i] = 0;
	end
	for (i=0; i < 16; i = i + 1) begin
		stack[i] = 0;
	end
	pc = 512;
	op = 0;
	arg_x = 0;
	arg_y = 0;
	arg_z = 0;
	carry = 0;
	skip = 0;
	stack_pointer = 0;
	delay_timer = 0;
	I = 0;
end

reg [15:0]instruction_debug = 0;


// Permite reiniciar la CPU 
always @(rst) begin
	for (i=0; i < 15; i = i + 1) begin
		registers[i] = 0;
	end
	for (i=0; i < 16; i = i + 1) begin
		stack[i] = 0;
	end
	pc = 512;
	op = 0;
	arg_x = 0;
	arg_y = 0;
	arg_z = 0;
	carry = 0;
	skip = 0;
	stack_pointer = 4'b0;
	delay_timer = 0;
	I = 0;
end

always @(posedge clk) begin
	$monitor("clk=%b, PC=%hex, INSTRUCTION=%hex, V0=%b, V1=%b, V2=%b, V3=%b, V4=%b, carry=%b, skip=%b, stack_pointer=%b, stack_0=%h, I=%h", clk, pc, instruction_debug, registers[0], registers[1], registers[2], registers[3], registers[4], carry, skip, stack_pointer, stack[0], I);
	instruction_debug <= {op, arg_x, arg_y, arg_z};
	if (delay_timer > 0) delay_timer <= delay_timer - 1;
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
				4'd0: // The interpreter sets the program counter to the address at the top of the stack, then subtracts 1 from the stack pointer.
					if (arg_z == 4'hE) begin
						pc <= stack[stack_pointer - 1];
						stack_pointer <= stack_pointer - 1;
					end
				4'd1: pc <= {arg_x, arg_y, arg_z}; // 1nnn - Jump to location nnn.
				4'd2: // The interpreter increments the stack pointer, then puts the current PC on the top of the stack. The PC is then set to nnn.
					begin
						stack[stack_pointer] <= pc;
						pc <= {arg_x, arg_y, arg_z};
						stack_pointer <= stack_pointer + 1;
					end
				4'd3: if (registers[arg_x] == {arg_y, arg_z}) skip <= 1;  // The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
				4'd4: if (registers[arg_x] != {arg_y, arg_z}) skip <= 1; //  The interpreter compares register Vx to kk, and if they are not equal, increments the program counter by 2.
				4'd5: if (registers[arg_x] == registers[arg_y]) skip <= 1; //  The interpreter compares register Vx to register Vy, and if they are equal, increments the program counter by 2.
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
				4'd9: if(registers[arg_x] != registers[arg_y]) skip <= 1; //  The values of Vx and Vy are compared, and if they are not equal, the program counter is increased by 2.
				4'hA: I <= {arg_x, arg_y, arg_z};
				4'hB: pc <= {arg_x, arg_y, arg_z} + registers[0]; //  The program counter is set to nnn plus the value of V0.
				4'hC: 
					begin // Implementar número aleatorio
						registers[arg_x] = 'b00001001 & {arg_y, arg_z};
					end
				4'hF:
					case(arg_z)
						4'd5: delay_timer <= registers[arg_x]; // DT is set equal to the value of Vx.
						4'd7: registers[arg_x] <= delay_timer; // The value of DT is placed into Vx.
						4'hE: I <= I + registers[arg_x];
					endcase	
			endcase
		end
		else skip <= 0;

end



endmodule
	
