library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_tb is
end control_unit_tb;

architecture a_control_unit_tb of control_unit_tb is

    signal clk : std_logic := '0';
    sign
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
        control_unit_inst: entity work.control_unit(a_control_unit) port map(
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
            wait for 6 us;         
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