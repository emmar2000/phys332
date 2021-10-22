`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module four_bit_add(
    input [7:0] SW,
    output [4:0] LED
    );
    wire a3, a2, a1, a0;
	wire b3, b2, b1, b0;
    wire sum3, sum2, sum1, sum0, c_out;
	wire out01, out12, out23;
    // global inputs
    assign a0 = SW[0];
	assign a1 = SW[1];
	assign a2 = SW[2];
	assign a3 = SW[3];
    assign b0 = SW[4];
	assign b1 = SW[5];
	assign b2 = SW[6];
	assign b3 = SW[7];
    
    // global outputs
    assign LED[0] = sum0;
    assign LED[1] = sum1;
	assign LED[2] = sum2;
	assign LED[3] = sum3;
	assign LED[4] = c_out;
	
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
