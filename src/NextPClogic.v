`timescale 1ns / 1ps

module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
    input [63:0] CurrentPC, SignExtImm64;
    input Branch, ALUZero, Uncondbranch;
    output reg [63:0] NextPC;

    reg [63:0] PCPlus4;
    reg [63:0] BranchTarget;
    
    always @(*) begin
        //(addition with constant)
        #1 PCPlus4 = CurrentPC + 64'd4;
        
        //(general addition)
        #2 BranchTarget = CurrentPC + (SignExtImm64 << 2);
        
        //(mux logic)
        #1
        if (Uncondbranch) begin
            //B - always take branch target
            NextPC = BranchTarget;
        end
        else if (Branch && ALUZero) begin
            //CB and condition is true
            NextPC = BranchTarget;
        end
        else begin
            // No branch or condition is false
            NextPC = PCPlus4;
        end
    end
endmodule