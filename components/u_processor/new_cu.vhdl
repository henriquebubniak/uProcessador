library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic;
        opcode : in unsigned(7 downto 0);
        flags: in unsigned(7 downto 0);
        oper: in unsigned(5 downto 0);
        --pc_clock, rom_clock, reg_bank_clock: out std_logic;
        jump, alu_src, write_en, flags_wr: out std_logic;
        pc_src: out unsigned(1 downto 0);
        write_ad, reg_a_ad, reg_b_ad : out unsigned(4 downto 0);
        alu_op : out unsigned(2 downto 0)
    );
end control_unit;

architecture a_control_unit of control_unit is
begin
    
    jump <= '1' when opcode = x"4C" else -- Jump
            flags(5) when opcode = x"F0" else -- BEQ
            flags(7) when opcode = x"30" else -- BMI
            flags(4) when opcode = x"B0" else -- BCS
            '0';

               -- ADC imm, SBC imm, LDA imm
    alu_src <= '1' when opcode(3 downto 0) = x"9" else
               -- ADC zpg, STA zpg, LDA zpg
               '0' when opcode(3 downto 0) = x"5" else
               -- BEQ, BMI, BCS
               '0' when opcode(3 downto 0) = x"0" else
               -- JMP
               '0' when opcode(3 downto 0) = x"C" else
               -- others
               '0';

    write_en <= '0' when opcode(3 downto 0) = x"0" else
                '0' when opcode(3 downto 0) = x"C" else
                '1' when opcode(3 downto 0) = x"5" else
                '1' when opcode(3 downto 0) = x"9" else
                '0';
    
    flags_wr <= '1' when opcode = x"65" else
                '1' when opcode = x"69" else
                '1' when opcode = x"E9" else
                '0' when opcode = x"85" else
                '0' when opcode = x"A9" else
                '0' when opcode = x"A5" else
                '0' when opcode = x"4C" else
                '0' when opcode = x"F0" else
                '0' when opcode = x"30" else
                '0' when opcode = x"B0" else
                '0';

    write_ad <= "00001" when opcode = x"65" else
                "00001" when opcode = x"69" else
                "00001" when opcode = x"E9" else
                "00001" when opcode = x"A9" else
                "00001" when opcode = x"A5" else
                oper(4 downto 0) when opcode = x"85" else
                "00000";

    reg_a_ad <= "00001" when opcode = x"65" else
                "00001" when opcode = x"69" else
                "00001" when opcode = x"E9" else
                "00001" when opcode = x"85" else
                "00001" when opcode = x"A9" else
                "00000" when opcode = x"A5" else
                "00000";

    reg_b_ad <= oper(4 downto 0) when opcode = x"65" else
                oper(4 downto 0) when opcode = x"69" else
                oper(4 downto 0) when opcode = x"E9" else
                oper(4 downto 0) when opcode = x"A9" else
                oper(4 downto 0) when opcode = x"A5" else
                "00000" when opcode = x"85" else
                "00000";

    alu_op <= "001" when opcode = x"E9" else
              "000" when opcode = x"65" else
              "000" when opcode = x"69" else
              "000" when opcode = x"85" else
              "000" when opcode = x"A9" else
              "000" when opcode = x"A5" else
              "000";
    
    pc_src <= "01" when opcode = x"4C" else
              "10" when opcode = x"F0" else
              "10" when opcode = x"30" else
              "10" when opcode = x"B0" else
              "00";


end a_control_unit;
