Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        op0, op1: in unsigned(15 downto 0);
        alu_op: in unsigned(2 downto 0);
        result: out unsigned(15 downto 0);
        zero, ovf, gt, st, eq: out std_logic
    );
end alu;

-- OPERATIONS:
-- Arithmetic: addition, subtraction;
-- Boolean: greater than, smaller than, equals;
-- Logical: and, or, xor.

architecture alu_arch of alu is
    
    --<operation>_r(esult)
    signal sum_r: unsigned(16 downto 0) := (others => '0');
    signal sub_r: unsigned(15 downto 0) := x"0000";
    signal and_r: unsigned(15 downto 0) := x"0000";
    signal or_r: unsigned(15 downto 0) := x"0000";
    signal xor_r: unsigned(15 downto 0) := x"0000";

    signal mux_out: unsigned(15 downto 0) := x"0000";

begin
    -- sum and sub
    sum_r <= ('0'& op0) + ('0'& op1);
    sub_r <= op0 - op1;

    -- logical
    and_r <= op0 and op1;
    or_r <= op0 or op1;
    xor_r <= op0 xor op1;

    -- muxing
    mux_out <= sum_r(15 downto 0) when alu_op = "000" else
               sub_r when alu_op = "001" else
               and_r when alu_op = "010" else
               or_r when alu_op = "011" else
               xor_r when alu_op = "100" else
               x"0000";

    --flags
    zero <= '1' when mux_out = 0 else '0';
    ovf <= '1' when sum_r(16) = '1' and alu_op = "000" else '0';
    gt <= '1' when op0 > op1 else '0';
    st <= '1' when op0 < op1 else '0';
    eq <= '1' when sub_r = 0 else '0';

    result <= mux_out;

end alu_arch;


