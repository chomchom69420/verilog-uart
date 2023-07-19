module Led_Blinking
#(parameter p_Counter_10Hz = 1250000,
  parameter p_Counter_5Hz = 2500000,
  parameter p_Counter_2Hz = 6250000,
  parameter p_Counter_1Hz = 12500000)
(input i_Clk, 
output reg o_LED_1 = 1'b0,
output reg o_LED_2 = 1'b0,
output reg o_LED_3 = 1'b0,
output reg o_LED_4 = 1'b0);

reg[31:0] r_Counter_10Hz = 0;
reg[31:0] r_Counter_5Hz = 0;
reg[31:0] r_Counter_2Hz = 0;
reg[31:0] r_Counter_1Hz = 0;

always @(posedge i_Clk)
begin
    if(r_Counter_10Hz < p_Counter_10Hz)
        r_Counter_10Hz <= r_Counter_10Hz + 1;
    else 
    begin
        r_Counter_10Hz <= 0;
        o_LED_1 <= ~ o_LED_1;
    end
end

always @(posedge i_Clk)
begin
    if(r_Counter_5Hz < p_Counter_5Hz)
        r_Counter_5Hz <= r_Counter_5Hz + 1;
    else 
    begin
        r_Counter_5Hz <= 0;
        o_LED_2 <= ~ o_LED_2;
    end
end

always @(posedge i_Clk)
begin
    if(r_Counter_2Hz < p_Counter_2Hz)
        r_Counter_2Hz <= r_Counter_2Hz + 1;
    else 
    begin
        r_Counter_2Hz <= 0;
        o_LED_3 <= ~ o_LED_3;
    end
end

always @(posedge i_Clk)
begin
    if(r_Counter_1Hz < p_Counter_1Hz)
        r_Counter_1Hz <= r_Counter_1Hz + 1;
    else 
    begin
        r_Counter_1Hz <= 0;
        o_LED_4 <= ~ o_LED_4;
    end
end


endmodule