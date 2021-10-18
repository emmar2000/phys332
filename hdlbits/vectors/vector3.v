module top_module (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z );//

    // assign { ... } = { ... };
    assign w = {a, b[4:2]}; // 5 from a + 3 from b
    assign x = {b[1:0], c, d[4]}; // 2 from b, 5 from c, 1 from d
    assign y = {d[3:0], e[4:1]}; // 4 from d, 4 from e
    assign z = {e[0], f, 2'b11}; // 1 from e, 5 from f, 11

endmodule
