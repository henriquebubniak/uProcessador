library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank_tb is
end register_bank_tb;

architecture a_register_bank_tb of register_bank_tb is
    component register_bank is
        port (
            reg_a_ad : in unsigned(2 downto 0);
            reg_b_ad : in unsigned(2 downto 0);
            write_en : in std_logic;
            write_ad : in unsigned(2 downto 0);
            write_data : in unsigned(15 downto 0);
            rst : in std_logic;
            clk : in std_logic;
            reg_a : out unsigned(15 downto 0);
            reg_b : out unsigned(15 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal reg_a_ad : unsigned(2 downto 0) := "000";
    signal reg_b_ad : unsigned(2 downto 0) := "000";
    signal write_en : std_logic := '0';
    signal write_ad : unsigned(2 downto 0) := "000";
    signal write_data : unsigned(15 downto 0) := x"0000";
    signal reg_a : unsigned(15 downto 0) := x"0000";
    signal reg_b : unsigned(15 downto 0) := x"0000";
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
        register_bank_inst: register_bank port map(
            reg_a_ad => reg_a_ad,
            reg_b_ad => reg_b_ad,
            write_en => write_en,
            write_ad => write_ad,
            write_data => write_data,
            rst => rst,
            clk => clk,
            reg_a => reg_a,
            reg_b => reg_b
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
            write_en <= '1';
            write_ad <= "000";
            write_data <= x"ABCD";
            reg_a_ad <= "000";
            reg_b_ad <= "000";
            wait for period_time;
            assert reg_a = x"0000"
            report "rst = 0 & reg_a != 0";
            assert reg_b = x"0000"
            report "rst = 0 & reg_b != 0";
            
            write_en <= '0';
            write_ad <= "001";
            write_data <= x"ABCD";
            reg_a_ad <= "000";
            reg_b_ad <= "001";
            wait for period_time;
            assert reg_b = x"0000"
            report "write_en = 0 and reg was written";
            
            write_en <= '1';
            write_ad <= "000";
            write_data <= x"ABCD";
            reg_a_ad <= "000";
            reg_b_ad <= "000";
            wait for period_time;
            assert reg_a = x"0000"
            report "reg 0 was written";

            write_en <= '1';
            write_ad <= "001";
            write_data <= x"ABCD";
            reg_a_ad <= "000";
            reg_b_ad <= "001";
            wait for period_time;
            assert reg_a = x"0000"
            report "reg 0 was written";
            assert reg_b = x"ABCD"
            report "reg_b was not written";
        
            wait;            
       end process;
    
end architecture;

