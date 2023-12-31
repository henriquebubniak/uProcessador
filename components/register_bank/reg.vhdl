library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
    port (
        data_in : in unsigned(15 downto 0);
        wr_en : in std_logic;
        rst : in std_logic;
        clk : in std_logic;
        data_out : out unsigned(15 downto 0)
    );
end reg;

architecture a_reg of reg is
    signal reg : unsigned(15 downto 0);
begin
    process(clk, rst, wr_en)
    begin
        if rst = '1' then
            reg <= x"0000";
        elsif wr_en = '1' then
            if rising_edge(clk) then
                reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg;
    
end a_reg;