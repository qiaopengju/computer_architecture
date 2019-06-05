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
        mem_m2reg, exe_wmem, mem_wmem, S, MEM_Alu
    );
    input clk, clrn;
	 input [31:0] ea,eb,eimm;		//ea-�ɼĴ��������Ĳ�����a��eb-�ɼĴ��������Ĳ�����b��eimm-������չ����������
	 input [2:0] ealuc;		//ALU������
	 input ealuimm,eshift;		//ALU����������Ķ�·ѡ����
     input exe_wreg;
     input [4:0] exe_d;
     input exe_m2reg;
     input exe_wmem;

	 output [31:0] ealu;		//alu�������
	 output z;
     output mem_wreg;
     output [4:0] mem_d;
     output mem_m2reg;
     output mem_wmem;
     output [31:0] S;
     output [31:0] MEM_Alu;
	 
	 wire [31:0] alua,alub,sa;

	 assign sa={26'b0,eimm[9:5]};//��λλ��������

	 mux32_2_1 alu_ina (ea,sa,eshift,alua);//ѡ��ALU a�˵�������Դ
	 mux32_2_1 alu_inb (eb,eimm,ealuimm,alub);//ѡ��ALU b�˵�������Դ
 	 alu al_unit (alua,alub,ealuc,ealu,z);//ALU
	 
    dff1 wreg2mem(exe_wreg, clk, clrn, mem_wreg);
    dff5 d2mem(exe_d, clk, clrn, mem_d);
    dff1 m2reg2mem(exe_m2reg, clk, clrn, mem_m2reg);
    dff1 wmem2mem(exe_wmem, clk, clrn, mem_wmem);
    dff32 rb2mem(eb, clk, clrn, S);
    dff32 alu2mem(ealu, clk, clrn, MEM_Alu);
endmodule
