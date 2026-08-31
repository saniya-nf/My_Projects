module bridge_fsm(
    input clk, rst,
    input fifo_empty,
    input PREADY,
    input [64:0] fifo_rdata,
    
    // outputs
    output reg wen,
    output reg PSEL1, PSEL2,
    output reg PENABLE,
    output reg [31:0] PADDR,
    output reg [31:0] PWDATA,
    output reg PWRITE,
    output reg BVALID,
    output reg RVALID
);

parameter IDLE       = 2'b00,
          APB_SETUP  = 2'b01,
          APB_ACCESS = 2'b10,
          AXI_RESP   = 2'b11;

reg [1:0] state, next_state;