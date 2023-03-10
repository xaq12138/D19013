// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/09 13:44:38
// File Name    : pc_rm_deframe.v
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
// pc_remote_local_sel
//    |---
// 
`timescale 1ns/1ns

module pc_rm_deframe #
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
// PC data
// ----------------------------------------------------------------------------
    input                     [7:0] pc_rx_data                  , 
    input                           pc_rx_data_valid            ,
// ----------------------------------------------------------------------------
// PC Remote/Local Select
// ----------------------------------------------------------------------------
    output reg                [2:0] pc_rmrl_mode                , 
    output reg                      pc_rmrl_valid                 
);

reg                           [7:0] pc_rx_data_1dly             ; 
reg                                 pc_rx_data_valid_1dly       ; 
reg                           [7:0] pc_rx_data_2dly             ; 
reg                                 pc_rx_data_valid_2dly       ; 

reg                          [31:0] rx_shift_reg                ; 

reg                                 frame_busy                  ; 
reg                          [31:0] frame_cnt                   ; 

reg                          [31:0] frame_length                ; 
reg                                 frame_type                  ; 

reg                                 crc_clear                   ; 
wire                         [31:0] crc_data_tmp                ; 
reg                                 crc_data_latch              ; 
reg                          [31:0] crc_data                    ; 

reg                                 pkg_isok                    ; 

// ============================================================================
// Delay
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            pc_rx_data_1dly <= #U_DLY 8'd0;
            pc_rx_data_2dly <= #U_DLY 8'd0;
        end
    else
        begin
            pc_rx_data_1dly <= #U_DLY pc_rx_data;
            pc_rx_data_2dly <= #U_DLY pc_rx_data_1dly;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            pc_rx_data_valid_1dly <= #U_DLY 1'b0;
            pc_rx_data_valid_2dly <= #U_DLY 1'b0;
        end
    else
        begin
            pc_rx_data_valid_1dly <= #U_DLY pc_rx_data_valid;
            pc_rx_data_valid_2dly <= #U_DLY pc_rx_data_valid_1dly;
        end
end

// ============================================================================
// Frame RX Control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rx_shift_reg <= #U_DLY 32'd0;
    else
        begin
            if(pc_rx_data_valid == 1'b1)
                rx_shift_reg <= #U_DLY {rx_shift_reg[23:0],pc_rx_data};
            else
                ;
        end
end

always @ (posedge clk_sys or  negedge rst_n)
begin
    if(rst_n == 1'b0)
        frame_busy <= #U_DLY 1'b0;
    else
        begin
            if((pc_rx_data_valid == 1'b1) && ({rx_shift_reg[23:0],pc_rx_data} == 32'hef9119fe))
                frame_busy <= #U_DLY 1'b1;
            else if((frame_cnt >= 32'd9) && (frame_cnt >= frame_length))
                frame_busy <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or  negedge rst_n)
begin
    if(rst_n == 1'b0)
        frame_cnt <= #U_DLY 32'd0;
    else
        begin
            if(frame_busy == 1'b1)
                begin
                    if(pc_rx_data_valid == 1'b1)
                        frame_cnt <= #U_DLY frame_cnt + 32'd1;
                    else
                        ;
                end 
            else
                frame_cnt <= #U_DLY 32'd0;
        end
end

// ============================================================================
// Get Frame Info
// ============================================================================
always @ (posedge clk_sys or  negedge rst_n)
begin
    if(rst_n == 1'b0)
        frame_length <= #U_DLY 32'd0;
    else
        begin
            if((pc_rx_data_valid == 1'b1) && (frame_cnt == 32'd5))
                frame_length <= #U_DLY {rx_shift_reg[27:0],pc_rx_data};
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        frame_type <= #U_DLY 1'b0;
    else
        begin
            if((pc_rx_data_valid == 1'b1) && (frame_cnt == 32'd1))
                case({rx_shift_reg[7:0],pc_rx_data})
                    16'h8002    : frame_type <= #U_DLY 1'b1;
                    default     : frame_type <= #U_DLY 1'b0;
                endcase
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_rmrl_mode <= #U_DLY 3'b0;
    else
        begin
            if((pc_rx_data_valid == 1'b1) && (frame_cnt == 32'd11))
                pc_rmrl_mode <= #U_DLY pc_rx_data[2:0];
            else
                ;
        end
end

// ============================================================================
// Get CRC32 Result
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        crc_data_latch <= #U_DLY 1'b0;
    else
        begin
            if((pc_rx_data_valid_2dly == 1'b1) && (frame_cnt == frame_length - 32'd4))
                crc_data_latch <= #U_DLY 1'b1;
            else
                crc_data_latch <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        crc_data <= #U_DLY 32'd0;
    else
        begin
            if(crc_data_latch==1'b1)
                crc_data <= #U_DLY crc_data_tmp;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pkg_isok <= #U_DLY 1'b0;
    else
        begin
            if((frame_busy == 1'b1) && (pc_rx_data_valid == 1'b1) && (frame_cnt == frame_length - 32'd1) && (crc_data == {rx_shift_reg[23:0],pc_rx_data}))
                pkg_isok <= #U_DLY 1'b1;
            else
                pkg_isok <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        crc_clear <= #U_DLY 1'b0;
    else
        begin
            if((frame_busy == 1'b0) && (pc_rx_data_valid == 1'b1) && (pc_rx_data == 8'hef))
                crc_clear <= #U_DLY 1'b1;
            else
                crc_clear <= #U_DLY 1'b0;
        end
end

// ----------------------------------------------------------------------------
// Local/remote select control
// ----------------------------------------------------------------------------
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_rmrl_valid <= #U_DLY 1'b0;
    else
        begin
            if((frame_type == 1'b1) && (pkg_isok == 1'b1))
                pc_rmrl_valid <= #U_DLY 1'b1;
            else
                pc_rmrl_valid <= #U_DLY 1'b0;
        end
end

cb_crc32 #
(
    .U_DLY                          (U_DLY                      )  
)
u_cb_crc32
(
//-----------------------------------------------------------------------------------
// Clock & Reset
//-----------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------------
// CRC32 Clear Signal
//-----------------------------------------------------------------------------------
    .crc_clear                      (crc_clear                  ), // (input )
//-----------------------------------------------------------------------------------
// Source Data
//-----------------------------------------------------------------------------------
    .src_data                       (pc_rx_data_2dly[7:0]       ), // (input )
    .src_data_valid                 (pc_rx_data_valid_2dly      ), // (input )
//-----------------------------------------------------------------------------------
// Source Data
//-----------------------------------------------------------------------------------
    .crc_data                       (crc_data_tmp[31:0]         ), // (output)
    .crc_data_valid                 (                           )  // (output)
);

endmodule




