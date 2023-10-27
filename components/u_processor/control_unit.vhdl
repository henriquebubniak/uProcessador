library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic;
        instruction : in unsigned(15 downto 0);
        pc_clock, rom_clock, reg_bank_clock  : out std_logic;
        jump, write_en, alu_src : out std_logic;
        alu_op : out unsigned(2 downto 0)
    );
end control_unit;

architecture a_control_unit of control_unit is
    signal state : unsigned(1 downto 0) := others => '0';
    signal opcode : unsigned(3 downto 0);
begin
    opcode <= instruction(13 downto 6);
    jump <= '1' when opcode = x"FF" else '0';
    process(clk)
    begin
        if rising_edge(clk) then
            if state = "11" then
                state = "00";
            elsif
                state <= state + 1;
            end if;
        end if;
    end process;
    pc_clock <= not state(0) and not state(1);
    rom_clock <= state(0) and not state(1);
    reg_bank_clock <= state(0) and state(1);
    write_en <= '1' when opcode = x"75" 
                     or opcode = x"69" 
                     or opcode = x"F5"
                     or opcode = x"E9"
                     or opcode = x"AA"
                     else '0';
    
end a_control_unit;