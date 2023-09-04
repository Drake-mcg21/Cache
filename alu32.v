`timescale 1ns / 1ps

`define ADDI 6'b001000
`define J 6'b000010 

module alu32(
    input [31:0] op1,	
    input [31:0] op2,
    input [2:0] control,
    output reg [31:0] result,
    output zero);

initial
    result = 32'd0;

assign zero = (result == 32'd0) ? 1'b1: 1'b0;

always @(*)
    begin
        case(control)
            6'b000: // ADD
                result = op1 + op2;
            6'b001: // SUB
                result = op1 - op2;
            6'b010: // SHIFT Left
                result = op1 << op2;
			6'b011: // SHIFT Right
                result = op1 >> op2;
            6'b100: // AND
                result = op1 & op2;
            6'b101: // OR
                result = op1 | op2;
            6'b110: // XOR
                result = op1 ^ op2;
			6'b111: begin if (op1<op2) result = 32'd1; //beq
				else result = 32'd0;
				end
            default: // add
                result = op1 + op2;
            endcase
    end


endmodule