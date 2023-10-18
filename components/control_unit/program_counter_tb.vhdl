library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter_tb is
end program_counter_tb;

architecture a_program_counter_tb of program_counter_tb is

    signal clk, rst, write_enable : std_logic := '0';
    signal data_in, counter : unsigned(6 downto 0) := (others => '0');
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
        program_counter_inst: entity work.program_counter(a_program_counter) port map(
            clk => clk,
            rst => rst,
            write_enable => write_enable,
            data_in => data_in,
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

        process                     
        begin
            assert counter = "0000000"
            report "counter rst failed";
            write_enable <= '1';
            data_in <= "0000000";
            wait for period_time;
            assert counter = "0000000"
            report "counter failed";

            data_in <= "0001001";
            wait for period_time;
            assert counter = "0000001"
            report "counter failed";

            data_in <= "0000010";
            wait for period_time;
            assert counter = "0000010"
            report "counter failed";

            data_in <= "0000011";
            wait for period_time;
            assert counter = "0000011"
            report "counter failed";

            data_in <= "0000100";
            wait for period_time;
            assert counter = "0000100"
            report "counter failed";

            data_in <= "0000101";
            wait for period_time;
            assert counter = "0000101"
            report "counter failed";

            data_in <= "0000110";
            wait for period_time;
            assert counter = "0000110"
            report "counter failed";

            data_in <= "0000111";
            wait for period_time;
            assert counter = "0000111"
            report "counter failed";

            wait;            
       end process;
    
end architecture;