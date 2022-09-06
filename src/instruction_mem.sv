module instruction_mem
#(
	parameter INSTR_MEM_SIZE = 32
)
(
	input 	logic [31:0] addr,
	output 	logic [31:0] rd
	
);


logic [31:0] mem [INSTR_MEM_SIZE-1:0]; //memory size for instructions

assign rd = mem[addr];

/*
initial begin
	 $readmemh ("program.hex", mem); 	// load program from file " program.hex "
end 
*/

endmodule 
