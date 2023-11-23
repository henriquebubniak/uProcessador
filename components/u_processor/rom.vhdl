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
        0  => b"01_1111" & x"A9", -- lda #31
        1  => b"00_0101" & x"85", -- sta 5 (zpg)
        2  => b"00_0101" & x"65", -- adc 5
        3  => b"00_0101" & x"85", -- sta 5 (zpg)
        4  => b"00_0010" & x"A9", -- lda #2
        5  => b"00_0010" & x"85", -- sta 2 (zpg)
        6  => b"00_0000" & x"18", -- clc
        7  => b"00_0000" & x"9D", -- sta 0,X (ram)
        8  => b"00_0001" & x"69", -- adc #1
        9  => b"00_0010" & x"E6", -- inc 2
        10 => b"00_0101" & x"C5", -- cmp 5 (zpg)
        11 => b"11_1011" & x"30", -- bmi -5
        12 => b"00_0010" & x"A9", -- lda #2
        13 => b"00_0010" & x"85", -- sta 2 (zpg)
        14 => b"00_0000" & x"18", -- clc
        15 => b"00_0000" & x"BD", -- lda 0,X (ram)
        16 => b"00_0000" & x"C9", -- cmp #0
        17 => b"00_1101" & x"F0", -- beq 13
        18 => b"00_1000" & x"85", -- sta 8 (zpg)
        19 => b"00_0000" & x"18", -- clc
        20 => b"00_1000" & x"65", -- adc 8
        21 => b"00_0000" & x"A8", -- tay
        22 => b"00_1000" & x"A5", -- lda 8 (zpg)
        23 => b"00_0101" & x"C4", -- cpy 5 (zpg)
        24 => b"00_0110" & x"10", -- bpl 6
        25 => b"00_0000" & x"A9", -- lda #0 2 (zpg)
        26 => b"00_0000" & x"18", -- clc
        27 => b"00_0000" & x"99", -- sta 0,y (ram)
        28 => b"00_0000" & x"98", -- tya 
        29 => b"01_0011" & x"4C", -- jmp 19
        30 => b"00_0010" & x"E6", -- inc 2
        31 => b"00_0101" & x"E4", -- cpx 5 (zpg)
        32 => b"10_1110" & x"D0", -- bne -18
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
