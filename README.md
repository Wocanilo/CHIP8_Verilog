# Hertz (WIP)
Hertz is a CPU based on the Chip8 instruction set. It implements all non-graphical instructions of the Chip8 besides some exclusive instructions that lets you control circuits via the IO pins of your FPGA. Unlike others CPUs,  Hertz aims to be based on human time, thats why it cycles at 1 hertz.

## Instruction set
(Source: [Cowgod's Chip-8 Technical Reference](http://devernay.free.fr/hacks/chip8/C8TECH10.HTM))
| Instruction | Mnemonic | Human|
|--|--|--|
| _1nnn_ | _JP addr_ |_PC = nnn_|
| _2nnn_ | _CALL addr_ |_sp += 1 / stack[sp] = pc / PC = nnn_|
|_3xkk_|_SE Vx, byte_|_pc += 2 if Vx == kk_|
|_4xkk_|_SNE Vx, byte_|_pc += 2 if Vx != kk_|
|_5xy0_|_SE Vx, Vy_|pc += 2 if Vx == Vy|
|_6xkk_|_LD Vx, byte_|_Vx = kk_|
|_7xkk_|_ADD Vx, byte_|_Vx = Vx + kk_|
|_8xy0_|_LD Vx, Vy_|_Vx = Vy_|
|_8xy1_|_OR Vx, Vy_|_Vx = Vx OR Vy_|
|_8xy2_|_AND Vx, Vy_|_Vx = Vx AND Vy_|
|_8xy3_|_XOR Vx, Vy_|_Vx = Vx XOR Vy_|
|_8xy4_|_ADD Vx, Vy_|_Vx = Vx + Vy, VF = carry_|
|_8xy5_|_SUB Vx, Vy_|_Vx = Vx - Vy, VF = NOT borrow_|
|_8xy6_|_SHR Vx {, Vy}_|_Vx = Vx >> 1, VF = least-significant bit_|
|_8xy7_|_SUBN Vx, Vy_|_Vx = Vy - Vx, VF = Not borrow_|
|_8xyE_|_SHL Vx {, Vy}_|_Vx = Vx << 1, VF = most-significant bit_|
|_9xy0_|_SNE Vx, Vy_|_pc += 2 if Vx != Vy_|
|_Annn_|_LD I, addr_| _I = nnn_|
|_Bnnn_|_JP V0, addr_|_pc = nnn + V0_|
|_Cxkk_|_RND Vx, byte_|_Vx = random_byte AND kk_|
|_Dnk0_|_OUT n_|_PIN n = k_|
|_Fx15_|_LD DT, Vx_|_DT = Vx_|
|_Fx18_|_LD ST, Vx_|_ST = Vx_|
|_Fx1E_|_ADD I, Vx_|_I = I + Vx_|

## Example code
The repository contains a file named _Chip8Test.binary_ from [Ruby Quiz - Chip-8 (#88)](http://rubyquiz.com/quiz88.html) that lets you test some of the functionalities of the CPU.
