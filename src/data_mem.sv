module data_mem
#(
	parameter DATA_MEM_SIZE = 64
)
(
	input logic 			clk,
	input logic 			rstn,
	
	input logic		[31:0]	addr,
	input logic				we,
	input logic		[31:0]	wd,
	
	output logic	[31:0]	rd
	
);

 
logic [31:0] ram [DATA_MEM_SIZE - 1 : 0]; // byte-addressing

// write
always @(posedge clk, negedge rstn) begin	
	if(~rstn) begin
		for(int i = 0; i < DATA_MEM_SIZE; i = i + 1) ram[i] <= 32'b0;
	end
	else begin
		if(we) ram[addr[31:2]] <= wd; // data aligned
	end
end
 
// read 
assign rd = ram[addr[31:2]]; 

endmodule 
