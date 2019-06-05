`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:59 05/14/2019 
// Design Name: 
// Module Name:    PPCPU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PPCPU(Clock, Resetn, PC, IF_Inst, ID_Inst, EXE_Alu, MEM_Alu, WB_Alu
    );
	 input Clock, Resetn;
	 output [31:0] PC, IF_Inst, ID_Inst, EXE_Alu, MEM_Alu, WB_Alu;
	 
	 wire [1:0] pcsource;
	 wire [31:0] bpc, jpc, if_pc4, id_pc4; 

     wire [4:0] exe_d, mem_d, wb_d;
     wire exe_wreg, mem_wreg, wb_wreg;
     wire exe_m2reg, mem_m2reg, wb_m2reg;
     wire exe_wmem, mem_wmem;
	 
	 wire [31:0] exe_a, exe_b, exe_imm;
	 wire wmem, exe_aluimm, exe_shift, z;
	 wire [2:0] exe_aluc;
	 wire [31:0] S, D;


	 IF_STAGE stage1 (Clock, Resetn, pcsource, bpc, jpc, if_pc4, id_pc4, 
        IF_Inst, ID_Inst, PC);
	 
	 ID_STAGE stage2 (id_pc4, ID_Inst, Clock, Resetn, bpc, jpc, pcsource,
	    exe_aluc, exe_aluimm, exe_a, exe_b, exe_imm, exe_shift, z, exe_wreg, exe_d, exe_m2reg, exe_wmem);	 

	 EXE_STAGE stage3 (exe_aluc, exe_aluimm, exe_a, exe_b, exe_imm, exe_shift, EXE_Alu, z,
        exe_wreg, mem_wreg, Clock, Resetn, exe_d, mem_d, exe_m2reg, 
        mem_m2reg, exe_wmem, mem_wmem, S, MEM_Alu);
	 
	 MEM_STAGE stage4 (mem_wmem, MEM_Alu, S, Clock, D, mem_wreg, wb_wreg, Resetn,
         mem_d, wb_d, mem_m2reg, wb_m2reg, WB_Alu);
	 
	 WB_STAGE stage5 (Clock, Resetn, WB_Alu, D, wb_m2reg, wb_wreg, wb_d);


endmodule
