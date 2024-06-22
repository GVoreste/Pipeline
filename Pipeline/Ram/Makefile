SRC_FILE=ram
TB_FILE=ram_tb
GHDL=ghdl
GHDLFLAGS=
GHDLRUNFLAGS=--stop-time=1500ns --vcd=$(VCDFILE)
VCDFILE=$(SRC_FILE).vcd

# Default target : elaborate
all : analyze elab run

# analyze
analyze: 
	$(GHDL) -a --ieee=synopsys $(SRC_FILE).vhd
	$(GHDL) -a --ieee=synopsys $(TB_FILE).vhd

# Elaborate target.  Almost useless
elab : 
	$(GHDL) -e --ieee=synopsys $(TB_FILE)

# Run target
run : 
	$(GHDL) -r $(TB_FILE)  $(GHDLRUNFLAGS)

.PHONY: clean

clean:
	$(GHDL) --clean
	rm -f *.cf
