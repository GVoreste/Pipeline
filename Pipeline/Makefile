EXE=bubble_sort
CC=gcc
SRC_FILE=$(EXE).c
OBJ_FILE=$(EXE).o

# Default target : elaborate
all: asc analyze elab run

analyze:
	ghdl -a 1_Fetch/PC/PC.vhd
	ghdl -a 1_Fetch/Ram/ram.vhd
	ghdl -a 1_Fetch/Fetch.vhd

	ghdl -a 2_Decode/ControlUnit/ControlUnit.vhd
	ghdl -a 2_Decode/ImmGen/ImmediateGen.vhd
	ghdl -a 2_Decode/RegisterFile/reg.vhd
	ghdl -a 2_Decode/Decode.vhd

	ghdl -a 3_Execute/ALU/Adder.vhd
	ghdl -a 3_Execute/ALU/ALU.vhd
	ghdl -a 3_Execute/ALUcontrol/ALUcontrol.vhd
	ghdl -a 3_Execute/Execute.vhd

	ghdl -a 4_MemoryAccess/Ram/ram.vhd
	ghdl -a 4_MemoryAccess/MemoryAccess.vhd

	ghdl -a Processor.vhd
#	ghdl -a Processor_tb.vhd

elab:
#	ghdl -e Processor_tb

run:
#	ghdl -r Processor_tb --stop-time=1500ns --vcd=Processor.vhd

asc : $(EXE) $(EXE).debug 

desc: r_$(EXE) r_$(EXE).debug

r_$(EXE).debug: $(SRC_FILE)
	$(CC) -DDESC -DDEBUG $(SRC_FILE) -o $@

$(EXE).debug: $(SRC_FILE)
	$(CC) -DDEBUG $(SRC_FILE) -o $@

r_$(EXE): $(SRC_FILE)
	echo 'fattoooooos'

$(EXE): $(SRC_FILE)
	echo 'fattoooooos'

# Run target
# run : 
# 	$(GHDL) -r $(TB_FILE)  $(GHDLRUNFLAGS)

.PHONY: clean

clean:
	rm -f $(EXE) r_$(EXE)
	rm -f $(EXE).debug r_$(EXE).debug
	ghdl --clean
	rm -f *.cf
	rm -f *.vcd
