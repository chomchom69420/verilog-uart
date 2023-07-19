module Debounce_Project_Top
  (input  i_Clk,
   input  i_Switch_1,
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
                             
//   reg  r_LED_1    = 1'b0;
  reg  r_Switch_1 = 1'b0;
  wire w_Switch_1;

  reg[3:0] r_Seven_Seg_Counter_1=4'b0000;
  reg[3:0] r_Seven_Seg_Counter_2=4'b0000;

  wire w_Segmenent2_A;
  wire w_Segmenent2_B;
  wire w_Segmenent2_C;
  wire w_Segmenent2_D;
  wire w_Segmenent2_E;
  wire w_Segmenent2_F;
  wire w_Segmenent2_G;
  wire w_Segmenent1_A;
  wire w_Segmenent1_B;
  wire w_Segmenent1_C;
  wire w_Segmenent1_D;
  wire w_Segmenent1_E;
  wire w_Segmenent1_F;
  wire w_Segmenent1_G;
   
  // Instantiate Debounce Module
  Debounce_Switch Debounce_Inst
  (.i_Clk(i_Clk), 
   .i_Switch(i_Switch_1),
   .o_Switch(w_Switch_1));
   
  // Purpose: Toggle LED output when w_Switch_1 is released.
  always @(posedge i_Clk)
  begin
    r_Switch_1 <= w_Switch_1;         // Creates a Register
 
    // This conditional expression looks for a falling edge on w_Switch_1.
    // Here, the current value (i_Switch_1) is low, but the previous value
    // (r_Switch_1) is high.  This means that we found a falling edge.
    if (w_Switch_1 == 1'b0 && r_Switch_1 == 1'b1)
    begin
        //   r_LED_1 <= ~r_LED_1;         // Toggle LED output
        //Instead of toggling LED output turn increment counter and display on LED
        if(r_Seven_Seg_Counter_2 < 9)
            r_Seven_Seg_Counter_2 <= r_Seven_Seg_Counter_2 + 1;
        else if(r_Seven_Seg_Counter_2 == 9)
        begin
            r_Seven_Seg_Counter_2 <= 0;
            if(r_Seven_Seg_Counter_1 <9)
                r_Seven_Seg_Counter_1 <= r_Seven_Seg_Counter_1 + 1;
            else 
                r_Seven_Seg_Counter_1 <= 0;           
        end
    end
  end
 
//   assign o_LED_1 = r_LED_1;

//Inst binary to seven segment converter module 
Binary_To_Seven_Segment Seven_Seg2_Inst
  (.i_Clk(i_Clk), 
   .i_Binary_Num(r_Seven_Seg_Counter_2),
   .o_Segment_A(w_Segmenent2_A),
   .o_Segment_B(w_Segmenent2_B),
   .o_Segment_C(w_Segmenent2_C),
   .o_Segment_D(w_Segmenent2_D),
   .o_Segment_E(w_Segmenent2_E),
   .o_Segment_F(w_Segmenent2_F),
   .o_Segment_G(w_Segmenent2_G));

Binary_To_Seven_Segment Seven_Seg1_Inst
  (.i_Clk(i_Clk), 
   .i_Binary_Num(r_Seven_Seg_Counter_1),
   .o_Segment_A(w_Segmenent1_A),
   .o_Segment_B(w_Segmenent1_B),
   .o_Segment_C(w_Segmenent1_C),
   .o_Segment_D(w_Segmenent1_D),
   .o_Segment_E(w_Segmenent1_E),
   .o_Segment_F(w_Segmenent1_F),
   .o_Segment_G(w_Segmenent1_G));

assign o_Segment2_A = ~w_Segmenent2_A;
assign o_Segment2_B = ~w_Segmenent2_B;
assign o_Segment2_C = ~w_Segmenent2_C;
assign o_Segment2_D = ~w_Segmenent2_D;
assign o_Segment2_E = ~w_Segmenent2_E;
assign o_Segment2_F = ~w_Segmenent2_F;
assign o_Segment2_G = ~w_Segmenent2_G;

assign o_Segment1_A = ~w_Segmenent1_A;
assign o_Segment1_B = ~w_Segmenent1_B;
assign o_Segment1_C = ~w_Segmenent1_C;
assign o_Segment1_D = ~w_Segmenent1_D;
assign o_Segment1_E = ~w_Segmenent1_E;
assign o_Segment1_F = ~w_Segmenent1_F;
assign o_Segment1_G = ~w_Segmenent1_G;
 
endmodule