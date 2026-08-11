module async_fifo_top #(parameter DATA_WIDTH =8,ADDR_WIDTH=6)(
    output [DATA_WIDTH-1:0]rdata,
    output wfull,rempty,
    input [DATA_WIDTH-1:0]wdata,
    input wclk,w_en,wrst_n,rclk,r_en,rrst_n
    );

    wire [ADDR_WIDTH:0]wptr_gray,rptr_gray;
    wire [ADDR_WIDTH:0]rq2_wptr,wq2_rptr;
    wire [ADDR_WIDTH-1:0]wptr_addr,rptr_addr;
    wire [ADDR_WIDTH:0]wptr_bin,rptr_bin;

    wptr_full wp(
        .wptr_bin(wptr_bin),
        .wfull(wfull),
        .wptr_addr(wptr_addr),
        .wptr_gray(wptr_gray),
        .wclk(wclk),
        .wrst_n(wrst_n),
        .w_en(w_en),
        .rq2_wptr(rq2_wptr)
    );

    rptr_empty r(
        .rptr_bin(rptr_bin),
        .rempty(rempty),
        .rptr_addr(rptr_addr),
        .rptr_gray(rptr_gray),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .r_en(r_en),
        .wq2_rptr(wq2_rptr)
    );

    w2r_synczr w2r(
        .wq2_rptr(wq2_rptr),
        .wptr_gray(wptr_gray),
        .rrst_n(rrst_n),
        .rclk(rclk)
    );

    r2w_synczr r2w(
        .rq2_wptr(rq2_wptr),
        .rptr_gray(rptr_gray),
        .wrst_n(wrst_n),
        .wclk(wclk)
    );

    fifo_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH-1)) fifo_inst (
        .rdata(rdata),
        .wdata(wdata),
        .waddr(wptr_addr),
        .raddr(rptr_addr),
        .wen(w_en),
        .wclk(wclk),
        // fifo mem doest need .rclk(rclk) coz read is asynchronous, assign rdata=mem[raddr]data avail immediately when raddr changes, no clk needed
    );

endmodule