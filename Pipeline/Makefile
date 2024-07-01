SRC_FILE=bubble_sort.c
ifdef REVERSE
EXE=r_bubble_sort
CFLAG=-DDESC
else
EXE=bubble_sort
CFLAG=
endif
SRC_FILE_VHDL=Processor
CC=gcc
RISCV_PFX=riscv64-elf-
GHDL=ghdl
OBJ_FILE=$(EXE).o

SUBCOMPONENTS_FETCH:=$(addprefix 1_Fetch/,Fetch PC/PC Ram/ram)
SUBCOMPONENTS_DECODE:=$(addprefix 2_Decode/,Decode ControlUnit/ControlUnit ImmGen/ImmediateGen RegisterFile/reg)
SUBCOMPONENTS_EXECUTE:=$(addprefix 3_Execute/,Execute ALU/ALU ALU/Adder ALUcontrol/ALUcontrol)
SUBCOMPONENTS_MEMACC:=$(addprefix 4_MemoryAccess/,MemoryAccess Ram/data_ram)
SUBCOMPONENTS:=$(SUBCOMPONENTS_FETCH) $(SUBCOMPONENTS_DECODE) $(SUBCOMPONENTS_EXECUTE) $(SUBCOMPONENTS_MEMACC)

TARGET_SUB:=$(addsuffix .o,$(notdir $(SUBCOMPONENTS)))
GHDLRUNFLAGS=--stop-time=1500ns --vcd=$(VCDFILE)
VCDFILE=$(SRC_FILE_VHDL).vcd
TB_FILE=$(SRC_FILE_VHDL)_tb

.SUFFIXES:
# Default target : elaborate
all: $(VCDFILE) $(EXE) $(EXE).x  $(EXE)_print  $(EXE)_TEXT.bin $(EXE)_DATA.bin $(EXE)_TEXT.txt $(EXE)_DATA.txt


TMP=$(filter %/$(patsubst %.o,%.vhd,$@),$^)
$(TB_FILE).o $(SRC_FILE_VHDL).o $(TARGET_SUB)  : $(SRC_FILE_VHDL).vhd $(TB_FILE).vhd $(addsuffix .vhd,$(SUBCOMPONENTS))
	$(GHDL) -a $(if $(TMP),$(TMP),$(patsubst %.o,%.vhd,$@))
	
%_tb : $(TB_FILE).o $(SRC_FILE_VHDL).o $(TARGET_SUB) 
	$(GHDL) -e $(TB_FILE)

%.vcd: $(shell echo %_tb | tr '[:upper:]' '[:lower:]')
	$(GHDL) -r $<  $(GHDLRUNFLAGS)


$(EXE): $(SRC_FILE)
	$(CC) $(CFLAG) -g -Wall $< -o $@

$(EXE)_print: $(SRC_FILE)
	$(CC) $(CFLAG) -DDEBUG -g -Wall $< -o $@


$(EXE).x: $(EXE).o
	$(RISCV_PFX)ld $< -o $@

$(EXE).o: $(EXE).asm
	$(RISCV_PFX)as $< -o $@

CFLAGS=$(CFLAG) -S -O1 -march=rv64i -mabi=lp64
ifdef VERBOSE
CFLAGS+= -fverbose-asm
endif 

$(EXE).asm: $(SRC_FILE)
	$(RISCV_PFX)$(CC) $(CFLAGS)  $< -o $@

$(EXE)_TEXT.txt: $(EXE)_TEXT.bin
	hexdump $< -e '4/1 "%02x" "\n"' > $@

$(EXE)_DATA.txt: $(EXE)_DATA.bin
	hexdump $< -e '4/1 "%02x" "\n"' > $@

$(EXE)_TEXT.bin: $(EXE).o
	$(RISCV_PFX)objcopy --reverse-bytes=4 --only-section=.text -O binary $< $@
$(EXE)_DATA.bin: $(EXE).o
	$(RISCV_PFX)objcopy --reverse-bytes=4 --only-section=.data -O binary $< $@
	
.PHONY: clean

clean:
	
	ghdl --clean
	rm -f work-obj*.cf
	rm -f $(VCDFILE)
	rm -f $(patsubst %.c,%,$(SRC_FILE)) r_$(patsubst %.c,%,$(SRC_FILE))
	rm -f *_print
	rm -f *.bin
	rm -f *.txt
	rm -f *.x
	rm -f *.o
	rm -f *.asm
