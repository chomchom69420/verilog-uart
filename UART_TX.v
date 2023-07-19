module UART_TX 
#(parameter CLKS_PER_BIT = 217)
(
    input i_Clk,
    input i_TX_DV, //Data valid signal to start parallelising 
    input [7:0] i_TX_Byte,
    output o_TX_Active, //HIGH when data is being parallelised
    output reg o_TX_Serial, //Serial out 
    output o_TX_Done //HIGH pulse of one clock cycle duration when done
);

    //My implementation 
    parameter IDLE = 4'b0000;
    parameter TX_START_BIT = 4'b0001;
    parameter TX_DATA_BIT = 4'b0010;
    parameter TX_STOP_BIT = 4'b0011;
    parameter CLEANUP = 4'b0100;

    reg [7:0] r_Clock_Counter = 0;
    reg [2:0] r_Bit_Index = 0;
    reg [3:0] r_SM_Main = IDLE;
    reg [7:0] r_TX_Data = 0; 
    reg r_TX_Serial = 0;
    reg r_TX_Done = 0;
    reg r_TX_Active = 0;
    
    always @(posedge i_Clk)
    begin
        case (r_SM_Main)
            IDLE:
            begin
                r_TX_Data <=0;
                r_TX_Active <=0;
                r_TX_Done <= 0;
                r_TX_Data <= 0;
                r_TX_Serial <= 0;
                r_Bit_Index <= 0;
                r_Clock_Counter <= 0;

                if(i_TX_DV == 1'b1)
                begin
                    //Start parallelising
                    r_SM_Main <= TX_START_BIT;
                    r_TX_Active <= 1'b1;
                    r_TX_Data <= i_TX_Byte;
                end
                else
                    r_SM_Main <= IDLE;
            end

            TX_START_BIT:
            begin
                o_TX_Serial <= 1'b0;

                //Keep for CLKS_PER_BIT clock cycles
                if(r_Clock_Counter < CLKS_PER_BIT - 1)
                begin
                    r_Clock_Counter <= r_Clock_Counter +1;
                    r_SM_Main <= TX_START_BIT;
                end
                else begin
                    r_SM_Main <= TX_DATA_BIT;
                    r_Clock_Counter <= 0;
                end
            end

            TX_DATA_BIT:
            begin
                //Send data on Serial out line 
                o_TX_Serial <= r_TX_Data[r_Bit_Index];

                //Wait for CLKS_PER_BIT clock cycles before sending next data bit
                if(r_Clock_Counter < CLKS_PER_BIT -1)
                begin
                    r_SM_Main <= TX_DATA_BIT;
                    r_Clock_Counter <= r_Clock_Counter +1;
                end
                else
                begin
                    r_Clock_Counter <= 0;

                    if(r_Bit_Index <7)
                    begin
                        r_Bit_Index <= r_Bit_Index +1;
                        r_SM_Main <= TX_DATA_BIT;
                    end
                    else
                    begin
                        r_Bit_Index <= 0;
                        r_SM_Main <= TX_STOP_BIT;
                    end
                end  
            end

            TX_STOP_BIT:
            begin
                //Send out the stop bit (HIGH) and then wait for CLKS_PER_BIT clock cycles

                o_TX_Serial <= 1'b1;

                if(r_Clock_Counter < CLKS_PER_BIT -1)
                begin
                    r_Clock_Counter <= r_Clock_Counter +1;
                    r_SM_Main <= TX_STOP_BIT;
                end

                //Stays for 1 clock cycle here
                else begin
                    r_Clock_Counter <= 0;
                    r_TX_Active <= 1'b0;
                    r_TX_Done <= 1'b1;
                    r_SM_Main <= CLEANUP;
                end
            end

            //Stays for 1 clock cycle here
            CLEANUP:
            begin
                r_Clock_Counter <= 0;
                r_TX_Active <= 1'b0;
                r_TX_Done <= 1'b0; //Makes done signal low after one clock cycle
                r_SM_Main <= IDLE;
            end

            default:
                r_SM_Main <= IDLE;
        endcase
    end
    assign o_TX_Active = r_TX_Active;
    assign o_TX_Done = r_TX_Done;
endmodule