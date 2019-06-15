module dff5(d,clk,clrn,q
    );
	input [4:0] d;
	input clk,clrn;
	output [4:0] q;

    reg [4:0] q;
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
