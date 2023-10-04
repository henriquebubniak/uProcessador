FILES_TO_DELETE := *o *cf *.ghw register_bank register_bank_tb alu alu_tb reg reg_tb

clean:
	for file in $(FILES_TO_DELETE); do \
		find . -type f -name "$$file" -delete; \
	done
	
