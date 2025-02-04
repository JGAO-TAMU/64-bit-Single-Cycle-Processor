module shifter_lsl (
    input [15:0] imm16,
    input [1:0] shamt,      
    output reg [63:0] result  
);

    always @(*) begin
        case (shamt)
            2'b00: result = {48'b0, imm16};
            2'b01: result = {32'b0, imm16, 16'b0}; 
            2'b10: result = {16'b0, imm16, 32'b0}; 
            2'b11: result = {imm16, 48'b0};       
            default: result = 64'b0;                  
            
        endcase
        if(result != 64'b0) 
            begin
            $display("imm: %h, shamt: %h, result: %h", imm16, shamt, result);
            end
        
    end

endmodule
