module FIFO(
    output reg [7:0]data_out,
    output reg [6:0]fifo_counter,//since we have to 64 locations and our fifo count has to go 1 higher, so u need 7 bits for fifo counter , why not[5:0]?
    input [7:0]data_in,
    input rst,clk,wr_en,rd_en,
    output reg fifo_empty,fifo_full
    );

    reg [5:0]rd_ptr,wr_ptr;
    reg [7:0]fifo_mem[63:0];

    always @(posedge clk or posedge rst)begin
         
        if(rst)
            fifo_counter<=0;
        else if (!fifo_full && wr_en && !fifo_empty && rd_en)
            fifo_counter<=fifo_counter;
        else if(!fifo_full && wr_en)
            fifo_counter<=fifo_counter+1;
        else if (!fifo_empty && rd_en)
            fifo_counter<=fifo_counter-1;
        else
            fifo_counter<=fifo_counter;
    end

    always@(fifo_counter)begin
        fifo_empty <= (fifo_counter==0);
        fifo_full <= (fifo_counter==64);
    end

    always@(posedge clk or posedge rst)begin 
        if(rst)
            data_out<=0;
        else begin
            if(rd_en && !fifo_empty)
                data_out<=fifo_mem[rd_ptr];
            else
                data_out<=data_out;
        end
    end

    always@(posedge clk) begin
        if(wr_en && !fifo_full)
            fifo_mem[wr_ptr]<=data_in;
        else 
            fifo_mem[wr_ptr]<=fifo_mem[wr_ptr];
    end

    always@(posedge clk or posedge rst)begin 
        if(rst) begin
            wr_ptr<=0;
            rd_ptr<=0;
        end
        else begin
            if(!fifo_full && wr_en)
                wr_ptr<=wr_ptr+1;
            else 
                wr_ptr<=wr_ptr;
            if(!fifo_empty && rd_en)//we can write both if in else block coz we check both ptrs happen simultaneously
                rd_ptr<=rd_ptr+1;//so while updating ur wr_ptr , u also check for ur read_signal if ur rd_en is active so ur able to read and increment ur rd_ptr also .
            else 
                rd_ptr<=rd_ptr;//now if ur rd_ptr also moves in same dir i.e tail(rd_ptr)goes after head(wr_ptr),rd_ptr cant overatke wr_ptr so here thats why else just retain ur rd_ptr as it is .
        end 
    end
endmodule

