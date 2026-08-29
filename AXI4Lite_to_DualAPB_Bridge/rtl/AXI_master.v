module axi_master(
    //write channel
    input clk,rst,
/*#1*/output reg [31:0]AWADDR,
    output reg AWVALID,
    input AWREADY,
    
/*#2*/output reg [31:0]WDATA,
    output reg WVALID,
    output reg[3:0]WSTRB,//we check for which byte is valid of data therefr in data channel
    input WREADY,

/*#3*/input [1:0]BRESP,
    input BVALID,
    output reg BREADY,

    //read channel
/*#4*/output reg [31:0]ARADDR,
    output reg ARVALID,
    input ARREADY, 
    
/*#5*/input [31:0]RDATA,
input RVALID,
output reg RREADY,
input [1:0] RRESP
);

always@(posedge clk,posedge rst)
    if(rst)begin
        //write channel
        AWADDR<=0;//ALL output reg signals → reset to 0
        AWVALID<=0;
        WDATA<=0;
        WVALID<=0;
        BREADY<=0;
        WSTRB<=0;

        //read channel
        ARADDR<=0;
        ARVALID<=0;
        RREADY<=0;
    end
    else begin
        //transactions -Step 1 — put address and data on bus
        AWADDR<=32'h0010_0010;//i gave random address to store my data into
        AWVALID<=1;
        WDATA<=32'hBCCC_CCCC;//data
        WVALID<=1;
        WSTRB <= 4'hF;//all bytes are valid for a simple design
        BREADY<=1;

        // Step 2 — wait for handshake
        if(AWREADY && WREADY)begin
            AWVALID<=0;//this shows handsake is done
            WVALID<=0;
        end

        //step3-response received
        if(BVALID)
            BREADY<=0;//as BREADY is always 1 , after slave asserts bready=1, which means handshake is complete so ,master deasserts bready for the next write to happen


    end
endmodule