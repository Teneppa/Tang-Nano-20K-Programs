/* 7-segment counter */

// Counts from 0-9 and changes dled state on every state change

// Input clk is defined in seg7.sdc
// seg_out and dled is defined in seg7.cst
module seg7(input clk, output reg [6:0] seg_out);

    // States for the state machine
    reg [9:0] present_state, next_state;

    // Counter for lowering the clock rate
    reg [31:0] count_1s = 'd0;

    // Calculate wait time from clock frequency
    // eg. multiplier = 0.8 -> 800 mS wait
    // 0.2 -> 200 mS
    // etc.
    parameter CLK_FREQ = 27_000_000;
    parameter MULTIPLIER = 0.8;
    parameter result = (CLK_FREQ * MULTIPLIER + 0.5);

    // Sequential logic for handling the state machine and lowering clock frequency
    always@(posedge clk ) begin
        // If clock has ticked specified time
        // $floor(number) rounds a real value down to the nearest integer
        if( count_1s < $floor(result) ) begin
            // Counter goes up by one
            count_1s <= count_1s + 'd1;
        end else begin
            // If clock has ticked specified amount

            // Set the next state
            present_state <= next_state;

            // Reset counter
            count_1s <= 'd0;
        end
    end

    // Always comb alternative
    // Handles 7-segment led driving and setting the next state

    //Segment order: [g,f,e,d,c,b,a]
    always @* begin
        case(present_state)
            0: begin
                seg_out = 7'b0111111;
                next_state = 1;
            end
            1: begin
                seg_out = 7'b0000110;
                next_state = 2;
            end
            2: begin
                seg_out = 7'b1011011;
                next_state = 3;
            end
            3: begin
                seg_out = 7'b1001111;
                next_state = 4;
            end
            4: begin
                seg_out = 7'b1100110;
                next_state = 5;
            end
            5: begin
                seg_out = 7'b1101101;
                next_state = 6;
            end
            6: begin
                seg_out = 7'b1111101;
                next_state = 7;
            end
            7: begin
                seg_out = 7'b0000111;
                next_state = 8;
            end
            8: begin
                seg_out = 7'b1111111;
                next_state = 9;
            end
            9: begin
                seg_out = 7'b1101111;
                next_state = 0;
            end
            default: begin
                seg_out = 7'b0000000;
                next_state = 2;
            end
        endcase
    end

endmodule
