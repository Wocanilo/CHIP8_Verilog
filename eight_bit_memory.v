module eight_bit_memory(
	input wire [7:0] addr, // Dirección de memoria
	input wire [7:0] write_data, //Contenido a escribir
	input wire memwrite, // Modo escritura o lectura
	output reg [7:0] read_data // Contenido leido
);

reg [7:0] mem [0:3327]; // Declaración de memoria de 3328 Bytes

// Parece que hay que inicializar la memoria

integer i;

initial begin
	read_data = 0; //Devolvemos ceros en el primer ciclo
	for (i=0; i < 3328; i = i + 1) begin
		mem[i] = 0;
	end
	$display("Loading rom.");
	$readmemb("Chip8Test.b", mem); // Cargamos la rom en memoria
end


always @(addr) begin
	if (memwrite == 1)
		mem[addr] <= write_data;
	else
		read_data <= mem[addr];

	end

endmodule



