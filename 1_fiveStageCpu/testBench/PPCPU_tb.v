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

module PPCPU_tb;

	// Inputs
	reg Clock, Resetn;

	// Outputs
	wire [31:0] PC, Inst, Alu_Result;

	// Instantiate the Unit Under Test (UUT)
	PPCPU uut (
        .Clock(Clock),
        .Resetn(Resetn),
        .PC(PC),
        .Inst(Inst),
        .Alu_Result(Alu_Result)
	);
	initial begin
        $dumpfile("PPCPU.vcd");
        $dumpvars(0, uut);

		// Initialize Inputs
        Clock=0;
        Resetn=0;

        #50;
        Resetn=1;
	end

    always begin
        #50
        Clock=~Clock;
    end
endmodule

