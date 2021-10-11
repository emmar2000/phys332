`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lab5
//////////////////////////////////////////////////////////////////////////////////


module lab5(
    input [3:0] SW,
     output [3:0] LED,
     output LED17_B,
     output LED17_G,
     output LED17_R
    );
    
    assign LED[0] = SW[0];
    assign LED[1] = SW[1];
    assign LED[2] = SW[2];
    assign LED[3] = SW[3];
    
    assign LED17_B = SW[0] & SW[1];
    assign LED17_G = SW[0]& SW[2];
    assign LED17_R = SW[0] & SW[3];
    
endmodule
