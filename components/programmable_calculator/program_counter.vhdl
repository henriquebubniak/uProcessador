library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
    port (
        clk, rst, write_enable : in std_logic;
        data_in : in unsigned(6 downto 0);
        counter : out unsigned(6 downto 0)
    );
end program_counter;

architecture a_program_counter of program_counter is
    signal counter_s : unsigned(6 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            counter_s <= (others => '0');
        elsif rising_edge(clk) then
            if write_enable = '1' then
                counter_s <= data_in;
            end if;
        end if;
    end process;

    counter <= counter_s;
    
end a_program_counter;