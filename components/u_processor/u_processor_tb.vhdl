library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity u_processor_tb is
end u_processor_tb;

architecture a_u_processor_tb of u_processor_tb is

    signal clk, rst : std_logic := '0';
    constant period_time : time := 10 ns;
    signal finished : std_logic := '0';

    begin
        u_processor_inst: entity work.u_processor(a_u_processor) port map(
            clk => clk,
            rst => rst
        );

        reset_global: process
        begin
            rst <= '1';
            wait for period_time; 
            rst <= '0';
            wait;
        end process;

        sim_time_proc: process
        begin
            wait for 30 us;         
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
