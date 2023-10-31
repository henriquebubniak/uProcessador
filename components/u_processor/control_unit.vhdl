library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic;
        instruction : in unsigned(13 downto 0);
        pc_clock, rom_clock, reg_bank_clock, jump, alu_src, write_en : out std_logic;
        alu_op : out unsigned(2 downto 0)
    );
end control_unit;

architecture a_control_unit of control_unit is
    signal state : unsigned(1 downto 0) := "00";
    signal opcode : unsigned(3 downto 0);
begin
    opcode <= instruction(3 downto 0);
    process(clk)
    begin
        if rising_edge(clk) then
            state <=  state + 1;
        end if;
    end process;

    pc_clock <= not state(1) and not state(0);
    rom_clock <= not state(1) and state(0);
    reg_bank_clock <= state(1) and state(0);

    alu_src <= '1' when (opcode = x"9" or
                         opcode = x"A" or
                         opcode = x"5" or
                         opcode = x"E") else
               '0';
    alu_op <= "000" when (opcode = x"9" or
                          opcode = x"6") else 
              "001" when (opcode = x"5") else
              "000";
    write_en <= '1' when (opcode = x"9" or
                          opcode = x"6" or
                          opcode = x"A" or
                          opcode = x"5" or
                          opcode = x"E") else
                '0';

    jump <= '1' when opcode = x"F" else 
            '0';
    
end a_control_unit;