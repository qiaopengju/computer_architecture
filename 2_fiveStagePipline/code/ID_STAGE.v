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
	 input [31:0] pc4,inst;		//pc4-PC值用于计算jpc；inst-读取的指令；wdi-向寄存器写入的数据
	 input clk,clrn;		//clk-时钟信号；clrn-复位信号；
	 input rsrtequ;		//branch控制信号, 取决于zf
	 output [31:0] bpc,jpc,a,b,exe_imm;		//bpc-branch_pc；jpc-jump_pc；a-寄存器操作数a；b-寄存器操作数b；imm-立即数操作数
	 output [2:0] exe_aluc;		//ALU控制信号
	 output [1:0] pcsource;		//下一条指令地址选择
	 output wmem,exe_aluimm,exe_shift;		
     output exe_wreg;
     output [4:0] exe_d;
     output exe_m2reg, exe_wmem;
	 
     wire wmem;
	 wire wreg;
     wire shift;
	 wire [2:0] aluc;		//ALU控制信号
	 wire [4:0] rn;         //写回寄存器号
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
					 sext,pcsource,shift); //控制部件，用于求控制信号
			 
    mux5_2_1 des_reg_num (rd,rt,regrt,rn); //选择目的寄存器是来自于rd,还是rt
    Regfile rf (rs,rt,0,rn,1'b0,~clk,clrn,qa,qb);//ID级只读寄存器不写寄存器


    assign e=sext&inst[25];//符号拓展或0拓展
    assign ext16={16{e}};//符号拓展
    assign imm={ext16,inst[25:10]};         //将立即数进行符号拓展

    assign br_offset={imm[29:0],2'b00};		//计算偏移地址
    add32 br_addr (pc4,br_offset,bpc);		//beq,bne指令的目标地址的计算
    assign jpc={pc4[31:28],inst[25:0],2'b00};		//jump指令的目标地址的计算
	 
    /*将之后所有级需要用到的控制信号都在下一个时钟上升沿传递下去*/
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
