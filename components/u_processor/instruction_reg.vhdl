Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_reg is
    port(
        clk, rst: in std_logic;
        data_in: in unsigned(13 downto 0);
        data_out: out unsigned(13 downto 0)
    );
end instruction_reg;

architecture behavioural of instruction_reg is
    signal data: unsigned(13 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            data <= (others => '0');
        elsif rising_edge(clk) then
            data <= data_in;
        end if;
    end process;
    data_out <= data;
end behavioural;
