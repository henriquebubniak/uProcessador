library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic;
        instruction : in unsigned(13 downto 0);
        pc_clock, rom_clock : out std_logic;
        jump : out std_logic
    );
end control_unit;

architecture a_control_unit of control_unit is
    signal state : unsigned(0 downto 0) := "0";
    signal opcode : unsigned(3 downto 0);
begin
    opcode <= instruction(13 downto 10);
    jump <= '1' when opcode = "1111" else '0';
    process(clk)
    begin
        if rising_edge(clk) then
            state <= not state;
        end if;
    end process;
    pc_clock <= not state(0);
    rom_clock <= state(0);
    
end a_control_unit;