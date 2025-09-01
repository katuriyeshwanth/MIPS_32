`timescale 1ns / 1ps

// example - 1
/* 
Adding three numbers 10 20 30 and store it on system Register

*/
module main_tb;
reg clk1, clk2;

integer k;

// instantiation of module
MIPS32 mips(clk1, clk2);

// Generating two-Phase clock
initial
    begin
        clk1 = 0; clk2 = 0;
        repeat(20)
            begin
                #5 clk1 = 1; #5 clk1 = 0;
                #5 clk2 = 1; #5 clk2 = 0;
            end
    end
    
initial
    begin
        for(k=0; k<31; k=k+1)
            begin
                mips.Reg[k] = k;
            end
                mips.Mem[0] = 32'h2801000a;  // ADDI R1 R0 10
                mips.Mem[0] = 32'h28020014;  // ADDI R2 R0 20
                mips.Mem[0] = 32'h28030019;  // ADDI R3 R0 30
                mips.Mem[0] = 32'h0ce77800;  // OR R7 R7 R7 -- dummy instruction to avoid the data hazard
                mips.Mem[0] = 32'h0ce77800;  // OR R7 R7 R7 -- dummy instruction to avoid the data hazard
                mips.Mem[0] = 32'h00222000;  // ADD R4 R1 R2
                mips.Mem[0] = 32'h0ce77800;  // OR R7 R7 R7 -- dummy instruction to avoid the data hazard
                mips.Mem[0] = 32'h00832800;  // ADD R5 R4 R3
                mips.Mem[0] = 32'hfc000000;  // HLT
            
            
            mips.HALTED = 0;
            mips.PC = 0;
            mips.TAKEN_BRANCH = 0;
            
            #280
            for(k=0; k<6; k=k+1)
                begin
                    $display("R%1d - %2d", k, mips.Reg[k]);
                end
    end
    
    initial
        begin
            $dumpfile("mips.vcd");
            $dumpvars(0, main_tb);
            #300 $finish;
        end



endmodule

/* 
- Example - 2
- Load a word stored in memory location 120. Add 45 to it and store the result in memory location 121
*/

// Generating two-Phase clock
module mem_location();
    reg clk1, clk2;
    integer k;
    MIPS32 mips(clk1, clk2);
    
    initial
        begin
            clk1 = 0; clk2 = 0;
                repeat(50)
                    begin
                        #5 clk1 = 1; #5 clk1 = 0;
                        #5 clk2 = 1; #5 clk2 = 0;
                    end
        end
    
    initial
        begin
            for(k=0; k<31;k=k+1)
                begin
                    mips.Reg[k] = k; 
                end    
                
                mips.Mem[0] = 32'h28010078;
                mips.Mem[0] = 32'h0c631800;
                mips.Mem[0] = 32'h20220000;
                mips.Mem[0] = 32'h0c631800;
                mips.Mem[0] = 32'h2842002d;
                mips.Mem[0] = 32'h0c631800;
                mips.Mem[0] = 32'h24220001;
                mips.Mem[0] = 32'hfc000000;
                    
                mips.Mem[120] = 85;
                    
                mips.HALTED = 0;
                mips.PC = 0;
                mips.TAKEN_BRANCH = 0;
                    
                    #500
                    
                    $display("Mem[120]: %4d \n Mem[121]: %4d", mips.Mem[120], mips.Mem[121]);
                    
                    #600 $finish();
        end

/*
Mem[120] = 85
Mem[121] = 130

 */
    
endmodule
