`timescale 1ns / 1ps

module display_4bit_add(
	input [7:0] SW,
	output [7:0] AN,	
    output CA, CB, CC, CD, CE, CF, CG 
	);
	
	
	assign AN[0] = 0;
	assign AN[7:1] = {7{1'b1}};
	
    wire a3, a2, a1, a0;
	wire b3, b2, b1, b0;
	assign a0 = SW[0];
	assign a1 = SW[1];
	assign a2 = SW[2];
	assign a3 = SW[3];
    assign b0 = SW[4];
	assign b1 = SW[5];
	assign b2 = SW[6];
	assign b3 = SW[7];
	
	wire s3,s2,s1,s0, c_out;
    four_bit_add fa(a3,a2,a1,a0, b3,b2,b1,b0, s3,s2,s1,s0, c_out);
	devicedriver drive(s3, s2, s1, s0, CA, CB, CC, CD, CE, CF, CG);
	

endmodule

module devicedriver(
    input s3, s2, s1, s0,
    output CA, CB, CC, CD, CE, CF, CG 
    );
    
    // truth tables were designed for active low
	// so these indicate when the segment is off
    assign CA = (~s3 & ~s2 & ~s1 & s0) | (s2 & ~s1 & ~s0);
    assign CB = (s2 & ~s1 & s0) | (s2 & s1 & ~s0);
    assign CC = ~s2 & s1 & ~s0;
    assign CD = (s3 & s0) | (s2 & s1 & s0) | (s2 & ~s1 & ~s0) | (~s2 & ~s1 & s0);
    assign CE = s0 | (s2 & ~s1);
    assign CF = (s1 & s0) | (~s3 & ~s2 & s1) | (~s3 & ~s2 & s0);
    assign CG = (~s3 & ~s2 & ~s1) | (s2 & s1 & s0);
    
endmodule


module four_bit_add(
    input a3, a2, a1, a0,
	input b3, b2, b1, b0,
    output sum3, sum2, sum1, sum0,
	output c_out
    );
	
	// intermediate wires
	wire out01, out12, out23;
	
	single_bit_fulladder add0(a0, b0, 0, out01, sum0);
	single_bit_fulladder add1(a1, b1, out01, out12, sum1);
	single_bit_fulladder add2(a2, b2, out12, out23, sum2);
	single_bit_fulladder add3(a3, b3, out23, c_out, sum3);
        
endmodule

module single_bit_fulladder(
    input a,
    input b,
    input c_in,
    output c_out,
    output sum
    );
    assign c_out = (a & b) | (a & c_in) | (b & c_in);
    assign sum = (~a & ~b & c_in) | (~a & b & ~c_in) | (a & b & c_in) | (a & ~b & ~c_in);
endmodule
