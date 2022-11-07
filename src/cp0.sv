`include "pipeline_cpu.vh"
`include "cmd.vh"

module cp0(
    input logic         clk,
    input logic         rstn,
    
    input logic  [31:0] cp0_PC, 
    output logic [31:0] cp0_EPC,    // exception program counter, after exception program_counter = EPC 
    
    output logic [31:0] cp0_ExcHandlerAddr,     // exception handler addr
    output logic        cp0_ExcAsynReq,
    input logic         cp0_ExcAsynAck,
    output logic        cp0_ExcAsync,   // request for asynchronous exception (interrupt)
    output logic        cp0_ExcSync,    // request for synchronous exception (interrupt)
    input logic         cp0_ExcRet,     // return from exception
    
    output logic [31:0] cp0_regRD,      // cp0 register access Read Data
    input logic  [31:0] cp0_regWD,      // cp0 register access Write Data
    input logic  [4:0]  cp0_regNum,     // cp0 register access num
    input logic  [2:0]  cp0_regSel,     // cp0 register access sel
    input logic         cp0_regWE,      // cp0 register access Write Enable
    
    input logic  [5:0]  cp0_ExcIntr,    // hardware interrupts
    input logic         cp0_ExcRI,      // reserved instruction exception
    input logic         cp0_ExcOF,      // arithmetic overflow exception
    output logic        cp0_TimerIntr   // timer interrupt
);

// cp0 registers & field
logic [31:0] cp0_Status_reg; // status register
logic [7:0]  cp0_Status_IM;  // interrupt mask   - [15:8]
logic        cp0_Status_UM;  // user mode        - [4]
logic        cp0_Status_EXL; // exception level  - [1]
logic        cp0_Status_IE;  // interrupt enable - [0]

logic [31:0] cp0_Cause_reg;  // cause register
logic        cp0_Cause_TI;   // timer interrupt    - [30]
logic        cp0_Cause_DC;   // disable count reg  - [27]
logic [7:0]  cp0_Cause_PI;   // pending interrupts - [15:8]
logic [4:0]  cp0_EXCODE;     // exception code     - [6:2]


// registers read access
assign cp0_Status_reg = {16'b0, cp0_Status_IM, 3'b0, cp0_Status_UM, 2'b0, cp0_Status_EXL, cp0_Status_IE};

assign cp0_Cause_reg = {1'b0, cp0_Cause_TI, 2'b0, cp0_Cause_DC, 11'b0, cp0_Cause_PI, 1'b0, cp0_EXCODE, 2'b0};




// exception handler address
assign cp0_ExcHandlerAddr = `CP0_EXCEPTION_HANDLER_ADDR;

endmodule
