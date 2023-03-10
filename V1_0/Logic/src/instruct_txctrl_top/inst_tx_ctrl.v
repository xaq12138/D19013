// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/13 16:45:01
// File Name    : inst_tx_ctrl.v
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
// inst_tx_ctrl
//    |---
// 
`timescale 1ns/1ps

module inst_tx_ctrl #
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
// Config Register Data
// ----------------------------------------------------------------------------
    input                    [15:0] cfg_ins_txcnt               , // 指令发送次数
    input                    [31:0] cfg_ins_waittime            , // 发送间隔时间
    input                           cfg_keyer_sel               , //调制体制选择  
// ----------------------------------------------------------------------------
// Time
// ----------------------------------------------------------------------------
    input                    [63:0] local_time                  , 
// ----------------------------------------------------------------------------
// Instruct Data From Memory
// ----------------------------------------------------------------------------
    input                   [511:0] inst_data                   , 
    input                           inst_data_valid             , 
// ----------------------------------------------------------------------------
// Log TX Data
// ----------------------------------------------------------------------------
    output reg              [575:0] log_inst_data               , 
    output reg                      log_inst_data_valid         , 
// ----------------------------------------------------------------------------
// PCM TX Data
// ----------------------------------------------------------------------------
    output                  [511:0] pcm_inst_data               , 
    output reg                      pcm_inst_data_valid         , 
// ----------------------------------------------------------------------------
// DY TX Data
// ----------------------------------------------------------------------------
    output                  [511:0] dy_inst_data                , 
    output reg                      dy_inst_data_valid          , 
// ----------------------------------------------------------------------------
// Debug Status
// ----------------------------------------------------------------------------
    output reg                      debug_tx_overflow             
);

reg                         [511:0] inst_data_latch             ; 

reg                                 step_en                     ; 
reg                          [15:0] step_cnt                    ; 

reg                          [31:0] ins_waitcnt                 ; 
reg                                 ins_txen                    ; 

// ============================================================================
// Latch instruct data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_data_latch <= #U_DLY 512'd0;
    else
        begin
            if((inst_data_valid == 1'b1) && (step_en == 1'b0))
                inst_data_latch <= #U_DLY inst_data;
            else
                ;
        end
end

// ============================================================================
// Instruct data send control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        begin
            if(inst_data_valid == 1'b1)
                step_en <= #U_DLY 1'b1;
            else if((step_cnt >= cfg_ins_txcnt) && (ins_waitcnt >= cfg_ins_waittime))
                step_en <= #U_DLY 1'b0;
            else
                ;
        end 
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 16'd0;
    else
        begin
            if(step_en == 1'b1)
                begin
                    if(ins_txen == 1'b1)
                        step_cnt <= #U_DLY step_cnt + 16'd1;
                    else
                        ;
                end
            else
                step_cnt <= #U_DLY 16'd0;
        end
end

// ============================================================================
// Instruct data send times
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ins_waitcnt <= #U_DLY 32'd0;
    else
        begin
            if((step_en == 1'b1) && (ins_waitcnt < cfg_ins_waittime))
                ins_waitcnt <= #U_DLY ins_waitcnt + 32'd1;
            else
                ins_waitcnt <= #U_DLY 32'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ins_txen <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b1) && (ins_waitcnt == 32'd1))
                ins_txen <= #U_DLY 1'b1;
            else
                ins_txen <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Log data 
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        log_inst_data <= #U_DLY 576'd0;
    else
        log_inst_data <= #U_DLY {local_time,inst_data_latch};
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        log_inst_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(ins_txen == 1'b1)
                log_inst_data_valid <= #U_DLY 1'b1;
            else
                log_inst_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// PCM data 
// ============================================================================
assign pcm_inst_data = inst_data_latch;

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pcm_inst_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((cfg_keyer_sel == 1'b1) && (ins_txen == 1'b1))
                pcm_inst_data_valid <= #U_DLY 1'b1;
            else
                pcm_inst_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// DY data 
// ============================================================================
assign dy_inst_data = inst_data_latch;

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dy_inst_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((cfg_keyer_sel == 1'b0) && (ins_txen == 1'b1))
                dy_inst_data_valid <= #U_DLY 1'b1;
            else
                dy_inst_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Debug 
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        debug_tx_overflow <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b1) && (inst_data_valid == 1'b1))
                debug_tx_overflow <= #U_DLY 1'b1;
            else
                debug_tx_overflow <= #U_DLY 1'b0;
        end
end

endmodule 




