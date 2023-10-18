library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end rom_tb;

architecture a_rom_tb of rom_tb is
    signal clk : std_logic := '0';
    signal address : unsigned(6 downto 0) := (others => '0');
    signal dado : unsigned(13 downto 0) := (others => '0');
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';
begin
    rom: entity work.rom(a_rom)
        port map(
            clk => clk,
            address => address,
            dado => dado
        );
        
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
            address <= "0000000";
            wait for period_time;
            assert dado = "00000000000010"
            report "wrong data";

            address <= "0000001";
            wait for period_time;
            assert dado = "00100000000000"
            report "wrong data";
            
            address <= "0000010";
            wait for period_time;
            assert dado = "00000000000000"
            report "wrong data";

            address <= "0000011";
            wait for period_time;
            assert dado = "00000000000000"
            report "wrong data";

            address <= "0000100";
            wait for period_time;
            assert dado = "00100000000000"
            report "wrong data";

            address <= "0000101";
            wait for period_time;
            assert dado = "00000000000010"
            report "wrong data";

            wait;
       end process;

end architecture;