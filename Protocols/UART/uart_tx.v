module uarttx /*#(parameter clk_freq = 1000000,
                parameter baud_rate = 9600
                )*/
                #(parameter idle = 2'b00, start= 2'b01, transfer= 2'b10, done= 2'b11 )(
                    input clk,rst,
                    input newd_flag,
                    input [7:0] data_tx,
                    output reg tx,
                    output reg donetx
                );

                /*localparam clkcount = (clk_freq/baud_rate);

                integer count =0;
                integer counts =0;

                reg uclk =0;

                enum bit[1:0] {idle = 2'b00, start= 2'b01, transfer= 2'b10, done= 2'b11} state;*/
                
