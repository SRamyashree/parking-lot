module FSM_Controller(
    input  wire clk,
    input  wire rst,
    input  wire mode_entry,
    input  wire lot_full,
    output reg [1:0] state
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        ENTRY = 2'b01,
        EXIT  = 2'b10,
        ALARM = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Sequential
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Combinational
    always @(*) begin
        next_state = current_state;
        case(current_state)
            IDLE: begin
                if (mode_entry && !lot_full)
                    next_state = ENTRY;
                else if (mode_entry && lot_full)
                    next_state = ALARM;
                else if (!mode_entry)
                    next_state = EXIT;
            end
            ENTRY: next_state = IDLE;
            EXIT:  next_state = IDLE;
            ALARM: begin
                if (!mode_entry)
                    next_state = EXIT;
                else if (mode_entry && !lot_full)
                    next_state = ENTRY;
            end
        endcase
    end

    // Output state
    always @(*) state = next_state;

endmodule
