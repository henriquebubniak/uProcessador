Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port(
        clk, rst: in std_logic;
        output: out unsigned(1 downto 0)
    );
end counter;

architecture behavioural of counter is
    signal state: unsigned(1 downto 0) := "00";
begin
    process(clk, rst)
    begin
        if rst = '1' then
            state <= "00";
        elsif rising_edge(clk) then
            state <= state + 1;
        end if;
    end process;

    output <= state;
end behavioural;
