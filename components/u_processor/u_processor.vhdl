library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity u_processor is
    port (
        clk, rst : in std_logic
    );
end u_processor;

architecture a_u_processor of u_processor is
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
            pc_clock, rom_clock, reg_bank_clock, jump, alu_src, write_en : out std_logic;
            alu_op : out unsigned(2 downto 0)
        );
    end component;
    
    component register_bank is
        port (
            reg_a_ad, reg_b_ad, write_ad : in unsigned(2 downto 0);
            write_en, rst, clk : in std_logic;
            write_data : in unsigned(15 downto 0);
            reg_a, reg_b : out unsigned(15 downto 0)
        );
    end component register_bank;

    component alu is
        port (
            op0, op1: in unsigned(15 downto 0);
            alu_op: in unsigned(2 downto 0);
            result: out unsigned(15 downto 0);
            zero, ovf, gt, st, eq: out std_logic
        );
    end component alu;
    
    signal rom_out : unsigned(13 downto 0) := (others => '0');
    signal pc_clock, rom_clock, reg_bank_clock, jump, alu_src, write_en, zero, ovf, gt, st, eq : std_logic := '0'; 
    signal pc_plus_one, jump_address, pc_address_mux, pc_out : unsigned(6 downto 0) := (others => '0');
    signal reg_a_out, reg_b_out, alu_src_mux, alu_out : unsigned(15 downto 0) := (others => '0');
    signal alu_op : unsigned(2 downto 0) := (others => '0');

begin
    control_unit_inst : control_unit
        port map (
            clk => clk,
            instruction => rom_out,
            pc_clock => pc_clock,
            rom_clock => rom_clock,
            reg_bank_clock => reg_bank_clock,
            jump => jump,
            alu_src => alu_src,
            write_en => write_en,
            alu_op => alu_op
        );

    rom_inst : rom
        port map (
            clk => rom_clock,
            address => pc_out,
            data => rom_out
        );

    program_counter_inst : program_counter
        port map (
            clk => pc_clock,
            rst => rst,
            write_enable => '1',
            data_in => pc_address_mux,
            counter => pc_out
        );

    register_bank_inst : register_bank
        port map (
            reg_a_ad => "001",
            reg_b_ad => rom_out(2 downto 0),
            write_ad => "001",
            write_en => write_en,
            rst => rst,
            clk => reg_bank_clock,
            write_data => alu_out,
            reg_a => reg_a_out,
            reg_b => reg_b_out
        );

    alu_inst : alu 
        port map (
            op0 => reg_a_out,
            op1 => alu_src_mux,
            alu_op => alu_op,
            result => alu_out,
            zero => zero,
            ovf => ovf,
            gt => gt,
            st => st,
            eq => eq
        );
    jump_address <= rom_out(6 downto 0);
    pc_plus_one <= pc_out + 1;
    pc_address_mux <= jump_address when jump = '1' else pc_plus_one;
    alu_src_mux <= "0000000000" & rom_out(5 downto 0) when alu_src = '1' else reg_b_out;

end a_u_processor;