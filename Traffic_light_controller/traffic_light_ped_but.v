module traffic_light (
    input clk,rst,time_of_day,ped_but,
    output reg red,green,yellow,walk
);

parameter RED=2'b00,GREEN=2'b01,YELLOW=2'b10,WALK=2'b11;

reg[1:0]state;
reg[5:0]count;
reg ped_req;//ped req is ur mem register,remembers button was pressed,stay high until walk state

always@(posedge clk,posedge rst)
    if(rst)begin
        count<=0;
        state<=red;
        ped_req<=0;
    end
    else begin 
        count<=count+1;
        if(ped_but)ped_req<=1;
        if(state==WALK)ped_req<=0;/*WALK state = pedestrian already walking!
Request has been SERVED! 
After WALK done:
ped_req = 0 → ready for next request! */
        case(state)
            RED:
                if(time_of_day)begin
                    if(count==15)begin 
                        state<=GREEN;
                        count<=0;
                    end
                end
                else begin 
                    if(count==30)begin 
                        state<=GREEN;
                        count<=0;
                    end
                end
            GREEN: if((ped_req && count>=5) || (time_of_day && count==10) || (!time_of_day && count==20))begin 
                    state<=YELLOW;
                    count<=0;
            end
            YELLOW:
                if(time_of_day)begin 
                    if(count==5)begin 
                        if(ped_req)begin 
                            state<=WALK;
                            count<=0;
                        end
                        else begin 
                            state<=RED;
                            count<=0;
                        end
                    end
                end
                else begin 
                    if(count==10)begin 
                        if(ped_req)begin 
                            state<=WALK;
                            count<=0;
                        end
                        else begin 
                            state<=RED;
                            count<=0;
                        end
                    end
                end
            WALK:
                if(count==15)begin 
                    state<=RED;
                    count<=0;
                end
        endcase 
    end
    
    always@(*)
        case(state)
            RED:{red,yellow,green,walk}=4'b1000;
            GREEN:{red,yellow,green,walk}=4'b0010;
            YELLOW:{red,yellow,green,walk}=4'b0100;
            WALK:{red,yellow,green,walk}=4'b1001;
            default:{red,yellow,green,walk}=4'b1000;
        endcase
endmodule