
`timescale 1ns / 1ps

module top_level(
    input CLK100MHZ,
    output [1:0] LED,
    output [2:1] JD
    );    
    
    wire outgoing_CLK1KHZ;
    create_1KHZ_clock   gate2 (CLK100MHZ,outgoing_CLK1KHZ);
     write_leds writer(outgoing_CLK1KHZ, LED, JD);
    
    // Note, if you run this with the 100MHZ clock, the display is messed up.  
    // Anode PNP transistors  (~35+ns to switch?) might not be fast enough to keep up?
   
    
endmodule

module write_leds(input CLK,
    output reg [1:0] LED,
    output reg [2:1] JD
    );
	
	// We have a 1 kHz clock - need to count 3 seconds for one LED and 3 ms for the other

	reg [11:0] slow_ctr = 0; // need 4096 space to be able to count to 3000
    reg [1:0] fast_ctr=0;
    
    always @(posedge CLK) begin
		
		if (slow_ctr == 1999) begin // 2000 - switch from on to off
			LED[1] = 0;
			JD[2] = 0;
		end
		else if (slow_ctr == 2999) begin // 3000 - switch back on
			LED[1] = 1;
			JD[2] = 1;
			slow_ctr = 0;
		end

		if (fast_ctr == 1) begin
		    JD[1] = 0;
			LED[0] = 0;
		end
		else if (fast_ctr == 3) begin
		    JD[1] = 1;
			LED[0] = 1;
			fast_ctr = 0;
		end
		
        // update the counter
        fast_ctr <= fast_ctr + 1;          
		slow_ctr <= slow_ctr + 1;  			
         
    end
    
endmodule

module create_1KHZ_clock(
    input incoming_CLK100MHZ,
    output reg outgoing_CLK1KHZ
    );
    
    // 100MHZ is 10ns cycles.  If I want 1KHZ output, I need to count 100M/1K = 1e5 cycles = 100_000 cycles
    // 2^17 = 131_072
    reg [16:0] ctr=0;
    
    always @ (posedge incoming_CLK100MHZ) begin
        if(ctr==49_999) begin
            outgoing_CLK1KHZ <= 1'b0;
            ctr <= ctr + 1;            
        end else if(ctr==99_999) begin
            outgoing_CLK1KHZ <= 1'b1;
            ctr <= 0;
        end else begin
            ctr <= ctr + 1;
        end         
    end
endmodule
