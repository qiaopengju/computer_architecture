`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:46:15 05/15/2019 
// Design Name: 
// Module Name:    Control_Unit 
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
module Control_Unit(rsrtequ,func,
	             op,wreg,m2reg,wmem,aluc,regrt,aluimm,
					 sext,pcsource,shift
    );
	 input rsrtequ; 		//判断ALU输出结果是否为0：if(r=0)rsrtequ=1；
	 input [5:0] func,op;		//指令中相应控制码字段
	 output wreg,m2reg,wmem,regrt,aluimm,sext,shift;
     /*
     * wreg:寄存器写信号
     * m2reg:为1，将存储器内容写入reg，否则将ALU结果写入寄存器
     * wmem:是否写memory
     * regrt:1:rt/0:rd
     * aluimm:alub是否为imm
     * sext:为1是符号扩展
     */
	 output [2:0] aluc;		//ALU控制码
	 output [1:0] pcsource;		//PC多路选择器控制码
	 
	 reg [2:0] aluc;
	 reg [1:0] pcsource;
	 
	 wire i_add,i_and,i_or,i_xor,i_sll,i_srl,i_sra;            //寄存器运算标志
	 wire i_addi,i_andi,i_ori,i_xori;		//立即数运算标志
	 wire i_lw,i_sw;		//存储器运算标志
	 wire i_beq,i_bne;		//branch运算标志
	 wire i_j;		//jump运算标志

    ////////////////////////////////////////////运算标志的生成/////////////////////////////////////////////////////////
	 and(i_add,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],~func[1],func[0]);		//add运算标志
	 and(i_and,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],~func[1],func[0]);		//and运算标志
	 and(i_or,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],func[1],~func[0]);		//or运算标志
	 and(i_xor,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],func[2],~func[1],~func[0]);		//xor运算标志
	 
	 and(i_sra,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],~func[1],func[0]);		//sra运算标志
	 and(i_srl,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],~func[0]);		//srl运算标志
	 and(i_sll,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],func[0]);		//sll运算标志
	 
	 and(i_addi,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);		//addi运算标志
	 and(i_andi,~op[5],~op[4],op[3],~op[2],~op[1],op[0]);		//andi运算标志
	 and(i_ori,~op[5],~op[4],op[3],~op[2],op[1],~op[0]);		//ori运算标志
	 and(i_xori,~op[5],~op[4],op[3],op[2],~op[1],~op[0]);		//xori运算标志
	 
	 and(i_lw,~op[5],~op[4],op[3],op[2],~op[1],op[0]);		//load运算标志
	 and(i_sw,~op[5],~op[4],op[3],op[2],op[1],~op[0]);		//store运算标志

	 and(i_beq,~op[5],~op[4],op[3],op[2],op[1],op[0]);		//beq运算标志
	 and(i_bne,~op[5],op[4],~op[3],~op[2],~op[1],~op[0]);		//bne运算标志

	 and(i_j,~op[5],op[4],~op[3],~op[2],op[1],~op[0]);		//jump运算标志

	 wire i_rs=i_add|i_and|i_or|i_xor|i_addi|i_andi|i_ori|i_xori|i_lw|i_beq|i_bne;		//rs字段（源操作数）使用标志
	 wire i_rt=i_add|i_and|i_or|i_xor|i_sra|i_srl|i_sll|i_sw|i_beq|i_bne;		//rt字段（源操作数）使用标志
	 
    ////////////////////////////////////////////控制信号的生成/////////////////////////////////////////////////////////
    assign wreg=i_add|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_addi|i_andi|i_ori|i_xori|i_lw;		//寄存器写信号
	 assign regrt=i_addi|i_andi|i_ori|i_xori|i_lw;    //regrt为1时目的寄存器是rt，否则为rd
	 assign m2reg=i_lw;  //运算结果写回寄存器：为1时将存储器数据写入寄存器，否则将ALU结果写入寄存器
	 assign shift=i_sll|i_srl|i_sra;//ALUa数据输入选择：为1时ALUa输入端使用移位位数字段inst[19:15]
	 assign aluimm=i_addi|i_andi|i_ori|i_xori|i_lw|i_sw;//ALUb数据输入选择：为1时ALUb输入端使用立即数
 	 assign sext=i_addi|i_lw|i_sw|i_beq|i_bne;//为1时符号拓展，否则零拓展
 	 assign wmem=i_sw;//存储器写信号：为1时写存储器，否则不写

	always @(*)
		case (op)
			6'b000000: begin aluc<=3'b000; pcsource<=2'b00; end		//+; pc=pc+4
			6'b000001: 
				case (func[2:0])
					3'b001: begin aluc<=3'b001; pcsource<=2'b00; end		//and; pc=pc+4
					3'b010: begin aluc<=3'b010; pcsource<=2'b00; end		//or; pc=pc+4
					3'b100: begin aluc<=3'b011; pcsource<=2'b00; end		//xor; pc=pc+4
				endcase
			6'b000010: 
				case (func[2:0])
					3'b010: begin aluc<=3'b100; pcsource<=2'b00; end		//srl; pc=pc+4
					3'b011: begin aluc<=3'b101; pcsource<=2'b00; end		//sll; pc=pc+4
				endcase				
			6'b000101: begin aluc<=3'b000; pcsource<=2'b00; end		//addi; pc=pc+4
			6'b001001: begin aluc<=3'b001; pcsource<=2'b00; end		//andi; pc=pc+4
			6'b001010: begin aluc<=3'b010; pcsource<=2'b00; end		//ori; pc=pc+4
			6'b001100: begin aluc<=3'b011; pcsource<=2'b00; end		//xori; pc=pc+4

			6'b001101: begin aluc<=3'b000; pcsource<=2'b00; end		//load; pc=pc+4
			6'b001110: begin aluc<=3'b000; pcsource<=2'b00; end		//store; pc=pc+4
			6'b001111: begin aluc<=3'b110; if(rsrtequ) pcsource<=2'b01; else pcsource<=2'b00; end		//beq; pc=bpc
			6'b010000: begin aluc<=3'b110; if(!rsrtequ) pcsource<=2'b01; else pcsource<=2'b00; end		//beq; pc=bpc
			6'b010010: pcsource<=2'b10;		//beq; pc=jpc
		endcase

endmodule
