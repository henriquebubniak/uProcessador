Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        op0, op1: in unsigned(7 downto 0);
        alu_op: in unsigned(2 downto 0);
        carry: in std_logic;
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
    signal sum_noc: unsigned(8 downto 0) := (others => '0');
    signal sub_r: unsigned(7 downto 0) := (others => '0');
    signal sub_noc: unsigned(7 downto 0) := (others => '0');
    signal and_r: unsigned(7 downto 0) := x"00";
    signal or_r: unsigned(7 downto 0) := x"00";
    signal xor_r: unsigned(7 downto 0) := x"00";

    signal mux_out: unsigned(7 downto 0) := x"00";

    signal sum_v, sub_v: std_logic := '0';

begin
    -- sum and sub
    sum_r <= ('0'& op0) + ('0'& op1) + (b"0000_0000" & carry);
    sub_r <= op0 - op1 - (b"0000_000" & not carry);

    -- sum and sub no carry
    sum_noc <= ('0'& op0) + ('0'& op1);
    sub_noc <= op0 - op1;

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
               sum_noc(7 downto 0) when alu_op = "101" else
               sub_noc when alu_op = "110" else
               x"00";

    --flags
    sum_v <= (sum_r(7) and not op0(7) and not op1(7)) or
             (not sum_r(7) and op0(7) and op1(7));
    
    sub_v <= '1' when to_integer(sub_r) > 127 else
             '1' when to_integer(sub_r) < -127 else
             '0';

    z <= '1' when mux_out = 0 else '0';

    v <= sum_v when alu_op = "000" else
         sub_v when alu_op = "001" else
         '0';

    c <= sum_r(8) when alu_op = "000" else 
         not sub_r(7) when alu_op = "001" else
         sum_noc(8) when alu_op = "101" else
         sub_noc(7) when alu_op = "110" else
         '0';

    n <= mux_out(7);

    result <= mux_out;

end alu_arch;


