FILES_TO_DELETE := *o *cf *.ghw register_bank alu reg alu_with_reg_bank rom

BUILD_NAME := rom

clean:
	for file in $(FILES_TO_DELETE); do \
		find . -type f -name "$$file" -delete; \
		find . -type f -name "$$file_tb" -delete; \
	done
	
build:	
	ghdl -a $(BUILD_NAME).vhdl
	ghdl -e $(BUILD_NAME)
	ghdl -a $(BUILD_NAME)_tb.vhdl
	ghdl -e $(BUILD_NAME)_tb
	ghdl -r $(BUILD_NAME)_tb --wave=$(BUILD_NAME)_tb.ghw