`include "mips_isa.v"
module control(
    input [5:0] instruction,
    input [5:0] funct,
    input zero,
    output reg reg_dst,
    output reg jump,
	output reg beq,
	output reg bne,
    output reg branch,
    output reg memRead,
    output reg mem2Reg,
    output reg [2:0] ALUop,
    output reg memWrite,
    output reg ALUsrc,
    output reg regWrite,
    output reg signXtend);

always @(*)
    begin
        casex(instruction)
            `R_TYPE:    
                begin
                    reg_dst =   1'b1;
                    jump =      1'b0;
                    beq =       1'b0;
                    bne =       1'b0;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b0;
                    ALUsrc =    1'b0;
                    regWrite =  1'b1;
                    signXtend = (funct[0]) ? 1'b0 : 1'b1;
                    ALUop =     3'b111; // NOP
                    
                    casex(funct)
                        6'b10000X:  // ADD
                            ALUop =     3'b000;
                        6'b10001X:  // SUB
                            ALUop =     3'b001;
                        6'b000000:  // Shift Left
                            ALUop =     3'b010;
                        6'b000010:   // Shift Right
                            ALUop =     3'b011;
                        6'b100100:   // AND
                            ALUop =     3'b100;
                        6'b100101:   //  OR
                            ALUop =     3'b101;
                        6'b100110:   // XOR
                            ALUop =     3'b110;                    
                        6'b00100X:  // Jump
                            jump =      1'b1;
                        default:    // MOV
                            begin
                                ALUop = 3'b111;
                            end
                    endcase
                end
            
            `J:
                begin
                    reg_dst =   1'b0;
                    jump =      1'b1;
                    beq =       1'b0;
                    bne =       1'b0;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b0;
                    ALUsrc =    1'b0;
                    regWrite =  1'b0;
                    ALUop =     3'b111;  
                    signXtend = 1'b0;       
                end
                
            `RI_TYPE:
                begin
                    
                end
            // I-Type
            6'b00100X:  // ADD
                begin
                    reg_dst =   1'b0;
                    jump =      1'b0;
                    beq =       1'b0;
                    bne =       1'b0;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b0;
                    ALUsrc =    1'b1;
                    regWrite =  1'b1;
                    ALUop =     3'b000;
                    signXtend = (instruction[0]) ? 1'b0 : 1'b1;
                end
                
            6'b00101X:  // Comparisons
                begin
                    reg_dst =   1'b0;
                    jump =      1'b0;
                    beq =       1'b0;
                    bne =       1'b0;   
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b0;
                    ALUsrc =    1'b1;
                    regWrite =  1'b1;
                    ALUop =     3'b010;
                    signXtend = (instruction[0]) ? 1'b0 : 1'b1;
                end
                
            6'b0011XX:  // Logic
                begin
                    reg_dst =   1'b0;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b0;
                    ALUsrc =    1'b1;
                    regWrite =  1'b1;
                    
                    casex(instruction)
                        6'b001100:  // AND
                            begin
                                ALUop =     3'b100;
                            end
                        6'b001101:  // OR
                            begin
                                ALUop =     3'b101;
                            end
                        6'b001110:  // XOR
                            begin
                                ALUop =     3'b110;
                            end
                    endcase                    
                end
                
            6'b0001XX:  // Branch Instructions
                begin
                    reg_dst =   1'b0;
                    beq =       1'b1;
                    bne =       1'b1;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b0;
                    ALUsrc =    1'b1;
                    regWrite =  1'b0;
                    
                    case(instruction)
                        `BEQ:
                            ALUop =     3'b111;
                        default:
                            ALUop =     3'b001;
                    endcase
                end
            
            //TODO Complete Load and Store instructions
            6'b100XXX:  // Load Instructions
                begin
                    reg_dst =   1'b0;
                    jump =      1'b0;
                    beq =       1'b0;
                    bne =       1'b0;
                    memRead =   1'b1;
                    mem2Reg =   1'b1;
                    memWrite =  1'b0;
                    ALUsrc =    1'b1;
                    regWrite =  1'b1;
                    ALUop =     3'b000;
                    signXtend = 1'b1;
                end
                
            6'b1010XX:  // Store Instructions
                begin
                   reg_dst =    1'b0;
                    jump =      1'b0;
                    beq =       1'b0;
                    bne =       1'b0;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b1;
                    ALUsrc =    1'b1;
                    regWrite =  1'b0;
                    ALUop =     3'b000;
                    signXtend = 1'b1; 
                end
                
            default:    
                begin
                    reg_dst =   1'b0;;
                    memRead =   1'b0;
                    mem2Reg =   1'b0;
                    memWrite =  1'b0;
                    ALUsrc =    1'b0;
                    regWrite =  1'b1;
                    ALUop =     3'b111;
                end
        endcase
    end

endmodule