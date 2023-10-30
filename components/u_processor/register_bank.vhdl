library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank is
    port (
        reg_a_ad, reg_b_ad, write_ad : in unsigned(2 downto 0);
        write_en, rst, clk : in std_logic;
        write_data : in unsigned(15 downto 0);
        reg_a, reg_b : out unsigned(15 downto 0)
    );
end register_bank;


architecture a_register_bank of register_bank is

    type reg_array is array (7 downto 0) of unsigned(15 downto 0);
    signal reg_file : reg_array;

begin
    process (clk, rst)
    begin
        if rst = '1' then
            reg_file <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if write_en = '1' then
                reg_file(to_integer(unsigned(write_ad))) <= write_data;
            end if;
        end if;
    end process;
    reg_file(0) <= x"0000";
    reg_a <= reg_file(to_integer(unsigned(reg_a_ad)));
    reg_b <= reg_file(to_integer(unsigned(reg_b_ad)));
    
end a_register_bank; 