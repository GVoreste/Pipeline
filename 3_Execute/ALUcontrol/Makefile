SRC_FILE=ALUcontrol
GHDL=ghdl
GHDLRUNFLAGS=--stop-time=1500ns --vcd=$(VCDFILE)
VCDFILE=$(SRC_FILE).vcd
TB_FILE=$(SRC_FILE)_tb

LOWER_TB=$(shell echo $(TB_FILE) | tr '[:upper:]' '[:lower:]')
.SUFFIXES:
# Default target : elaborate
all : $(VCDFILE)

# analyze
%.o: %.vhd
	$(GHDL) -a $<

# Elaborate target.  Almost useless
%_tb : $(TB_FILE).o $(SRC_FILE).o
	$(GHDL) -e $(TB_FILE)

%.vcd: $(shell echo %_tb | tr '[:upper:]' '[:lower:]')
	$(GHDL) -r $<  $(GHDLRUNFLAGS)

.PHONY: clean

clean:
	$(GHDL) --clean
	rm -f work-obj*.cf
	rm -f $(VCDFILE)
