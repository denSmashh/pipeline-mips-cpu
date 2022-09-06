module register_file
(
	input logic 		clk,
	input logic 		rstn,
	
	input logic	[4:0]   a1,		// [25:21] instr bits 
	input logic	[4:0]   a2,		// [20:16] instr bits
	input logic	[4:0]	a3,		// [20:16] or [15:11] instr bits
	
	input logic 		we3,
	input logic	[31:0]	wd3,
	
	output logic [31:0]	rd1,
	output logic [31:0]	rd2
	
);

logic [31:0] mem_reg [31:0]; // amount architectural MIPS registers = 32 

// read from register_file (if simultaneously read and write, first we writing, then we reading)
assign rd1 = (a1 == 'b0) ? 32'b0 : (we3 && a1 == a3) ? wd3 : mem_reg[a1]; 
assign rd2 = (a2 == 'b0) ? 32'b0 : (we3 && a2 == a3) ? wd3 : mem_reg[a2];


// write in register file
always @(posedge clk) begin	
	if(~rstn) begin
		for(int i = 0; i < 32; i = i + 1) mem_reg[i] <= 32'b0;	
	end
	else begin
		if (we3) mem_reg[a3] <= wd3;			
	end
end

endmodule 
