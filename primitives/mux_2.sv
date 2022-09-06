module mux_2
#(parameter DW = 32) 
(
    input logic [DW-1:0]  a1,
    input logic [DW-1:0]  a2,
    output logic [DW-1:0] y,
    input logic sel    
);

assign y = (sel) ? a2 : a1;

endmodule
