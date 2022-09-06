`include "cmd.vh"

module control_unit(

	input logic	[5:0] 	opcode,
	input logic	[5:0]	funct,
	
	output logic 		mem_to_reg,
	output logic 		mem_write,
	output logic 		branch,
	output logic [2:0] 	alu_control,
	output logic 		alu_src,
	output logic 		reg_dst,
	output logic 		reg_write

);

logic [1:0] alu_op;
logic [7:0] controls;

//------------------ DECODER FOR CONTROL SIGNALS ----------------//
assign {reg_write,reg_dst,alu_src,
        branch,mem_write,mem_to_reg,
        alu_op} = controls;  

always @(*) begin
	
	case (opcode)
		
		`R_TYPE_OP: controls <= 8'b11000010;  
		`LW_OP	  : controls <= 8'b10100100;
		`ADDI_OP  : controls <= 8'b10100000;  
		`SW_OP	  : controls <= 8'b00101000; 
		`BEQ_OP	  : controls <= 8'b00010001;
		default	  : controls <= 8'b00000000; 
		
	endcase 
end

//---------------------- ALU DECODER ---------------------------//
always_comb begin
 case (alu_op)
    2'b00: alu_control <= `ALU_ADD;
    2'b01: alu_control <= `ALU_SUB;
    default: begin 
        case (funct)
            `ADD_F: alu_control <= `ALU_ADD;
            `SUB_F: alu_control <= `ALU_SUB;
            `AND_F: alu_control <= `ALU_AND;
            `OR_F : alu_control <= `ALU_OR;
            `SLT_F: alu_control <= `ALU_SLT;
           default: alu_control <= `ALU_ADD;
       endcase
    end
 endcase
end
  
endmodule
