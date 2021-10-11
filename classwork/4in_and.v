`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// 

module example1(
    input [3:0] swt,
    output [1:0] led
    );
    wire a_in, b_in, c_in, d_in;
	wire out1, out2, out_final;
    assign a_in = swt[0];
    assign b_in = swt[1];
	assign c_in = swt[2];
	assign d_in = swt[3];
    assign led[0] = c_out;

    and2 g1(a_in, b_in, out1);
	and2 g2(c_in, d_in, out2);
	and2 fin(out1, out2, out_final);
    assign led[1] = swt[0] & swt[1];

endmodule 

module and2(
    input a,
    input b,
    output c
    );
    assign c = a & b;
endmodule
