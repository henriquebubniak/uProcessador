clean:
	find . -type f ! -name '*.vhdl' ! -name '*.gtkw' ! -name '*.ghw' ! -name 'Makefile' ! -name '*.txt' -delete;

all:
	ghdl -a new_cu.vhdl
	ghdl -a new_cu_tb.vhdl
	ghdl -e new_cu_tb
	ghdl -r new_cu_tb --wave=new_cu_tb.ghw --stop-time=300ns
	make clean
