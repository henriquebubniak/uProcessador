library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        opcode : in unsigned(7 downto 0);
        flags: in unsigned(7 downto 0);
        oper: in unsigned(5 downto 0);
        jump, alu_src, write_en, flags_wr: out std_logic;
        pc_src: out unsigned(1 downto 0);
        write_ad, reg_a_ad, reg_b_ad : out unsigned(4 downto 0);
        alu_op : out unsigned(2 downto 0);
        flag_mask: out unsigned(7 downto 0);
        imm: out unsigned(5 downto 0);
        mem_wr, mem_to_reg: out std_logic
    );
end control_unit;

--  ADC imm, zpg
--  SBC imm, zpg
--  LDA imm, zpg, (abs,X)
--  CLC impl
--  CLV impl
--  SEC impl
--  STA zpg, (abs,X)
--  JMP abs
--  BMI rel
--  BEQ rel
--  BCS rel

--  CMP imm, zpg
--  TAY
--  TYA
--  BPL rel 
--  INC zpg

-- LDA abs
-- STA abs, Y
-- BNE
-- CPY imm
-- CPX imm

architecture a_control_unit of control_unit is
begin
    
    jump <= '1' when opcode = x"4C" else -- Jump
            flags(5) when opcode = x"F0" else -- BEQ
            flags(7) when opcode = x"30" else -- BMI
            flags(4) when opcode = x"B0" else -- BCS
            not flags(7) when opcode = x"10" else -- BPL
            not flags(5) when opcode = x"D0" else -- BNE
            '0';

    alu_src <= '1' when opcode = x"69" else -- ADC imm
               '1' when opcode = x"E9" else -- SBC imm
               '1' when opcode = x"A9" else -- LDA imm
               '1' when opcode = x"9D" else -- STA abs,X
               '1' when opcode = x"99" else -- STA abs,Y
               '1' when opcode = x"BD" else -- LDA abs,X
               '1' when opcode = x"AD" else -- LDA abs
               '1' when opcode = x"C9" else -- CMP imm
               '1' when opcode = x"E0" else -- CPX imm
               '1' when opcode = x"C0" else -- CPY imm
               '1' when opcode = x"38" else -- SEC impl
               '1' when opcode = x"E6" else -- INC zpg
               '0';

    write_en <= '1' when opcode = x"65" else -- ADC zpg
                '1' when opcode = x"85" else -- STA zpg
                '1' when opcode = x"A5" else -- LDA zpg
                '1' when opcode = x"69" else -- ADC imm
                '1' when opcode = x"E9" else -- SBC imm
                '1' when opcode = x"A9" else -- LDA imm
                '1' when opcode = x"BD" else -- LDA abs,X
                '1' when opcode = x"AD" else -- LDA abs
                '1' when opcode = x"A8" else -- TAY
                '1' when opcode = x"98" else -- TYA
                '1' when opcode = x"E6" else -- INC zpg
                '0';
    
    flags_wr <= '1' when opcode = x"65" else -- ADC zpg
                '1' when opcode = x"69" else -- ADC imm
                '1' when opcode = x"E9" else -- SBC imm
                '1' when opcode = x"A9" else -- LDA imm
                '1' when opcode = x"A5" else -- LDA zpg
                '1' when opcode = x"BD" else -- LDA abs,X
                '1' when opcode = x"AD" else -- LDA abs
                '1' when opcode = x"18" else -- CLC impl
                '1' when opcode = x"38" else -- SEC impl
                '1' when opcode = x"B8" else -- CLV impl
                '1' when opcode = x"C9" else -- CMP imm
                '1' when opcode = x"C5" else -- CMP zpg
                '1' when opcode = x"E0" else -- CPX imm
                '1' when opcode = x"C0" else -- CPY imm
                '1' when opcode = x"A8" else -- TAY
                '1' when opcode = x"98" else -- TYA
                '1' when opcode = x"E6" else -- INC zpg
                '0';

    write_ad <= "00001" when opcode = x"65" else -- ADC zpg
                "00001" when opcode = x"69" else -- ADC imm
                "00001" when opcode = x"E9" else -- SBC imm
                "00001" when opcode = x"A9" else -- LDA imm
                "00001" when opcode = x"A5" else -- LDA zpg
                "00001" when opcode = x"BD" else -- LDA abs,X
                "00001" when opcode = x"AD" else -- LDA abs
                "00001" when opcode = x"98" else -- TYA
                "00011" when opcode = x"A8" else -- TAY
                oper(4 downto 0) when opcode = x"85" else -- STA zpg
                oper(4 downto 0) when opcode = x"E6" else -- INC zpg
                "00000";

    reg_a_ad <= "00001" when opcode = x"65" else -- ADC zpg
                "00001" when opcode = x"69" else -- ADC imm
                "00001" when opcode = x"E9" else -- SBC imm
                "00001" when opcode = x"85" else -- STA zpg
                "00001" when opcode = x"C9" else -- CMP imm
                "00001" when opcode = x"C5" else -- CMP zpg
                "00001" when opcode = x"A8" else -- TAY
                "11111" when opcode = x"38" else -- SEC impl
                "00010" when opcode = x"9D" else -- STA abs,X
                "00010" when opcode = x"BD" else -- LDA abs,X
                "00010" when opcode = x"E0" else -- CPX imm
                "00011" when opcode = x"98" else -- TYA
                "00011" when opcode = x"C0" else -- CPY imm
                "00011" when opcode = x"99" else -- STA abs,Y
                oper(4 downto 0) when opcode = x"E6" else -- INC zpg
                "00000";

    reg_b_ad <= oper(4 downto 0) when opcode = x"65" else -- ADC zpg
                oper(4 downto 0) when opcode = x"69" else -- ADC imm
                oper(4 downto 0) when opcode = x"E9" else -- SBC imm
                oper(4 downto 0) when opcode = x"A9" else -- LDA imm
                oper(4 downto 0) when opcode = x"A5" else -- LDA zpg
                oper(4 downto 0) when opcode = x"C5" else -- CMP zpg
                "11111" when opcode = x"38" else          -- SEC impl
                "00001" when opcode = x"9D" else          -- STA abs,X
                "00001" when opcode = x"99" else          -- STA abs,Y
                "00000";

    alu_op <= "001" when opcode = x"E9" else -- SBC imm
              "011" when opcode = x"A9" else -- LDA imm
              "011" when opcode = x"A5" else -- LDA zpg
              "011" when opcode = x"AD" else -- LDA abs
              "011" when opcode = x"85" else -- STA zpg
              "011" when opcode = x"A8" else -- TAY
              "011" when opcode = x"98" else -- TYA
              "110" when opcode = x"C9" else -- CMP imm
              "110" when opcode = x"C5" else -- CMP zpg
              "110" when opcode = x"E0" else -- CPX imm
              "110" when opcode = x"C0" else -- CPY imm
              "101" when opcode = x"E6" else -- INC zpg
              "000";
    
    pc_src <= "01" when opcode = x"4C" else -- JMP
              "10" when opcode = x"F0" else -- BEQ
              "10" when opcode = x"30" else -- BMI
              "10" when opcode = x"B0" else -- BCS
              "10" when opcode = x"10" else -- BPL
              "10" when opcode = x"D0" else -- BNE
              "00";
                
                -- n, v, z, c, 0000
    flag_mask <= b"1111_0000" when opcode = x"65" else -- ADC zpg
                 b"1111_0000" when opcode = x"69" else -- ADC imm
                 b"1111_0000" when opcode = x"E9" else -- SBC imm
                 b"1010_0000" when opcode = x"A9" else -- LDA imm
                 b"1010_0000" when opcode = x"A5" else -- LDA zpg
                 b"1010_0000" when opcode = x"BD" else -- LDA abs,X
                 b"1010_0000" when opcode = x"AD" else -- LDA abs
                 b"0001_0000" when opcode = x"18" else -- CLC impl
                 b"0001_0000" when opcode = x"38" else -- SEC impl
                 b"0100_0000" when opcode = x"B8" else -- CLV impl
                 b"1011_0000" when opcode = x"C9" else -- CMP imm
                 b"1011_0000" when opcode = x"C5" else -- CMP zpg
                 b"1011_0000" when opcode = x"E0" else -- CPX imm
                 b"1011_0000" when opcode = x"C0" else -- CPY imm
                 b"1010_0000" when opcode = x"A8" else -- TAY
                 b"1010_0000" when opcode = x"98" else -- TYA
                 b"1010_0000" when opcode = x"E6" else -- INC zpg
                 b"0000_0000";
    
    mem_wr <= '1' when opcode = x"9D" else -- STA abs,X
              '1' when opcode = x"99" else -- STA abs,Y
              '0';
    
    mem_to_reg <= '1' when opcode = x"BD" else -- LDA abs,X
                  '1' when opcode = x"AD" else -- LDA abs
                  '0';

    imm <= b"11_1111" when opcode = x"38" else
           b"00_0001" when opcode = x"E6" else
           oper;



end a_control_unit;
