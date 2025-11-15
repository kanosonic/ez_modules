TOP = fir_tb
SRC = $(wildcard src/*.v)
TEST_SRC= $(TOP).v
BIN = $(TOP).vvp

$(BIN): $(SRC) $(TEST_SRC)
	iverilog -o $(BIN) -s $(TOP) $(SRC) $(TEST_SRC)
.PHONY: all clean sim

all: $(BIN)

sim: $(BIN)
	vvp $(BIN)
	@echo Open waveform
	gtkwave $(TOP).vcd
clean:
	rm -f *.vvp *.vcd
