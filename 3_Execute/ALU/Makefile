SRC_FILES=ALU Adder
GHDL=ghdl
GHDLRUNFLAGS=--stop-time=1500ns
VCDFILES=$(addsuffix .vcd,$(SRC_FILES))
TB_FILES=$(addsuffix _tb,$(SRC_FILES))

LOWER_TBS=$(shell echo $(TB_FILES) | tr '[:upper:]' '[:lower:]')
.SUFFIXES:
# Default target : elaborate
all : $(VCDFILES)

# analyze
%.o: %.vhd
	$(GHDL) -a $<

# Elaborate target.  Almost useless
%_tb : $(addsuffix .o,$(TB_FILES) $(SRC_FILES))
	$(GHDL) -e $@

%.vcd: $(shell echo %_tb | tr '[:upper:]' '[:lower:]')
	$(GHDL) -r $<  $(GHDLRUNFLAGS) --vcd=$@

.PHONY: clean

clean:
	$(GHDL) --clean
	rm -f work-obj*.cf
	rm -f $(VCDFILES)
