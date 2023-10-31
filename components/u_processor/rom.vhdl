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
        0  => "000101" & x"69", --adc #5: A = 0005
        1  => "001010" & x"85", --sta 10: R3 = 0005
        2  => "000000" & x"A9", --lda #0: A = 0000
        3  => "001000" & x"69", --adc #8: A = 0008
        4  => "001011" & x"85", --sta 11: R4 = 0008
        5  => "000000" & x"A9", --lda #0: A = 0000
        6  => "001010" & x"65", --adc 10: A += R3
        7  => "001011" & x"65", --adc 11: A += R4
        8  => "001100" & x"85", --sta 12: R5 = A
        9  => "000001" & x"E9", --sbc 12: A -= 1
        10 => "001100" & x"85", --sta 12: R5 = A
        11 => "010100" & x"4C", --jmp 20 
        12 => "00000000000000", --nop
        13 => "00000000000000", --nop
        14 => "00000000000000", --nop
        15 => "00000000000000", --nop
        16 => "00000000000000", --nop
        17 => "00000000000000", --nop
        18 => "00000000000000", --nop
        19 => "00000000000000", --nop
        20 => "000000" & x"A9", --lda #0: A = 0000
        21 => "001100" & x"65", --adc 12: A = R5
        22 => "001010" & x"85", --sta 10: R3 = A
        23 => "000101" & x"4C", --jmp 5 
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