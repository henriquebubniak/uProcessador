library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_with_reg_bank_tb is
end alu_with_reg_bank_tb;

architecture a_alu_with_reg_bank_tb of alu_with_reg_bank_tb is
    component alu_with_reg_bank is
        port (
            clk, rst, write_en, sel_const_reg_b : in std_logic;
            op : in std_logic_vector(2 downto 0);
            reg_a_ad, reg_b_ad, write_ad : in unsigned(2 downto 0);
            const: in unsigned(15 downto 0);
            reg_a, reg_b, alu_out : out unsigned(15 downto 0);
            zero, ovf, gt, st, eq: out std_logic
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal write_en : std_logic := '0';
    signal sel_const_reg_b : std_logic := '0';
    signal op : std_logic_vector(2 downto 0) := (others => '0');
    signal reg_a_ad : unsigned(2 downto 0) := (others => '0');
    signal reg_b_ad : unsigned(2 downto 0) := (others => '0');
    signal write_ad : unsigned(2 downto 0) := (others => '0');
    signal const : unsigned(15 downto 0) := (others => '0');
    signal reg_a : unsigned(15 downto 0) := (others => '0');
    signal reg_b : unsigned(15 downto 0) := (others => '0');
    signal alu_out : unsigned(15 downto 0) := (others => '0');
    signal zero : std_logic := '0';
    signal ovf : std_logic := '0';
    signal gt : std_logic := '0';
    signal st : std_logic := '0';
    signal eq : std_logic := '0';
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
        alu_with_reg_bank_inst: alu_with_reg_bank port map(
            clk => clk,
            rst => rst,
            write_en => write_en,
            sel_const_reg_b => sel_const_reg_b,
            op => op,
            reg_a_ad => reg_a_ad,
            reg_b_ad => reg_b_ad,
            write_ad => write_ad,
            const => const,
            reg_a => reg_a,
            reg_b => reg_b,
            alu_out => alu_out,
            zero => zero,
            ovf => ovf,
            gt => gt,
            st => st,
            eq => eq
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
            sel_const_reg_b <= '1';
            op <= "000";
            reg_a_ad <= "001";
            reg_b_ad <= "001";
            write_ad <= "001";
            wait for period_time;
            assert alu_out = x"0000"
            report "rst = 0 & reg_a + reg_b != 0";

            sel_const_reg_b <= '1';
            op <= "000";
            reg_a_ad <= "001";
            reg_b_ad <= "001";
            write_ad <= "001";
            const <= x"0002";
            assert alu_out = x"0002"
            report "reg_a (0) + 0002 != 0002";
            wait for period_time;
            assert reg_a = x"0002"
            report "reg(write_ad) != alu_out";
            
            sel_const_reg_b <= '0';
            op <= "000";
            reg_a_ad <= "001";
            reg_b_ad <= "001";
            write_ad <= "001";
            assert alu_out = x"0004"
            report "reg_a (0002) + reg_b(0002) != 0004";
            wait for period_time;
            assert reg_a = x"0004"
            report "reg(write_ad) != alu_out";

            sel_const_reg_b <= '1';
            op <= "001";
            reg_a_ad <= "001";
            reg_b_ad <= "001";
            write_ad <= "001";
            const <= x"0001";
            assert alu_out = x"0003"
            report "reg_a (0004) - 0001 != 0003";
            wait for period_time;
            assert reg_a = x"0003"
            report "reg(write_ad) != alu_out";
        
            sel_const_reg_b <= '0';
            op <= "000";
            reg_a_ad <= "001";
            reg_b_ad <= "001";
            write_ad <= "001";
            assert alu_out = x"0006"
            report "reg_a (0003) + reg_b(0003) != 0006";
            wait for period_time;
            assert reg_a = x"0006"
            report "reg(write_ad) != alu_out";

            wait;            
       end process;
    
end architecture;

