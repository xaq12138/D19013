// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:39:24
// File Name    : pc_rx_deframe.v
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
// pc_rx_deframe
//    |---
// 
`timescale 1ns/1ns

module pc_rx_deframe #
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
// Frame Data BRAM Write Port
// ----------------------------------------------------------------------------
    output reg                      fdram_wr_en                 , 
    output reg               [11:0] fdram_wr_addr               , 
    output reg                [7:0] fdram_wr_data               , 
// ----------------------------------------------------------------------------
// Frame Info Fifo Write Port
// ----------------------------------------------------------------------------
    output reg                [3:0] fififo_wr_en                , 
    output reg               [71:0] fififo_wr_data              , 
// ----------------------------------------------------------------------------
// Responce Pakadge Infomation
// ----------------------------------------------------------------------------
    output reg               [19:0] resp_info                   , 
    output reg                      resp_info_valid               
);

reg                           [7:0] pc_rx_data_1dly             ; 
reg                                 pc_rx_data_valid_1dly       ; 
reg                           [7:0] pc_rx_data_2dly             ; 
reg                                 pc_rx_data_valid_2dly       ; 

reg                          [31:0] rx_shift_reg                ; 

reg                                 frame_busy                  ; 
reg                          [31:0] frame_cnt                   ; 

reg                          [11:0] frame_start_addr            ; 
reg                          [31:0] frame_length                ; 
reg                           [3:0] frame_type                  ; 
reg                          [15:0] frame_function              ; 

reg                                 crc_clear                   ; 
wire                         [31:0] crc_data_tmp                ; 
reg                                 crc_data_latch              ; 
reg                          [31:0] crc_data                    ; 

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
        frame_start_addr <= #U_DLY 12'd0;
    else
        begin
            if((frame_busy == 1'b1) && (pc_rx_data_valid == 1'b1) && (frame_cnt == 32'd10))
                frame_start_addr <= #U_DLY fdram_wr_addr;
            else
                ;
        end
end

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
        frame_type <= #U_DLY 4'd0;
    else
        begin
            if((pc_rx_data_valid == 1'b1) && (frame_cnt == 32'd1))
                case({rx_shift_reg[7:0],pc_rx_data})
                    16'h0001    : frame_type <= #U_DLY 4'b0010;
                    16'h0002    : frame_type <= #U_DLY 4'b0100;
                    16'h0003    : frame_type <= #U_DLY 4'b0100;
                    default     : frame_type <= #U_DLY 4'b0;
                endcase
            else
                ;
        end
end

always @ (posedge clk_sys or  negedge rst_n)
begin
    if(rst_n == 1'b0)
        frame_function <= #U_DLY 16'd0;
    else
        begin
            if((frame_cnt == 32'd11) && (pc_rx_data_valid == 1'b1))
                frame_function <= #U_DLY {rx_shift_reg[7:0],pc_rx_data};
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

// ============================================================================
// Data BRAM Write Control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fdram_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((pc_rx_data_valid == 1'b1) && (frame_cnt >= 32'd10) && (frame_cnt < frame_length - 32'd4))
                fdram_wr_en <= #U_DLY 1'b1;
            else
                fdram_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fdram_wr_addr <= #U_DLY 12'd0;
    else
        begin
            if(fdram_wr_en == 1'b1)
                fdram_wr_addr <= #U_DLY fdram_wr_addr + 12'd1;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fdram_wr_data <= #U_DLY 8'd0;
    else
        fdram_wr_data <= #U_DLY pc_rx_data;
end

// ============================================================================
// Pakadge Infomation Deframe
//
// fififo_wr_data[71:56]    : pakedge function.
// fififo_wr_data[55:40]    : data ram start address
// fififo_wr_data[39:32]    : pakedge status --> 'h80:ok,'h00:error
// fififo_wr_data[31:0]     : pakedge length
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fififo_wr_data <= #U_DLY 72'd0;
    else
        begin
            if((frame_busy == 1'b1) && (pc_rx_data_valid == 1'b1) && (frame_cnt == frame_length - 32'd1))
                begin
                    fififo_wr_data[71:56] <= #U_DLY frame_function;
                    
                    fififo_wr_data[55:40] <= #U_DLY frame_start_addr;

                    if(crc_data == {rx_shift_reg[23:0],pc_rx_data})
                        fififo_wr_data[39:32] <= #U_DLY 8'h80;
                    else
                        fififo_wr_data[39:32] <= #U_DLY 8'h00;

                    fififo_wr_data[31:0] <= #U_DLY frame_length;
                end
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fififo_wr_en <= #U_DLY 4'd0;
    else
        begin
            if((frame_busy == 1'b1) && (pc_rx_data_valid == 1'b1) && (frame_cnt == frame_length - 1'b1) && ((crc_data == {rx_shift_reg[23:0],pc_rx_data})))
                fififo_wr_en <= #U_DLY frame_type;
            else
                fififo_wr_en <= #U_DLY 4'd0;
        end
end

// ============================================================================
// Response Infomation
//
// resp_info[19]    : reserved
// resp_info[18:16] : status
// resp_info[15:0]  : function
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        resp_info <= #U_DLY 20'd0;
    else
        begin
            if((frame_busy == 1'b1) && (pc_rx_data_valid == 1'b1) && (frame_cnt == frame_length - 32'd1))
                begin
                    resp_info[15:0] <= #U_DLY frame_function;  

                    if(crc_data == {rx_shift_reg[23:0],pc_rx_data})
                        resp_info[18:16] <= #U_DLY 3'd1;
                    else
                        resp_info[18:16] <= #U_DLY 3'd0;
                end
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        resp_info_valid <= #U_DLY 1'b0;
    else
        begin
            if((frame_busy == 1'b1) && (pc_rx_data_valid == 1'b1) && (frame_cnt == frame_length - 32'd1) && (|frame_type == 1'b1))
                resp_info_valid <= #U_DLY 1'b1;
            else
                resp_info_valid <= #U_DLY 1'b0;
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









