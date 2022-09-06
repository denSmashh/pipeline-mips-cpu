
module cpu_top (
    input logic CLK,
    input logic RSTn
);

// FETCH STAGE wires
logic [31:0] pc;
logic [31:0] pc_next;
logic [31:0] mips_instr_F;
logic [31:0] pc_plus_4_F;
logic [31:0] im_addr;

// DECODE STAGE wires
logic [31:0] mips_instr_D;
logic [31:0] signImm_D;
logic reg_write_D;
logic mem2reg_D;
logic mem_write_D;
logic alu_src_D;
logic reg_dst_D;
logic branch_D;
logic [2:0] alu_control_D;
logic [31:0] rd1_data;
logic [31:0] rd2_data;
logic [31:0] rd1_D;
logic [31:0] rd2_D;
logic PC_src_D;
logic [31:0] pc_plus_4_D;
logic [31:0] pc_branch;

// EXECUTE STAGE wires
logic [4:0] rs_E;
logic [4:0] rt_E;
logic [4:0] rd_E;
logic [31:0] signImm_E;
logic reg_write_E;
logic mem2reg_E;
logic mem_write_E;
logic alu_src_E;
logic reg_dst_E;
logic [2:0] alu_control_E;
logic [31:0] rd1_E;
logic [31:0] rd2_E;
logic [4:0] write_reg_E;
logic [31:0] srcA_E;
logic [31:0] srcB_E;
logic [31:0] write_data_E;
logic [31:0] alu_out_E;

// MEMORY STAGE wires
logic reg_write_M;
logic mem2reg_M;
logic mem_write_M;
logic [4:0] write_reg_M;
logic [31:0] write_data_M;
logic [31:0] alu_out_M;
logic [31:0] read_data_M;

// WRITEBACK STAGE wires
logic reg_write_W;
logic mem2reg_W;
logic [4:0] write_reg_W;
logic [31:0] read_data_W;
logic [31:0] alu_out_W;
logic [31:0] result_W;

// Hazards wires
logic stall_F_n;
logic stall_D_n;
logic bypass_srcA_D;
logic bypass_srcB_D;
logic flush_E;
logic [1:0] bypass_srcA_E;
logic [1:0] bypass_srcB_E;


//------------------------------ PIPELINE REGISTERS -----------------------------//

//*** FETCH REG
register_en #(.DW(32)) pc_reg_F (.clk(CLK), .rstn(RSTn), .en(stall_F_n), .d(pc_next), .q(pc));

//*** DECODE REG
register_en_clr #(.DW(32)) instr_reg_D (.clk(CLK), .rstn(RSTn), .en(stall_D_n), .clr(PC_src_D), .d(mips_instr_F), .q(mips_instr_D));
register_en_clr #(.DW(32)) pcplus4_reg_D (.clk(CLK), .rstn(RSTn), .en(stall_D_n), .clr(PC_src_D), .d(pc_plus_4_F), .q(pc_plus_4_D));

//*** EXECUTE REG
register_clr #(.DW(5)) rs_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(mips_instr_D[25:21]), .q(rs_E));
register_clr #(.DW(5)) rt_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(mips_instr_D[20:16]), .q(rt_E));
register_clr #(.DW(5)) rd_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(mips_instr_D[15:11]), .q(rd_E));
register_clr #(.DW(32)) signImm_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(signImm_D), .q(signImm_E));

register_clr #(.DW(1)) regwrite_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(reg_write_D), .q(reg_write_E));
register_clr #(.DW(1)) mem2reg_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(mem2reg_D), .q(mem2reg_E));
register_clr #(.DW(1)) memwrite_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(mem_write_D), .q(mem_write_E));
register_clr #(.DW(1)) alusrcE_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(alu_src_D), .q(alu_src_E));
register_clr #(.DW(1)) regdst_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(reg_dst_D), .q(reg_dst_E));
register_clr #(.DW(3)) alucontrol_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(alu_control_D), .q(alu_control_E));

register_clr #(.DW(32)) rd1_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(rd1_D), .q(rd1_E));
register_clr #(.DW(32)) rd2_reg_E (.clk(CLK), .rstn(RSTn), .clr(flush_E), .d(rd2_D), .q(rd2_E));

//*** DATA REG 
register #(.DW(1)) reg_write_reg_M (.clk(CLK), .rstn(RSTn), .d(reg_write_E), .q(reg_write_M));
register #(.DW(1)) mem2reg_reg_M (.clk(CLK), .rstn(RSTn), .d(mem2reg_E), .q(mem2reg_M));
register #(.DW(1)) memwrite_reg_M (.clk(CLK), .rstn(RSTn), .d(mem_write_E), .q(mem_write_M));
register #(.DW(5)) write_reg_reg_M (.clk(CLK), .rstn(RSTn), .d(write_reg_E), .q(write_reg_M));
register #(.DW(32)) write_data_reg_M (.clk(CLK), .rstn(RSTn), .d(write_data_E), .q(write_data_M));
register #(.DW(32)) alu_out_reg_M (.clk(CLK), .rstn(RSTn), .d(alu_out_E), .q(alu_out_M));

