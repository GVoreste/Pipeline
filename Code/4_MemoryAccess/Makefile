SUBCOMPONENTS:= Ram/data_ram
SRC_FILE=MemoryAccess
TARGET_SUB:=$(addsuffix .o,$(notdir $(SUBCOMPONENTS)))
GHDL=ghdl
GHDLRUNFLAGS=--stop-time=1500ns --vcd=$(VCDFILE)
VCDFILE=$(SRC_FILE).vcd
TB_FILE=$(SRC_FILE)_tb

LOWER_TB=$(shell echo $(TB_FILE) | tr '[:upper:]' '[:lower:]')

.SUFFIXES:
# Default target : elaborate
all : $(VCDFILE)

%.o : $(SRC_FILE).vhd $(TB_FILE).vhd $(addsuffix .vhd,$(SUBCOMPONENTS))
	$(GHDL) -a $(filter %$(patsubst %.o,%.vhd,$@), $^)
	

%_tb : $(TB_FILE).o $(SRC_FILE).o $(TARGET_SUB) 
	$(GHDL) -e $(TB_FILE)

%.vcd: $(shell echo %_tb | tr '[:upper:]' '[:lower:]')
	$(GHDL) -r $<  $(GHDLRUNFLAGS)

.PHONY: clean

clean:
	$(GHDL) --clean
	rm -f work-obj*.cf
	rm -f $(VCDFILE)
