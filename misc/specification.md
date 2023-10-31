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
| adc zpg   | 65     | adr      | A += mem[adr] | ok
| adc imm   | 69     | val      | A += val      | ok
| sbc imm   | E9     | val      | A -= val      | ok
| sta       | 85     | adr      | mem[adr] = A  | not ok
| lda imm   | A9     | val      | A = val       | not ok
| lda zpg   | A5     | adr      | A = mem[adr]  | not ok
| jmp       | 4C     | adr      | PC = adr      | ok


- sta: em vez de armazenar val, armazena A + val

   solução: write_data_mux

## Interface do banco de registradores

- reg_a_ad
- reg_b_ad
- write_data: alu_out
- write_ad: A ou adr





