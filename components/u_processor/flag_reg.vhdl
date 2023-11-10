Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flag_reg is
    port(
        input: in unsigned(7 downto 0);
        output: out unsigned(7 downto 0);
        clk, clear, wr_en: in std_logic
    );
end flag_reg;

architecture behavioural of flag_Reg is
    signal flags: unsigned(7 downto 0) := x"00";

begin
    process(clk, clear)
    begin
        if clear = '1' then
            flags <= x"00";
        elsif rising_edge(clk) then
            if wr_en = '1'then
                flags <= input;
            end if;
        end if;
    end process;
    output <= flags;
end behavioural;
