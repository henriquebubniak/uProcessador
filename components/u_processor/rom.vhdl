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
        0 => "000000" & x"A9", --lda #0: A = 0
        1 => "001010" & x"85", --sta 10: R3 = 0
        2 => "001011" & x"85", --sta 11: R4 = 0
        3 => "001010" & x"65", --adc 10: A = A + R4
        4 => "001011" & x"65", --adc 11: A = A + R3
        5 => "001011" & x"85", --sta 11: R4 = A
        6 => "000000" & x"A9", --lda #0: A = 0
        7 => "000001" & x"69", --adc #1: A = A + 1
        8 => "001010" & x"85", --sta 10 R3 = A (A == 1)
        9 => "011110" & x"E9", --sbc #30: A = A - 30 (1 - 30 == -29)
        10 => "111001" & x"30", --bmi #-7 (relative)
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
