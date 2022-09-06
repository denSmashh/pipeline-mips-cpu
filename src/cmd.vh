
//ALU commands
`define ALU_ADD 	3'b010
`define ALU_SUB 	3'b110
`define ALU_AND 	3'b000
`define ALU_OR  	3'b001
`define ALU_SLT	    3'b111


//funct commands
`define	ADD_F		6'b100000
`define	SUB_F		6'b100010
`define	AND_F		6'b100100
`define	OR_F		6'b100101
`define	SLT_F		6'b101010


//opcode commands
`define R_TYPE_OP 	6'b000000
`define LW_OP 	 	6'b100011
`define SW_OP 	 	6'b101011
`define BEQ_OP 	 	6'b000100
`define ADDI_OP 	6'b001000
`define J_OP 	 	6'b000010