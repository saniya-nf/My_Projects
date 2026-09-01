module bridge_fsm  #(parameter IDLE=2'b00,APB_SETUP=2'b01,APB_ACCESS=2'b10,AXI_RESP=2'b11)(
    input fifo_empty,
    input [64:0]fifo_rdata,
    input clk,rst,
    input PREADY,
    input [31:0]PRDATA,

    output reg [31:0]PADDR,
    output reg [31:0]PWDATA,
    output reg PWRITE,
    output reg PENABLE,
    output reg PSEL1,PSEL2,
    output reg [31:0] RDATA, // read data back to AXI!
    output reg BVALID,
    output reg RVALID
);

reg[1:0]state;
reg [1:0]next_state;

always@(posedge clk,posedge rst)//state register block
    if(rst)
        state<=IDLE;
    else
        state<=next_state;

always@(*)begin//next state logic blk
    
    next_state = state;//1)So what does this do if weve already written default in case?-->It gives next_state a default value before the case:
    //so by this nxt_state=satte means by default stay on whichever state u are,ill explicitly tell u when to move fwd to which state,so no need to writee else statements for dle and access like u wrote before
    //by this default above, it makes the FSM shorter and safer as it grows.
    case(state)
        IDLE: if(!fifo_empty) next_state=APB_SETUP;
                //else next_state=IDLE;
        APB_SETUP: next_state=APB_ACCESS;
        APB_ACCESS: if(PREADY) next_state=AXI_RESP;
                    //no need to write too -->else next_state=APB_ACCESS;
        AXI_RESP: next_state=IDLE;
        //2)so u dont need to write this default too ,default is not necessary when all legal states are explicitly covered, but it is commonly included as a safe recovery for illegal/unknown states.,-->default: next_state=IDLE;
        default:
            next_state = IDLE;
    endcase
end

//output logic blk
always@(*)begin 
    PSEL1=0; PSEL2=0; PENABLE=0;
    PWRITE=0; PADDR=0; PWDATA=0;
    BVALID=0; RVALID=0; RDATA=0;

    case(state)
        //ive already written default simialr to idle so no need to write IDL case at all
        /*IDLE:begin
            PSEL1=0; PSEL2=0; PENABLE=0;
            PWRITE=0; PADDR=0; PWDATA=0;
            BVALID=0; RVALID=0; RDATA=0;
        end*/

        APB_SETUP:begin 
            PADDR=fifo_rdata[63:32];
            PSEL1=!PADDR[16];
            PSEL2=PADDR[16];
            PWRITE=fifo_rdata[64];
            PWDATA=fifo_rdata[31:0];
            PENABLE=0;
        end

        APB_ACCESS:begin
            PADDR=fifo_rdata[63:32];
            PSEL1=!PADDR[16];
            PSEL2=PADDR[16];
            PWRITE=fifo_rdata[64];
            PWDATA=fifo_rdata[31:0];
            PENABLE=1;
        end

        AXI_RESP:begin 
            BVALID=fifo_rdata[64];
            RVALID=!fifo_rdata[64];
            RDATA=PRDATA; //read data from APB slave to AXI master
        end

end
    
