/*
+------------------------------------------------------+
|Coded by: circuitfever.com                            |
|License: MIT License                                  |
|Description: Basic UART transmitter module.           |
+------------------------------------------------------+
*/
module transmitter (
    input tx_clk,
    input enable,
    input load_send,
    input [7:0] data_in,
    output reg TX,
    output reg done
);

reg [1:0] state;
reg [9:0] frame;                    //start bit + data bits + stop bit

reg [3:0] count;

localparam idle_state = 0;
localparam send_state = 1;
localparam done_state = 2;

always @ (posedge clk) begin 
    if(enable) begin 
        state <= idle_state;
        TX <= 1;                    //In idle state, TX is high
        done <= 0;
        count <= 0;
    end else begin 
        case (state)
            idle_state: begin 
                count <= 0;
                done <= 0;
                TX <= 1;
                if(load_send) begin 
                    frame <= {1'b0,data_in,1'b1};               //start bit || data bits || stop bit
                    state <= idle_state;
                end else begin 
                    frame <= frame;
                    state <= send_state;
                end
            end 
            send_state: begin 
                TX <= frame[8];
                count <= count + 1;
                frame <= frame << 1;
                if(count == 10)
                    state <= done_state;
                else 
                    state <= send_state;
            end
            done_state: begin 
                done <= 1;
                state <= idle_state;
            end
            default: begin 
                state <= idle_state; 
                done <= 0;
                TX <= 1;
            end
        endcase
    end
end

endmodule