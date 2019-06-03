////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:58:17 05/17/2019
// Design Name:   IF_STAGE
// Module Name:   C:/Users/Lenovo/Desktop/verilog/cpu_5/stage1_IF_test.v
// Project Name:  cpu_5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IF_STAGE
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module IF_STAGE_tb;

	// Inputs
	reg clk;
	reg clrn;
	reg [1:0] pcsource;
	reg [31:0] bpc;
	reg [31:0] jpc;

	// Outputs
	wire [31:0] pc4;
	wire [31:0] inst;
	wire [31:0] PC;

	// Instantiate the Unit Under Test (UUT)
	IF_STAGE uut (
		.clk(clk), 
		.clrn(clrn), 
		.pcsource(pcsource), 
		.bpc(bpc), 
		.jpc(jpc), 
		.pc4(pc4), 
		.inst(inst), 
		.PC(PC)
	);
	initial begin
        $dumpfile("IF.vcd");
        $dumpvars(0, uut);

		// Initialize Inputs
		clk = 0;
		clrn = 0;
		pcsource = 0;
		bpc = 6'h03;
		jpc = 6'h04;
		
		#50; clrn = 1;
		#50; clk = ~clk;
		#100; pcsource = 1;
		#100; pcsource = 2;
		#100; pcsource = 3;
		#100; pcsource = 0;
	end
   
	always begin
		#50
		clk = ~clk;
	end
		   
endmodule

