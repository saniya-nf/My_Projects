
module fifo_mem #(parameter DATA_WIDTH=8,ADDR_WIDTH=3)(
output [DATA_WIDTH-1:0]rdata,
input wclk,we,
input [DATA_WIDTH-1:0]wdata,
input [ADDR_WIDTH-1:0]waddr,raddr
);

reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

//write operation
always@(posedge wclk)
   /*if(rst) ,this  is not needed here coz fifo rst pointers already do that , pointers reset when both 
      show same locations. FIFO appears empty --old data never read, so no need to clr mem with rst*/
    if(we)
    mem[waddr] <= wdata;
//else mem[waddr] <= mem[waddr]; //no need to write coz mem automatically holds value .  the same data again, it will be retained in the memory
  
  //read operation - async coz if we use clk here then fifo wont be fast anymore it will depend on the rising edge of clk.
  assign rdata = mem[raddr];
endmodule//1) fifo_mem


