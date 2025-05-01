/*
+------------------------------------------------------+
|Coded by: circuitfever.com                            |
|License: MIT License                                  |
|Description: Input clock for UART transmitter module. |
+------------------------------------------------------+
*/

module uart_txclk #(
    parameter master_clock = 100_000_000,
    parameter baud_rate = 115200
)(
input clk,
output reg clk_out
);

reg [31:0]count = 0;

always @ (posedge clk)begin
if(count == ((master_clock/baud_rate) -1))
    count <= 0;
else
    count <= count + 1;

clk_out <= (count < ((master_clock/baud_rate)/2))?1:0;      //50 % duty cycle

end

endmodule