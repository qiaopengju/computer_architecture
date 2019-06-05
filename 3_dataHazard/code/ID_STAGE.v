`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:48 05/15/2019 
// Design Name: 
// Module Name:    ID_STAGE 
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
module ID_STAGE(pc4,inst,
              clk,clrn,bpc,jpc,pcsource,
				  exe_aluc,exe_aluimm,a,b,exe_imm,
				  exe_shift,rsrtequ,
                  exe_wreg, exe_d, exe_m2reg, exe_wmem
    );
	 input [31:0] pc4,inst;		//pc4-PCֵ���ڼ���jpc��inst-��ȡ��ָ�wdi-��Ĵ���д�������
	 input clk,clrn;		//clk-ʱ���źţ�clrn-��λ�źţ�
	 input rsrtequ;		//branch�����ź�, ȡ����zf
	 output [31:0] bpc,jpc,a,b,exe_imm;		//bpc-branch_pc��jpc-jump_pc��a-�Ĵ���������a��b-�Ĵ���������b��imm-������������
	 output [2:0] exe_aluc;		//ALU�����ź�
	 output [1:0] pcsource;		//��һ��ָ���ַѡ��
	 output wmem,exe_aluimm,exe_shift;		
     output exe_wreg;
     output [4:0] exe_d;
     output exe_m2reg, exe_wmem;
	 
     wire wmem;
	 wire wreg;
     wire shift;
	 wire [2:0] aluc;		//ALU�����ź�
	 wire [4:0] rn;         //д�ؼĴ�����
	 wire [5:0] op,func;
	 wire [4:0] rs,rt,rd;
	 wire [31:0] qa,qb,br_offset;
	 wire [31:0] imm;
	 wire [15:0] ext16;
	 wire regrt,sext,e;
     wire m2reg;
	 
	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	 Control_Unit cu(rsrtequ,func,op,wreg,m2reg,wmem,aluc,regrt,aluimm,
					 sext,pcsource,shift); //���Ʋ���������������ź�
			 
    mux5_2_1 des_reg_num (rd,rt,regrt,rn); //ѡ��Ŀ�ļĴ�����������rd,����rt
    Regfile rf (rs,rt,0,rn,1'b0,~clk,clrn,qa,qb);//ID��ֻ���Ĵ�����д�Ĵ���


    assign e=sext&inst[25];//������չ��0��չ
    assign ext16={16{e}};//������չ
    assign imm={ext16,inst[25:10]};         //�����������з�����չ

    assign br_offset={imm[29:0],2'b00};		//����ƫ�Ƶ�ַ
    add32 br_addr (pc4,br_offset,bpc);		//beq,bneָ���Ŀ���ַ�ļ���
    assign jpc={pc4[31:28],inst[25:0],2'b00};		//jumpָ���Ŀ���ַ�ļ���
	 
    /*��֮�����м���Ҫ�õ��Ŀ����źŶ�����һ��ʱ�������ش�����ȥ*/
    dff1 wreg2exe(wreg, clk, clrn, exe_wreg);
    dff5 d2exe(rn, clk, clrn, exe_d);
    dff1 m2reg2exe(m2reg, clk, clrn, exe_m2reg);
    dff1 wmem2exe(wmem, clk, clrn, exe_wmem);
    dff3 aluc2exe(aluc, clk, clrn, exe_aluc);
    dff1 aluimm2exe(aluimm, clk, clrn, exe_aluimm);
    dff32 a2exe(qa, clk , clrn, a);
    dff32 b2exe(qb, clk , clrn, b);
    dff32 imm2exe(imm, clk , clrn, exe_imm);
    dff1 shift2exe(shift, clk, clrn, exe_shift);
endmodule
