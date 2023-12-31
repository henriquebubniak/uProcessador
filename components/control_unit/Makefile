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

program_counter:
	ghdl -a program_counter.vhdl
	ghdl -e program_counter

program_counter_tb: program_counter
	ghdl -a program_counter_tb.vhdl
	ghdl -e program_counter_tb
	ghdl -r program_counter_tb --wave=program_counter_tb.ghw

pc_incrementer_tb: program_counter
	ghdl -a pc_incrementer_tb.vhdl
	ghdl -e pc_incrementer_tb
	ghdl -r pc_incrementer_tb --wave=pc_incrementer_tb.ghw

pc_with_rom: program_counter rom
	ghdl -a pc_with_rom.vhdl
	ghdl -e pc_with_rom

pc_with_rom_tb: pc_with_rom
	ghdl -a pc_with_rom_tb.vhdl
	ghdl -e pc_with_rom_tb
	ghdl -r pc_with_rom_tb --wave=pc_with_rom_tb.ghw

control_unit:
	ghdl -a control_unit.vhdl
	ghdl -e control_unit

top_level: control_unit rom program_counter
	ghdl -a top_level.vhdl
	ghdl -e top_level

top_level_tb: top_level
	ghdl -a top_level_tb.vhdl
	ghdl -e top_level_tb
	ghdl -r top_level_tb --wave=top_level_tb.ghw