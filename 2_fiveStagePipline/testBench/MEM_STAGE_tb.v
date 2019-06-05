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

module MEM_STAGE_tb;

	// Inputs
    reg [31:0] datain;
    reg [31:0] addr;
    reg clk,we;

	// Outputs
    wire [31:0] dataout;

	// Instantiate the Unit Under Test (UUT)
	MEM_STAGE uut (
        .datain(datain),
        .addr(addr),
        .clk(clk),
        .we(we),
        .dataout(dataout)
	);
	initial begin
        $dumpfile("MEM.vcd");
        $dumpvars(0, uut);

		// Initialize Inputs
        datain=6'h01;
        addr=5'h04; //read ram[1]
        clk=0;
        we=0;

        #100
        addr=32'h00000001; //write 1 to ram[1]
        we=1;

        #100
        addr=5'h04; //read ram[1]
        we=0;
	end

	always begin
		#50
		clk = ~clk;
	end
endmodule

