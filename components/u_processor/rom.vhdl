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
        3 => "000000" & x"A9", --lda #0: A = 0
        4 => "000000" & x"18", --CLC: C <= 0
        5 => "001010" & x"65", --adc 10: A = A + R3
        6 => "001011" & x"65", --adc 11: A = A + R4
        7 => "000000" & x"18", --CLC: C <= 0
        8 => "001011" & x"85", --sta 11: R4 = A
        9 => "000000" & x"A9", --lda #0: A = 0
        10 => "001010" & x"65", --adc 10: A = R3
        11 => "000001" & x"69", --adc #1: A = A + 1
        12 => "001010" & x"85", --sta 10 R3 = A (A == R3 + 1)
        13 => "011101" & x"E9", --sbc #29: A = A - 29
        14 => "110101" & x"30", --bmi #-11 (relative)
        15 => "000000" & x"18", --CLC: C <= 0
        16 => "000000" & x"A9", --lda #0: A = 0
        17 => "001011" & x"65", --adc 11: A = A + R4
        18 => "001100" & x"85", --sta 12: R5 = A
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
