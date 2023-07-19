module UART_RX 
#(parameter CLKS_PER_BIT = 217)
(
    input i_Clk, 
    input i_RX_Serial, 
    output o_RX_DV,
    output[7:0] o_RX_Byte);

    parameter IDLE = 3'b000;
    parameter RX_START_BIT = 3'b001;
    parameter RX_DATA_BIT = 3'b010;
    parameter RX_STOP_BIT = 3'b011;
    parameter CLEANUP = 3'b100;

    reg [7:0] r_Clock_Counter=0;
    reg [2:0] r_Bit_Index=0;  //8 bits long data --> 3 bits long index
    reg [7:0] r_RX_Byte =0;   //for storing the received bit after parallelising
    reg       r_RX_DV = 0;   //for storing the data valid signal 
    reg [2:0] r_SM_Main=0;   //stores state

    always @(posedge i_Clk)
    begin
        case(r_SM_Main)

            IDLE:
            begin
                //Make data valid 0, clock counter =0, and rx bit index as 0
                r_RX_DV <= 1'b0;
                r_Clock_Counter <= 0;
                r_Bit_Index <= 0;

                //if HIGH to LOW transition is detected then move to RX_START_BIT 
                if(i_RX_Serial == 1'b0)
                    r_SM_Main <= RX_START_BIT;
                else
                    r_SM_Main <= IDLE;

            end  //End of IDLE 

            RX_START_BIT:
            begin
                //Check the middle of the supposed start bit to make sure its still low, return to IDLE if not 
                if(r_Clock_Counter < (CLKS_PER_BIT -1)/2)
                begin
                    r_SM_Main <= RX_START_BIT;
                    r_Clock_Counter <= r_Clock_Counter +1;
                end
                else if(r_Clock_Counter == (CLKS_PER_BIT-1)/2)
                begin
                    //Check is still low
                    if(i_RX_Serial == 1'b0)
                    begin
                        //Still low, so move to RX_DATA_BIT and make counter 0 to start afresh
                        r_Clock_Counter <= 0;
                        r_SM_Main <= RX_DATA_BIT;
                    end
                    else
                    begin
                        r_Clock_Counter <=0;
                        r_SM_Main <= IDLE;
                    end
                end
            end  //End of RX_START_BIT

            RX_DATA_BIT:
            begin
                //Wait another bit width duration (CLKS_PER_BIT) to sample data at the middle of the next data bit
                if(r_Clock_Counter == CLKS_PER_BIT-1)
                begin
                    r_Clock_Counter<=0;
                    r_RX_Byte[r_Bit_Index] = i_RX_Serial;

                    if(r_Bit_Index < 7)
                    begin
                        //More bits to parallelize, increase bit index
                        r_Bit_Index <= r_Bit_Index + 1;
                        r_SM_Main <= RX_DATA_BIT;
                    end
                    else
                    begin
                        r_Bit_Index <= 0;
                        r_SM_Main <= RX_STOP_BIT;
                    end
                end
                else
                begin
                    r_SM_Main <= RX_DATA_BIT;
                    r_Clock_Counter <= r_Clock_Counter + 1;
                end
            end  //End of RX_DATA_BIT 

            RX_STOP_BIT:
            begin
                //Wait for STOP bit to finish
                if(r_Clock_Counter < CLKS_PER_BIT-1)
                begin
                    r_Clock_Counter <= r_Clock_Counter + 1;
                    r_SM_Main <= RX_STOP_BIT;
                end
                else
                begin
                    r_RX_DV <= 1'b1;
                    r_SM_Main <= CLEANUP;
                    r_Clock_Counter <= 0;
                end
            end //End of RX_STOP_BIT 

            CLEANUP:
            begin
                r_SM_Main <= IDLE;
                r_RX_DV <= 1'b0;
            end  //End of CLEANUP 

        endcase
    end

    assign o_RX_Byte = r_RX_Byte;
    assign o_RX_DV = r_RX_DV; 

endmodule