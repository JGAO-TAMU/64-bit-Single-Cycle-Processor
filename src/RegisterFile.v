`timescale 1ns/1ps
module RegisterFile(
    output reg [63:0] BusA,  
    output reg [63:0] BusB,   
    input [63:0] BusW,     //  
    input [4:0] RA,        //b00100  d4
    input [4:0] RB,        //b01100  d12
    input [4:0] RW,        //b01100  d12
    input RegWr,           //b0
    input Clk,
    input movz                
);
    
    reg [63:0] registers [31:0];
    
    // Initialize register 31 to zero 
    initial begin
        registers[31] = 64'b0;
    end

    //read logic with 2-tic delay
    always @(*) begin
        #2 BusA = (RA == 31) ? 64'b0 : registers[RA];
           BusB = (RB == 31) ? 64'b0 : registers[RB];
    end

    // write logicwith 3-tic delay
    always @ (negedge Clk) begin
        if (RegWr && RW != 31 && movz) begin
            #3 registers[RW] <= BusW;
            $display("Register Wrote: %h to X%h", BusW, RW);
        end
        else if (RegWr && RW != 31) begin
            #3 registers[RW] <= BusW;
            $display("Register Wrote: %h to X%h", BusW, RW);
        end
    end
endmodule
