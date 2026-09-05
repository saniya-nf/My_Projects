module vending_machine(
    input clk,rst,coin,dispense,full_price,extra_price,
    output reg product,change
);
parameter IDLE=2'b00,WAIT=2'b01,PRODUCT=2'b10,CHANGE=2'b11;

reg [1:0]state;
reg extra_reg;
//reg[3:0]count;

always@(posedge clk,posedge rst)
    if(rst)begin 
        state<=IDLE;
        //count<=0;
    end
    else begin 
        case(state)
            IDLE: begin
                if(coin)begin 
                    state<=WAIT;
                    //count<=0;
                end
                else begin 
                    state<=IDLE;
                    //count<=count+1;
                end 
            end
            WAIT:
                if(full_price && dispense)begin 
                    state<=PRODUCT;
                    extra_reg<=0;
                    //count<=0;
                end
                else if (extra_price && dispense)begin 
                    state<=PRODUCT;
                    extra_reg<=1;
                    //count<=count+1;
                end
            PRODUCT:
                if(extra_reg)begin 
                    state<=CHANGE;
                    //count<=0;
                end
                else begin 
                    state<=IDLE;
                    //count<=count+1;
                end
            CHANGE:begin 
                state<=IDLE;
            end
                

    end

    always@(*)begin
        product=0;
        change=0;
        case(state)
            PRODUCT:product=1;
            CHANGE:change=1;
        
    end
        endcase
    endmodule
