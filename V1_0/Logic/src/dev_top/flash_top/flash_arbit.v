// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/23 11:55:57
// File Name    : flash_arbit.v
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
// flash_arbit
//    |---
// 
`timescale 1ns/1ps

module flash_arbit #
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
// Arbit Port
//  user_cmd[31]    --> write(0)/read(1).
//  user_cmd[30:24] --> reserved
//  user_cmd[23:16] --> length
//  user_cmd[15:0]  --> addr
// ----------------------------------------------------------------------------
    input                     [2:0] user_req                    , 
    output reg                [2:0] user_ack                    , 
    input                     [2:0] user_done                   , 

    input                     [2:0] user_en                     , 
    input                    [95:0] user_cmd                    , 
    input                    [23:0] user_wr_data                , 
    
    output reg               [23:0] user_rd_data                , 
    output reg                [2:0] user_rd_data_valid          , 
// ----------------------------------------------------------------------------
// Info FIFO(fwft)
//
// arbit_ififo_wr_data[15:10] --> reserved
// arbit_ififo_wr_data[9:8] --> c_user
// arbit_ififo_wr_data[7:0] --> length 
// ----------------------------------------------------------------------------
    output reg                      arbit_ififo_wr_en           , 
    output reg               [15:0] arbit_ififo_wr_data         , 
    output reg                      arbit_ififo_rd_en           , 
    input                    [15:0] arbit_ififo_rd_data         , 
// ----------------------------------------------------------------------------
// Write TO FLASH Control
// ----------------------------------------------------------------------------
    output reg                      flash_ififo_wr_en           , 
    output reg               [31:0] flash_ififo_wr_data         , 

    output reg                      flash_dfifo_wr_en           , 
    output reg                [7:0] flash_dfifo_wr_data         , 

    input                     [7:0] flash_rd_data               , 
    input                           flash_rd_data_valid           
);

localparam IDLE  = 3'b000;
localparam ARBIT = 3'b001;
localparam ACK   = 3'b011;
localparam WRITE = 3'b010;

reg                           [2:0] c_status                    ; 
reg                           [2:0] n_status                    ; 

reg                           [1:0] c_user                      ; 

reg                           [7:0] rdstp_cnt                   ; 

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
                if(|user_req == 1'b1)
                    n_status = ARBIT;
                else
                    n_status = IDLE;
            end
        ARBIT   : n_status = ACK;
        ACK     : n_status = WRITE;
        WRITE   :
            begin
                if(user_done[c_user] == 1'b1)
                    n_status = IDLE;
                else
                    n_status = WRITE;
            end 
        default : n_status = IDLE;
    endcase
end

// ============================================================================
// Arbit control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        c_user <= #U_DLY 2'd0;
    else
        begin
            if(c_status == ARBIT)
                case({c_user,user_req})
                    5'b00_000   : c_user <= #U_DLY 2'd0;
                    5'b00_001   : c_user <= #U_DLY 2'd0;
                    5'b00_010   : c_user <= #U_DLY 2'd1;
                    5'b00_011   : c_user <= #U_DLY 2'd1;
                    5'b00_100   : c_user <= #U_DLY 2'd2;
                    5'b00_101   : c_user <= #U_DLY 2'd2;
                    5'b00_110   : c_user <= #U_DLY 2'd1;
                    5'b00_111   : c_user <= #U_DLY 2'd1;
                    5'b01_000   : c_user <= #U_DLY 2'd1;
                    5'b01_001   : c_user <= #U_DLY 2'd0;
                    5'b01_010   : c_user <= #U_DLY 2'd1;
                    5'b01_011   : c_user <= #U_DLY 2'd0;
                    5'b01_100   : c_user <= #U_DLY 2'd2;
                    5'b01_101   : c_user <= #U_DLY 2'd2;
                    5'b01_110   : c_user <= #U_DLY 2'd2;
                    5'b01_111   : c_user <= #U_DLY 2'd2;      
                    5'b10_000   : c_user <= #U_DLY 2'd2;
                    5'b10_001   : c_user <= #U_DLY 2'd0;
                    5'b10_010   : c_user <= #U_DLY 2'd1;
                    5'b10_011   : c_user <= #U_DLY 2'd0;
                    5'b10_100   : c_user <= #U_DLY 2'd2;
                    5'b10_101   : c_user <= #U_DLY 2'd0;
                    5'b10_110   : c_user <= #U_DLY 2'd1;
                    5'b10_111   : c_user <= #U_DLY 2'd0;             
                    default     : c_user <= #U_DLY 2'd0;
                endcase
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_ack <= #U_DLY 3'd0;
    else
        begin
            if(c_status == ACK)
                user_ack[c_user] <= #U_DLY 1'b1;
            else
                user_ack <= #U_DLY 3'd0;
        end
end

// ============================================================================
// Write data & commond to FIFO 
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        flash_ififo_wr_en <= #U_DLY 1'b0;
    else
        begin
            if(user_done[c_user] == 1'b1)
                flash_ififo_wr_en <= #U_DLY 1'b1;
            else
                flash_ififo_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        flash_ififo_wr_data <= #U_DLY 32'd0;
    else
        flash_ififo_wr_data <= #U_DLY user_cmd[(c_user*32)+:32];
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        flash_dfifo_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((user_en[c_user] == 1'b1) && (user_cmd[c_user*32+31] == 1'b0))
                flash_dfifo_wr_en <= #U_DLY 1'b1;
            else
                flash_dfifo_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        flash_dfifo_wr_data <= #U_DLY 8'd0;
    else
        flash_dfifo_wr_data <= #U_DLY user_wr_data[(c_user*8)+:8];
end

// ============================================================================
// Store commond to FIFO
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        arbit_ififo_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((user_done[c_user] == 1'b1) && (user_cmd[c_user*32+31] == 1'b1))
                arbit_ififo_wr_en <= #U_DLY 1'b1;
            else
                arbit_ififo_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        arbit_ififo_wr_data <= #U_DLY 16'd0;
    else
        arbit_ififo_wr_data <= #U_DLY {6'b0,c_user,user_cmd[(c_user*32+16)+:8]};
end

// ============================================================================
// Read Data Framer
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rdstp_cnt <= #U_DLY 8'd0;
    else
        begin
            if(flash_rd_data_valid == 1'b1)
                begin
                    if(rdstp_cnt < arbit_ififo_rd_data[7:0] - 8'd1)
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
        user_rd_data <= #U_DLY 24'd0;
    else
        user_rd_data <= #U_DLY {3{flash_rd_data}};
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        user_rd_data_valid <= #U_DLY 3'd0;
    else
        begin
            if(flash_rd_data_valid == 1'b1)
                user_rd_data_valid[arbit_ififo_rd_data[9:8]] <= #U_DLY 1'b1;
            else
                user_rd_data_valid <= #U_DLY 3'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        arbit_ififo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((flash_rd_data_valid == 1'b1) && (rdstp_cnt >= arbit_ififo_rd_data[7:0] - 8'd1))
                arbit_ififo_rd_en <= #U_DLY 1'b1;
            else
                arbit_ififo_rd_en <= #U_DLY 1'b0;
        end
end

endmodule




