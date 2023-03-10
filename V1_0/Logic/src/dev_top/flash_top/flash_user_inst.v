// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/22 22:41:51
// File Name    : flash_user_inst.v
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
// flash_user_inst
//    |---
// 
`timescale 1ns/1ps

module flash_user_inst #
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
    input                     [7:0] cfg_ins_enable              , 
// ----------------------------------------------------------------------------
// Instruct Data
// ----------------------------------------------------------------------------
    input                    [15:0] key_inst                    , 
    input                           key_inst_valid              , 

    input                    [15:0] rm_inst                     , 
    input                           rm_inst_valid               , 
// ----------------------------------------------------------------------------
// Info FIFO(FWFT) Write Or Read Data
// ----------------------------------------------------------------------------
    output reg                      inst_fifo_wr_en             , 
    output reg               [15:0] inst_fifo_wr_data           , 
    output reg                      inst_fifo_rd_en             , 
    input                    [15:0] inst_fifo_rd_data           , 
    input                           inst_fifo_empty             , 
// ----------------------------------------------------------------------------
// Instruct Data
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
    
    input                     [7:0] user_rd_data                , 
    input                           user_rd_data_valid            
);

localparam IDLE  = 4'b0000;
localparam CHECK = 4'b0001;  
localparam QUIT  = 4'b1001;
localparam ARBIT = 4'b0011; 
localparam WRITE = 4'b0010; 
localparam DONE  = 4'b0110;

reg                           [3:0] c_status                    ; 
reg                           [3:0] n_status                    ; 

reg                                 inst_valid                  ; 

reg                           [7:0] rdstp_cnt                   ; 

// ============================================================================
// Instruct Store
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_fifo_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((key_inst_valid == 1'b1) || (rm_inst_valid == 1'b1))
                inst_fifo_wr_en <= #U_DLY 1'b1;
            else
                inst_fifo_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_fifo_wr_data <= #U_DLY 16'd0;
    else
        begin
            if(rm_inst_valid == 1'b1)
                inst_fifo_wr_data <= #U_DLY rm_inst;
            else if(key_inst_valid == 1'b1)
                inst_fifo_wr_data <= #U_DLY key_inst;
            else
                ;
        end
end

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
                if(inst_fifo_empty == 1'b0)
                    n_status = CHECK;
                else
                    n_status = IDLE;
            end
        CHECK   :
            begin
                if(inst_valid == 1'b1)
                    n_status = ARBIT;
                else
                    n_status = QUIT;
            end
        QUIT    : n_status = IDLE;
        ARBIT   :
            begin
                if(user_ack == 1'b1)
                    n_status = WRITE;
                else
                    n_status = ARBIT;
            end
        WRITE   : n_status = DONE;
        DONE    : n_status = IDLE;
        default : n_status = IDLE;
    endcase
end

// ============================================================================
// Check instruct if it was error
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_valid <= #U_DLY 1'b0;
    else
        begin
            if((inst_fifo_empty == 1'b0) && (cfg_ins_enable[inst_fifo_rd_data[7:0]] == 1'b1))
                inst_valid <= #U_DLY 1'b1;
            else
                inst_valid <= #U_DLY 1'b0;
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
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_en <= #U_DLY 1'b0;
    else
        begin
            if(c_status == WRITE)
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
            user_cmd[31] <= #U_DLY 1'b1;
            user_cmd[23:16] <= #U_DLY inst_length[7:0] + 8'd4;
            user_cmd[15:0] <= #U_DLY {1'b1,inst_fifo_rd_data[7:0],7'd0};
        end
end

// ============================================================================
// Release to arbiter & Info FIFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_fifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_status == WRITE) || (c_status == QUIT))
                inst_fifo_rd_en <= #U_DLY 1'b1;
            else
                inst_fifo_rd_en <= #U_DLY 1'b0;
        end
end

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
        rdstp_cnt <= #U_DLY 8'd0;
    else
        begin
            if(user_rd_data_valid == 1'b1)
                begin
                    if(rdstp_cnt < inst_length[7:0] + 8'd3)
                        rdstp_cnt <= #U_DLY rdstp_cnt + 8'd1;
                    else
                        rdstp_cnt <= #U_DLY 8'd0;
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
            if((user_rd_data_valid == 1'b1) && (rdstp_cnt > 8'd3))
                inst_data[(67-rdstp_cnt)*8+:8] <= #U_DLY user_rd_data;
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
            if((rdstp_cnt == inst_length[7:0] + 8'd3) && (user_rd_data_valid == 1'b1))
                inst_data_valid <= #U_DLY 1'b1;
            else
                inst_data_valid <= #U_DLY 1'b0;
        end
end

endmodule




