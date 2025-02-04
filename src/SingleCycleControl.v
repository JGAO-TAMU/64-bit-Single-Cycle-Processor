
module control(
    output reg reg2loc,
    output reg alusrc,
    output reg mem2reg,
    output reg regwrite,
    output reg memread,
    output reg memwrite,
    output reg branch,
    output reg uncond_branch,
    output reg [3:0] aluop,
    output reg [1:0] signop,
    output reg [1:0] shamt,
    output reg movz,
    input [10:0] opcode
);

always @(*)
begin
    casez (opcode)

        /* Add cases here for each instruction your processor supports */
        // R-TYPE AND
        11'b?0001010???: begin
            reg2loc       <= 1'b0; // Register to local
            alusrc        <= 1'b0; // ALU input source
            mem2reg       <= 1'b0; // memory to register
            regwrite      <= 1'b1; // write to register
            memread       <= 1'b0; // read from register
            memwrite      <= 1'b0; // write to memory
            branch        <= 1'b0; // CBZ
            uncond_branch <= 1'b0; // unconditional branch
            aluop         <= 4'b0000; // ALU opcode
            signop        <= 2'bxx; // sign extender opcode
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end

        // R-TYPE OR
        11'b?0101010???: begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b0;
            mem2reg       <= 1'b0;
            regwrite      <= 1'b1;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'b0001;
            signop        <= 2'bxx;
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end

        // R-TYPE ADD
        11'b?0?01011???: begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b0;
            mem2reg       <= 1'b0;
            regwrite      <= 1'b1;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'b0010;
            signop        <= 2'bxx;
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end

        // R-TYPE SUB
        11'b?1?01011???: begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b0;
            mem2reg       <= 1'b0;
            regwrite      <= 1'b1;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'b0110;
            signop        <= 2'bxx;
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end

        11'b?1?10001???: // I-TYPE SUB
        begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b1; // 1 to get from sign extender
            mem2reg       <= 1'b0; 
            regwrite      <= 1'b1; 
            memread       <= 1'b0; 
            memwrite      <= 1'b0; 
            branch        <= 1'b0; 
            uncond_branch <= 1'b0; 
            aluop         <= 4'b0110;
            signop        <= 2'b00; // opcode for I-type in sign extender
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end
        11'b?0?10001???: // I-TYPE ADD
        begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b1; // 1 to get from sign extender
            mem2reg       <= 1'b0; 
            regwrite      <= 1'b1; 
            memread       <= 1'b0; 
            memwrite      <= 1'b0; 
            branch        <= 1'b0; 
            uncond_branch <= 1'b0; 
            aluop         <= 4'b0010;
            signop        <= 2'b00; // opcode for I-type in sign extender
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end
        11'b?011010????: //conditional branch 
        begin
            reg2loc       <= 1'b1;
            alusrc        <= 1'b0;
            mem2reg       <= 1'bx; 
            regwrite      <= 1'b0; 
            memread       <= 1'b0; 
            memwrite      <= 1'b0; 
            branch        <= 1'b1; 
            uncond_branch <= 1'b0; 
            aluop         <= 4'b0111; // opcode for passB
            signop        <= 2'b11; // opcode for CBZ in sign extender
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end
        11'b?00101?????: // uncond branch 
        begin
            reg2loc       <= 1'bx;
            alusrc        <= 1'bx;
            mem2reg       <= 1'bx; 
            regwrite      <= 1'b0; 
            memread       <= 1'b0; 
            memwrite      <= 1'b0; 
            branch        <= 1'bx; 
            uncond_branch <= 1'b1; 
            aluop         <= 4'bxxxx;
            signop        <= 2'b10; // opcode for B in sign extender
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end
        11'b??111000010: // load unscaled reg
        begin
            reg2loc       <= 1'bx;
            alusrc        <= 1'b1;
            mem2reg       <= 1'b1; 
            regwrite      <= 1'b1; 
            memread       <= 1'b1; 
            memwrite      <= 1'b0; 
            branch        <= 1'b0; 
            uncond_branch <= 1'b0; 
            aluop         <= 4'b0010; // opcode for ALU add
            signop        <= 2'b01; // opcode for D-type in sign extender
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end
        11'b??111000000: // store unscaled reg
        begin
            reg2loc       <= 1'b1;
            alusrc        <= 1'b1;
            mem2reg       <= 1'bx; 
            regwrite      <= 1'b0; 
            memread       <= 1'b0; 
            memwrite      <= 1'b1; 
            branch        <= 1'b0; 
            uncond_branch <= 1'b0; 
            aluop         <= 4'b0010; // opcode for alu add
            signop        <= 2'b01; // opcode for D-type in sign extender
            shamt         <= 2'b00;
            movz          <= 1'b0;
        end
        11'b110100101??: // MOVZ
        begin
            reg2loc       <= 1'b1;
            alusrc        <= 1'b0;
            mem2reg       <= 1'b0; 
            regwrite      <= 1'b1; 
            memread       <= 1'b0; 
            memwrite      <= 1'b0; 
            branch        <= 1'b0; 
            uncond_branch <= 1'b0; 
            aluop         <= 4'b0111; // opcode for alu passB
            signop        <= 2'bxx;
            shamt         <= opcode[1:0];
            movz          <= 1'b1;
        end
        default:
        begin
            reg2loc       <= 1'bx;
            alusrc        <= 1'bx;
            mem2reg       <= 1'bx;
            regwrite      <= 1'b0;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'bxxxx;
            signop        <= 2'bxx;
            shamt         <= 2'bxx;
            movz          <= 1'bx;
        end
    endcase
end

endmodule

