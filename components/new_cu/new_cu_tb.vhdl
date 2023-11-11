Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity new_cu_tb is
end new_cu_tb;

architecture test_bench of new_cu_tb is
    component new_cu is
        port (
            opcode : in unsigned(7 downto 0);
            flags: in unsigned(7 downto 0);
            oper: in unsigned(5 downto 0);
            jump, alu_src, write_en, flags_wr: out std_logic;
            pc_src: out unsigned(1 downto 0);
            write_ad, reg_a_ad, reg_b_ad : out unsigned(4 downto 0);
            alu_op : out unsigned(2 downto 0)
    );
    end component new_cu;
    
    signal opcode:  unsigned(7 downto 0);
    signal flags: unsigned(7 downto 0);
    signal oper: unsigned(5 downto 0);
    signal jump, alu_src, write_en, flags_wr: std_logic;
    signal pc_src: unsigned(1 downto 0);
    signal write_ad, reg_a_ad, reg_b_ad: unsigned(4 downto 0);
    signal alu_op: unsigned(2 downto 0);

begin
    control_unit_inst : new_cu
        port map (
            opcode => opcode,
            flags => flags,
            oper => oper,
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
    
        process
        begin
            oper <= "101010";
            flags <= x"00";

            -- ADC zpg
            opcode <= x"65";
            wait for 10 ns;
            
            -- ADC imm
            opcode <= x"69";
            wait for 10 ns;
            
            -- SBC imm
            opcode <= x"E9";
            wait for 10 ns;
            
            -- STA zpg
            opcode <= x"85";
            wait for 10 ns;

            -- LDA imm
            opcode <= x"A9";
            wait for 10 ns;

            -- LDA zpg
            opcode <= x"A5";
            wait for 10 ns;

            -- JMP
            opcode <= x"4C";
            oper <= "010101";
            wait for 10 ns;

            -- BEQ
            opcode <= x"F0";
            oper <= "110011";
            wait for 10 ns;

            flags <= b"0010_0000";
            wait for 10 ns;

            -- BMI
            opcode <= x"30";
            oper <= "001100";
            wait for 10 ns;
            
            flags <= b"1000_0000";
            wait for 10 ns;

            -- BCS
            opcode <= x"B0";
            oper <= "100001";
            wait for 10 ns;

            flags <= b"0001_0000";
            wait for 10 ns;
        end process;

end test_bench;

