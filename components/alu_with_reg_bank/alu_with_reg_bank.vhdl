library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_with_reg_bank is 
    port (
        clk, rst, write_en, sel_const_reg_b : in std_logic;
        op : in std_logic_vector(2 downto 0);
        reg_a_ad, reg_b_ad, write_ad : in unsigned(2 downto 0);
        const : in unsigned(15 downto 0);
        reg_a, reg_b, alu_out : out unsigned(15 downto 0);
        zero, ovf, gt, st, eq: out std_logic
    );
end entity alu_with_reg_bank;

architecture a_alu_with_reg_bank of alu_with_reg_bank is
    component alu is
        port (
            op0, op1: in unsigned(15 downto 0);
            alu_op: in std_logic_vector(2 downto 0);
            result: out unsigned(15 downto 0);
            zero, ovf, gt, st, eq: out std_logic
        );
    end component alu;
    component register_bank is
        port (
            reg_a_ad, reg_b_ad, write_ad : in unsigned(2 downto 0);
            write_en, rst, clk : in std_logic;
            write_data : in unsigned(15 downto 0);
            reg_a, reg_b : out unsigned(15 downto 0)
        );
    end component register_bank;
    signal reg_a_node, reg_b_node, alu_out_node, mux_reg_b_const : unsigned(15 downto 0);

begin
    alu_inst : alu port map (
        op0 => reg_a_node,
        op1 => mux_reg_b_const,
        alu_op => op,
        result => alu_out_node,
        zero => zero,
        ovf => ovf,
        gt => gt,
        st => st,
        eq => eq
    );
    reg_bank_inst : register_bank port map (
        reg_a_ad => reg_a_ad,
        reg_b_ad => reg_b_ad,
        write_ad => write_ad,
        write_en => write_en,
        rst => rst,
        clk => clk,
        write_data => alu_out_node,
        reg_a => reg_a_node,
        reg_b => reg_b_node
    );
    mux_reg_b_const <= const when sel_const_reg_b = '1' else reg_b_node;
    reg_a <= reg_a_node;
    reg_b <= reg_b_node;
    alu_out <= alu_out_node;

end architecture a_alu_with_reg_bank;