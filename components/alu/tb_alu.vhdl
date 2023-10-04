Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_alu is
end tb_alu;

architecture test_bench of tb_alu is
    signal op0, op1, result: unsigned(15 downto 0);
    signal alu_op: std_logic_vector(2 downto 0);
    signal zero, ovf, gt, st, eq: std_logic;

begin
    my_alu: entity work.alu(alu_arch)
        port map(
            op0 => op0,
            op1 => op1,
            alu_op => alu_op,
            result => result,
            zero => zero,
            ovf => ovf,
            gt => gt,
            st => st,
            eq => eq
        );

    process
    begin

        op0 <= x"0029"; -- 41
        op1 <= x"0011"; -- 17

        -- sum without overflow
        alu_op <= "000";
        wait for 10 ns;

        --sub
        alu_op <= "001";
        wait for 10 ns;

        --and
        op0 <= x"AAAA"; --"1010..."
        op1 <= x"5555"; --"0101..."
        --expect x"0000"
        alu_op <= "010";
        wait for 10 ns;

        --or
        alu_op <= "011";
        --expect x"FFFF"
        wait for 10 ns;

        --xor
        alu_op <= "100";
        --expect x"FFFF"
        wait for 10 ns;

        --sum with overflow
        op0 <= x"FFF3";
        op1 <= x"FFFD";

        alu_op <= "000";

        wait for 10 ns;

        --sub where op1 > op0
        op0 <= x"0011";
        op1 <= x"0029";
        alu_op <= "001";
        wait for 10 ns;

        -- equals
        alu_op <= "000";
        op0 <= x"0029";
        wait for 10 ns;

        --invalid op
        alu_op <= "010";
        wait for 10 ns;

    end process;
end test_bench; 
    
