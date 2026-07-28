module FIFO #(parameter DEPTH=4,WIDTH=8)(
    output reg [WIDTH-1:0] data_out,
    output fifo_full,
    output fifo_empty,
    input [WIDTH-1:0]data_in,
    input clk,rst,wr_en,rd_en
);

    reg[WIDTH-1:0] sr[DEPTH-1:0];
    reg[2:0]count;

    assign fifo_full=(count==DEPTH);
    assign fifo_empty=(count==0);

    always@(posedge clk or posedge rst)
        if(rst)begin
            count<=0;
            sr[0]<=0;
            sr[1]<=0;       
            sr[2]<=0;
            sr[3]<=0;
        end
        else begin 
            if(wr_en && !fifo_full)begin 
                sr[0]<=data_in;
                sr[1]<=sr[0];
                sr[2]<=sr[1];
                sr[3]<=sr[2];
                count<=count+1;
            end

            if(rd_en && !fifo_empty)
                count<=count-1;
        end

    always@(posedge clk)
        if(rd_en && !fifo_empty)
            data_out<=sr[count-1];

    endmodule
        