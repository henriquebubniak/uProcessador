library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic;
        opcode : in unsigned(7 downto 0);
        oper: in unsigned(5 downto 0);
        pc_clock, rom_clock, reg_bank_clock, jump, alu_src, write_en : out std_logic;
        write_ad, reg_a_ad, reg_b_ad : out unsigned(4 downto 0);
        alu_op : out unsigned(2 downto 0)
    );
end control_unit;

architecture a_control_unit of control_unit is
    signal state : unsigned(1 downto 0) := "00";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            state <=  state + 1;
        end if;
    end process;


    pc_clock <= not state(1) and not state(0);
    rom_clock <= not state(1) and state(0);
    reg_bank_clock <= state(1) and state(0);

    process(opcode, oper)
    begin
        case opcode is
            when x"65" =>
                jump <= '0';
                alu_src <= '0';
                write_en <= '1';
                write_ad <= "00001";
                reg_a_ad <= "00001";
                reg_b_ad <= oper(4 downto 0);
                alu_op <= "000";

            when x"69" =>
                jump <= '0';
                alu_src <= '1';
                write_en <= '1';
                write_ad <= "00001";
                reg_a_ad <= "00001";
                reg_b_ad <= oper(4 downto 0);
                alu_op <= "000";

            when x"E9" =>
                jump <= '0';
                alu_src <= '1';
                write_en <= '1';
                write_ad <= "00001";
                reg_a_ad <= "00001";
                reg_b_ad <= oper(4 downto 0);
                alu_op <= "001";

            when x"85" =>
                jump <= '0';
                alu_src <= '0';
                write_en <= '1';
                write_ad <= oper(4 downto 0);
                reg_a_ad <= "00001";
                reg_b_ad <= "00000";
                alu_op <= "000";

            when x"A9" =>
                jump <= '0';
                alu_src <= '1';
                write_en <= '1';
                write_ad <= "00001";
                reg_a_ad <= "00000";
                reg_b_ad <= oper(4 downto 0);
                alu_op <= "000";
            
            when x"A5" =>
                jump <= '0';
                alu_src <= '0';
                write_en <= '1';
                write_ad <= "00001";
                reg_a_ad <= "00000";
                reg_b_ad <= oper(4 downto 0);
                alu_op <= "000";
            
            -- Jump
            when x"4C" =>
                jump <= '1';
                alu_src <= '0';
                write_en <= '0';
                write_ad <= "00001";
                reg_a_ad <= "00000";
                reg_b_ad <= oper(4 downto 0);
                alu_op <= "000";
            
            -- BEQ
            when x"F0" =>
                
            

            when others =>
                jump <= '0';
                alu_src <= '0';
                write_en <= '0';
                write_ad <= "00001";
                reg_a_ad <= "00000";
                reg_b_ad <= oper(4 downto 0);
                alu_op <= "000";
        
        end case ;
    end process;
    
end a_control_unit;
