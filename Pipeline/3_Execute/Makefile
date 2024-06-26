SUBCOMPONENTS:= ALU/ALU  ALU/Adder ALUcontrol/ALUcontrol
TARGET_SUB:=$(addsuffix .o,$(SUBCOMPONENTS))
SRC_FILE=Execute
TB_FILE=Execute_tb
GHDL=ghdl
GHDLFLAGS=
GHDLRUNFLAGS=--stop-time=1500ns --vcd=$(VCDFILE)
VCDFILE=$(SRC_FILE).vcd

# Default target : elaborate
all : analyze elab run

# analyze
analyze: $(TARGET_SUB) 
	$(GHDL) -a $(SRC_FILE).vhd
	$(GHDL) -a $(TB_FILE).vhd

%.o: %.vhd
	$(GHDL) -a $<

# Elaborate target.  Almost useless
elab : 
	$(GHDL) -e $(TB_FILE)

# Run target
run : 
	$(GHDL) -r $(TB_FILE)  $(GHDLRUNFLAGS)

.PHONY: clean

clean:
	$(GHDL) --clean
	rm -f *.cf
	rm -f *.vcd