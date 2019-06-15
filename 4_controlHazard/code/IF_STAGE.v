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
module IF_STAGE(clk,clrn,pcsource,bpc,jpc,if_pc4,id_pc4,if_inst,id_inst,PC,load_depen
    );
	 input clk, clrn; //时钟信号/复位信号
	 input [31:0] bpc,jpc;
	 input [1:0] pcsource;
     input load_depen;
	 
	 output [31:0] if_pc4, id_pc4, if_inst, id_inst;
	 output [31:0] PC;
	 
	 wire [31:0] pc;
	 wire [31:0] npc;
     wire [31:0] muxPc;
     wire dClk;
	 
     mux32_2_1 select_pc(npc, pc, load_depen, muxPc);//若没有load冒险，选择npc，否则，选择pc
 	 dff32 program_counter(muxPc,clk,clrn,pc);   //利用32位的D触发器实现PC; npc=>pc/pc=0
	 add32 pc_plus4(pc,32'h4,if_pc4);//32位加法器，用来计算PC+4; pc+4 => pc4
	 mux32_4_1 next_pc(if_pc4,bpc,jpc,32'b0,pcsource,npc);//根据pcsource信号选择下一条指令的地址; 重新算出npc
	 Inst_ROM inst_mem(pc,if_inst); //指令存储器; 通过pc取指令
	 
	 assign PC=pc;
     assign dClk = (load_depen == 1) ? 1 : clk;

     dff32 pc2id(if_pc4, dClk, clrn, id_pc4);        //时钟上升沿将pc4传给ID级
     dff32 inst2id(if_inst, dClk, clrn, id_inst);    //时钟上升沿将inst传给ID级
	 
endmodule
