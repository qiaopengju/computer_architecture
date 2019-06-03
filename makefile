stage1 = code/IF_STAGE.v code/dff32.v code/add32.v code/mux32_4_1.v code/Inst_ROM.v
IF: $(stage1) makefile
	iverilog -o IF $(stage1) testBench/IF_STAGE_tb.v
	vvp IF
	open IF.vcd
openIF:
	vim -p $(stage1) testBench/IF_STAGE_tb.v
