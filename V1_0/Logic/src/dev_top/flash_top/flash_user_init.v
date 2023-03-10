// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/22 22:12:25
// File Name    : flash_user_init.v
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
// flash_user_init
//    |---
// 
`timescale 1ns/1ps

module flash_user_init #
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
// Initial Config Data
// ----------------------------------------------------------------------------
    input                           mem_rd_en                   , 
    input                    [15:0] mem_rd_addr                 , 

    output reg               [31:0] mem_rd_data                 , 
    output reg                      mem_rd_data_valid           , 
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

localparam IDLE    = 4'b0000;
localparam ARBIT   = 4'b0011; 
localparam WRITE   = 4'b0010; 
localparam DONE    = 4'b0110;

reg                           [3:0] c_status                    ; 
reg                           [3:0] n_status                    ; 

reg                           [2:0] rdstp_cnt                   ; 

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
                if(mem_rd_en == 1'b1)
                    n_status = ARBIT;
                else
                    n_status = IDLE;
            end
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
// Request send permission.
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_req <= #U_DLY 1'b0;
    else
        begin
            if(c_status ==ARBIT)
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
            if(mem_rd_en == 1'b1)
                begin
                    user_cmd[31] <= #U_DLY 1'b1;
                    user_cmd[23:16] <= #U_DLY 8'd4;
                    user_cmd[15:0] <= #U_DLY {4'd0,mem_rd_addr[7:0],4'd0};
                end
            else
                ;
        end
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
        rdstp_cnt <= #U_DLY 3'd0;
    else
        begin
            if(user_rd_data_valid == 1'b1)
                begin
                    if(rdstp_cnt < 3'd3)
                        rdstp_cnt <= #U_DLY rdstp_cnt + 3'd1;
                    else
                        rdstp_cnt <= #U_DLY 3'd0;
                end
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_data <= #U_DLY 32'd0;
    else
        begin
            if(user_rd_data_valid == 1'b1)
                case(rdstp_cnt)
                    3'd0    : mem_rd_data[3*8+:8] <= #U_DLY user_rd_data;
                    3'd1    : mem_rd_data[2*8+:8] <= #U_DLY user_rd_data;
                    3'd2    : mem_rd_data[1*8+:8] <= #U_DLY user_rd_data;
                    3'd3    : mem_rd_data[0*8+:8] <= #U_DLY user_rd_data;
                    default :;
                endcase
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((rdstp_cnt == 3'd3) && (user_rd_data_valid == 1'b1))
                mem_rd_data_valid <= #U_DLY 1'b1;
            else
                mem_rd_data_valid <= #U_DLY 1'b0;
        end
end

endmodule



