module axi_slave(
    input clk,rst,
    //write addr channel
    input [31:0] AWADDR,
    input AWVALID,
    output reg AWREADY,
    

    //write DATA channel
    input [31:0] WDATA,
    input WVALID,
    input [3:0]WSTRB,
    output reg WREADY,
    
    output reg [1:0]BRESP,
    output reg BVALID,
    input BREADY,

    input [31:0]ARADDR,
    input ARVALID,
    output reg ARREADY,

    output reg [31:0]RDATA,
    output reg RVALID,
    output reg[1:0] RRESP,
    input RREADY,

    //TO FIFO
    output fifo_wen, //wire coz assign
    output [64:0]fifo_wdata,//wire
    input fifo_full//written in fifo module
);

    wire fifo_wen;
    wire [64:0]fifo_wdata;

    always@(posedge clk,posedge rst)
    if(rst)begin
        //write channel
        AWREADY<=0;//ALL output reg signals → reset to 0!
        WREADY<=0;
        BRESP<=0;
        BVALID<=0;
        /*fifo_wen<=0;
        fifo_wdata<=0; BUG-fifo_wen and fifo_wdata are wires — can't reset in always block:*/

        //read channel
        ARREADY<=0;
        RDATA<=0;
        RVALID<=0;
        RRESP<=0;
    end
    else begin
        if( AWVALID && !fifo_full)
            AWREADY<=1;/*// If condition false → AWREADY HOLDS old value!
                        // = stays 1 forever after first handshake!  */
        else 
            AWREADY<=0;//with else it deasserts when not needed
        
        if(WVALID &&!fifo_full)
            WREADY<=1;
        else
            WREADY <= 0;  // deassert!
        

        if(fifo_wen)begin 
            BRESP<=2'b00;
            BVALID<=1;
        end
        else if(BVALID && BREADY)
            BVALID<=0;//handshaking is done!

        if(ARVALID && !fifo_full)
            ARREADY<=1;
        else
            ARREADY <= 0;

    end

assign fifo_wen = (AWVALID & AWREADY & WVALID  & WREADY); 
assign fifo_wdata = {1'b1, AWADDR, WDATA}; 