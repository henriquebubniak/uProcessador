Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port(
        address: in unsigned(5 downto 0);
        wr_data_in: in unsigned(7 downto 0);
        mem_wr, clk: in std_logic;
        r_data_out: out unsigned(7 downto 0)
    );
end ram;

architecture behavioural of ram is
    type mem is array(63 downto 0) of unsigned(7 downto 0);
    signal mem_inst: mem := (others => x"00");
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_wr = '1' then
                mem_inst(to_integer(address)) <= wr_data_in;
            end if;
        end if;
    end process;
    r_data_out <= mem_inst(to_integer(address));
end behavioural;