//*** WRITEBACK REG
register #(.DW(1)) reg_write_reg_W (.clk(CLK), .rstn(RSTn), .d(reg_write_M), .q(reg_write_W));
register #(.DW(1)) mem2reg_reg_W (.clk(CLK), .rstn(RSTn), .d(mem2reg_M), .q(mem2reg_W));
register #(.DW(5)) write_reg_reg_W (.clk(CLK), .rstn(RSTn), .d(write_reg_M), .q(write_reg_W));
register #(.DW(32)) write_read_data_reg_W (.clk(CLK), .rstn(RSTn), .d(read_data_M), .q(read_data_W));
register #(.DW(32)) alu_out_reg_W (.clk(CLK), .rstn(RSTn), .d(alu_out_M), .q(alu_out_W));

//----------------------------------- MUXes, ADDERs ---------------------------------------//

//*** FETCH 
mux_2 #(.DW(32)) i_mux_pc (.a1(pc_plus_4_F), .a2(pc_branch), .sel(PC_src_D), .y(pc_next));
adder #(.DW(32)) i_pcplus4_adder (.a1(pc), .a2(32'h4), .y(pc_plus_4_F));

//*** DECODE 
mux_2 #(.DW(32)) i_mux_rd1 (.a1(rd1_data), .a2(alu_out_M), .sel(bypass_srcA_D), .y(rd1_D));
mux_2 #(.DW(32)) i_mux_rd2 (.a1(rd2_data), .a2(alu_out_M), .sel(bypass_srcB_D), .y(rd2_D));  
adder #(.DW(32)) i_pcplusImm_adder (.a1(signImm_D << 2), .a2(pc_plus_4_D), .y(pc_branch));

//*** EXECUTE 
mux_2 #(.DW(5)) i_mux_rt_re (.a1(rt_E), .a2(rd_E), .sel(reg_dst_E), .y(write_reg_E));
mux_4 #(.DW(32)) i_mux_srcA (.a1(rd1_E), .a2(result_W), .a3(alu_out_M), .a4('b0), .sel(bypass_srcA_E), .y(srcA_E));
mux_4 #(.DW(32)) i_mux_write_data (.a1(rd2_E), .a2(result_W), .a3(alu_out_M), .a4('b0), .sel(bypass_srcB_E), .y(write_data_E));
mux_2 #(.DW(32)) i_mux_srcB (.a1(write_data_E), .a2(signImm_E), .sel(alu_src_E), .y(srcB_E));

//*** WRITEBACK
mux_2 #(.DW(32)) i_mux_result (.a1(alu_out_W), .a2(read_data_W), .sel(mem2reg_W), .y(result_W));

//----------------------------------- INSTANCES ---------------------------------------//
hazard_unit i_hz_unit 
(    
    .rs_D(mips_instr_D[25:21]),
    .rt_D(mips_instr_D[20:16]),
    .rs_E(rs_E),
    .rt_E(rt_E),
    .write_reg_E(write_reg_E),
    .write_reg_M(write_reg_M),
    .write_reg_W(write_reg_W),
    .branch_D(branch_D),
    .mem2reg_E(mem2reg_E),
    .mem2reg_M(mem2reg_M),
    .reg_write_E(reg_write_E),
    .reg_write_W(reg_write_W),
    .reg_write_M(reg_write_M),    
    .stall_F_n(stall_F_n),
    .stall_D_n(stall_D_n),
    .bypass_srcA_D(bypass_srcA_D),
    .bypass_srcB_D(bypass_srcB_D),
    .bypass_srcA_E(bypass_srcA_E),
    .bypass_srcB_E(bypass_srcB_E),
    .flush_E(flush_E)    
);


instruction_mem #(.INSTR_MEM_SIZE(32)) i_instr_mem
(
	.addr(im_addr),
	.rd(mips_instr_F)
);
assign im_addr = pc >> 2;

register_file i_reg_file 
(
	.clk(CLK),
	.rstn(RSTn),	
    .a1(mips_instr_D[25:21]),		
	.a2(mips_instr_D[20:16]),		
	.a3(write_reg_W),
	.we3(reg_write_W),
	.wd3(result_W),
	.rd1(rd1_data),
	.rd2(rd2_data)
);

data_mem #(.DATA_MEM_SIZE(32)) i_data_mem
(
	.clk(CLK),
	.rstn(RSTn),
	.addr(alu_out_M),
	.we(mem_write_M),
	.wd(write_data_M),
	.rd(read_data_M)
);

control_unit i_control_unit
(
	.opcode(mips_instr_D[31:26]),
	.funct(mips_instr_D[5:0]),
	.mem_to_reg(mem2reg_D),
	.mem_write(mem_write_D),
	.branch(branch_D),
	.alu_control(alu_control_D),
	.alu_src(alu_src_D),
	.reg_dst(reg_dst_D),
	.reg_write(reg_write_D)
);
assign PC_src_D = branch_D & (rd1_D == rd2_D);


alu i_alu
(
    .srcA(srcA_E),
    .srcB(srcB_E),
    .alu_control(alu_control_E),
    .zero_flag(),
    .alu_result(alu_out_E)
);

sign_extend i_sign_extend
(
	.imm(mips_instr_D[15:0]),
	.signImm(signImm_D)	
);


endmodule
