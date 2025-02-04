module mux21_64bit (
    input [63:0] in0,  
    input [63:0] in1,  
    input sel,        // Selector signal (1-bit)
    output reg [63:0] out  
);

always @(*) begin
    case(sel)
        1'b0: out = in0;  // If sel is 0, output in0
        1'b1: out = in1;  // If sel is 1, output in1
        default: out = 64'h00000000; // Default case (safety)
    endcase
end

endmodule
