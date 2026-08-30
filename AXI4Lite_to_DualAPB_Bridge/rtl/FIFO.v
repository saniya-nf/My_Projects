module fifo(
    input clk,rst,wen,
    input [64:0]fifo_wdata,
    output fifo_empty,fifo_full,
    output reg [64:0] RDATA//when wen this ort will be an i/p for fsm bridge , when wen =0 this port will give i/p to axi slave
);
//we are using sync fifo coz axi and apb are in the same sys,using same clk for simplicity
    
    reg [64:0]fifo_mem;
    reg [1:0]wr_ptr,rd_ptr;//1 MSB+ 1 location depth fifo
    /*bit[0] = address (0 only for depth=1!)
     bit[1] = MSB for full/empty detection! */

    assign fifo_empty=(wr_ptr==rd_ptr);//we are going by msb change bit for full and empty coz counter and shift reg code gets bigger
    assign fifo_full=(wr_ptr[1] != rd_ptr[1]) && (wr_ptr[0]==rd_ptr[0]);

    //write logic
    always@(posedge clk)
    if(wen && !fifo_full)
        fifo_mem <= fifo_wdata; //BUG-no index needed coz fifo mem is a single register -->fifo_mem[wr_ptr[1:0]] <= fifo_wdata;

    //read logic
    always@(posedge clk,posedge rst)
        if(rst)
            RDATA<=0;
        else if(!wen && !fifo_empty)
            RDATA <= fifo_mem;//similalry no index needed -->RDATA<=fifo_mem[rd_ptr[1:0]];

        /*fifo_mem[wr_ptr[1:0]]  // ❌ 2 bit index for 1 location!
        fifo_mem[0]// ✅ always location 0! */

    /*pointer logic --- wr_ptr+1 if wen && ~fifo_full and rd_ptr+1 if ren &~fifo_empty
    ptr logic is not needed If DEPTH=1 — no pointer increment needed!
    address is  always 0but msb still need to flip for full/empty-ohh*/

    always@(posedge clk,posedge rst)
        if(rst)begin 
            wr_ptr<=0;
            rd_ptr<=0;
        end
        else begin 
            if(wen && !fifo_full)
                wr_ptr<= wr_ptr+1;
            if(!wen && !fifo_empty) /*What if neither read nor write needed?
                                    wen=0 always triggers read! Even when bridge not ready! Better to add rd_en separately!*/
                rd_ptr<=rd_ptr+1;
        end
    endmodule


