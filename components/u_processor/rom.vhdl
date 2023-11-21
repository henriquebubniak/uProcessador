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
        b"00_0000" & x"A9", --LDA #0: A <= 0
        b"00_1010" & x"85", --STA $10: zpg[10] <= A
        b"00_0000" & x"18", --CLC
        b"00_1010" & x"A5", --LDA $10: A <= zpg[10]
        b"00_0001" & x"69", --ADC #1: A <= A + 1
        b"00_1010" & x"85", --STA $10: zpg[10] <= A
        b"00_0000" & x"9D", --STA abs,X: mem[*X + abs] <= A
        b"00_0010" & x"85", --STA X: X <= A
        b"01_1111" & x"E9", --SBC #63: A <= A - 31
        b"11_1001" & x"30", --BMI #-7
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
