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
	 input clk, clrn; //时钟信号/复位信号
	 input [31:0] bpc,jpc;
	 input [1:0] pcsource;
     input load_depen;
     input btaken;
     input [31:0] id_inst_in; //当前ID级INST
     input id_condition_jmp, exe_condition_jmp;
	 
	 output [31:0] if_pc4, id_pc4, if_inst, id_inst;
	 output [31:0] PC;
	 
	 wire [31:0] pc;
	 wire [31:0] npc;
     wire [31:0] muxPc;
     wire [31:0] inst;
     wire dClk;
	 
     mux32_2_1 select_pc(npc, pc, load_depen |
         id_condition_jmp, muxPc);//若没有load冒险或者条件跳转暂停暂停，选择npc，否则，选择pc
 	 dff32 program_counter(muxPc,clk,clrn,pc);   //利用32位的D触发器实现PC; npc=>pc/pc=0
	 add32 pc_plus4(pc,32'h4,if_pc4);//32位加法器，用来计算PC+4; pc+4 => pc4
	 mux32_4_1 next_pc(if_pc4,bpc,jpc,32'b0,pcsource,npc);//根据pcsource信号选择下一条指令的地址; 重新算出npc
	 Inst_ROM inst_mem(pc, inst); //指令存储器; 通过pc取指令

     assign if_inst = btaken | id_condition_jmp /*| exe_condition_jmp*/ ? 32'h00000000 : inst;
	 assign PC = pc;
     assign dClk = (load_depen /*| btaken*/) ? 1 : clk;

     dff32 pc2id(if_pc4, dClk, clrn, id_pc4);        //时钟上升沿将pc4传给ID级
     dff32 inst2id(if_inst, dClk, clrn, id_inst);    //时钟上升沿将inst传给ID级
     //dff1 btaken2z(1'b0, dClk, clrn, btaken);       //时钟上升沿将btaken清零
	 
endmodule
