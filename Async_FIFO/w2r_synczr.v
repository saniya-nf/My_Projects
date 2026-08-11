module w2r_synczr (
    output reg [6:0]wq2_rptr,//output from FF2
    input [6:0]wptr_gray,
    input rrst_n,rclk
);
    reg[6:0]wq1_rptr;//FF1

    always@(posedge rclk ,negedge rrst_n)
        if(!rrst_n)begin
            wq1_rptr<=7'b0;
            wq2_rptr<=7'b0;
        end
        else begin
            wq1_rptr<=wptr_gray;//FF1 catches the wptr_gray from write clock domain
            wq2_rptr<=wq1_rptr;//FF2 stabilizes the wptr_gray to be used in read clock domain
        end
endmodule