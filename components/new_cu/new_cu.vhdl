library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity new_cu is
    port (
        --clk : in std_logic;
        opcode : in unsigned(7 downto 0);
        flags: in unsigned(7 downto 0);
        oper: in unsigned(5 downto 0);
        --pc_clock, rom_clock, reg_bank_clock: out std_logic;
        jump, alu_src, write_en, flags_wr: out std_logic;
        pc_src: out unsigned(1 downto 0);
        write_ad, reg_a_ad, reg_b_ad : out unsigned(4 downto 0);
        alu_op : out unsigned(2 downto 0)
    );
end new_cu;

architecture a_control_unit of new_cu is
begin
    
    jump <= '1' when opcode = x"4C" else -- Jump
            flags(5) when opcode = x"F0" else -- BEQ
            flags(7) when opcode = x"30" else -- BMI
            flags(4) when opcode = x"B0" else -- BCS
            '0';

               -- ADC imm, SBC imm, LDA imm
    alu_src <= '1' when opcode = x"69" else
               '1' when opcode = x"E9" else
               '1' when opcode = x"A9" else
               '0';

    write_en <= '1' when opcode = x"65" else -- ADC zpg
                '1' when opcode = x"85" else -- STA zpg
                '1' when opcode = x"A5" else -- LDA zpg
                '1' when opcode = x"69" else -- ADC imm
                '1' when opcode = x"E9" else -- SBC imm
                '1' when opcode = x"A9" else -- LDA imm
                '0';
    
    flags_wr <= '1' when opcode = x"65" else -- ADC zpg
                '1' when opcode = x"69" else -- ADC imm
                '1' when opcode = x"E9" else -- SBC imm
                '0';

    write_ad <= "00001" when opcode = x"65" else -- ADC zpg
                "00001" when opcode = x"69" else -- ADC imm
                "00001" when opcode = x"E9" else -- SBC imm
                "00001" when opcode = x"A9" else -- LDA imm
                "00001" when opcode = x"A5" else -- LDA zpg
                oper(4 downto 0) when opcode = x"85" else -- STA zpg
                "00000";

    reg_a_ad <= "00001" when opcode = x"65" else -- ADC zpg
                "00001" when opcode = x"69" else -- ADC imm
                "00001" when opcode = x"E9" else -- SBC imm
                "00001" when opcode = x"85" else -- STA zpg
                "00000";

    reg_b_ad <= oper(4 downto 0) when opcode = x"65" else -- ADC zpg
                oper(4 downto 0) when opcode = x"69" else -- ADC imm
                oper(4 downto 0) when opcode = x"E9" else -- SBC imm
                oper(4 downto 0) when opcode = x"A9" else -- LDA imm
                oper(4 downto 0) when opcode = x"A5" else -- LDA zpg
                "00000";

    alu_op <= "001" when opcode = x"E9" else -- SBC imm
              "000";
    
    pc_src <= "01" when opcode = x"4C" else -- JMP
              "10" when opcode = x"F0" else -- BEQ
              "10" when opcode = x"30" else -- BMI
              "10" when opcode = x"B0" else -- BCS
              "00";


end a_control_unit;
