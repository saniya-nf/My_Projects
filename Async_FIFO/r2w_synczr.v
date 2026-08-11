module r2w_synczr (
    output reg [6:0]rq2_wptr,//output from FF2
    input [6:0]rptr_gray,
    input wrst_n,wclk
);
    reg[6:0]rq1_wptr;//FF1

    always@(posedge wclk ,negedge wrst_n)
        if(!wrst_n)begin
            rq1_wptr<=7'b0;
            rq2_wptr<=7'b0;
        end
        else begin
            rq1_wptr<=rptr_gray;//FF1 catches the rptr_gray from read clock domain
            rq2_wptr<=rq1_wptr;//FF2 stabilizes the rptr_gray to be used in write clock domain
        end
endmodule