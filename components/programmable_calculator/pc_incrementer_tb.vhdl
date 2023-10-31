library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_incrementer_tb is
end pc_incrementer_tb;

architecture a_pc_incrementer_tb of pc_incrementer_tb is

    signal clk, rst, write_enable : std_logic := '0';
    signal inc, counter : unsigned(6 downto 0) := (others => '0');
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
        pc_incrementer_inst: entity work.program_counter(a_program_counter) port map(
            clk => clk,
            rst => rst,
            write_enable => '1',
            data_in => inc,
            counter => counter
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
            wait for 1 us;         
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

        write_enable <= '1';
        inc <= counter + 1;
    
end architecture;