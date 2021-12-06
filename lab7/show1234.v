`timescale 1ns / 1ps

module display1234(
	input CLK100MHZ,
	output [7:0] AN,
	output CA, CB, CC, CD, CE, CF, CG, DP
	);
	
	assign DP = 1; // active low - don't need it on
	
	wire [6:0] Cs;
	assign CA = Cs[6];
    assign CB = Cs[5];
    assign CC = Cs[4];
    assign CD = Cs[3];
    assign CE = Cs[2];
    assign CF = Cs[1];
    assign CG = Cs[0];
	
	
	// slow clock down so the display can keep up
	wire outgoing_CLK1KHZ;
    create_1KHZ_clock gate2(CLK100MHZ, outgoing_CLK1KHZ);    
	clockwork iterator(outgoing_CLK1KHZ, AN, Cs);
    	
	
endmodule

module clockwork(
	input clk,
	output reg [7:0] displays,
	output reg [6:0] segments // CA-CG
	);
	
	reg [1:0] ctr = 0; // we only need to represent 4 states
	// remember cathodes and anodes both are active low
	
	always @(posedge clk) begin
        if (ctr == 2'b00) begin
            // 1
            displays <= 8'b1111_0111;
            segments <= 7'b100_1111;
        end
        else if (ctr == 2'b01) begin
            // 2
            displays <= 8'b1111_1011;
            segments <= 7'b001_0010;
        end	
        else if (ctr == 2'b10) begin
            // 3
            displays <= 8'b1111_1101;
            segments <= 7'b000_0110;
        end
        else if (ctr == 2'b11) begin
            // 4
            displays <= 8'b1111_1110;
            segments <= 7'b100_1100;
        end
        else begin
            // This should never happen
            displays <= 8'b1111_1111;
            segments <= 7'b111_1111;
        end
        
        // We use all the states of the counter, so we can just let it overflow back to zero and not manually reset it
        if (ctr == 2'b11) begin
            ctr <= 0;
        end
        else begin
            ctr <= ctr + 1;
        end
           
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