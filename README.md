# CHIP8 Verilog

Emulador de CHIP8 en Verilog. Posee todas las funciones del intérprete a excepción de aquellas relacionadas con gráficos, que no serán implementadas. 

Incluye una ROM de prueba obtenida de http://rubyquiz.com/quiz88.html. 

La ROM realiza las siguientes instrucciones:

```
000: [6177] V1 = 0x77
002: [6245] V2 = 0x45
004: [7101] V1 = V1 + 0x01
006: [8320] V3 = V2
008: [8121] V1 = V1 | V2
00A: [8122] V1 = V1 & V2
00C: [8233] V2 = V2 ^ V3
00E: [8134] V1 = V1 + V3
010: [8235] V2 = V2 - V3
012: [8106] V1 = V1 >> 1
014: [8327] V3 = V2 - V3
016: [830E] V3 = V3 << 1
018: [64FF] V4 = 0xFF
01A: [C411] V4 = rand() & 0x11
01C: [32BB] skip next if V2 == 0xBB
01E: [1000] goto 000
020: [0000] exit
```

Y como resultado los registros quedan así:
```
V1:01000101
V2:10111011
V3:11101100
V4:this number should be random, so do multiple runs to make sure it changes -> Aún no ha sido implementada una función que genere números aleatorios por lo que el resultado es el mismo siempre.
VF:00000000 -> En nuestro caso es el registro Carry
```

Es posible desarrollar programas para ella mediante el ensamblador Octo (https://github.com/JohnEarnest/Octo). Una vez compilados se puede obtener el archivo de texto con la representación del programa en binario mediante el comando:

```
xxd -b Chip8Test | cut -d: -f 2 | sed 's/  .*//;' > Chip8Test.b
```

Para ejecutar el programa tan solo debemos compilar el emulador y ejecutarlo en el simulador:
```
iverilog -o cpu_test cpu.v cpu_test.v
vvp cpu_test
```

La salida del programa será parecida (o idéntica si usamos la ROM de prueba) a la siguiente:

```
Loading rom.
WARNING: cpu.v:33: $readmemb(Chip8Test.b): Not enough words in the file for the requested range [512:4096].
VCD info: dumpfile memory.vcd opened for output.
clk=1, PC=0202ex, INSTRUCTION=0000ex, V0=00000000, V1=00000000, V2=00000000, V3=00000000, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0202ex, INSTRUCTION=0000ex, V0=00000000, V1=00000000, V2=00000000, V3=00000000, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0204ex, INSTRUCTION=6177ex, V0=00000000, V1=01110111, V2=00000000, V3=00000000, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0204ex, INSTRUCTION=6177ex, V0=00000000, V1=01110111, V2=00000000, V3=00000000, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0206ex, INSTRUCTION=6245ex, V0=00000000, V1=01110111, V2=01000101, V3=00000000, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0206ex, INSTRUCTION=6245ex, V0=00000000, V1=01110111, V2=01000101, V3=00000000, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0208ex, INSTRUCTION=7101ex, V0=00000000, V1=01111000, V2=01000101, V3=00000000, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0208ex, INSTRUCTION=7101ex, V0=00000000, V1=01111000, V2=01000101, V3=00000000, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=020aex, INSTRUCTION=8320ex, V0=00000000, V1=01111000, V2=01000101, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=020aex, INSTRUCTION=8320ex, V0=00000000, V1=01111000, V2=01000101, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=020cex, INSTRUCTION=8121ex, V0=00000000, V1=01111101, V2=01000101, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=020cex, INSTRUCTION=8121ex, V0=00000000, V1=01111101, V2=01000101, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=020eex, INSTRUCTION=8122ex, V0=00000000, V1=01000101, V2=01000101, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=020eex, INSTRUCTION=8122ex, V0=00000000, V1=01000101, V2=01000101, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0210ex, INSTRUCTION=8233ex, V0=00000000, V1=01000101, V2=00000000, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0210ex, INSTRUCTION=8233ex, V0=00000000, V1=01000101, V2=00000000, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0212ex, INSTRUCTION=8134ex, V0=00000000, V1=10001010, V2=00000000, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0212ex, INSTRUCTION=8134ex, V0=00000000, V1=10001010, V2=00000000, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0214ex, INSTRUCTION=8235ex, V0=00000000, V1=10001010, V2=10111011, V3=01000101, V4=00000000, carry=1, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0214ex, INSTRUCTION=8235ex, V0=00000000, V1=10001010, V2=10111011, V3=01000101, V4=00000000, carry=1, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0216ex, INSTRUCTION=8106ex, V0=00000000, V1=01000101, V2=10111011, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0216ex, INSTRUCTION=8106ex, V0=00000000, V1=01000101, V2=10111011, V3=01000101, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0218ex, INSTRUCTION=8327ex, V0=00000000, V1=01000101, V2=10111011, V3=01110110, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0218ex, INSTRUCTION=8327ex, V0=00000000, V1=01000101, V2=10111011, V3=01110110, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=021aex, INSTRUCTION=830eex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=021aex, INSTRUCTION=830eex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000000, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=021cex, INSTRUCTION=64ffex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=11111111, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=021cex, INSTRUCTION=64ffex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=11111111, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=021eex, INSTRUCTION=c411ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=021eex, INSTRUCTION=c411ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0220ex, INSTRUCTION=32bbex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=1, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0220ex, INSTRUCTION=32bbex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=1, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0222ex, INSTRUCTION=1000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0222ex, INSTRUCTION=1000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0224ex, INSTRUCTION=0000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0224ex, INSTRUCTION=0000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0226ex, INSTRUCTION=0000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0226ex, INSTRUCTION=0000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0228ex, INSTRUCTION=0000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=0, PC=0228ex, INSTRUCTION=0000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
clk=1, PC=0228ex, INSTRUCTION=0000ex, V0=00000000, V1=01000101, V2=10111011, V3=11101100, V4=00000001, carry=0, skip=0, stack_pointer=0000, stack_0=0000, I=0000
```
Es posible que sea necesario ajustar el número de unidades de tiempo que se ejecutará la simulación en el archivo cpu_test.v

```
		#200 $finish;
```




