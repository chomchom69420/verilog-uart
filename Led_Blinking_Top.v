module LED_Blinking_Top
 (input  i_Clk,
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4);
 
  // Input clock is 25 MHz
  // Generics represent count values to which internals count
  // before toggling their LEDs
  Led_Blinking #(.p_Counter_10Hz(1250000), 
              .p_Counter_5Hz(2500000), 
              .p_Counter_2Hz(6250000),
              .p_Counter_1Hz(12500000)) LED_Blink_Inst
    (.i_Clk(i_Clk),
     .o_LED_1(),    // this is perfectly OK to do
     .o_LED_2(o_LED_2),
     .o_LED_3(o_LED_3),
     .o_LED_4(o_LED_4));
 
endmodule