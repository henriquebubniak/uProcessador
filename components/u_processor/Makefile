clean:
	find . -type f ! -name '*.vhdl' ! -name '*.gtkw' ! -name 'Makefile' -delete;
	
register_bank:
	ghdl -a register_bank.vhdl

alu:
	ghdl -a alu.vhdl

rom:	
	ghdl -a rom.vhdl


program_counter:
	ghdl -a program_counter.vhdl

control_unit:
	ghdl -a control_unit.vhdl

u_processor: control_unit rom program_counter register_bank alu
	ghdl -a u_processor.vhdl

u_processor_tb: u_processor
	ghdl -a u_processor_tb.vhdl
	ghdl -e u_processor_tb
	ghdl -r u_processor_tb --wave=u_processor_tb.ghw