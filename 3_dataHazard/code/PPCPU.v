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

     wire [4:0] exe_d, mem_d, wb_d;         //d存储回写目的寄存器编号，每个时钟上升沿传递给下一级
     wire exe_wreg, mem_wreg, wb_wreg;      //wreg存储写寄存器信号，每个时钟上升沿传给下一级
     wire exe_m2reg, mem_m2reg, wb_m2reg;   //m2reg存储是否是内存写寄存器信号
     wire exe_wmem, mem_wmem;               //写存储器信号
     wire [4:0] exe_rs, exe_rt;
	 
	 wire [31:0] exe_a, exe_b, exe_imm;     //传递给EXE级的操作数
	 wire exe_aluimm, exe_shift, z;         //传递给EXE级的操作数或控制信号
     wire [14:0] exe_alu_type; //每级操作类型
	 wire [2:0] exe_aluc;                   //传递给EXE级的ALU控制字
	 wire [31:0] S, D, nextD;                      //S:BUS_B, D:从存储器读出的数据
     wire load_depen;                       //load流水线暂停信号
     wire [4:0] exe_rd, mem_rd;
	 wire [31:0] wdi;   //WB级写回寄存器值

	 IF_STAGE stage1 (Clock, Resetn, pcsource, bpc, jpc, if_pc4, id_pc4, 
        IF_Inst, ID_Inst, PC, load_depen);
	 
	 ID_STAGE stage2 (id_pc4, ID_Inst, Clock, Resetn, bpc, jpc, pcsource,
	    exe_aluc, exe_aluimm, exe_a, exe_b, exe_imm, exe_shift, z, exe_wreg,
        exe_d, exe_m2reg, exe_wmem, load_depen, exe_d, exe_alu_type, 
        exe_rs, exe_rt, exe_m2reg, exe_wreg, wdi, wb_d, wb_wreg);	 

	 EXE_STAGE stage3 (exe_aluc, exe_aluimm, exe_a, exe_b, exe_imm, exe_shift, EXE_Alu, z,
        exe_wreg, mem_wreg, Clock, Resetn, exe_d, mem_d, exe_m2reg, 
        mem_m2reg, exe_wmem, mem_wmem, S, MEM_Alu, mem_wreg, wb_wreg, mem_d, wb_d,
        MEM_Alu, WB_Alu, exe_rs, exe_rt, wb_m2reg, nextD);
	 
	 MEM_STAGE stage4 (mem_wmem, MEM_Alu, S, Clock, D, mem_wreg, wb_wreg, Resetn,
         mem_d, wb_d, mem_m2reg, wb_m2reg, WB_Alu);
	 
	 WB_STAGE stage5 (Clock, Resetn, WB_Alu, D, wb_m2reg, wb_wreg, wb_d, wdi);

     dff32 d2NextD(D, Clock, Resetn, nextD);


endmodule
