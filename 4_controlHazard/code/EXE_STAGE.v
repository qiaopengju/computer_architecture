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
	 input [31:0] ea,eb,eimm;		//ea-�ɼĴ��������Ĳ�����a��eb-�ɼĴ��������Ĳ�����b��eimm-������չ����������
	 input [2:0] ealuc;		//ALU������
	 input ealuimm,eshift;		//ALU����������Ķ�·ѡ����
     input exe_wreg;
     input [4:0] exe_d;
     input exe_m2reg;
     input exe_wmem;
     input mem_wregIn, wb_wregIn; //����д�Ĵ����ź�
     input [4:0] mem_dIn, wb_dIn;//����Ŀ�ļĴ�����
     input [31:0] mem_aluIn, wb_aluIn;//�������
     input [31:0] D;//���ڴ�ȡ����ֵ
     input [4:0] exe_rs, exe_rt;
     input wb_m2reg;

	 output [31:0] ealu;		//alu�������
	 output z;
     output mem_wreg;
     output [4:0] mem_d;
     output mem_m2reg;
     output mem_wmem;
     output [31:0] S;
     output [31:0] MEM_Alu;
	 
	 wire [31:0] alua,alub,sa;
     wire [1:0] sA, sB;//aluѡ���ź�
	 wire [31:0] wdi;//����д��Ĵ��������� 

	 assign sa={26'b0,eimm[9:5]};//��λλ��������

     assign sA = (mem_wregIn & exe_rs==mem_dIn) ? 2'b10 : //alu��һ��������ѡ�������ź�
                 (wb_wregIn & exe_rs==wb_dIn) ? 2'b11 :
                 (eshift) ? 2'b01 : 2'b00;
     assign sB = (ealuimm) ? 2'b01 :                    //alu�ڶ���������ѡ�������ź�
                 (mem_wregIn & exe_rt==mem_dIn) ? 2'b10 :
                 (wb_wregIn & exe_rt==wb_dIn) ? 2'b11 : 2'b00;

     mux32_2_1 select_wdi (mem_aluIn,D,wb_m2reg,wdi);
	 mux32_4_1 alu_ina (ea,sa,mem_aluIn,wb_aluIn,sA,alua);//ѡ��ALU a�˵�������Դ
	 mux32_4_1 alu_inb (eb,eimm,mem_aluIn,wdi,sB,alub);//ѡ��ALU b�˵�������Դ
	 //mux32_2_1 alu_ina (ea,sa,eshift,alua);//ѡ��ALU a�˵�������Դ
	 //mux32_2_1 alu_inb (eb,eimm,ealuimm,alub);//ѡ��ALU b�˵�������Դ
 	 alu al_unit (alua,alub,ealuc,ealu,z);//ALU
	 
    dff1 wreg2mem(exe_wreg, clk, clrn, mem_wreg);
    dff5 d2mem(exe_d, clk, clrn, mem_d);
    dff1 m2reg2mem(exe_m2reg, clk, clrn, mem_m2reg);
    dff1 wmem2mem(exe_wmem, clk, clrn, mem_wmem);
    dff32 rb2mem(eb, clk, clrn, S);
    dff32 alu2mem(ealu, clk, clrn, MEM_Alu);
endmodule
