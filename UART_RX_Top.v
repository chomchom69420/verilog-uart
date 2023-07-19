module UART_RX_Top (
    input i_Clk,
    input i_UART_RX,

    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G,

    output o_Segment1_A,
    output o_Segment1_B,
    output o_Segment1_C,
    output o_Segment1_D,
    output o_Segment1_E,
    output o_Segment1_F,
    output o_Segment1_G);

    wire w_RX_DV; //Its OK to not create this as well, as the Data Valid signal is not going to be used anywhere
    wire[7:0] w_UART_RX_Byte;

    wire w_Segmenent1_A, w_Segmenent2_A;
    wire w_Segmenent1_B, w_Segmenent2_B;
    wire w_Segmenent1_C, w_Segmenent2_C;
    wire w_Segmenent1_D, w_Segmenent2_D;
    wire w_Segmenent1_E, w_Segmenent2_E;
    wire w_Segmenent1_F, w_Segmenent2_F;
    wire w_Segmenent1_G, w_Segmenent2_G;

    //Clocks per bit = Clock frequency / Baud rate

    UART_RX #(.CLKS_PER_BIT(217)) UART_RX_Inst
    (.i_Clk(i_Clk),
    .i_RX_Serial(i_UART_RX),
    .o_RX_Byte(w_UART_RX_Byte),
    .o_RX_DV(w_RX_DV));

    //Instantiate seven segments
    Binary_To_Seven_Segment Seven_Seg1_Inst
    (.i_Clk(i_Clk),
    .i_Binary_Num(w_UART_RX_Byte[7:4]),
    .o_Segment_A(w_Segmenent1_A),
    .o_Segment_B(w_Segmenent1_B),
    .o_Segment_C(w_Segmenent1_C),
    .o_Segment_D(w_Segmenent1_D),
    .o_Segment_E(w_Segmenent1_E),
    .o_Segment_F(w_Segmenent1_F),
    .o_Segment_G(w_Segmenent1_G)
    );

    Binary_To_Seven_Segment Seven_Seg2_Inst
    (.i_Clk(i_Clk),
    .i_Binary_Num(w_UART_RX_Byte[3:0]),
    .o_Segment_A(w_Segmenent2_A),
    .o_Segment_B(w_Segmenent2_B),
    .o_Segment_C(w_Segmenent2_C),
    .o_Segment_D(w_Segmenent2_D),
    .o_Segment_E(w_Segmenent2_E),
    .o_Segment_F(w_Segmenent2_F),
    .o_Segment_G(w_Segmenent2_G)
    );

    assign o_Segment1_A = ~w_Segmenent1_A;
    assign o_Segment1_B = ~w_Segmenent1_B;
    assign o_Segment1_C = ~w_Segmenent1_C;
    assign o_Segment1_D = ~w_Segmenent1_D;
    assign o_Segment1_E = ~w_Segmenent1_E;
    assign o_Segment1_F = ~w_Segmenent1_F;
    assign o_Segment1_G = ~w_Segmenent1_G;

    assign o_Segment2_A = ~w_Segmenent2_A;
    assign o_Segment2_B = ~w_Segmenent2_B;
    assign o_Segment2_C = ~w_Segmenent2_C;
    assign o_Segment2_D = ~w_Segmenent2_D;
    assign o_Segment2_E = ~w_Segmenent2_E;
    assign o_Segment2_F = ~w_Segmenent2_F;
    assign o_Segment2_G = ~w_Segmenent2_G;

endmodule