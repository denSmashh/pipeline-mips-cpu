`include "hazardValue.vh"

module hazard_unit(
    
    input logic [4:0] rs_D,
    input logic [4:0] rt_D,
    input logic [4:0] rs_E,
    input logic [4:0] rt_E,
    input logic [4:0] write_reg_E,
    input logic [4:0] write_reg_M,
    input logic [4:0] write_reg_W,
    input logic branch_D,
    input logic mem2reg_E,
    input logic mem2reg_M,
    input logic reg_write_E,
    input logic reg_write_W,
    input logic reg_write_M,    
        
    output logic stall_F_n,
    output logic stall_D_n,
    output logic bypass_srcA_D,
    output logic bypass_srcB_D,
    output logic [1:0] bypass_srcA_E,
    output logic [1:0] bypass_srcB_E,
    output logic flush_E
  
);

// bypass for simultaneously EXUCUTE and MEMORY|WRITEBACK stages with equal address
assign bypass_srcA_E = ((rs_E != 5'b0) && reg_write_M && (write_reg_M == rs_E)) ? `HZ_BYPASS_M2E 
                      :((rs_E != 5'b0) && reg_write_W && (write_reg_W == rs_E)) ? `HZ_BYPASS_W2E : `HZ_BYPASS_NONE;  

assign bypass_srcB_E = ((rt_E != 'b0) && reg_write_M && (write_reg_M == rt_E)) ? `HZ_BYPASS_M2E 
                      :((rt_E != 'b0) && reg_write_W && (write_reg_W == rt_E)) ? `HZ_BYPASS_W2E : `HZ_BYPASS_NONE;

// bypass for comporator branch instruction
assign bypass_srcA_D = ((rs_D != 5'b0) && reg_write_M && (rs_D == write_reg_M));
assign bypass_srcB_D = ((rt_D != 5'b0) && reg_write_M && (rt_D == write_reg_M));


// stalling if hazard instruction lw
logic lw_stall;
assign lw_stall = (mem2reg_E && (rt_E == rt_D || rt_E == rs_D));

// stalling for branch instruction
logic branch_stall;
assign branch_stall = ( (branch_D && reg_write_E && (write_reg_E == rs_D || write_reg_E == rt_D)) 
                                                       || 
                      ( branch_D && mem2reg_M && (write_reg_M == rs_D || write_reg_M == rt_D)));


assign stall_F_n = ~(lw_stall || branch_stall);
assign stall_D_n = ~(lw_stall || branch_stall);
assign flush_E = (lw_stall || branch_stall);

endmodule
