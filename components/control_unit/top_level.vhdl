library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
        clk : in std_logic;
        rom_out : out unsigned(13 downto 0)
    );
end top_level;

architecture a_top_level of top_level is
    component rom is
        port (
            clk : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(13 downto 0)
        );
    end component;

    component program_counter is
        port (
            clk, rst, write_enable : in std_logic;
            data_in : in unsigned(6 downto 0);
            counter : out unsigned(6 downto 0)
        );
    end component;

    component control_unit is
        port (
            clk : in std_logic;
            instruction : in unsigned(13 downto 0);
            pc_clock, rom_clock, jump : out std_logic
        );
    end component;

    signal pc_out : unsigned(6 downto 0) := (others => '0');
    signal rom_out_s : unsigned(13 downto 0) := (others => '0');
    signal pc_clock, rom_clock, jump : std_logic := '0'; 
    signal pc_plus_one, jump_address, pc_address_mux : unsigned(6 downto 0) := (others => '0');

begin
    control_unit_inst : control_unit
        port map (
            clk => clk,
            instruction => rom_out_s,
            pc_clock => pc_clock,
            rom_clock => rom_clock,
            jump => jump
        );
    rom_inst : rom
        port map (
            clk => rom_clock,
            address => pc_out,
            data => rom_out_s
        );
    program_counter_inst : program_counter
        port map (
            clk => pc_clock,
            rst => '0',
            write_enable => '1',
            data_in => pc_address_mux,
            counter => pc_out
        );
    jump_address <= rom_out_s(9 downto 3);
    pc_plus_one <= pc_out + 1;
    pc_address_mux <= jump_address when jump = '1' else pc_plus_one;
    rom_out <= rom_out_s;

end a_top_level;