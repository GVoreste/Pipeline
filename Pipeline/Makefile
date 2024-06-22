EXE=bubble_sort
CC=gcc
SRC_FILE=$(EXE).c
OBJ_FILE=$(EXE).o

# Default target : elaborate
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
