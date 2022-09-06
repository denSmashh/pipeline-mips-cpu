`include "cmd.vh"

module alu(
    input logic [31:0]  srcA,
    input logic [31:0]  srcB,
    input logic [2:0]   alu_control,
    
    output logic        zero_flag,
    output logic [31:0] alu_result  
);

assign zero_flag = (alu_result == 0);

always_comb begin
	
	case(alu_control)

		`ALU_ADD : alu_result = srcA + srcB;
		`ALU_SUB : alu_result = srcA - srcB;
		`ALU_AND : alu_result = srcA & srcB;
		`ALU_OR  : alu_result = srcA | srcB;
		`ALU_SLT : alu_result = (srcA < srcB) ? 1 : 0;			
		default  : alu_result = 0;
		
	endcase

end
endmodule
