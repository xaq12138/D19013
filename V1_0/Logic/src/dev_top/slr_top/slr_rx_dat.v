// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/31 20:02:35
// File Name    : slr_rx_dat.v
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
// slr_rx_dat
//    |---
// 
`timescale 1ns/1ps

module slr_rx_dat #
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
// Config
// ----------------------------------------------------------------------------
    input                    [63:0] local_time                  , 
    input                     [7:0] cfg_ins_length              , 
    input                           cfg_keyer_sel               ,
    input                     [7:0] cfg_pcm_header              , 
    input                     [7:0] cfg_dy_header               , 
// ----------------------------------------------------------------------------
// Uart RX Data
// ----------------------------------------------------------------------------
    input                     [7:0] rx_data                     , 
    input                           rx_data_valid               , 
// ----------------------------------------------------------------------------
// SLR RX Instruct Data
// rxins_data[575:512] : (8byte)  time
// rxins_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------    
    output reg              [575:0] rxins_data                  , 
    output reg                      rxins_data_valid              
);

reg                          [15:0] overtime_cnt                ; 

reg                           [7:0] step_data                   ; 
reg                           [7:0] step_cnt                    ; 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        overtime_cnt <= #U_DLY 16'd0;
    else
        begin
            if(rx_data_valid == 1'b1)
                overtime_cnt <= #U_DLY 16'd0;
            else if(overtime_cnt < 16'd9735) // 150us@62.5MHz
                overtime_cnt <= #U_DLY overtime_cnt + 16'd1;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_data <= #U_DLY 8'd0;
    else
        begin
            if(cfg_keyer_sel == 1'b1)
                step_data <= #U_DLY cfg_ins_length - cfg_pcm_header;
            else
                step_data <= #U_DLY cfg_ins_length - cfg_dy_header;

        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 8'd0;
    else
        begin 
            if(rx_data_valid == 1'b1)
                begin
                    if(step_cnt < step_data - 8'd1)
                        step_cnt <= step_cnt + 8'd1;
                    else
                        step_cnt <= #U_DLY 8'd0;
                end
            else if(overtime_cnt >= 16'd9735)
                step_cnt <= #U_DLY 8'd0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxins_data <= #U_DLY 576'd0;
    else
        begin
            if(step_cnt == 8'd0)
                rxins_data[575:512] <= #U_DLY local_time;
            else
                ;

            if(rx_data_valid == 1'b1)
                rxins_data[(63-step_cnt)*8+:8] <= #U_DLY rx_data;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxins_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((rx_data_valid == 1'b1) && (step_cnt == step_data - 8'd1))
                rxins_data_valid <= #U_DLY 1'b1;
            else
                rxins_data_valid <= #U_DLY 1'b0;
        end
end

endmodule 




