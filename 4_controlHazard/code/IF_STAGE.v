//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:34:26 05/14/2019 
// Design Name: 
// Module Name:    IF_STAGE 
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
module IF_STAGE(clk,clrn,pcsource,bpc,jpc,if_pc4,id_pc4,if_inst,id_inst,PC,load_depen,btaken, id_inst_in,
    id_condition_jmp, exe_condition_jmp
    );
	 input clk, clrn; //ʱ���ź�/��λ�ź�
	 input [31:0] bpc,jpc;
	 input [1:0] pcsource;
     input load_depen;
     input btaken;
     input [31:0] id_inst_in; //��ǰID��INST
     input id_condition_jmp, exe_condition_jmp;
	 
	 output [31:0] if_pc4, id_pc4, if_inst, id_inst;
	 output [31:0] PC;
	 
	 wire [31:0] pc;
	 wire [31:0] npc;
     wire [31:0] muxPc;
     wire [31:0] inst;
     wire dClk;
	 
     mux32_2_1 select_pc(npc, pc, load_depen |
         id_condition_jmp, muxPc);//��û��loadð�ջ���������ת��ͣ��ͣ��ѡ��npc������ѡ��pc
 	 dff32 program_counter(muxPc,clk,clrn,pc);   //����32λ��D������ʵ��PC; npc=>pc/pc=0
	 add32 pc_plus4(pc,32'h4,if_pc4);//32λ�ӷ�������������PC+4; pc+4 => pc4
	 mux32_4_1 next_pc(if_pc4,bpc,jpc,32'b0,pcsource,npc);//����pcsource�ź�ѡ����һ��ָ��ĵ�ַ; �������npc
	 Inst_ROM inst_mem(pc, inst); //ָ��洢��; ͨ��pcȡָ��

     assign if_inst = btaken | id_condition_jmp /*| exe_condition_jmp*/ ? 32'h00000000 : inst;
	 assign PC = pc;
     assign dClk = (load_depen /*| btaken*/) ? 1 : clk;

     dff32 pc2id(if_pc4, dClk, clrn, id_pc4);        //ʱ�������ؽ�pc4����ID��
     dff32 inst2id(if_inst, dClk, clrn, id_inst);    //ʱ�������ؽ�inst����ID��
     //dff1 btaken2z(1'b0, dClk, clrn, btaken);       //ʱ�������ؽ�btaken����
	 
endmodule
