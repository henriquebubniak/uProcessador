library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is
    port (
        clk : in std_logic;
        rst : in std_logic;
        state : out unsigned(0 downto 0)
    );
end state_machine;

architecture a_state_machine of state_machine is
    signal state_reg: unsigned(0 downto 0) := "0";

begin
    process(clk, rst)
    begin
        if rst = '1' then
            state_reg <= "0";
        elsif rising_edge(clk) then
            state_reg <= not state_reg;
        end if;
    end process;

    state <= state_reg;
    
end a_state_machine;