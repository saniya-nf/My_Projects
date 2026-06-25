module w2r_synczr (
    output wptr_rsync,
    input wptr,
    input rst,wclk,rclk
);

reg [ADDR_WIDTH:0] sync1,sync2;

    //ff
    always@(posedge wclk or negedge rst)
        if(!rst)
            
endmodule