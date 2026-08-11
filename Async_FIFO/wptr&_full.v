module wptr_full(
    output reg [6:0]wptr_bin,
    output reg wfull,
    output reg [5:0]wptr_addr,
    output reg [6:0]wptr_gray,
    input wclk,wrst_n,w_en,
    input [6:0]rq2_wptr
);


always@(posedge wclk or negedge wrst_n)
    if(!wrst_n)begin
        wptr_bin<=7'b0;
        wptr_gray<=7'b0;
    end
    else if(w_en && !wfull)begin
        wptr_bin<=wptr_bin + 1'b1;
        wptr_gray<=((wptr_bin +1'b1)>>1)^(wptr_bin+1'b1);
    end

assign wptr_addr = wptr_bin[5:0];
    
    always@(posedge wclk, negedge wrst_n)
        if(!wrst_n)
            wfull<=0;
        else 
            wfull<=((wptr_gray[6] != rq2_wptr[6]) && (wptr_gray[5] != rq2_wptr[5]) && (wptr_gray[4:0]== rq2_wptr[4:0]));
    
    endmodule
    