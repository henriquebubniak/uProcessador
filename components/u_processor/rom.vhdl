library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( 
        clk     : in std_logic;
        address : in unsigned(6 downto 0);
        data    : out unsigned(13 downto 0) 
    );
end entity;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(13 downto 0);
    constant content : mem := (
        0  => "01101001001011", --adc #11 A = 000B
        1  => "01101001001011", --adc #11 A = 0016
        2  => "00000000000000", --nop
        3  => "01101001101000", --adc #40 A = 003E
        4  => "01101001000000", --adc #0 A = 001E
        5  => "00000000000010", --nop
        6  => "11110001000011", --nop
        7  => "01101001000010", --adc #2 A = 0020
        8  => "11110000110011", --nop
        9  => "00000000000000", --nop
        10 => "00000000000000", --nop
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