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

architecture a_control_unit of control_unit is
begin
    
    jump <= '1' when opcode = x"4C" else -- Jump
            flags(5) when opcode = x"F0" else -- BEQ
            flags(7) when opcode = x"30" else -- BMI
            flags(4) when opcode = x"B0" else -- BCS
            '0';

    alu_src <= '1' when opcode = x"69" else -- ADC imm
               '1' when opcode = x"E9" else -- SBC imm
               '1' when opcode = x"A9" else -- LDA imm
               '1' when opcode = x"9D" else -- STA abs,X
               '1' when opcode = x"BD" else -- LDA abs,X
               '0';

    write_en <= '1' when opcode = x"65" else -- ADC zpg
                '1' when opcode = x"85" else -- STA zpg
                '1' when opcode = x"A5" else -- LDA zpg
                '1' when opcode = x"69" else -- ADC imm
                '1' when opcode = x"E9" else -- SBC imm
                '1' when opcode = x"A9" else -- LDA imm
                '1' when opcode = x"BD" else -- LDA abs,X
                '0';
    
    flags_wr <= '1' when opcode = x"65" else -- ADC zpg
                '1' when opcode = x"69" else -- ADC imm
                '1' when opcode = x"E9" else -- SBC imm
                '1' when opcode = x"A9" else -- LDA imm
                '1' when opcode = x"A5" else -- LDA zpg
                '1' when opcode = x"BD" else -- LDA abs,X
                '1' when opcode = x"18" else -- CLC impl
                '1' when opcode = x"38" else -- SEC impl
                '1' when opcode = x"B8" else -- CLV impl
                '0';

    write_ad <= "00001" when opcode = x"65" else -- ADC zpg
                "00001" when opcode = x"69" else -- ADC imm
                "00001" when opcode = x"E9" else -- SBC imm
                "00001" when opcode = x"A9" else -- LDA imm
                "00001" when opcode = x"A5" else -- LDA zpg
                "00001" when opcode = x"BD" else -- LDA abs,X
                oper(4 downto 0) when opcode = x"85" else -- STA zpg
                "00000";

    reg_a_ad <= "00001" when opcode = x"65" else -- ADC zpg
                "00001" when opcode = x"69" else -- ADC imm
                "00001" when opcode = x"E9" else -- SBC imm
                "00001" when opcode = x"85" else -- STA zpg
                "11111" when opcode = x"38" else -- SEC impl
                "00010" when opcode = x"9D" else -- STA abs,X
                "00010" when opcode = x"BD" else -- LDA abs,X
                "00000";

    reg_b_ad <= oper(4 downto 0) when opcode = x"65" else -- ADC zpg
                oper(4 downto 0) when opcode = x"69" else -- ADC imm
                oper(4 downto 0) when opcode = x"E9" else -- SBC imm
                oper(4 downto 0) when opcode = x"A9" else -- LDA imm
                oper(4 downto 0) when opcode = x"A5" else -- LDA zpg
                "11111" when opcode = x"38" else          -- SEC impl
                "00001" when opcode = x"9D" else          -- STA abs,X
                "00000";

    alu_op <= "001" when opcode = x"E9" else -- SBC imm
              "011" when opcode = x"A9" else -- LDA imm
              "011" when opcode = x"A5" else -- LDA zpg
              "011" when opcode = x"85" else -- STA zpg
              "000";
    
    pc_src <= "01" when opcode = x"4C" else -- JMP
              "10" when opcode = x"F0" else -- BEQ
              "10" when opcode = x"30" else -- BMI
              "10" when opcode = x"B0" else -- BCS
              "00";
                
                -- n, v, z, c, 0000
    flag_mask <= b"1111_0000" when opcode = x"65" else -- ADC zpg
                 b"1111_0000" when opcode = x"69" else -- ADC imm
                 b"1111_0000" when opcode = x"E9" else -- SBC imm
                 b"1010_0000" when opcode = x"A9" else -- LDA imm
                 b"1010_0000" when opcode = x"A5" else -- LDA zpg
                 b"1010_0000" when opcode = x"BD" else -- LDA abs,X
                 b"0001_0000" when opcode = x"18" else -- CLC impl
                 b"0001_0000" when opcode = x"38" else -- SEC impl
                 b"0100_0000" when opcode = x"B8" else -- CLV impl
                 b"0000_0000";
    
    mem_wr <= '1' when opcode = x"9D" else -- STA abs,X
              '0';
    
    mem_to_reg <= '1' when opcode = x"BD" else -- LDA abs,X
                  '0';



end a_control_unit;
