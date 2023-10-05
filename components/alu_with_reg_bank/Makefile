FILES_TO_DELETE := *o *cf *.ghw register_bank register_bank_tb alu alu_tb reg reg_tb alu_with_reg_bank alu_with_reg_bank_tb

clean:
	for file in $(FILES_TO_DELETE); do \
		find . -type f -name "$$file" -delete; \
	done
	
build:
	ghdl -a register_bank.vhdl
	
	ghdl -a alu.vhdl
	
	ghdl -a alu_with_reg_bank.vhdl
	ghdl -a alu_with_reg_bank_tb.vhdl
	ghdl -e alu_with_reg_bank_tb
	ghdl -r alu_with_reg_bank_tb --wave=alu_with_reg_bank_tb.ghw