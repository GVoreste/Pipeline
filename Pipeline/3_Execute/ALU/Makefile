SRC_FILE=reg
TB_FILE=reg_tb
GHDL=ghdl
GHDLFLAGS=
GHDLRUNFLAGS=--stop-time=1500ns --vcd=$(VCDFILE)
VCDFILE=$(SRC_FILE).vcd

# Default target : elaborate
all : analyze elab run

# analyze
analyze: 
	$(GHDL) -a Adder.vhd
	$(GHDL) -a Adder_tb.vhd
	$(GHDL) -a ALU.vhd
	$(GHDL) -a ALU_tb.vhd

# Elaborate target.  Almost useless
elab : 
	$(GHDL) -e Adder_tb
	$(GHDL) -e ALU_tb

# Run target
run : 
	$(GHDL) -r Adder_tb  --stop-time=1500ns --vcd=Adder.vcd
	$(GHDL) -r ALU_tb    --stop-time=1500ns --vcd=ALU.vcd

.PHONY: clean

clean:
	$(GHDL) --clean
	rm -f *.cf
	rm -f *.vcd
