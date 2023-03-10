// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/22 22:42:03
// File Name    : flash_user_cfg.v
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
// flash_user_cfg
//    |---
// 
`timescale 1ns/1ps

module flash_user_cfg #
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
    input                    [15:0] inst_length                 , 
// ----------------------------------------------------------------------------
// FIFO Read Port
// ----------------------------------------------------------------------------
    output reg                      cfgfifo_rd_en               , 
    input                     [7:0] cfgfifo_rd_data             , 
    input                           cfgfifo_empty               , 
// ----------------------------------------------------------------------------
// Read Instruct Data
// ----------------------------------------------------------------------------
    output reg              [511:0] inst_data                   , 
    output reg                      inst_data_valid             , 
// ----------------------------------------------------------------------------
// Arbit Port
//  user_cmd[31]    --> write(0)/read(1).
//  user_cmd[30:24] --> reserved
//  user_cmd[23:16] --> length
//  user_cmd[15:0]  --> addr
// ----------------------------------------------------------------------------
    output reg                      user_req                    , 
    input                           user_ack                    , 
    output reg                      user_done                   , 

    output reg                      user_en                     , 
    output reg               [31:0] user_cmd                    , 
    output reg                [7:0] user_wr_data                , 
    
    input                     [7:0] user_rd_data                , 
    input                           user_rd_data_valid            
);

localparam IDLE    = 4'b0000;
localparam GETINFO = 4'b0001;  
localparam ARBIT   = 4'b0011; 
localparam WRITE   = 4'b0010; 
localparam DONE    = 4'b0110;

reg                           [3:0] c_status                    ; 
reg                           [3:0] n_status                    ; 

reg                           [2:0] getinfo_cnt                 ; 

reg                           [7:0] wrstp_cnt                   ; 

reg                          [15:0] pkg_header                  ; 
reg                           [7:0] wrstep_length               ; 

reg                           [7:0] frame_cnt                   ; 

// ============================================================================
// FSM - 1&2
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        c_status <= #U_DLY IDLE;
    else
        c_status <= #U_DLY n_status;
end

always @ (*)
begin
    case(c_status)
        IDLE    :
            begin
                if(cfgfifo_empty == 1'b0)
                    n_status = GETINFO;
                else
                    n_status = IDLE;
            end
        GETINFO :
            begin
                if(getinfo_cnt > 3'd4)
                    begin
                        if((pkg_header != 16'h0005) && (pkg_header != 16'h0007) && (pkg_header != 16'h000a))  
                            n_status = IDLE;
                        else
                            n_status = ARBIT;
                    end
                else
                    n_status = GETINFO;
            end
        ARBIT   :
            begin
                if(user_ack == 1'b1)
                    n_status = WRITE;
                else
                    n_status = ARBIT;
            end
        WRITE   :
            begin
                if(wrstp_cnt >= wrstep_length + 8'd1)
                    n_status = DONE;
                else
                    n_status = WRITE;
            end
        DONE    : n_status = IDLE;
        default : n_status = IDLE;
    endcase
end

// ============================================================================
// Status step control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        getinfo_cnt <= #U_DLY 3'd0;
    else
        begin
            if(c_status == GETINFO)
                getinfo_cnt <= #U_DLY getinfo_cnt + 3'd1;
            else
                getinfo_cnt <= #U_DLY 3'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wrstp_cnt <= #U_DLY 8'd0;
    else
        begin
            if(c_status == WRITE)
                wrstp_cnt <= #U_DLY wrstp_cnt + 8'd1;
            else
                wrstp_cnt <= #U_DLY 8'd0;
        end
end

// ============================================================================
// Read data from FiFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        cfgfifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if(((c_status == GETINFO) && (getinfo_cnt <= 3'd1)) || ((c_status == WRITE) && (wrstp_cnt <= wrstep_length - 8'd1)))
                cfgfifo_rd_en <= #U_DLY 1'b1;
            else
                cfgfifo_rd_en <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Get pakadge infomation
// ============================================================================
// get header
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pkg_header <= #U_DLY 16'd0;
    else
        begin
            if((getinfo_cnt >= 3'd2) && (getinfo_cnt <= 3'd3))
                pkg_header <= #U_DLY {pkg_header[7:0],cfgfifo_rd_data[7:0]};
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        wrstep_length <= #U_DLY 8'd0;
    else
        begin
            if(getinfo_cnt == 3'd4)
                case(pkg_header)
                    16'h0005    : wrstep_length <= #U_DLY 8'd6;
                    16'h0007    : wrstep_length <= #U_DLY inst_length[7:0] + 8'd6;
                    16'h000a    : wrstep_length <= #U_DLY inst_length[7:0] + 8'd6;
                    default     : wrstep_length <= #U_DLY 8'd0;
                endcase
            else
                ;
        end
end

// ============================================================================
// Request send permission.
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_req <= #U_DLY 1'b0;
    else
        begin
            if(c_status == ARBIT)
                user_req <= #U_DLY 1'b1;
            else
                user_req <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Write to arbiter
// ============================================================================
// get address sign
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_en <= #U_DLY 1'b0;
    else
        begin
            if((c_status == WRITE) && (wrstp_cnt >= 8'd4) && (wrstp_cnt <= wrstep_length + 8'd1))
                user_en <= #U_DLY 1'b1;
            else
                user_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_cmd <= #U_DLY 32'd0;
    else
        begin
            if((c_status == WRITE) && (wrstp_cnt == 8'd3))
                begin
                    // write(0)/read(1)
                    if(pkg_header == 16'h000a)
                        user_cmd[31] <= #U_DLY 1'b1;
                    else
                        user_cmd[31] <= #U_DLY 1'b0;
                    // length
                    user_cmd[23:16] <= #U_DLY wrstep_length - 8'd2;
                    // address
                    if(pkg_header == 16'h0005)
                        user_cmd[15:0] <= #U_DLY {4'd0,cfgfifo_rd_data[7:0],4'b0}; // 0x000000~0x000fff --> regerster data
                    else
                        user_cmd[15:0] <= #U_DLY {1'b1,cfgfifo_rd_data[7:0],7'd0}; // 0x008000~0x00ffff --> instruct data
                end
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_wr_data <= #U_DLY 8'd0;
    else
        user_wr_data <= #U_DLY cfgfifo_rd_data;
end

// ============================================================================
// Release to arbiter
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_done <= #U_DLY 1'b0;
    else
        begin
            if(c_status == DONE)
                user_done <= #U_DLY 1'b1;
            else
                user_done <= #U_DLY 1'b0;
        end
        
end

// ============================================================================
// Read data framer
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        frame_cnt <= #U_DLY 8'd0;
    else
        begin
            if(user_rd_data_valid == 1'b1)
                begin
                    if(frame_cnt < inst_length[7:0] + 8'd3)
                        frame_cnt <= #U_DLY frame_cnt + 8'd1;
                    else
                        frame_cnt <= #U_DLY 8'd0;
                end
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_data <= #U_DLY 512'd0;
    else
        begin
            if((user_rd_data_valid == 1'b1) && (frame_cnt > 8'd3))
                inst_data[(67-frame_cnt)*8+:8] <= #U_DLY user_rd_data;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((frame_cnt == inst_length[7:0] + 8'd3) && (user_rd_data_valid == 1'b1))
                inst_data_valid <= #U_DLY 1'b1;
            else
                inst_data_valid <= #U_DLY 1'b0;
        end
end

endmodule 




