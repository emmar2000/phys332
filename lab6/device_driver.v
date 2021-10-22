module devicedriver(
    input [3:0] SW,
    output [7:0] AN, 
    output CA, CB, CC, CD, CE, CF, CG 
    );
    
    wire s3, s2, s1, s0;    
    assign s3 = SW[3];
    assign s2 = SW[2];
    assign s1 = SW[1];
    assign s0 = SW[0];
        
    // active low
    assign AN[0] = 0;
    assign AN[1] = 1;
    assign AN[2] = 1;
    assign AN[3] = 1;
    assign AN[4] = 1;
    assign AN[5] = 1;
    assign AN[6] = 1;
    assign AN[7] = 1;
    
    // truth tables were designed for active low
    assign CA = (~s3 & ~s2 & ~s1 & s0) | (s2 & ~s1 & ~s0);
    assign CB = (s2 & ~s1 & s0) | (s2 & s1 & ~s0);
    assign CC = ~s2 & s1 & ~s0;
    assign CD = (s3 & s0) | (s2 & s1 & s0) | (s2 & ~s1 & ~s0) | (~s2 & ~s1 & s0);
    assign CE = s0 | (s2 & ~s1);
    assign CF = (s1 & s0) | (~s3 & ~s2 & s1) | (~s3 & ~s2 & s0);
    assign CG = (~s3 & ~s2 & ~s1) | (s2 & s1 & s0);
    
endmodule
