module tt_um_parking_manager(
    input  wire clk,
    input  wire rst,
    input  wire mode_entry,
    output wire [3:0] slot_available,
    output wire [2:0] free_count,
    output wire lot_full,
    output wire buzzer
);

    wire [1:0] state;
    wire [3:0] slots;

    // Instantiate FSM
    FSM_Controller fsm(
        .clk(clk),
        .rst(rst),
        .mode_entry(mode_entry),
        .lot_full(&slots),
        .state(state)
    );

    // Instantiate Slot Manager
    Slot_Manager sm(
        .clk(clk),
        .rst(rst),
        .state(state),
        .slots(slots)
    );

    // Outputs
    assign slot_available = ~slots;
    assign free_count     = 4 - (slots[0] + slots[1] + slots[2] + slots[3]);
    assign lot_full       = &slots;
    assign buzzer         = (state == 2'b11); // ALARM state

endmodule
