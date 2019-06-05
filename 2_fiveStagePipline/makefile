stageIF = code/IF_STAGE.v code/dff32.v code/add32.v code/mux32_4_1.v code/Inst_ROM.v
stageID = code/ID_STAGE.v code/Control_Unit.v code/Regfile.v code/mux5_2_1.v code/add32.v
stageEXE = code/EXE_STAGE.v code/mux32_2_1.v code/alu.v
stageMEM = code/MEM_STAGE.v
stageWB = code/WB_STAGE.v code/mux32_2_1.v

PPCPU: code/*.v makefile testBench/PPCPU_tb.v
	iverilog -o PPCPU code/*.v testBench/PPCPU_tb.v
	vvp PPCPU 
	open PPCPU.vcd

IF: $(stageIF) makefile testBench/IF_STAGE_tb.v
	iverilog -o IF $(stageIF) testBench/IF_STAGE_tb.v
	vvp IF
	open IF.vcd
ID: $(stageID) makefile testBench/ID_STAGE_tb.v
	iverilog -o ID $(stageID) testBench/ID_STAGE_tb.v
	vvp ID
	open ID.vcd
EXE: $(stageEXE) makefile testBench/EXE_STAGE_tb.v
	iverilog -o EXE $(stageEXE) testBench/EXE_STAGE_tb.v
	vvp EXE
	open EXE.vcd
MEM: $(stageMEM) makefile testBench/MEM_STAGE_tb.v
	iverilog -o MEM $(stageMEM) testBench/MEM_STAGE_tb.v
	vvp MEM
	open MEM.vcd
WB: $(stageWB) makefile testBench/WB_STAGE_tb.v
	iverilog -o WB $(stageWB) testBench/WB_STAGE_tb.v
	vvp WB 
	open WB.vcd

openIF:
	vim -p $(stageIF) testBench/IF_STAGE_tb.v
openID:
	vim -p $(stageID) testBench/ID_STAGE_tb.v
openEXE:
	vim -p $(stageEXE) testBench/EXE_STAGE_tb.v
openMEM:
	vim -p $(stageMEM) testBench/MEM_STAGE_tb.v
openWB:
	vim -p $(stageWB) testBench/WB_STAGE_tb.v
