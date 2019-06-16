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
              clk,clrn,jpc,pcsource,
				  exe_aluc,exe_aluimm,a,b,exe_imm,
				  exe_shift,rsrtequ,
                  exe_wreg, exe_d, exe_m2reg, exe_wmem, load_depen, d,
                  exe_alu_type, exe_rs, exe_rt, exe_m2regIn, exe_wregIn,
                  wdi, wb_d, wb_wreg, btaken, id_condition_jmp, exe_condition_jmp,
                  exe_condition_jmp_in, exe_beq, exe_bne, exe_beq_in, exe_bne_in, exe_bpc
    );
	 input [31:0] pc4,inst;		//pc4-PC值用于计算jpc；inst-读取的指令；wdi-向寄存器写入的数据
	 input clk,clrn;		//clk-时钟信号；clrn-复位信号；
	 input rsrtequ;		//branch控制信号, 取决于zf
     input [4:0] d;     //此时的exe_d
     input exe_m2regIn, exe_wregIn;
     input [31:0] wdi;
     input [4:0] wb_d;
     input wb_wreg;
     input exe_condition_jmp_in;
     input exe_beq_in, exe_bne_in;

	 output [31:0] exe_bpc,jpc,a,b,exe_imm;		//bpc-branch_pc；jpc-jump_pc；a-寄存器操作数a；b-寄存器操作数b；imm-立即数操作数
	 output [2:0] exe_aluc;		//ALU控制信号
	 output [1:0] pcsource;		//下一条指令地址选择
	 output wmem,exe_aluimm,exe_shift;		
     output exe_wreg;
     output [4:0] exe_d;
     output exe_m2reg, exe_wmem;
     output [14:0] exe_alu_type;
	 output [4:0] exe_rs, exe_rt;
     output load_depen;
     output btaken;
     output id_condition_jmp;     //条件跳转
     output exe_condition_jmp;
     output exe_beq, exe_bne;
	 
     wire wmem;
	 wire wreg;
     wire aluimm;
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
     wire [14:0] alu_type;
     wire idRs1IsReg, idRs2IsReg;
     wire dClk;
     wire [1:0] tmp_pcsource;
     wire [31:0] bpc;
	 
	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	 Control_Unit cu(rsrtequ,func,op,wreg,m2reg,wmem,aluc,regrt,aluimm,
					 sext,tmp_pcsource,shift, alu_type); //控制部件，用于求控制信号
			 
    mux5_2_1 des_reg_num (rd,rt,regrt,rn); //选择目的寄存器是来自于rd,还是rt
    Regfile rf (rs,rt,wdi,wb_d,wb_wreg,~clk,clrn,qa,qb);//ID级只读寄存器不写寄存器
    add32 br_addr (pc4,br_offset,bpc);		//beq,bne指令的目标地址的计算


    assign e=sext&inst[25];//符号拓展或0拓展
    assign ext16={16{e}};//符号拓展
    assign imm={ext16,inst[25:10]};         //将立即数进行符号拓展

    //assign br_offset=/*{imm[29:0],2'b00}*/{16'h0000, inst[25:10]};		//计算偏移地址
    assign br_offset={imm[29:0], 2'b00};
    assign jpc={pc4[31:28],inst[25:0],2'b00};		//jump指令的目标地址的计算

    assign idRs1IsReg =alu_type[0] | alu_type[1] | alu_type[2] |
        alu_type[3] | alu_type[6] | alu_type[7] | alu_type[8] |
        alu_type[9] | alu_type[10] | alu_type[11];
    assign idRs2IsReg = alu_type[0] | alu_type[1] | alu_type[2] |
        alu_type[3] | alu_type[4] | alu_type[5]; 

	 
    assign load_depen = (rs==d & (exe_m2reg & exe_wreg) & idRs1IsReg) | //判断load冒险
        (rt==d & (exe_m2reg & exe_wreg) & idRs2IsReg) |
        (rn==d & (exe_m2reg & exe_wreg));
    assign btaken = alu_type[14] | (exe_beq_in&rsrtequ) | (exe_bne_in&~rsrtequ); //判断跳转
    assign id_condition_jmp = alu_type[12] | alu_type[13]; //是否是条件跳转
    assign pcsource = exe_condition_jmp_in&btaken ? 2'b01 : id_condition_jmp ? 2'b00 : tmp_pcsource;

    //assign dClk = (load_depen == 1) ? 1 : clk;
    assign dClk=clk;
    /*将之后所有级需要用到的控制信号都在下一个时钟上升沿传递下去*/
    dff1 wreg2exe(wreg, dClk, clrn, exe_wreg);
    dff5 d2exe(rn, dClk, clrn, exe_d);
    dff1 m2reg2exe(m2reg, dClk, clrn, exe_m2reg);
    dff1 wmem2exe(wmem, dClk, clrn, exe_wmem);
    dff3 aluc2exe(aluc, dClk, clrn, exe_aluc);
    dff1 aluimm2exe(aluimm, dClk, clrn, exe_aluimm);
    dff32 a2exe(qa, dClk , clrn, a);
    dff32 b2exe(qb, dClk , clrn, b);
    dff32 imm2exe(imm, dClk , clrn, exe_imm);
    dff1 shift2exe(shift, dClk, clrn, exe_shift);
    dff15 alutype2exe(alu_type, dClk, clrn, exe_alu_type);
    dff5 rs2exe(rs, dClk, clrn, exe_rs);
    dff5 rt2exe(rt, dClk, clrn, exe_rt);
    dff1 conditionJmp2exe(id_condition_jmp, dClk, clrn, exe_condition_jmp);
    dff1 beq2exe(alu_type[12], dClk, clrn, exe_beq);
    dff1 bne2exe(alu_type[13], dClk, clrn, exe_bne);
    dff32 bpc2exe(bpc, dClk, clrn, exe_bpc);
endmodule
