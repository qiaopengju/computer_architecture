`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:13 05/15/2019 
// Design Name: 
// Module Name:    EXE_STAGE 
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
module EXE_STAGE(ealuc,ealuimm,ea,eb,eimm,eshift,ealu,z,
        exe_wreg, mem_wreg, clk, clrn, exe_d, mem_d, exe_m2reg, 
        mem_m2reg, exe_wmem, mem_wmem, S, MEM_Alu, mem_wregIn, wb_wregIn,
        mem_dIn, wb_dIn, mem_aluIn, wb_aluIn, exe_rs, exe_rt, wb_m2reg, D
    );
     input clk, clrn;
	 input [31:0] ea,eb,eimm;		//ea-由寄存器读出的操作数a；eb-由寄存器读出的操作数b；eimm-经过扩展的立即数；
	 input [2:0] ealuc;		//ALU控制码
	 input ealuimm,eshift;		//ALU输入操作数的多路选择器
     input exe_wreg;
     input [4:0] exe_d;
     input exe_m2reg;
     input exe_wmem;
     input mem_wregIn, wb_wregIn; //两级写寄存器信号
     input [4:0] mem_dIn, wb_dIn;//两级目的寄存器号
     input [31:0] mem_aluIn, wb_aluIn;//两级结果
     input [31:0] D;//从内存取出的值
     input [4:0] exe_rs, exe_rt;
     input wb_m2reg;

	 output [31:0] ealu;		//alu操作输出
	 output z;
     output mem_wreg;
     output [4:0] mem_d;
     output mem_m2reg;
     output mem_wmem;
     output [31:0] S;
     output [31:0] MEM_Alu;
	 
	 wire [31:0] alua,alub,sa;
     wire [1:0] sA, sB;//alu选择信号
	 wire [31:0] wdi;//最终写向寄存器的数据 

	 assign sa={26'b0,eimm[9:5]};//移位位数的生成

     assign sA = (mem_wregIn & exe_rs==mem_dIn) ? 2'b10 : //alu第一个操作数选择输入信号
                 (wb_wregIn & exe_rs==wb_dIn) ? 2'b11 :
                 (eshift) ? 2'b01 : 2'b00;
     assign sB = (ealuimm) ? 2'b01 :                    //alu第二个操作数选择输入信号
                 (mem_wregIn & exe_rt==mem_dIn) ? 2'b10 :
                 (wb_wregIn & exe_rt==wb_dIn) ? 2'b11 : 2'b00;

     mux32_2_1 select_wdi (mem_aluIn,D,wb_m2reg,wdi);
	 mux32_4_1 alu_ina (ea,sa,mem_aluIn,wb_aluIn,sA,alua);//选择ALU a端的数据来源
	 mux32_4_1 alu_inb (eb,eimm,mem_aluIn,wdi,sB,alub);//选择ALU b端的数据来源
	 //mux32_2_1 alu_ina (ea,sa,eshift,alua);//选择ALU a端的数据来源
	 //mux32_2_1 alu_inb (eb,eimm,ealuimm,alub);//选择ALU b端的数据来源
 	 alu al_unit (alua,alub,ealuc,ealu,z);//ALU
	 
    dff1 wreg2mem(exe_wreg, clk, clrn, mem_wreg);
    dff5 d2mem(exe_d, clk, clrn, mem_d);
    dff1 m2reg2mem(exe_m2reg, clk, clrn, mem_m2reg);
    dff1 wmem2mem(exe_wmem, clk, clrn, mem_wmem);
    dff32 rb2mem(eb, clk, clrn, S);
    dff32 alu2mem(ealu, clk, clrn, MEM_Alu);
endmodule
