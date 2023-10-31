library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( 
        clk      : in std_logic;
        address : in unsigned(6 downto 0);
        data     : out unsigned(13 downto 0) 
    );
end entity;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(13 downto 0);
    constant content : mem := (
        0  => "00000000000010", --0002
        1  => "00100000000000", --0800
        2  => "00000000000000", --0000
        3  => "11110000101000", --0000
        4  => "11010000000000", --3C00
        5  => "00000000000010", --0002
        6  => "11110001000011", --0F03
        7  => "00000000000010", --0002
        8  => "11110000110011", --0002
        9  => "00000000000000", --0000
        10 => "00000000000000", --0000
        -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
    );
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            data <= content(to_integer(address));
        end if;
    end process;
end architecture;