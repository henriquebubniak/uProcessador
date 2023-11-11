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

    
    --component control_unit is
    component new_cu is
        port (
            --clk : in std_logic;
            opcode : in unsigned(7 downto 0);
            flags: in unsigned(7 downto 0);
            oper: in unsigned(5 downto 0);
            --pc_clock, rom_clock, reg_bank_clock: out std_logic;
            jump, alu_src, write_en : out std_logic;
            flags_wr: out std_logic;
            pc_src: out unsigned(1 downto 0);
            write_ad, reg_a_ad, reg_b_ad : out unsigned(4 downto 0);
            alu_op : out unsigned(2 downto 0)
        );
    end component;
    
    component register_bank is
        port (
            reg_a_ad, reg_b_ad, write_ad : in unsigned(4 downto 0);
            write_en, rst, clk : in std_logic;
            write_data : in unsigned(15 downto 0);
            reg_a, reg_b : out unsigned(15 downto 0)
        );
    end component register_bank;

    component flag_reg is
        port (
            input: in unsigned(7 downto 0);
            output: out unsigned(7 downto 0);
            clk, clear, wr_en: in std_logic
        );
    end component flag_reg;

    component alu is
        port (
            op0, op1: in unsigned(15 downto 0);
            alu_op: in unsigned(2 downto 0);
            result: out unsigned(15 downto 0);
            n, v, z, c:out std_logic
        );
    end component alu;

    component counter is
        port(
            clk, rst: in std_logic;
            output: out unsigned(1 downto 0)
        );
    end component counter;
    
    signal rom_out : unsigned(13 downto 0) := (others => '0');
    signal pc_clock, rom_clock, reg_bank_clock, jump, alu_src, write_en, zero, ovf, gt, st, eq : std_logic := '0'; 
    signal pc_plus_one, jump_address, pc_address_mux, pc_out : unsigned(6 downto 0) := (others => '0');
    signal reg_a_out, reg_b_out, alu_src_mux, alu_out : unsigned(15 downto 0) := (others => '0');
    signal alu_op : unsigned(2 downto 0) := (others => '0');
    signal write_ad, reg_a_ad, reg_b_ad : unsigned(4 downto 0) := (others => '0');

    signal flags_wr: std_logic := '0';
    signal flags_in, flags_out: unsigned(7 downto 0) := x"00";

    signal n,v,z,c: std_logic := '0';

    signal signal_extender: unsigned(15 downto 0) := x"0000";

    signal branch_address: unsigned(6 downto 0);
    signal pc_src: unsigned(1 downto 0) := b"00";

    signal counter_state: unsigned(1 downto 0) := "00";

begin
    pc_clock <= '1' when counter_state = "00" else '0';
    rom_clock <= '1' when counter_state = "01" else '0';
    reg_bank_clock <= '1' when counter_state = "11" else '0';
    counter_inst: counter
        port map(
            clk => clk,
            rst => rst,
            output => counter_state
        );

    control_unit_inst : new_cu
        port map (
            --clk => clk,
            opcode => rom_out(7 downto 0),
            flags => flags_out,
            oper => rom_out(13 downto 8),
            --pc_clock => pc_clock,
            --rom_clock => rom_clock,
            --reg_bank_clock => reg_bank_clock,
            jump => jump,
            alu_src => alu_src,
            write_en => write_en,
            alu_op => alu_op,
            flags_wr => flags_wr,
            pc_src => pc_src,
            write_ad => write_ad,
            reg_a_ad => reg_a_ad,
            reg_b_ad => reg_b_ad
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
   
    flags_in <= (n & v & z & c & "0000");
    flag_reg_inst: flag_reg
        port map(
            input => flags_in,
            output => flags_out,
            clk => reg_bank_clock,
            clear => rst,
            wr_en => flags_wr
        );

    register_bank_inst : register_bank
        port map (
            reg_a_ad => reg_a_ad,
            reg_b_ad => reg_b_ad,
            write_ad => write_ad,
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
            n => n,
            v => v,
            z => z,
            c => c
        );
    jump_address <= "0"&rom_out(13 downto 8);
    pc_plus_one <= pc_out + 1;
    branch_address <= pc_out + signal_extender(6 downto 0);
                        
    pc_address_mux <= pc_plus_one when pc_src = b"00" else 
                      jump_address when (pc_src = b"01")  else
                      branch_address when (pc_src = b"10" and jump = '1')
                      else pc_plus_one;
    
    signal_extender <= b"11_1111_1111" & rom_out(13 downto 8) when rom_out(13) = '1'
                       else b"00_0000_0000" & rom_out(13 downto 8);

    alu_src_mux <= signal_extender when alu_src = '1' else reg_b_out;

end a_u_processor;
