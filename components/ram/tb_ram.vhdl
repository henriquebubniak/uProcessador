Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ram is
end tb_ram;

architecture test_bench of tb_ram is
    signal mem_wr, clk: std_logic := '0';
    signal address: unsigned(5 downto 0) := b"000000";
    signal wr_data_in: unsigned(7 downto 0) := x"01";
    signal r_data_out: unsigned(7 downto 0) := x"00";

    component ram is
        port(
            address: in unsigned(5 downto 0);
            wr_data_in: in unsigned(7 downto 0);
            mem_wr, clk: in std_logic;
            r_data_out: out unsigned(7 downto 0)
        );
    end component;
begin
    
    ram_inst: ram
        port map(
            address => address,
            wr_data_in => wr_data_in,
            mem_wr => mem_wr,
            clk => clk,
            r_data_out => r_data_out
        );
    
    -- clk
    process
    begin
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
    end process;
    
    process
    begin
        -- write all positions
        mem_wr <= '1';
        for i in 0 to 63 loop
            wait for 10 ns;
            address <= address + 1;
            wr_data_in <= wr_data_in + 1;
        end loop;
        
        -- tries to write all positions with mem_wr = '0'
        mem_wr <= '0';
        address <= b"000000";
        for i in 0 to 63 loop
            wait for 10 ns;
            address <= address + 1;
            wr_data_in <= wr_data_in + 1;
        end loop;
    end process;


end test_bench;
