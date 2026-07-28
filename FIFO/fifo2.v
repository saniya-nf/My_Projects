module FIFO_msb(
    output reg [7:0] data_out,
    input [7:0] data_in,
    input rst, clk, wr_en, rd_en,
    output fifo_empty, fifo_full
);

reg [6:0] wr_ptr, rd_ptr;  // 7 bits! (6 addr + 1 MSB)
reg [7:0] fifo_mem [63:0];

// Full and Empty flags
assign fifo_empty = (wr_ptr == rd_ptr);
assign fifo_full  = (wr_ptr[5:0] == rd_ptr[5:0]) && (wr_ptr[6]  != rd_ptr[6]);

// Write logic
always@(posedge clk)
    if(wr_en && !fifo_full)
        fifo_mem[wr_ptr[5:0]] <= data_in;

// Read logic
always@(posedge clk or posedge rst)
    if(rst)
        data_out <= 0;
    else if(rd_en && !fifo_empty)
        data_out <= fifo_mem[rd_ptr[5:0]];

// Pointer logic
always@(posedge clk or posedge rst)
    if(rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
    end
    else begin
        if(wr_en && !fifo_full)
            wr_ptr <= wr_ptr + 1;
        if(rd_en && !fifo_empty)
            rd_ptr <= rd_ptr + 1;
    end

endmodule