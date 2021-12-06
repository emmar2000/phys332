`timescale 1ns / 1ps

module count_seconds(
	input CLK100MHZ,
	output reg [7:0] LED
	);
	
	wire CLK_1Hz;
	clk_1HZ_1s clock_gate(CLK100MHZ, CLK_1Hz);
	
	always @(posedge CLK_1Hz) begin
		LED <= LED + 1;
	end
	
endmodule

module clk_1HZ_1s(
	input incoming_CLK100MHZ,
	output reg outgoing_CLK1HZ
	);
	
	// need to count 100M cycles 
	// log2(100M) = 26.6 -> 27 bit counter
	
	reg [26:0] ctr = 0;
	
	always @(posedge incoming_CLK100MHZ) begin
		if (ctr == 49_999_999) begin
			outgoing_CLK1HZ <= 1;
			ctr <= ctr + 1;
		end
		else if (ctr == 99_999_999) begin
			outgoing_CLK1HZ <= 0;
			ctr <= 0;
		end
		else begin
			ctr <= ctr + 1;
		end	
	end

endmodule