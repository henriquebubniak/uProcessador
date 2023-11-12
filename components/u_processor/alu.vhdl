Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        op0, op1: in unsigned(7 downto 0);
        alu_op: in unsigned(2 downto 0);
        result: out unsigned(7 downto 0);
        n,v,z,c: out std_logic
    );
end alu;

-- OPERATIONS:
-- Arithmetic: addition, subtraction;
-- Logical: and, or, xor.

architecture alu_arch of alu is
    
    --<operation>_r(esult)
    signal sum_r: unsigned(8 downto 0) := (others => '0');
    signal sub_r: unsigned(8 downto 0) := (others => '0');
    signal and_r: unsigned(7 downto 0) := x"00";
    signal or_r: unsigned(7 downto 0) := x"00";
    signal xor_r: unsigned(7 downto 0) := x"00";

    signal mux_out: unsigned(7 downto 0) := x"00";

begin
    -- sum and sub
    sum_r <= ('0'& op0) + ('0'& op1);
    sub_r <= ('0'& op0) - ('0'& op1);

    -- logical
    and_r <= op0 and op1;
    or_r <= op0 or op1;
    xor_r <= op0 xor op1;

    -- muxing
    mux_out <= sum_r(7 downto 0) when alu_op = "000" else
               sub_r(7 downto 0) when alu_op = "001" else
               and_r when alu_op = "010" else
               or_r when alu_op = "011" else
               xor_r when alu_op = "100" else
               x"00";

    --flags
    z <= '1' when mux_out = 0 else '0';
    v <= '1' when sum_r(8) = '1' else '0';
    c <= '1' when sum_r(8) = '1' else '0';
    n <= '1' when mux_out(7) = '1' else '0';

    result <= mux_out;

end alu_arch;


