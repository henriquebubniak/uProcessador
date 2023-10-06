FILES_TO_DELETE := *o *cf *.ghw register_bank register_bank_tb alu tb_alu reg reg_tb alu_with_reg_bank alu_with_reg_bank_tb

clean:
	for file in $(FILES_TO_DELETE); do \
		find . -type f -name "$$file" -delete; \
	done
	
build:	
	ghdl -a alu.vhdl
	ghdl -e alu
	ghdl -a tb_alu.vhdl
	ghdl -e tb_alu
	ghdl -r tb_alu --wave=tb_alu.ghw