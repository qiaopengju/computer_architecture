////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:58:17 06/04/2019
// Design Name:   ID_STAGE
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

module ID_STAGE_tb;

	// Inputs
	reg [31:0] pc4;
	reg [31:0] inst;
	reg [31:0] wdi;
	reg clk;
    reg clrn;
    reg rsrtequ;

	// Outputs
	wire [31:0] bpc;
	wire [31:0] jpc;
	wire [31:0] a;
	wire [31:0] b;
	wire [31:0] imm;
    wire [2:0] aluc;
    wire m2reg;
    wire wmem;
    wire aluimm;
    wire shift;

	// Instantiate the Unit Under Test (UUT)
	ID_STAGE uut (
        .pc4(pc4),
        .inst(inst),
        .wdi(wdi),
        .clk(clk),
        .clrn(clrn),
        .rsrtequ(rsrtequ),
        .bpc(bpc),
        .jpc(jpc),
        .a(a),
        .b(b),
        .imm(imm),
        .aluc(aluc),
        .m2reg(m2reg),
        .wmem(wmem),
        .aluimm(aluimm),
        .shift(shift)
	);
	initial begin
        $dumpfile("ID.vcd");
        $dumpvars(0, uut);

		// Initialize Inputs
        pc4=6'h06;
        inst=32'h3ffff0e8; //beq r7, r8, 6'h02
        wdi=6'h0f;
        clk=0;
        clrn=0;
        rsrtequ=1;
		
		#50;
        pc4=6'h02;
        inst=32'h00101464; //add r5, r3, r4
        rsrtequ=0;
	end
   
	always begin
		#50
		clk = ~clk;
	end
		   
endmodule

