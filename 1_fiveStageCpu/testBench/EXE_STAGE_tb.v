////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:58:17 06/04/2019
// Design Name:   EXE_STAGE
// Project Name:  cpu_5
// Target Device:  
// Tool versions:  
// Description: 
//
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module EXE_STAGE_tb;

	// Inputs
	reg [31:0] ea,eb,eimm;	//ea-由寄存器读出的操作数a；eb-由寄存器读出的操作数a；eimm-经过扩展的立即数；
    reg [2:0] ealuc;		//ALU控制码
    reg ealuimm,eshift;		//ALU输入操作数的多路选择器

	// Outputs
    wire  [31:0] ealu;		//alu操作输出
    wire  z;

	// Instantiate the Unit Under Test (UUT)
	EXE_STAGE uut (
        .ea(ea),
        .eb(eb),
        .eimm(eimm),
        .ealuc(ealuc),
        .ealuimm(ealuimm),
        .eshift(eshift),
        .ealu(ealu),
        .z(z)
	);
	initial begin
        $dumpfile("EXE.vcd");
        $dumpvars(0, uut);

		// Initialize Inputs
        ea=6'h00;
        eb=6'h01;
        eimm=6'h02;
        ealuc=3'b000;
        eshift=0;
        ealuimm=0;
		
		#50;
        ealuimm=1;
		#200;
	end
endmodule

