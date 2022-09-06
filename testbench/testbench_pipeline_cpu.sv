`timescale 1ns / 1ns

module testbench_pipeline_cpu();

logic clk,rstn;

cpu_top i_cpu_top (.CLK(clk), .RSTn(rstn));



integer i;
// register file reset (all registers 0x0)
/*initial begin
    for(i = 0; i < 32; i = i + 1) 
        i_cpu_top.i_reg_file.mem_reg[i] = 'h0;
end    */
    
// load machine code   
initial begin

// test commands
i_cpu_top.i_instr_mem.mem[0] = 'h20030080;   // addi 0x0 0x3 0b0000000010000000    (write decimal 128 in register $3 )
i_cpu_top.i_instr_mem.mem[1] = 'h2004000F;   // addi 0x0 0x4 0b0000000000001111    (write decimal 15  in register $4 )
i_cpu_top.i_instr_mem.mem[2] = 'hAC040008;   // sw   0x0 0x4 0b0000000000010000    (store in mem[0x00+0x8] register $4 )   
i_cpu_top.i_instr_mem.mem[3] = 'h8C050008;   // lw   0x5 0x0 0b0000000000000000    (write in register $5 mem[0x0+0x8] )
i_cpu_top.i_instr_mem.mem[4] = 'h10A40003;   // beq  0x4 0x5 0x0003 (if $4 == $5, branch in 3 steps; *true condition )
i_cpu_top.i_instr_mem.mem[5] = 'h8C050010;   // (instruction [3])
i_cpu_top.i_instr_mem.mem[6] = 'h10A40003;   // (instruction [4])
i_cpu_top.i_instr_mem.mem[7] = 'h00000000;   // (nop - no operation)
i_cpu_top.i_instr_mem.mem[8] = 'h10640010;   // beq (if $3 == $4, branch in 16 steps; *false condition)
i_cpu_top.i_instr_mem.mem[9] = 'h00000000;   // nop (no operations)


/*
// test hazard(Read after Write hazard) using bypass    *example from H&H book
i_cpu_top.i_instr_mem.mem[0] = 'h02538020;  // add $s0 $s2 $s3      reg($16 = $18 + $19)
i_cpu_top.i_instr_mem.mem[1] = 'h02114024;  // and $t0 $s0 $s1      reg($8 = $16 & $17)
i_cpu_top.i_instr_mem.mem[2] = 'h02904825;  // or $t1 $s4 $s0       reg($9 = $20 | $16)
i_cpu_top.i_instr_mem.mem[3] = 'h02155022;  // sub $t2 $s0 $s5      reg($10 = $16 - $21)
#6;
i_cpu_top.i_reg_file.mem_reg[17] = 'h3; 
i_cpu_top.i_reg_file.mem_reg[18] = 'h5; 
i_cpu_top.i_reg_file.mem_reg[19] = 'h4;
i_cpu_top.i_reg_file.mem_reg[21] = 'h2;
*/

/*
// test hazard(Stall CPU) using stall signal for CPU    *example from H&H book
i_cpu_top.i_instr_mem.mem[0] = 'h8C100028;  // lw $s0 0x40 $zero     (write in register $16 mem[0x0+0x28])
i_cpu_top.i_instr_mem.mem[1] = 'h02114024;  // and $t0 $s0 $s1        reg($8 = $16 & $17)
i_cpu_top.i_instr_mem.mem[2] = 'h02904825;  // or $t1 $s4 $s0         reg($9 = $20 | $16)
i_cpu_top.i_instr_mem.mem[3] = 'h02155022;  // sub $t2 $s0 $s5        reg($10 = $16 - $21)
#6;
i_cpu_top.i_data_mem.ram[10] = 'h9;  // addr mem = 0x40
i_cpu_top.i_reg_file.mem_reg[17] = 'h3;
i_cpu_top.i_reg_file.mem_reg[18] = 'h5; 
i_cpu_top.i_reg_file.mem_reg[19] = 'h4;
i_cpu_top.i_reg_file.mem_reg[21] = 'h2;
*/


end


initial clk = 0;
initial rstn = 1;
    
always #5 clk = ~clk;    
    
initial begin
rstn = 0; #6; rstn = 1;

end    
    
endmodule
