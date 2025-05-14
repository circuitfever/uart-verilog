/*
+------------------------------------------------------+
|Coded by: circuitfever.com                            |
|License: MIT License                                  |
|Description: Input clock for UART transmitter module. |
+------------------------------------------------------+
*/

module uart_clk_gen(
    input clk,              
    output reg txclk,
    output reg rxclk,
    output reg one_sec
);

parameter master_clock = 24_000_000;
parameter baud_rate = 115200;

reg [31:0]count_rx,count_tx,clock_count;

always @(posedge clk) begin

if(count_rx == ((master_clock/(baud_rate * 16)) -1))             //Baud rate is 115200
        count_rx <= 0;
else
        count_rx <= count_rx + 1;

if(count_tx == ((master_clock/baud_rate) -1))            //baud rate is 115200
        count_tx <= 0;
else
        count_tx <= count_tx + 1;
        
if(clock_count == (master_clock-1))
    clock_count <= 0;
else 
    clock_count <= clock_count + 1;

txclk <= (count_tx < ((master_clock/baud_rate)/2))?1:0;      //50 % duty cycle
rxclk <= (count_rx < (master_clock/(baud_rate * 32)))?1:0;  //50% duty cycle
one_sec <= (clock_count < (master_clock/2))?1:0;                            //1 second clock
end

endmodule