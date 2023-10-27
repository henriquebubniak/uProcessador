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

    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant content : mem := (
        0  => "0000000000001000", --0002
        1  => "0010000000000000", --0800
        2  => "0000000000000000", --0000
        3  => "1111000010100000", --0000
        4  => "1101000000000000", --3C00
        5  => "0000000000001000", --0002
        6  => "1111000100001100", --0F03
        7  => "0000000000001000", --0002
        8  => "1111000011001100", --0002
        9  => "0000000000000000", --0000
        10 => "0000000000000000", --0000
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