`timescale 1ns / 1ps

`define STRLEN 32
`define HalfClockPeriod 60
`define ClockPeriod `HalfClockPeriod * 2

module SingleCycleProcTest_v;

    initial
    begin
        $dumpfile("singlecycle.vcd");
        $dumpvars;
    end

    // These tasks are used to check if a given test has passed and
    // confirm that all tests passed.
    task passTest;
        input [63:0] actualOut, expectedOut;
        input [`STRLEN*8:0] testType;
        inout [7:0] 	  passed;

        if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
        else $display ("%s failed: 0x%x should be 0x%x", testType, actualOut, expectedOut);
    endtask

    task allPassed;
        input [7:0] passed;
        input [7:0] numTests;

        if(passed == numTests) $display ("All tests passed");
        else $display("Some tests failed: %d of %d passed", passed, numTests);
    endtask

    // Inputs
    reg        CLK;
    reg        Reset_L;
    reg [63:0] startPC;
    reg [7:0]  passed;
    reg [15:0] watchdog;

    // Outputs
    wire [63:0] dMemOut;
    wire [63:0] currentPC;

    // Instantiate the Unit Under Test
    singlecycle uut (
        .CLK(CLK),
        .resetl(Reset_L),
        .startpc(startPC),
        .currentpc(currentPC),
        .dmemout(dMemOut)
    );

    initial begin
        // Initialize Inputs
        Reset_L = 1;
        startPC = 0;
        passed = 0;

        // Initialize Watchdog timer
        watchdog = 0;

        // Wait for global reset
        #(1 * `ClockPeriod);

        // Program 1
        #1
        Reset_L = 0; startPC = 0;
        #(1 * `ClockPeriod);
        Reset_L = 1;

        // ***********************************************************
        // This while loop will continue cycling the processor until the
        // PC reaches the final instruction in the first test.  If the
        // program forms an infinite loop, never reaching the end, the
        // watchdog timer will kick in and kill simulation after 64K
        // cycles.
        // ***********************************************************

        while (currentPC < 64'h30)
        begin
           #(1 * `ClockPeriod);
           //$display("=========================");
           $display("=====================\nCurrentPC:%h",currentPC);
           //$display("dMemOut:%h",dMemOut);
        end
        #(1 * `ClockPeriod);	// One more cycle to load the pass code from the DataMemory.
        passTest(dMemOut, 64'hF, "Results of Program 1", passed);
        
        while (currentPC < 64'h58)
        begin
           #(1 * `ClockPeriod);
           $display("=====================\nCurrentPC:%h",currentPC);
           //$display("dMemOut:%h",dMemOut);
        end
        #(1 * `ClockPeriod);	// One more cycle to load the pass code from the DataMemory.
        passTest(dMemOut, 64'h123456789abcdef0, "Results of Program 2", passed);
        allPassed(passed, 2);   
        $finish;
    end

    initial begin
        CLK = 0;
    end

    // The following works if clock starts at LOW level at StartTime //
    always begin
        #`HalfClockPeriod CLK = ~CLK;
        #`HalfClockPeriod CLK = ~CLK;
        watchdog = watchdog +1;
    end

    // Kill the simulation if the watchdog hits 64K cycles
    always @*
        if (watchdog == 16'hFF)
        begin
            $display("Watchdog Timer Expired.");
            $finish;
        end


endmodule

