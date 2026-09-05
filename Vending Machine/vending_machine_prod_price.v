module vending_machine(
    input clk,rst,coin_5,coin_10 ,dispense,
    output reg product,change
);
parameter IDLE=2'b00,WAIT=2'b01,PRODUCT=2'b10,CHANGE=2'b11;

reg [1:0]state;
reg [4:0]money;
reg[4:0]change_amt;


always@(posedge clk,posedge rst)
    if(rst)begin 
        state<=IDLE;
        money<=0;
        change_amt<=0;
    end
    else begin 
        case(state)
            IDLE: begin
                if(coin_5)begin 
                    state<=WAIT;
                    money<=5;
                end
                else if(coin_10)begin 
                    state<=WAIT;
                    money<=10;
                end
                else begin 
                    state<=IDLE;
                    
                end 
            end
            WAIT: 
                if(coin_5)begin 
                
                    money<=money+5;
                    
                end
                else if (coin_10)begin 
                    money<=money+10;
                end
                // Press dispense after enough money is inserted
                if(money>=15 && dispense)begin 
                    if(money>15)
                        change_amt<=money-15;
                    else 
                        change_amt<=0;
                    
                    state<=PRODUCT;
                end
            PRODUCT:
                if(change_amt>0)begin
                    state<=CHANGE;
                    
                end
                else begin 
                    state<=IDLE;
                    
                end
            CHANGE:begin 
                state<=IDLE;
                
                change_amt<=0;
            end
        endcase  

    end

    always@(*)begin
        product=0;
        change=0;
        case(state)
            PRODUCT:product=1;
            CHANGE:begin 
                //you already entered CHANGE only when change_amt > 0:if(change_amt>0)
                    change=1;
                else 
                    change=0;
            end
        endcase
    end
    endmodule
