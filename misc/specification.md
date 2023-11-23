# Especificação

## Registradores

| Endereço | Descrição
| -        | -
| 0        | zero
| 1        | acumulador
| 2        | X
| 3        | Y
| 4..      | Zeropage

## Flags

NZVC0000

## Instruções

Os opcodes são formados pelos 8 bits menos significativos. Os 6 bits mais significativos é o operando. Segue tabela de instruções:

| Instrução | Opcode | Operando | Descrição       | status
| --------- | ------ | -------- | --------------- | ------
| adc zpg   | 65     | adr      | A += mem[adr]   | ok
| adc imm   | 69     | val      | A += val        | ok
| sbc imm   | E9     | val      | A -= val        | ok
| sta zpg   | 85     | adr      | mem[adr] = A    | ok
| sta abs,x | 9D     | adr      | mem[adr+x] = A  | ok
| sta abs,y | 99     | adr      | mem[adr+y] = A  | not ok
| lda imm   | A9     | val      | A = val         | ok
| lda zpg   | A5     | adr      | A = mem[adr]    | ok
| lda abs   | AD     | adr      | A = mem[adr]    | not ok
| lda abs,x | BD     | adr      | A = mem[adr+x]  | ok
| tay       | A8     | -        | Y = A           | ok
| tya       | 98     | -        | A = Y           | ok
| cmp imm   | C9     | val      | A - val         | ok
| cmp zpg   | C5     | adr      | A - mem[adr]    | ok
| cpx imm   | E0     | val      | X - val         | not ok
| cpy imm   | C0     | val      | Y - val         | not ok
| sec       | 38     | -        | C = 1           | ok
| clc       | 18     | -        | C = 0           | ok
| clv       | B8     | -        | V = 0           | ok
| inc zpg   | E6     | adr      | mem[adr] += 1   | ok
| jmp       | 4C     | adr      | PC = adr        | ok
| beq       | F0     | adr      | PC += adr se Z  | ok
| bne       | D0     | adr      | PC += adr se !Z | not ok
| bmi       | 30     | adr      | PC += adr se N  | ok
| bcs       | B0     | adr      | PC += adr se C  | ok
| bpl       | 10     | adr      | PC += adr se !N | ok
