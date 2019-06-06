`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:26 05/16/2019 
// Design Name: 
// Module Name:    WB_STAGE 
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
module WB_STAGE(clk,clrn,r_alu,m_o,m2reg,
        wb_wreg,wb_d, wdi
    );
    input clk, clrn;
	input [31:0] r_alu; //ALU result
	input [31:0] m_o;  //Read from memory
    input [4:0] wb_d;
	input m2reg;
    input wb_wreg;

	output [31:0] wdi;
	
	mux32_2_1 wb_stage (r_alu, m_o, m2reg, wdi);
    //Regfile rf (5'h0,5'h0,wdi,wb_d,wb_wreg,~clk,clrn,tmp,tmp);//wreg=1时回写register

endmodule
