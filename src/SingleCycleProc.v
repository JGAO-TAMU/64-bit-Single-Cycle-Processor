

module SingleCycleProc(
    input resetl,
    input [63:0] startpc,
    output reg [63:0] currentpc,
    output [63:0] dmemout,
    input CLK
);

    // Next PC connections
    wire [63:0] nextpc;       // The next PC, to be updated on clock cycle

    // Instruction Memory connections
    wire [31:0] instruction;  // The current instruction

    // Parts of instruction
    wire [4:0] rd;            // destination register
    wire [4:0] rm;            // Operand 1
    wire [4:0] rn;            // Operand 2
    wire [10:0] opcode;
    wire [15:0] movimm;
    // Control wires
    wire reg2loc;
    wire alusrc;
    wire mem2reg;
    wire regwrite;
    wire memread;
    wire memwrite;
    wire branch;
    wire uncond_branch;
    wire [3:0] aluctrl;
    wire [1:0] signop;
    wire [1:0] shamt;
    wire movz;

    // Register file connections
    wire [63:0] regoutA;     // Output A
    wire [63:0] regoutB;     // Output B
    wire [63:0] regWriteData;
    wire [63:0] regWriteIn;
    // ALU connections
    wire [63:0] aluout;
    wire zero;

    // Sign Extender connections
    wire [63:0] extimm;

    // ALU Input wire NEW
    wire [63:0] ALUinputB;

    // Data Memory input wire NEW
    wire [63:0] datMemAddr;
    
    // Data Memory Mux wire NEW
    wire [63:0] datMemReadData;

    // currpc wire NEW
    wire [63:0] currentPCWire;

    // shifter output NEW
    wire [63:0] shiftOutData;

    //debug
    // wire is_cbz = (opcode == `OPCODE_CBZ);  // CBZ opcode  
    // wire should_branch = is_cbz & zero;          // Branch condition for CBZ
    // // PC update logic
    always @(negedge CLK)
    begin
        if (resetl)
            currentpc <= nextpc;
        else
            currentpc <= startpc;
        // begin
        //     currentpc <= startpc;
        //     // Debug output
        //     $display("Time: %0t, PC: %h", $time, currentpc);
        //     $display("Instruction: %h, Opcode: %b", instruction, opcode);
        //     if (is_cbz) begin
        //         $display("CBZ detected - X12 value: %h, Zero flag: %b", regoutA, zero);
        //         $display("Should branch: %b, Next PC: %h", should_branch, nextpc);
        //     end
        //     $display("X13 value: %h", regoutB);
        //     $display("-----------------------");
        // end
    end

    // Parts of instruction
    assign rd = instruction[4:0];
    assign rm = instruction[9:5];
    assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
    assign opcode = instruction[31:21];
    assign movimm = instruction[20:5];
    assign dmemout = datMemReadData;

    InstructionMemory imem(
        .Data(instruction),
        .Address(currentpc)
    );

    control control(
        .reg2loc(reg2loc),
        .alusrc(alusrc),
        .mem2reg(mem2reg),
        .regwrite(regwrite),
        .memread(memread),
        .memwrite(memwrite),
        .branch(branch),
        .uncond_branch(uncond_branch),
        .aluop(aluctrl),
        .signop(signop),
        .opcode(opcode),
        .shamt(shamt),
        .movz(movz)
    );
    
    NextPClogic nextPCLogic ( 
        .CurrentPC(currentpc), //from PC Update Logic
        .SignExtImm64(extimm),
        .Branch(branch),
        .ALUZero(zero),
        .Uncondbranch(uncond_branch),
        .NextPC(nextpc)
    );
    
    RegisterFile registers (
        
        //input
        .BusW(regWriteIn),
        .RA(rm),
        .RB(rn),
        .RW(rd),
        .RegWr(regwrite),
        .Clk(CLK),
        .movz(movz),
        //output
        .BusA(regoutA), 
        .BusB(regoutB)

    );

    SignExtender signExtend (

        //input
        .Imm32(instruction),
        .Ctrl(signop),
        //output
        .BusImm(extimm)
        
    );

    mux21_64bit ALUInputMux (
        .in0(regoutB),
        .in1(extimm),
        .sel(alusrc),
        .out(ALUinputB)
    );

    ALU mainALU (
        //input
        .BusA(regoutA),
        .BusB(ALUinputB),
        .ALUCtrl(aluctrl),
        //output
        .BusW(datMemAddr),
        .Zero(zero)
    );

    DataMemory dataMemory (
        .Address(datMemAddr),
        .WriteData(regoutB),
        .Clock(CLK),
        .MemoryRead(memread),
        .MemoryWrite(memwrite),
        //output reg
        .ReadData(datMemReadData)
    );

    mux21_64bit datMemMux (
        .in0(datMemAddr),
        .in1(datMemReadData),
        .sel(mem2reg),
        .out(regWriteData)
    );

    shifter_lsl shifter (
        .shamt(shamt),
        .imm16(movimm),
        .result(shiftOutData)
    );

    mux21_64bit regWriteMux (
        .in0(regWriteData),
        .in1(shiftOutData),
        .sel(movz),
        .out(regWriteIn)
    );

endmodule

