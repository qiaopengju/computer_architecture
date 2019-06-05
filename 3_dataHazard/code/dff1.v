module dff1(d,clk,clrn,q
    );
	input d;
	input clk,clrn;
	output q;

    reg q;
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
