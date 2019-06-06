`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:52:03 05/15/2019 
// Design Name: 
// Module Name:    MEM_STAGE 
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
module MEM_STAGE(we,MEM_Alu,addr,clk,D,
        mem_wreg, wb_wreg, clrn, mem_d, wb_d, mem_m2reg, wb_m2reg, WB_Alu
    );
	 input [31:0] MEM_Alu;
	 input [31:0] addr;
	 input clk,we;
     input mem_wreg;
     input clrn;
     input [4:0] mem_d;
     input mem_m2reg;

     output wb_wreg;
     output [4:0] wb_d;
     output wb_m2reg;
     output [31:0] D;
     output [31:0] WB_Alu;

	 wire [31:0] dataout;
	 reg [31:0] ram [0:31];
	 assign dataout=ram[addr[6:2]];		//读出常有效
	 always @(posedge clk)begin
         if(we)ram[addr[6:2]]=MEM_Alu;
	 end
	 
	 integer i;
	 initial begin		//存储器初始化
         for(i=0;i<32;i=i+1)		
            ram[i]=0;
		 ram[5'h01]<=32'h00000001;
		 ram[5'h02]<=32'h00000002;
		 ram[5'h03]<=32'h00000003;
		 ram[5'h04]<=32'h00000004;		  
		 ram[5'h05]<=32'h00000005;
		 ram[5'h06]<=32'h00000006;
		 ram[5'h07]<=32'h00000007;
		 ram[5'h08]<=32'h00000008;		  
     end

    dff1 wreg2wb(mem_wreg, clk, clrn, wb_wreg);
    dff5 d2wb(mem_d, clk, clrn, wb_d);
    dff1 m2reg2wb(mem_m2reg, clk, clrn, wb_m2reg);
    dff32 dataout2wb(dataout, clk, clrn, D);
    dff32 aluResult2wb(MEM_Alu, clk, clrn, WB_Alu);
endmodule
