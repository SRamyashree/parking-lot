module Slot_Manager(
    input  wire clk,
    input  wire rst,
    input  wire [1:0] state,
    output reg  [3:0] slots
);

    localparam IDLE  = 2'b00,
               ENTRY = 2'b01,
               EXIT  = 2'b10,
               ALARM = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst)
            slots <= 4'b0000; // all free
        else begin
            case(state)
                ENTRY: begin
                    if (!slots[0]) slots[0] <= 1'b1;
                    else if (!slots[1]) slots[1] <= 1'b1;
                    else if (!slots[2]) slots[2] <= 1'b1;
                    else if (!slots[3]) slots[3] <= 1'b1;
                end
                EXIT: begin
                    if (slots[0]) slots[0] <= 1'b0;
                    else if (slots[1]) slots[1] <= 1'b0;
                    else if (slots[2]) slots[2] <= 1'b0;
                    else if (slots[3]) slots[3] <= 1'b0;
                end
                default: slots <= slots;
            endcase
        end
    end
endmodule
