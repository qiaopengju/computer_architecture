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

module WB_STAGE_tb;

	// Inputs
    reg [31:0] r_alu; //ALU result
    reg [31:0] m_o;  //Read from memory
    reg m2reg;

	// Outputs
    wire [31:0] wdi;

	// Instantiate the Unit Under Test (UUT)
	WB_STAGE uut (
        .r_alu(r_alu),
        .m_o(m_o),
        .m2reg(m2reg),
        .wdi(wdi)
	);
	initial begin
        $dumpfile("WB.vcd");
        $dumpvars(0, uut);

		// Initialize Inputs
        r_alu=0;
        m_o=1;
        m2reg=0;

        #50; m2reg=1;
        #200;
	end
endmodule

