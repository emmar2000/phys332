`timescale 1ns / 1ps

module display_switches_hex(
	input CLK100MHZ,
	input [5:0] SW,
	output [7:0] AN,
	output CA, CB, CC, CD, CE, CF, CG, DP
	);
	
	assign DP = 1; // active low - don't need it on	
	
	// slow clock down so the display can keep up
	wire outgoing_CLK1KHZ;
    create_1KHZ_clock gate2(CLK100MHZ, outgoing_CLK1KHZ);
	
	wire [3:0] value;
	clockwork iterator(outgoing_CLK1KHZ, SW[5:0], AN, value);
	generate_7seg_bits getsegs(value[3], value[2], value[1], value[0], CA, CB, CC, CD, CE, CF, CG);
	
endmodule

module clockwork(
	input clk,
	input [5:0] sw,
	output reg [7:0] displays,
	output reg [3:0] number
	);
	
	reg ctr = 0; // we only need to represent 2 states - may not work, might be unhappy about this
	// remember cathodes and anodes both are active low
	
	always @(posedge clk) begin
        if (ctr == 0) begin
            // leading digit
            displays <= 8'b1111_1101;
            number <= {{2{1'b0}}, sw[5:4]}; // we only take in 2 switches, so pad with 2 leading 0s
        end
        else if (ctr == 1) begin
            // last digit
            displays <= 8'b1111_1110;
            number <= sw[3:0];
        end	

        else begin
            // This should never happen
            displays <= 8'b1111_1111;
            number <= {{4{1'b0}}};
        end
        
        // We use all the states of the counter, so we can just let it overflow back to zero and not manually reset it       
        ctr <= ctr + 1;    
	end
	
endmodule

module generate_7seg_bits(
    input s3, s2, s1, s0, 
    output da, db, dc, dd, de, df, dg
	);
	
	// Taken from the Github
	// I like the Karnaugh maps better, but I don't want to redo all of them to include the letters
	// So I just fixed up this version instead
	
    wire zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen;
    assign zero     = ~s3&~s2&~s1&~s0;
    assign one      = ~s3&~s2&~s1& s0;
    assign two      = ~s3&~s2& s1&~s0;
    assign three    = ~s3&~s2& s1& s0;
    assign four     = ~s3& s2&~s1&~s0;
    assign five     = ~s3& s2&~s1& s0;
    assign six      = ~s3& s2& s1&~s0;
    assign seven    = ~s3& s2& s1& s0;
    assign eight    =  s3&~s2&~s1&~s0;
    assign nine     =  s3&~s2&~s1& s0;
    assign ten      =  s3&~s2& s1&~s0; // A
    assign eleven   =  s3&~s2& s1& s0; // b
    assign twelve   =  s3& s2&~s1&~s0; // C
    assign thirteen =  s3& s2&~s1& s0; // d
    assign fourteen =  s3& s2& s1&~s0; // E
    assign fifteen  =  s3& s2& s1& s0; // F
    
    assign da = ~(zero | two | three | five | six | seven | eight | nine | ten | twelve | fourteen | fifteen);
    assign db = ~(zero | one | two | three | four | seven | eight | nine | ten | thirteen);
    assign dc = ~(zero | one | three | four | five | six | seven | eight | nine | ten | eleven | thirteen) ;
    assign dd = ~(zero | two | three | five | six | eight | eleven | twelve | thirteen | fourteen) ;
    assign de = ~(zero | two | six | eight | ten | eleven | twelve | thirteen | fourteen | fifteen) ;
    assign df = ~(zero | four | five | six | eight | nine | ten | eleven | twelve | fourteen | fifteen) ;
    assign dg = ~(two | three | four | five | six | eight | nine | ten | eleven | thirteen | fourteen | fifteen) ;
    
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