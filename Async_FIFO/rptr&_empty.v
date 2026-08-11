module rptr_empty(
    output reg [6:0]rptr_bin,
    output reg rempty,
    output  [5:0]rptr_addr,
    output reg [6:0]rptr_gray,
    input rclk,rrst_n,r_en,
    input [6:0]wq2_rptr
);


always@(posedge rclk or negedge rrst_n)
    if(!rrst_n)begin
        rptr_bin<=7'b0;
        rptr_gray<=7'b0;
    end
    else if(r_en && !rempty)begin
        rptr_bin<=rptr_bin + 1'b1;
        rptr_gray<=((rptr_bin +1'b1)>>1)^(rptr_bin+1'b1);
    end

assign rptr_addr = rptr_bin[5:0];
    
    always@(posedge rclk, negedge rrst_n)
        if(!rrst_n)
            rempty<=1;
        else 
            rempty<=(rptr_gray==wq2_rptr); //equal=empty
    
    endmodule
    