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
            opcode : in unsigned(7 downto 0);
            flags: in unsigned(7 downto 0);
            oper: in unsigned(5 downto 0);
            jump, alu_src, write_en : out std_logic;
            flags_wr: out std_logic;
            pc_src: out unsigned(1 downto 0);
            write_ad, reg_a_ad, reg_b_ad : out unsigned(4 downto 0);
            alu_op : out unsigned(2 downto 0);
            flag_mask: out unsigned(7 downto 0);
            mem_wr, mem_to_reg: out std_logic
        );
    end component;
    
    component register_bank is
        port (
            reg_a_ad, reg_b_ad, write_ad : in unsigned(4 downto 0);
            write_en, rst, clk : in std_logic;
            write_data : in unsigned(7 downto 0);
            reg_a, reg_b : out unsigned(7 downto 0)
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
            op0, op1: in unsigned(7 downto 0);
            alu_op: in unsigned(2 downto 0);
            carry : in std_logic;
            result: out unsigned(7 downto 0);
            n, v, z, c:out std_logic
        );
    end component alu;

    component counter is
        port(
            clk, rst: in std_logic;
            output: out unsigned(1 downto 0)
        );
    end component counter;

    component ram is
        port(   
            address: in unsigned(5 downto 0);
            wr_data_in: in unsigned(7 downto 0);
            mem_wr, clk: in std_logic;
            r_data_out: out unsigned(7 downto 0)
        );
    end component ram;
    
    signal rom_out : unsigned(13 downto 0) := (others => '0');
    signal pc_clock, rom_clock, write_back, jump, alu_src, write_en, zero, ovf, gt, st, eq : std_logic := '0'; 
    signal pc_plus_one, jump_address, pc_address_mux, pc_out : unsigned(6 downto 0) := (others => '0');
    signal reg_a_out, reg_b_out, alu_src_mux, alu_out : unsigned(7 downto 0) := (others => '0');
    signal alu_op : unsigned(2 downto 0) := (others => '0');
    signal write_ad, reg_a_ad, reg_b_ad : unsigned(4 downto 0) := (others => '0');

    signal flags_wr: std_logic := '0';
    signal flags_in, flags_out: unsigned(7 downto 0) := x"00";

    signal n,v,z,c: std_logic := '0';

    signal signal_extender: unsigned(7 downto 0) := x"00";

    signal branch_address: unsigned(6 downto 0);
    signal pc_src: unsigned(1 downto 0) := b"00";

    signal counter_state: unsigned(1 downto 0) := "00";
    
    signal flag_mask: unsigned(7 downto 0) := x"00";
    signal flag_filter_out: unsigned(7 downto 0) := x"00";

    signal mem_to_reg, mem_wr: std_logic := '0';
    signal ram_data: unsigned(7 downto 0) := x"00";
    signal reg_wr_mux: unsigned(7 downto 0) := x"00";

begin
    pc_clock <= '1' when counter_state = "00" else '0';
    rom_clock <= '1' when counter_state = "01" else '0';
    write_back <= '1' when counter_state = "11" else '0';

    counter_inst: counter
        port map(
            clk => clk,
            rst => rst,
            output => counter_state
        );

    control_unit_inst : control_unit
        port map (
            opcode => rom_out(7 downto 0),
            flags => flags_out,
            oper => rom_out(13 downto 8),
            jump => jump,
            alu_src => alu_src,
            write_en => write_en,
            alu_op => alu_op,
            flags_wr => flags_wr,
            pc_src => pc_src,
            write_ad => write_ad,
            reg_a_ad => reg_a_ad,
            reg_b_ad => reg_b_ad,
            flag_mask => flag_mask,
            mem_wr => mem_wr,
            mem_to_reg => mem_to_reg
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
    flag_filter_out <= (flags_in and flag_mask) or (flags_out and not(flag_mask));
    flag_reg_inst: flag_reg
        port map(
            input => flag_filter_out,
            output => flags_out,
            clk => write_back,
            clear => rst,
            wr_en => flags_wr
        );
    
    reg_wr_mux <= ram_data when mem_to_reg = '1' else alu_out;
    register_bank_inst : register_bank
        port map (
            reg_a_ad => reg_a_ad,
            reg_b_ad => reg_b_ad,
            write_ad => write_ad,
            write_en => write_en,
            rst => rst,
            clk => write_back,
            write_data => reg_wr_mux,
            reg_a => reg_a_out,
            reg_b => reg_b_out
        );

    alu_inst : alu 
        port map (
            op0 => reg_a_out,
            op1 => alu_src_mux,
            alu_op => alu_op,
            carry => flags_out(4),
            result => alu_out,
            n => n,
            v => v,
            z => z,
            c => c
        );
    
    ram_inst: ram
        port map(
            address => alu_out(5 downto 0),
            wr_data_in => reg_b_out,
            mem_wr => mem_wr,
            clk => write_back,
            r_data_out => ram_data
        );

    jump_address <= "0"&rom_out(13 downto 8);
    pc_plus_one <= pc_out + 1;
    branch_address <= pc_out + signal_extender(6 downto 0);
                        
    pc_address_mux <= pc_plus_one when pc_src = b"00" else 
                      jump_address when (pc_src = b"01")  else
                      branch_address when (pc_src = b"10" and jump = '1')
                      else pc_plus_one;
    
    signal_extender <= b"11" & rom_out(13 downto 8) when rom_out(13) = '1'
                       else b"00" & rom_out(13 downto 8);

    alu_src_mux <= signal_extender when alu_src = '1' else reg_b_out;
    

end a_u_processor;
