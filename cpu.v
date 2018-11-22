module cpu(

	input clk,
	input [7:0] read_data,
	output [7:0] salida,
	output [7:0] addr,
	output [7:0] write_data,
	output reg memwrite
	
);

reg[7:0] registers[0:17]; // El último registro se usa como PC

reg [7:0] current_addr, current_write_data; // Almacenan el valor actual que se pasa a las salidas

reg [3:0]op; // Opcode
reg [3:0]arg_x;
reg [3:0]arg_y;
reg [3:0]arg_z; 

eight_bit_memory memory(
	.addr(addr),
	.write_data(write_data),
	.memwrite(memwrite),
	.read_data(read_data)
);

assign addr = current_addr;
assign salida = current_addr; // En un futuro devolverá los registros una vez acabe el programa
assign write_data = current_write_data;

initial begin
	memwrite = 0; // No es necesario
	registers[17] = 0; // Establecemos el PC a 0.
	current_addr = 0; // No es necesario
	current_write_data = 0;
	//Asignamos los valores de lo que será el opcode NOP (no hacer nada)
	op = 0;
	arg_x = 0;
	arg_y = 0;
	arg_z = 0;
end

always @(posedge clk) begin
	$monitor("memwrite=%b, clk=%b, addr=%b, write_data=%b, read_data=%b, PC=%b, OP=%b, arg_x=%b, arg_y=%b, arg_z=%b", memwrite, clk, addr, write_data, read_data, registers[17], op, arg_x, arg_y, arg_z);
	current_addr <= registers[17]; // Asignamos la dirección de memoria del ciclo
	memwrite = 0; // Por defecto la memoria está en solo lectura

	// Obtenemos primer byte de la instrucción
	op <= ('b11110000 & read_data) >> 4; // Los primeros 4 bits son el opcode
	arg_x <= ('b00001111 & read_data); // Los siguientes 4 bits son el primer 'argumento'


	// Aumentamos de nuevo el PC para saltar a la siguiente instruccion
	registers[17] <= registers[17] + 1; // Cada instruccion son 2 bytes
end



endmodule
	
