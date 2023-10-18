library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine_tb is
end state_machine_tb;

architecture a_state_machine_tb of state_machine_tb is
    component state_machine
        port (
            clk : in std_logic;
            rst : in std_logic;
            state : out unsigned(0 downto 0)
        );
    end component;
    signal clk, rst : std_logic;
    signal state : unsigned(0 downto 0) := (others => '0');
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
begin
    state_machine_inst : state_machine port map (
        clk => clk,
        rst => rst,
        state => state
    );
        sim_time_proc: process
        begin
            wait for 1 us;         
            finished <= '1';
            wait;
        end process sim_time_proc;

        reset_global: process
        begin
            rst <= '1';
            wait for period_time; 
            rst <= '0';
            wait;
        end process;

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