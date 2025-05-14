/*
+------------------------------------------------------+
|Coded by: circuitfever.com                            |
|License: MIT License                                  |
|Description: Basic UART transmitter module.           |
+------------------------------------------------------+
*/
module receiver (
    input rx_clk,
    input enable,
    input RX,
    output reg [7:0] data_in,
    output reg done
);

reg [1:0] state;
reg [3:0] count;
reg [3:0] received_byte;

localparam idle_state = 0;
localparam receive_state = 1;
localparam done_state = 2;

always @ (posedge clk) begin 
    if(enable) begin 
        state <= idle_state;
        count <= 0;
        done <= 0;
    end else begin 
        case (state)
            idle_state: begin 
                received_byte <= 0;
                if(count == 15) begin 
                    state <= receive_state;
                    count <= 0;
                end else begin  
                    state <= receive_state;
                    if(~RX)
                        count <= count + 1;
                    else
                        count <= count;
                end
            end 
            receive_state: begin
                count <= count + 1;

                if(count == 15)
                    received_byte <= received_byte + 1;
                else 
                    received_byte <= received_byte;

                if(received_byte == 8)
                    state <= done_state;
                else 
                    state <= receive_state;
                
                if(count == 7)
                    data_in <= {data_in[6:0],RX};
                else
                    data_in <= data_in;
            end
            done_state: begin 
                done <= 1;
                
                if(count == 15) begin 
                    count <= 0;
                    state <= idle_state
                end else begin  
                    state <= done_state;
                    count <= count + 1;
                end
                
            end
            default: begin 
                state <= idle_state; 
                done <= 0;
            end
        endcase
    end
end

endmodule