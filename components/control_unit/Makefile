clean:
	find . -type f ! -name '*.vhdl' ! -name '*.gtkw' ! -name 'Makefile' -delete;
	
register_bank:
	ghdl -a register_bank.vhdl

alu:
	ghdl -a alu.vhdl

alu_with_reg_bank: alu register_bank
	ghdl -a alu_with_reg_bank.vhdl

alu_with_reg_bank_tb: alu_with_reg_bank
	ghdl -a alu_with_reg_bank_tb.vhdl
	ghdl -e alu_with_reg_bank_tb
	ghdl -r alu_with_reg_bank_tb --wave=alu_with_reg_bank_tb.ghw
rom:	
	ghdl -a rom.vhdl
	ghdl -e rom

rom_tb: rom
	ghdl -a rom_tb.vhdl
	ghdl -e rom_tb
	ghdl -r rom_tb --wave=rom_tb.ghw

state_machine:
	ghdl -a state_machine.vhdl
	ghdl -e state_machine

state_machine_tb: state_machine
	ghdl -a state_machine_tb.vhdl
	ghdl -e state_machine_tb
	ghdl -r state_machine_tb --wave=state_machine_tb.ghw