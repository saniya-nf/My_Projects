module traffic_light_daynight(
    input clk,rst,time_of_day, //0 for day,1 for night
    output reg RED,YELLOW,GREEN
);

parameter red=2'b00,green=2'b01,yellow=2'b10;

reg[1:0]state;
reg[4:0]count;

always@(posedge clk,posedge rst)
    if(rst)begin
        count<=0;
        state<=0;
    end
    else begin 
        count<=count+1;
        case(state)
            red: 
            if(time_of_day)begin 
                if(count==15)begin 
                    state<=green;
                    count<=0;
                end
            end
            else begin 
                if(count==30)begin 
                    state<=green;
                    count<=0;
                end
            end
            green: 
            if(time_of_day)begin 
                if(count==10)begin 
                    state<=yellow;
                    count<=0;
                end
            end
            else begin 
                if(count==20)begin 
                    state<=yellow;
                    count<=0;
                end
            end
            yellow:
            if(time_of_day)begin 
                if(count==5)begin 
                    state<=red;
                    count<=0;
                end
            end
            else begin 
                if(count==10)begin 
                    state<=red;
                    count<=0;
                end
            end
        endcase
    end
 
    always@(*)
        case(state)
            red:{RED,YELLOW,GREEN}=3'b100;
            green:{RED,YELLOW,GREEN}=3'b001;
            yellow:{RED,YELLOW,GREEN}=3'b010;
            default:{RED,YELLOW,GREEN}=3'b100;
        endcase
endmodule

