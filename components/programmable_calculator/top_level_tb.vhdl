library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end top_level_tb;

architecture a_top_level_tb of top_level_tb is

    signal clk : std_logic := '0';
    signal rom_out : unsigned(13 downto 0) := (others => '0');
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
        top_level_inst: entity work.top_level(a_top_level) port map(
            clk => clk,
            rom_out => rom_out
        );
        
        sim_time_proc: process
        begin
            wait for 2 us;         
            finished <= '1';
            wait;
        end process sim_time_proc;

        clk_proc: process
        begin                       
            while finished /= '1' loop
                clk <= '0';
                wait for period_time/2;
                clk <= '1';
                wait for period_time/2;
            end loop;
            wait;
        end process clk_proc;
    
end architecture;