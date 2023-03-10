// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:34:37
// File Name    : pc_tx_status.v
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
// pc_tx_status
//    |---
// 
`timescale 1ns/1ns

module pc_tx_status#
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
    input                    [31:0] cfg_status_waittime         , 
// ----------------------------------------------------------------------------
// Monitor Data
// ----------------------------------------------------------------------------
    input                     [7:0] debug_lr_sel                , 
    input                    [31:0] debug_port_status           , 
    input                    [31:0] debug_power_current         , 
    input                    [31:0] debug_power_voltage         , 
    input                    [31:0] debug_power_data            , 
    input                    [63:0] debug_local_time            , 
// ----------------------------------------------------------------------------
// Debug Pakadge Frame
// ----------------------------------------------------------------------------
    output reg                      status_wr_req               , 
    input                           status_wr_ack               , 
    output reg                      status_wr_done              , 

    output reg                      status_wr_en                , 
    output reg                [7:0] status_wr_data                
);

reg                          [31:0] timer_cnt                   ; 
reg                                 debug_sample_req            ; 

reg                                 step_en                     ; 
reg                           [7:0] step_cnt                    ; 

// ============================================================================
// Timer
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        timer_cnt <= #U_DLY 32'd0;
    else
        begin
            if(timer_cnt < cfg_status_waittime)
                timer_cnt <= #U_DLY timer_cnt + 32'd1;
            else
                timer_cnt <= #U_DLY 32'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        debug_sample_req <= #U_DLY 1'b0;
    else
        begin
            if(timer_cnt >= cfg_status_waittime)
                debug_sample_req <= #U_DLY 1'b1;
            else
                debug_sample_req <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Request send frame permission.
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        status_wr_req <= #U_DLY 1'b0;
    else
        begin
            if(debug_sample_req == 1'b1)
                status_wr_req <= #U_DLY 1'b1;
            else if(status_wr_ack == 1'b1)
                status_wr_req <= #U_DLY 1'b0;
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
            if(status_wr_ack == 1'b1)
                step_en <= #U_DLY 1'b1;
            else if(step_cnt >= 8'd38)
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 8'd0;
    else
        begin
            if(step_en == 1'b1)
                step_cnt <= #U_DLY step_cnt + 8'd1;
            else
                step_cnt <= #U_DLY 8'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        status_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((step_en == 1'b1) && (step_cnt < 8'd38))
                status_wr_en <= #U_DLY 1'b1;
            else
                status_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        status_wr_data <= #U_DLY 8'd0;
    else
        case(step_cnt)
            8'd0    : status_wr_data <= #U_DLY 8'h00;
            8'd1    : status_wr_data <= #U_DLY 8'h00;
            8'd2    : status_wr_data <= #U_DLY 8'h00;
            8'd3    : status_wr_data <= #U_DLY 8'd44;
            8'd4    : status_wr_data <= #U_DLY 8'h00;
            8'd5    : status_wr_data <= #U_DLY 8'h00;
            8'd6    : status_wr_data <= #U_DLY 8'h00;
            8'd7    : status_wr_data <= #U_DLY 8'h00;
            8'd8    : status_wr_data <= #U_DLY debug_local_time[7*8+:8];
            8'd9    : status_wr_data <= #U_DLY debug_local_time[6*8+:8];
            8'd10   : status_wr_data <= #U_DLY debug_local_time[5*8+:8];
            8'd11   : status_wr_data <= #U_DLY debug_local_time[4*8+:8];
            8'd12   : status_wr_data <= #U_DLY debug_local_time[3*8+:8];
            8'd13   : status_wr_data <= #U_DLY debug_local_time[2*8+:8];
            8'd14   : status_wr_data <= #U_DLY debug_local_time[1*8+:8];
            8'd15   : status_wr_data <= #U_DLY debug_local_time[0*8+:8];
            8'd16   : status_wr_data <= #U_DLY debug_port_status[3*8+:8];
            8'd17   : status_wr_data <= #U_DLY debug_port_status[2*8+:8];
            8'd18   : status_wr_data <= #U_DLY debug_port_status[1*8+:8];
            8'd19   : status_wr_data <= #U_DLY debug_port_status[0*8+:8];
            8'd20   : status_wr_data <= #U_DLY debug_power_voltage[3*8+:8];
            8'd21   : status_wr_data <= #U_DLY debug_power_voltage[2*8+:8];
            8'd22   : status_wr_data <= #U_DLY debug_power_current[3*8+:8];
            8'd23   : status_wr_data <= #U_DLY debug_power_current[2*8+:8];
            8'd24   : status_wr_data <= #U_DLY debug_power_data[3*8+:8];
            8'd25   : status_wr_data <= #U_DLY debug_power_data[2*8+:8];
            8'd26   : status_wr_data <= #U_DLY debug_power_voltage[1*8+:8];
            8'd27   : status_wr_data <= #U_DLY debug_power_voltage[0*8+:8];
            8'd28   : status_wr_data <= #U_DLY debug_power_current[1*8+:8];
            8'd29   : status_wr_data <= #U_DLY debug_power_current[0*8+:8];
            8'd30   : status_wr_data <= #U_DLY debug_power_data[1*8+:8];
            8'd31   : status_wr_data <= #U_DLY debug_power_data[0*8+:8];
            8'd32   : status_wr_data <= #U_DLY 8'd0;
            8'd33   : status_wr_data <= #U_DLY debug_lr_sel[0*8+:8];
            8'd34   : status_wr_data <= #U_DLY 8'd0;
            8'd35   : status_wr_data <= #U_DLY 8'd0;
            8'd36   : status_wr_data <= #U_DLY 8'd0;
            8'd37   : status_wr_data <= #U_DLY 8'd0;
            default : status_wr_data <= #U_DLY 8'd0;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        status_wr_done <= #U_DLY 1'b0;
    else
        begin
            if(step_cnt == 8'd38)
                status_wr_done <= #U_DLY 1'b1;
            else
                status_wr_done <= #U_DLY 1'b0;
        end
end

endmodule



