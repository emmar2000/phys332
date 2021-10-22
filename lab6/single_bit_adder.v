`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module single_bit_add(
    input [2:0] SW,
    output [1:0] LED
    );
    wire a, b, c_in;
    wire s, c_out;
    
    // global inputs
    assign a = SW[0];
    assign b = SW[1];
    assign c_in = SW[2];
    
    // global outputs
    assign LED[0] = s;
    assign LED[1] = c_out;
	
    assign c_out = (a & b) | (a & c_in) | (b & c_in);
    assign s = (~a & ~b & c_in) | (~a & b & ~c_in) | (a & b & c_in) | (a & ~b & ~c_in);
        
endmodule
