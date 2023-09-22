library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits_tb is
end reg16bits_tb;

architecture a_reg16bits_tb of reg16bits_tb is
    signal wr_en, rst, clk : std_logic;
    signal data_in, data_out : unsigned(15 downto 0);
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
begin
    reg16bit_inst: entity work.reg16bits(a_reg16bits)
        port map(
            data_in => data_in,
            wr_en => wr_en,
            rst => rst,
            clk => clk,
            data_out => data_out
        );
    
    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2; 
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
      wr_en <= '0';
      data_in <= x"ABCD";
      wait for 100 ns;
      assert data_out = x"0000"
      report "rst = 0 & data_out != 0";
      wr_en <= '1';
      data_in <= x"1234";
      wait for 100 ns;
      assert data_out = x"0000"
      report "rst = 0 & data_out != 0";
      wr_en <= '0';
      data_in <= x"ABCD";
      wait for 100 ns;
      assert data_out = x"0000"
      report "wr_en = 0 & data was written";
      data_in <= x"1234";
      wait for 100 ns;
      assert data_out = x"0000"
      report "wr_en = 0 & data was written";
      wr_en <= '1';
      data_in <= x"ABCD";
      wait for 100 ns;
      assert data_out = x"ABCD"
      report "wr_en = 1 & data was not written";
      data_in <= x"1234";
      wait for 100 ns;
      assert data_out = x"1234"
      report "wr_en = 1 & data was not written";

      wait;            
   end process;

end architecture;