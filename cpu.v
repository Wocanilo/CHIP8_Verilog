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
	$monitor("clk=%b, PC=%b, INSTRUCTION=%hex", clk, pc, instruction_debug);
	instruction_debug <= {op, arg_x, arg_y, arg_z};
	// Obtenemos la instrucción
	op <= ('b11110000 & ROM[pc]) >> 4; // Los primeros 4 bits son el opcode
	arg_x <= ('b00001111 & ROM[pc]); // Los siguientes 4 bits son el primer 'argumento'

	arg_y <= ('b11110000 & ROM[pc + 1]) >> 4; // Los primeros 4 bits segundo 'argumento'
	arg_z <= ('b00001111 & ROM[pc + 1]); // Los siguientes 4 bits son el tercer 'argumento'


	// Aumentamos el PC. Cada instruccion son 2 bytes
	pc <= pc + 2;
end



endmodule
	
