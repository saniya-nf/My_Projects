module traffic_light_controller #(parameter RED=2'b00,YELLOW=2'b01,GREEN=2'b10)(
    input clk,rst,
    output reg red,yellow,green
);

reg[1:0]state;
reg[4:0]count;

/*state <= GREEN means:
state IS the next state!
No separate next_state variable needed!

This is 1 always block style! ✅
Simpler for timer based FSMs! */

/*// We combined state register + next state
 // 3 block style needs next_state:
always@(*) // next state logic
    case(state)
        RED: if(count==20) next_state=GREEN;

always@(posedge clk) // state register
    state <= next_state;

// 1 block style — combined:
always@(posedge clk)
    case(state)
        RED: if(count==20) state<=GREEN; // ✅ simpler!*/
always@(posedge clk,negedge rst)
    if(!rst)begin 
        state<=RED;
        count<=0;
    end
    else begin 
        count<=count+1;
        case(state)
            RED: 
                if(count==5'd20)begin 
                    state<=GREEN;
                    count<=0;//again count=0 to reset the timer,so it starts counting fresh for the next state
                end
            GREEN:
                if(count==5'd15)begin 
                    state<=YELLOW;
                    count<=0;
                end
            YELLOW:
                if(count==5'd5)begin 
                    state<=RED;
                    count<=0;
                end
        endcase
    end

    always@(*)
        case(state)
            RED:{red,yellow,green}=3'b100;
            GREEN:{red,yellow,green}=3'b001;
            YELLOW:{red,yellow,green}=3'b010;
            default:{red,yellow,green}=3'b100;
        endcase

    endmodule

    ///////////////////////////////////////////////////////////////////
    module traffic_light_3blk(
    input clk, rst,
    output reg red, yellow, green
);

parameter RED    = 2'b00,
          GREEN  = 2'b01,
          YELLOW = 2'b10;

reg [1:0] state, next_state;
reg [5:0] count;

// Block 1 — state register
always@(posedge clk or posedge rst)
    if(rst) begin
        state <= RED;
        count <= 0;
    end
    else begin
        state <= next_state;
        if(next_state != state)
            count <= 0;  // reset when state changes!
        else
            count <= count + 1;
    end

// Block 2 — next state logic
always@(*) begin
    next_state = state;
    case(state)
        RED:    if(count == 20) next_state = GREEN;
        GREEN:  if(count == 15) next_state = YELLOW;
        YELLOW: if(count == 5)  next_state = RED;
        default: next_state = RED;
    endcase
end

// Block 3 — output logic
always@(*)
    case(state)
        RED:    {red,yellow,green} = 3'b100;
        GREEN:  {red,yellow,green} = 3'b001;
        YELLOW: {red,yellow,green} = 3'b010;
        default:{red,yellow,green} = 3'b100;
    endcase

endmodule