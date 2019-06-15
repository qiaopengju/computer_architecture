//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:40:58 05/15/2019 
// Design Name: 
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
module dff15(d,clk,clrn,q
    );
	 input [14:0] d;
	 input clk,clrn;
	 output [14:0] q;
    reg [14:0] q;
    always @ (negedge clrn or posedge clk) //clrn下降沿或clk上升沿触发，若clrn=0，清零，否则q<=d
	 if(clrn==0)
	     begin
		      q<=0;
		  end
    else	
        begin		      
		      q<=d;
		  end	 
endmodule
