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

| Instrução | Opcode | Operando | Descrição
| -         | -      | -        | -
| adc zpg   | 6      | adr      | A += mem[adr]
| adc imm   | 9      | val      | A += val
| sbc imm   | E      | val      | A -= val
| sta       | 5      | adr      | mem[adr] = A
| lda imm   | A      | val      | A = val
| jmp       | F      | adr      | PC = adr
