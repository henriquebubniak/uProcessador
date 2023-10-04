library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank_tb is
end register_bank_tb;

architecture a_register_bank_tb of register_bank_tb is
    component register_bank is
        port (
            readReg1 : in unsigned(2 downto 0);
            readReg2 : in unsigned(2 downto 0);
            writeEn : in std_logic;
            writeReg : in unsigned(2 downto 0);
            writeData : in unsigned(15 downto 0);
            rst : in std_logic;
            clk : in std_logic;
            reg1 : out unsigned(15 downto 0);
            reg2 : out unsigned(15 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal readReg1 : unsigned(2 downto 0) := "000";
    signal readReg2 : unsigned(2 downto 0) := "000";
    signal writeEn : std_logic := '0';
    signal writeReg : unsigned(2 downto 0) := "000";
    signal writeData : unsigned(15 downto 0) := x"0000";
    signal reg1 : unsigned(15 downto 0) := x"0000";
    signal reg2 : unsigned(15 downto 0) := x"0000";
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
        register_bank_inst: register_bank port map(
            readReg1 => readReg1,
            readReg2 => readReg2,
            writeEn => writeEn,
            writeReg => writeReg,
            writeData => writeData,
            rst => rst,
            clk => clk,
            reg1 => reg1,
            reg2 => reg2
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
            writeEn <= '1';
            writeReg <= "000";
            writeData <= x"ABCD";
            readReg1 <= "000";
            readReg2 <= "000";
            wait for period_time;
            assert reg1 = x"0000"
            report "rst = 0 & reg1 != 0";
            assert reg2 = x"0000"
            report "rst = 0 & reg2 != 0";
            
            writeEn <= '0';
            writeReg <= "001";
            writeData <= x"ABCD";
            readReg1 <= "000";
            readReg2 <= "001";
            wait for period_time;
            assert reg2 = x"0000"
            report "writeEn = 0 and reg was written";
            
            writeEn <= '1';
            writeReg <= "000";
            writeData <= x"ABCD";
            readReg1 <= "000";
            readReg2 <= "000";
            wait for period_time;
            assert reg1 = x"0000"
            report "reg 0 was written";

            writeEn <= '1';
            writeReg <= "001";
            writeData <= x"ABCD";
            readReg1 <= "000";
            readReg2 <= "001";
            wait for period_time;
            assert reg1 = x"0000"
            report "reg 0 was written";
            assert reg2 = x"ABCD"
            report "reg2 was not written";
        
            wait;            
       end process;
    
end architecture;

