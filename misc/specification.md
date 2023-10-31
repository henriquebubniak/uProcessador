# Especificação

## Registradores

| Endereço | Descrição
| -        | - 
| 0        | zero
| 1        | acumulador
| 2        | X
| 3        | Y
| 4..      | Zeropage

## Instruções

| Instrução | Opcode | Operando | Descrição     | status
| -         | -      | -        | -             | -
| adc zpg   | 6      | adr      | A += mem[adr] | ok
| adc imm   | 9      | val      | A += val      | ok
| sbc imm   | E      | val      | A -= val      | ok
| sta       | 5      | adr      | mem[adr] = A  | not ok
| lda imm   | A      | val      | A = val       | not ok
| lda zpg   | B      | adr      | A = mem[adr]  | not ok
| jmp       | F      | adr      | PC = adr      | ok
