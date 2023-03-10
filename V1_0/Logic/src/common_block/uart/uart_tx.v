// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/14 16:18:04
// File Name    : uart_tx.v
// Module Ver   : Vx.x
//
//
// All Rights Reserved
//
// ---------------------------------------------------------------------------------/
//
// Modification History:
// V1.0         initial
//
// -FHDR============================================================================/
// 
// uart_tx
//    |---
// 
`timescale 1ns/1ps

module uart_tx #
(
    parameter                       U_DLY = 1
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Config Data 
// ----------------------------------------------------------------------------
    input                           baud_en                     , 

    input                     [3:0] data_width                  , 
    input                           check_en                    , 
    input                           check_sel                   , 
    input                           stop_bit                    , 

    output reg                      tx_busy                     , 
// ----------------------------------------------------------------------------
// Send Data 
// ----------------------------------------------------------------------------
    input                     [7:0] driver_tx_data              , 
    input                           driver_tx_data_valid        , 
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    output reg                      uart_tx                       
);

reg                                 tx_req                      ; 
reg                           [7:0] tx_data_lacth               ; 

reg                           [6:0] step_data                   ; 
reg                                 step_en                     ; 
reg                           [6:0] step_cnt                    ; 

reg                                 check_data                  ; 

// ============================================================================
// Step control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_data <= #U_DLY 7'd0;
    else
        case({stop_bit,check_en,data_width})
        6'h05   : step_data <= #U_DLY 7'd56;
        6'h06   : step_data <= #U_DLY 7'd64;
        6'h07   : step_data <= #U_DLY 7'd72;
        6'h08   : step_data <= #U_DLY 7'd80;
        6'h15   : step_data <= #U_DLY 7'd64;
        6'h16   : step_data <= #U_DLY 7'd72;
        6'h17   : step_data <= #U_DLY 7'd80;
        6'h18   : step_data <= #U_DLY 7'd88;
        6'h25   : step_data <= #U_DLY 7'd64;
        6'h26   : step_data <= #U_DLY 7'd72;
        6'h27   : step_data <= #U_DLY 7'd80;
        6'h28   : step_data <= #U_DLY 7'd88;
        6'h35   : step_data <= #U_DLY 7'd72;
        6'h36   : step_data <= #U_DLY 7'd80;
        6'h37   : step_data <= #U_DLY 7'd88;
        6'h38   : step_data <= #U_DLY 7'd96;
        default : step_data <= #U_DLY 7'd80;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        tx_req <= #U_DLY 1'b0;
    else
        begin
            if(driver_tx_data_valid == 1'b1)
                tx_req <= #U_DLY 1'b1;
            else if(baud_en == 1'b1)
                tx_req <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        begin
            if((tx_req == 1'b1) && (baud_en == 1'b1))
                step_en <= #U_DLY 1'b1;
            else if((step_cnt >= step_data) && (baud_en == 1'b1))
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 7'd0;
    else
        begin
            if(step_en == 1'b1)
                begin
                    if(baud_en == 1'b1)
                        step_cnt <= #U_DLY step_cnt + 7'd1;
                    else
                        ;
                end
            else
                step_cnt <= #U_DLY 7'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        tx_data_lacth <= #U_DLY 8'd0;
    else
        begin
            if(driver_tx_data_valid == 1'b1)
                tx_data_lacth <= #U_DLY driver_tx_data;
            else
                ;
        end
end

// ============================================================================
// Step control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        check_data <= #U_DLY 1'b0;
    else
        case(data_width)
            4'd8    : check_data <= #U_DLY check_sel^tx_data_lacth[0]^tx_data_lacth[1]^tx_data_lacth[2]^tx_data_lacth[3]^tx_data_lacth[4]^tx_data_lacth[5]^tx_data_lacth[6]^tx_data_lacth[7];
            4'd7    : check_data <= #U_DLY check_sel^tx_data_lacth[0]^tx_data_lacth[1]^tx_data_lacth[2]^tx_data_lacth[3]^tx_data_lacth[4]^tx_data_lacth[5]^tx_data_lacth[6];
            4'd6    : check_data <= #U_DLY check_sel^tx_data_lacth[0]^tx_data_lacth[1]^tx_data_lacth[2]^tx_data_lacth[3]^tx_data_lacth[4]^tx_data_lacth[5];
            4'd5    : check_data <= #U_DLY check_sel^tx_data_lacth[0]^tx_data_lacth[1]^tx_data_lacth[2]^tx_data_lacth[3]^tx_data_lacth[4];
            default : check_data <= #U_DLY check_sel^tx_data_lacth[0]^tx_data_lacth[1]^tx_data_lacth[2]^tx_data_lacth[3]^tx_data_lacth[4];
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        uart_tx <= #U_DLY 1'b1;
    else
        begin
            if((step_en == 1'b1) && ((baud_en == 1'b1)))
                begin
                    if(step_cnt[6:3] == 4'd0)
                        uart_tx <= #U_DLY 1'b0;
                    else if((step_cnt[6:3] >= 4'd1) && (step_cnt[6:3] <= data_width))
                        uart_tx <= #U_DLY tx_data_lacth[step_cnt[6:3] - 4'd1];
                    else if((check_en == 1'b1) && (step_cnt[6:3] == data_width + 4'd1))
                        uart_tx <= #U_DLY check_data;
                    else
                        uart_tx <= #U_DLY 1'b1;
                end
            else
                ;
        end
end

// ============================================================================
// Status
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        tx_busy <= #U_DLY 1'b0;
    else 
        begin
            if(step_en == 1'b1)
                tx_busy <= #U_DLY 1'b1;
            else
                tx_busy <= #U_DLY 1'b0;
        end
end

endmodule




