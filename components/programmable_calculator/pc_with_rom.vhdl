library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_with_rom is
    port (
        clk, rst, write_enable : in std_logic;
        rom_out : out unsigned(13 downto 0)
    );
end pc_with_rom;

architecture a_pc_with_rom of pc_with_rom is
    component rom is
        port (
            clk : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(13 downto 0)
        );
    end component;
    component program_counter is
        port (
            clk, rst : in std_logic;
            write_enable : in std_logic;
            data_in : in unsigned(6 downto 0);
            counter : out unsigned(6 downto 0)
        );
    end component;

    signal pc : unsigned(6 downto 0);
    signal pc_plus_one : unsigned(6 downto 0);
begin
    pc_inst : program_counter port map (
            clk => clk,
            rst => rst,
            write_enable => write_enable,
            data_in => pc_plus_one,
            counter => pc
    );
    rom_inst : rom port map (
            clk => clk,
            address => pc,
            data => rom_out
    );
    pc_plus_one <= pc + 1;
end a_pc_with_rom;