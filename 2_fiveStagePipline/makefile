PPCPU: code/*.v makefile testBench/*.v
	iverilog -o PPCPU code/*.v testBench/*.v
	vvp PPCPU 
	open PPCPU.vcd
