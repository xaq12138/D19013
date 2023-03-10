// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 00:35:37
// File Name    : pc_ch_sel.v
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

module pc_ch_sel #
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
// Local PC data
// ----------------------------------------------------------------------------
    input                     [7:0] pc_lcrx_data                , 
    input                           pc_lcrx_data_valid          , 
    
    output reg                      pc_lctx_en                  , 
    output reg                [7:0] pc_lctx_data                , 
// ----------------------------------------------------------------------------
// UDP TX & RX Data
// ----------------------------------------------------------------------------
    output reg                      udp_tx_en                   , 
    output reg                [7:0] udp_tx_data                 , 

    input                     [7:0] udp_rx_data                 , 
    input                           udp_rx_data_valid           , 
// ----------------------------------------------------------------------------
// Remote PC data
// ----------------------------------------------------------------------------
    input                     [7:0] pc_rmrx_data                , 
    input                           pc_rmrx_data_valid          , 

    output reg                      pc_rmtx_en                  , 
    output reg                [7:0] pc_rmtx_data                , 
// ----------------------------------------------------------------------------
// Mux PC data
// ----------------------------------------------------------------------------
    input                     [7:0] pc_tx_data                  , 
    input                           pc_tx_data_valid            , 

    output reg                [7:0] pc_rx_data                  , 
    output reg                      pc_rx_data_valid            , 
// ----------------------------------------------------------------------------
// PC Remote/Local Select
// ----------------------------------------------------------------------------
    input                           test_mode                   , // normal(0)/test(1)
    input                           rm_route                    , // uart(0)/udp(1)
    input                           pc_ch_mode                    // remote(0)/local(1)
);

// ----------------------------------------------------------------------------
// FPGA
// ----------------------------------------------------------------------------
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_rx_data <= #U_DLY 8'd0;
    else
        begin
            if(pc_ch_mode == 1'b0)
                pc_rx_data <= #U_DLY pc_rmrx_data;
            else
                pc_rx_data <= #U_DLY udp_rx_data;
        end
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_rx_data_valid <= #U_DLY 1'd0;
    else
        begin
            if(pc_ch_mode == 1'b0)
                pc_rx_data_valid <= #U_DLY pc_rmrx_data_valid;
            else
                pc_rx_data_valid <= #U_DLY udp_rx_data_valid;
        end
end 

// ----------------------------------------------------------------------------
// Local
// ----------------------------------------------------------------------------
//always @ (posedge clk_sys or negedge rst_n)
//begin
//    if(rst_n == 1'b0)
//        pc_lctx_data <= #U_DLY 8'd0;
//    else
//        ;
//        case({test_mode,rm_route,pc_ch_mode})
//            3'b000  : pc_lctx_data <= #U_DLY pc_rmrx_data;
//            3'b001  : pc_lctx_data <= #U_DLY pc_tx_data;
//            3'b010  : pc_lctx_data <= #U_DLY udp_rx_data;
//            3'b011  : pc_lctx_data <= #U_DLY pc_tx_data;
//            3'b100  : pc_lctx_data <= #U_DLY pc_rmrx_data;
//            3'b101  : pc_lctx_data <= #U_DLY pc_rmrx_data;
//            3'b110  : pc_lctx_data <= #U_DLY udp_rx_data;
//            3'b111  : pc_lctx_data <= #U_DLY udp_rx_data;
//            default : pc_lctx_data <= #U_DLY 8'd0;
//        endcase
//end 
//
//always @ (posedge clk_sys or negedge rst_n)
//begin
//    if(rst_n == 1'b0)
//        pc_lctx_en <= #U_DLY 1'b0;
//    else
//        case({test_mode,rm_route,pc_ch_mode})
//            3'b000  : pc_lctx_en <= #U_DLY pc_rmrx_data_valid;
//            3'b001  : pc_lctx_en <= #U_DLY pc_tx_data_valid;
//            3'b010  : pc_lctx_en <= #U_DLY udp_rx_data_valid;
//            3'b011  : pc_lctx_en <= #U_DLY pc_tx_data_valid;
//            3'b100  : pc_lctx_en <= #U_DLY pc_rmrx_data_valid;
//            3'b101  : pc_lctx_en <= #U_DLY pc_rmrx_data_valid;
//            3'b110  : pc_lctx_en <= #U_DLY udp_rx_data_valid;
//            3'b111  : pc_lctx_en <= #U_DLY udp_rx_data_valid;
//            default : pc_lctx_en <= #U_DLY 1'b0;
//        endcase
//end 

// ----------------------------------------------------------------------------
// Remote Uart
// ----------------------------------------------------------------------------
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_rmtx_en <= #U_DLY 1'b0;
    else
        begin
            if(pc_ch_mode == 1'b0)
                pc_rmtx_en <= #U_DLY pc_tx_data_valid;
            else
                pc_rmtx_en <= #U_DLY 1'b0;
        end
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_rmtx_data <= #U_DLY 8'd0;
    else
        begin
            if(pc_ch_mode == 1'b0)
                pc_rmtx_data <= #U_DLY pc_tx_data;
            else
                pc_rmtx_data <= #U_DLY 8'd0;
        end
end 

// ----------------------------------------------------------------------------
// Remote UDP
// ----------------------------------------------------------------------------
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        udp_tx_en <= #U_DLY 1'b0;
    else
        begin
            if(pc_ch_mode == 1'b1)
                udp_tx_en <= #U_DLY pc_tx_data_valid;
            else
                udp_tx_en <= #U_DLY 1'b0;
        end
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        udp_tx_data <= #U_DLY 8'd0;
    else
        begin
            if(pc_ch_mode == 1'b1)
                udp_tx_data <= #U_DLY pc_tx_data;
            else
                udp_tx_data <= #U_DLY 8'd0;
        end
end 

endmodule




