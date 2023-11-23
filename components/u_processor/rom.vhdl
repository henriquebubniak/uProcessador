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
        0  => b"00_0010" & x"A9", -- lda #2
        1  => b"00_0010" & x"85", -- sta 2 (zpg)
        2  => b"00_0000" & x"18", -- clc
        3  => b"00_1010" & x"9D", -- sta 10,X (ram)
        4  => b"00_0001" & x"69", -- adc #1
        5  => b"00_0010" & x"E6", -- inc 2
        6  => b"01_1111" & x"C9", -- cmp #31
        7  => b"11_1011" & x"D0", -- bne -5
        8  => b"00_0010" & x"A9", -- lda #2
        9  => b"00_0010" & x"85", -- sta 2 (zpg)
        10 => b"00_1010" & x"BD", -- lda 10,X (ram)
        11 => b"00_0000" & x"C9", -- cmp #0
        12 => b"00_1100" & x"F0", -- beq 12
        13 => b"00_1000" & x"85", -- sta 8 (zpg)
        14 => b"00_0000" & x"18", -- clc
        15 => b"00_1000" & x"65", -- adc 8
        16 => b"00_0000" & x"A8", -- tay
        17 => b"00_1000" & x"A5", -- lda 8 (zpg)
        18 => b"01_1111" & x"C0", -- cpy #31
        19 => b"00_0101" & x"10", -- bpl 5
        20 => b"00_0000" & x"A9", -- lda #0 2 (zpg)
        21  => b"00_0000" & x"18", -- clc
        22 => b"00_1010" & x"99", -- sta 10,y (ram)
        23 => b"00_0000" & x"98", -- tya 
        24 => b"00_1110" & x"4C", -- jmp 14
        25 => b"00_0010" & x"E6", -- inc 2
        26 => b"01_1111" & x"E0", -- cpx #31
        27 => b"11_0000" & x"D0", -- bne -16
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
