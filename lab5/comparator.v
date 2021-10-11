`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lab5
//////////////////////////////////////////////////////////////////////////////////
//
// Comparator: compares 2 2-bit numbers - A and B
// Output bits: e, f, g
// e: A = B
// f: A > B
// g: A < B

module comparator(
    input [3:0] SW,
     output [2:0] LED,
    );
	
	wire a1,a0,b1,b0;
	wire e,f,g;	
    
    assign a0 = SW[0];
    assign a1 = SW[1];
    assign b0 = SW[2];
    assign b1 = SW[3];
	
	assign LED[0] = e;
	assign LED[1] = f;
	assign LED[2] = g;
	
	assign e = (~a1 & ~a0 & ~b1 & ~b0) | (~a1 & a0 & ~b1 & b0) |
				(a1 & a0 & b1 & b0) | (a1 & ~a0 & b1 & ~b0);
	assign f = (a1 & ~b1) | (a1 & a0 & ~b0) | (a0 & ~b1 & ~b0);
	assign g = (~a1 & b1) | (~a0 & b1 & b0) | (~a1 & ~a0 & b0);
    
endmodule
