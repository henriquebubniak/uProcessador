library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank is
    port (
        readReg1 : in unsigned(2 downto 0);
        readReg2 : in unsigned(2 downto 0);
        writeEn : in std_logic;
        writeReg : in unsigned(2 downto 0);
        writeData : in unsigned(15 downto 0);
        rst : in std_logic;
        clk : in std_logic;
        reg1 : out unsigned(15 downto 0);
        reg2 : out unsigned(15 downto 0)
    );
end register_bank;


architecture a_register_bank of register_bank is

    type regArray is array (7 downto 0) of unsigned(15 downto 0);
    signal regFile : regArray;

begin
    process (clk, rst)
    begin
        if rst = '1' then
            regFile <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if writeEn = '1' then
                regFile(to_integer(unsigned(writeReg))) <= writeData;
            end if;
        end if;
    end process;
    regFile(0) <= x"0000";
    reg1 <= regFile(to_integer(unsigned(readReg1)));
    reg2 <= regFile(to_integer(unsigned(readReg2)));
    
end a_register_bank; 