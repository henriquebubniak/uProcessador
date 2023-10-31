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
        0  => "0000000101" & x"9", --adc #5: A = 0005
        1  => "0000001010" & x"5", --sta 10: R3 = 0005
        2  => "0000000000" & x"A", --lda #0: A = 0000
        3  => "0000001000" & x"9", --adc #8: A = 0008
        4  => "0000001011" & x"5", --sta 11: R4 = 0008
        5  => "0000000000" & x"A", --lda #0: A = 0000
        6  => "0000001010" & x"6", --adc 10: A += R3
        7  => "0000001011" & x"6", --adc 11: A += R4
        8  => "0000001100" & x"5", --sta 12: R5 = A
        9  => "0000000001" & x"E", --sbc 12: R5 -= 1
        10  => "0000010100" & x"F", --jmp 20 
        11 => "00000000000000", --nop
        12 => "00000000000000", --nop
        13 => "00000000000000", --nop
        14 => "00000000000000", --nop
        15 => "00000000000000", --nop
        16 => "00000000000000", --nop
        17 => "00000000000000", --nop
        18 => "00000000000000", --nop
        19 => "00000000000000", --nop
        20 => "0000000000" & x"A", --lda #0: A = 0000
        21 => "0000001100" & x"6", --adc 12: A = R5
        22 => "0000001010" & x"5", --sta 10: R3 = A
        23 => "0000000101" & x"F", --jmp 5 
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