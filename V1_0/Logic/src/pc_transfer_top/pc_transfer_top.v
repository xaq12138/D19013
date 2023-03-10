// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:23:51
// File Name    : pc_transfer_top.v
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
// pc_transfer_top
//    |---
// 
`timescale 1ns/1ns

module pc_transfer_top #
(
    parameter                       U_DLY = 1                   ,                  
    parameter                       STATUS_SAMPLE_DATA = 32'd99_9999    
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
    
    output                          pc_lctx_en                  , 
    output                    [7:0] pc_lctx_data                , 
// ----------------------------------------------------------------------------
// UDP TX & RX Data
// ----------------------------------------------------------------------------
    output                          udp_tx_en                   , 
    output                    [7:0] udp_tx_data                 , 

    input                     [7:0] udp_rx_data                 , 
    input                           udp_rx_data_valid           , 
// ----------------------------------------------------------------------------
// Remote PC data
// ----------------------------------------------------------------------------
    input                     [7:0] pc_rmrx_data                , 
    input                           pc_rmrx_data_valid          , 

    output                          pc_rmtx_en                  , 
    output                    [7:0] pc_rmtx_data                , 
// ----------------------------------------------------------------------------
// Monitor Data
// ----------------------------------------------------------------------------
    input                    [31:0] debug_port_status           , 
    input                    [31:0] debug_power_current         , 
    input                    [31:0] debug_power_voltage         , 
    input                    [31:0] debug_power_data            , 
    input                    [63:0] debug_local_time            , 
// ----------------------------------------------------------------------------
// Key Data
// ----------------------------------------------------------------------------
    input                    [15:0] key_data                    , 
    input                           key_data_valid              , 

    input                           key_lr_status               , 
    input                           key_status_valid            , 
// ----------------------------------------------------------------------------
// TX Instruct Data
// dfifo_rd_data[576:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    input                   [575:0] txins_data                  , 
    input                           txins_data_valid            , 
// ----------------------------------------------------------------------------
// SLR RX Instruct Data
// dfifo_rd_data[576:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    input                   [575:0] rxins_data                  , 
    input                           rxins_data_valid            , 
// ----------------------------------------------------------------------------
// Read Instruct Data
//
// instruct_rd_data[511:0]      : instruct data
// ----------------------------------------------------------------------------
    input                   [511:0] memins_data                 , 
    input                           memins_data_valid           , 
// ----------------------------------------------------------------------------
// Instruct Config Data 
//
// instruct_cfg_data[15:0] insInstruct sign
// ----------------------------------------------------------------------------
    output                   [15:0] instruct_cfg_data           , 
    output                          instruct_cfg_data_valid     , 
// ----------------------------------------------------------------------------
// SLR Config Data
// ----------------------------------------------------------------------------
    output                    [7:0] slr_cfg_data                , 
    output                          slr_cfg_data_valid          , 

    input                     [7:0] slr_rd_data                 , 
    input                           slr_rd_data_valid           , 
// ----------------------------------------------------------------------------
// Up Convert Config Data
// ----------------------------------------------------------------------------
    output                    [7:0] upconvert_cfg_data          , 
    output                          upconvert_cfg_data_valid    , 

    input                     [7:0] upcovert_rd_data            , 
    input                           upcovert_rd_data_valid      , 
// ----------------------------------------------------------------------------
// Config Data To Memory
// ----------------------------------------------------------------------------
    output                    [7:0] mem_cfg_data                , 
    output                          mem_cfg_data_valid          , 
// ----------------------------------------------------------------------------
// Internal Config Port
// ----------------------------------------------------------------------------
    output                          inter_cfg_wr_en             , 
    output                          inter_cfg_rd_en             , 
    output                   [15:0] inter_cfg_addr              , 
    output                   [31:0] inter_cfg_wr_data           , 
    input                    [31:0] inter_cfg_rd_data           , 
    input                           inter_cfg_rd_data_valid     , 
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    output                          pc_ch_mode                  , 

    input                    [15:0] cfg_ins_length              , // 指令长度
    input                    [31:0] cfg_status_waittime           // 
);

wire                          [7:0] pc_tx_data                  ; 
wire                                pc_tx_data_valid            ; 

wire                          [7:0] pc_rx_data                  ; 
wire                                pc_rx_data_valid            ; 

wire                         [19:0] resp_info                   ; 
wire                                resp_info_valid             ; 

wire                         [15:0] inst_resp_data              ; 
wire                                inst_resp_data_valid        ; 

lrmode_ctrl_wrapper #
(
    .U_DLY                          (U_DLY                      )  
)
u_lrmode_ctrl_wrapper
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Local PC data
// ----------------------------------------------------------------------------
    .pc_lcrx_data                   (pc_lcrx_data[7:0]          ), // (input )
    .pc_lcrx_data_valid             (pc_lcrx_data_valid         ), // (input )
    
    .pc_lctx_en                     (pc_lctx_en                 ), // (output)
    .pc_lctx_data                   (pc_lctx_data[7:0]          ), // (output)
// ----------------------------------------------------------------------------
// UDP TX & RX Data
// ----------------------------------------------------------------------------
    .udp_tx_en                      (udp_tx_en                  ), // (output)
    .udp_tx_data                    (udp_tx_data[7:0]           ), // (output)

    .udp_rx_data                    (udp_rx_data[7:0]           ), // (input )
    .udp_rx_data_valid              (udp_rx_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Remote PC data
// ----------------------------------------------------------------------------
    .pc_rmrx_data                   (pc_rmrx_data[7:0]          ), // (input )
    .pc_rmrx_data_valid             (pc_rmrx_data_valid         ), // (input )

    .pc_rmtx_en                     (pc_rmtx_en                 ), // (output)
    .pc_rmtx_data                   (pc_rmtx_data[7:0]          ), // (output)
// ----------------------------------------------------------------------------
// Mux PC data
// ----------------------------------------------------------------------------
    .pc_tx_data                     (pc_tx_data[7:0]            ), // (input )
    .pc_tx_data_valid               (pc_tx_data_valid           ), // (input )

    .pc_rx_data                     (pc_rx_data[7:0]            ), // (output)
    .pc_rx_data_valid               (pc_rx_data_valid           ), // (output)
// ----------------------------------------------------------------------------
// Key Data
// ----------------------------------------------------------------------------
    .key_status                     (key_lr_status              ), // (input )
    .key_valid                      (key_status_valid           ), // (input )
// ----------------------------------------------------------------------------
// PC Select
// ----------------------------------------------------------------------------
    .pc_ch_mode                     (pc_ch_mode                 )  // (output)
);

pc_rx_wrapper #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_rx_wrapper
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// PC data
// ----------------------------------------------------------------------------
    .pc_rx_data                     (pc_rx_data[7:0]            ), // (input )
    .pc_rx_data_valid               (pc_rx_data_valid           ), // (input )
// ----------------------------------------------------------------------------
// Instruct Config Data 
// ----------------------------------------------------------------------------
    .instruct_cfg_data              (instruct_cfg_data[15:0]    ), // (output)
    .instruct_cfg_data_valid        (instruct_cfg_data_valid    ), // (output)
// ----------------------------------------------------------------------------
// SLR Config Data
// ----------------------------------------------------------------------------
    .slr_cfg_data                   (slr_cfg_data[7:0]          ), // (output)
    .slr_cfg_data_valid             (slr_cfg_data_valid         ), // (output)
// ----------------------------------------------------------------------------
// Up Convert Config Data
// ----------------------------------------------------------------------------
    .upconvert_cfg_data             (upconvert_cfg_data[7:0]    ), // (output)
    .upconvert_cfg_data_valid       (upconvert_cfg_data_valid   ), // (output)
// ----------------------------------------------------------------------------
// Config Data To Memory
// ----------------------------------------------------------------------------
    .mem_cfg_data                   (mem_cfg_data[7:0]          ), // (output)
    .mem_cfg_data_valid             (mem_cfg_data_valid         ), // (output)

    .inst_resp_data                 (inst_resp_data[15:0]       ), // (output)
    .inst_resp_data_valid           (inst_resp_data_valid       ), // (output)
// ----------------------------------------------------------------------------
// Internal Config Port
// ----------------------------------------------------------------------------
    .inter_cfg_wr_en                (inter_cfg_wr_en            ), // (output)
    .inter_cfg_rd_en                (inter_cfg_rd_en            ), // (output)
    .inter_cfg_addr                 (inter_cfg_addr[15:0]       ), // (output)
    .inter_cfg_data                 (inter_cfg_wr_data[31:0]    ), // (output)
// ----------------------------------------------------------------------------
// Responce Pakadge Infomation
// ----------------------------------------------------------------------------
    .resp_info                      (resp_info[19:0]            ), // (output)
    .resp_info_valid                (resp_info_valid            )  // (output)
);

pc_tx_wrapper  #
(
    .U_DLY                          (U_DLY                      ), 
    .SAMPLE_DATA                    (STATUS_SAMPLE_DATA         )  
)
u_pc_tx_wrapper
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (input )
    .cfg_status_waittime            (cfg_status_waittime[31:0]  ), // (input )
// ----------------------------------------------------------------------------
// Monitor Data
// ----------------------------------------------------------------------------
    .debug_lr_sel                   ({7'd0,pc_ch_mode}          ), // (input )
    .debug_port_status              (debug_port_status[31:0]    ), // (input )
    .debug_power_current            (debug_power_current[31:0]  ), // (input )
    .debug_power_voltage            (debug_power_voltage[31:0]  ), // (input )
    .debug_power_data               (debug_power_data[31:0]     ), // (input )
    .debug_local_time               (debug_local_time[63:0]     ), // (input )
// ----------------------------------------------------------------------------
// Instruct Sign
// ----------------------------------------------------------------------------
    .rm_inst                        (instruct_cfg_data[15:0]    ), // (input )
    .rm_inst_valid                  (instruct_cfg_data_valid    ), // (input )

    .lc_inst                        (key_data[15:0]             ), // (input )
    .lc_inst_valid                  (key_data_valid             ), // (input )
// ----------------------------------------------------------------------------
// TX Instruct Data
// dfifo_rd_data[575:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    .txins_data                     (txins_data[575:0]          ), // (input )
    .txins_data_valid               (txins_data_valid           ), // (input )
// ----------------------------------------------------------------------------
// SLR RX Instruct Data
// dfifo_rd_data[575:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    .rxins_data                     (rxins_data[575:0]          ), // (input )
    .rxins_data_valid               (rxins_data_valid           ), // (input )
// ----------------------------------------------------------------------------
// SLR Config Data
// ----------------------------------------------------------------------------
    .slr_rd_data                    (slr_rd_data[7:0]           ), // (input )
    .slr_rd_data_valid              (slr_rd_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Up Convert Config Data
// ----------------------------------------------------------------------------
    .upcovert_rd_data               (upcovert_rd_data[7:0]      ), // (input )
    .upcovert_rd_data_valid         (upcovert_rd_data_valid     ), // (input )
// ----------------------------------------------------------------------------
// Read Instruct Data
//
// instruct_rd_data[511:0]      : instruct data
// ----------------------------------------------------------------------------
    .inst_resp_data                 (inst_resp_data[15:0]       ), // (input )
    .inst_resp_data_valid           (inst_resp_data_valid       ), // (input )

    .memins_data                    (memins_data[511:0]         ), // (input )
    .memins_data_valid              (memins_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Internal Config Data
// ----------------------------------------------------------------------------
    .inter_cfg_addr                 (inter_cfg_addr[15:0]       ), // (input )
    .inter_cfg_rd_data              (inter_cfg_rd_data[31:0]    ), // (input )
    .inter_cfg_rd_data_valid        (inter_cfg_rd_data_valid    ), // (input )
// ----------------------------------------------------------------------------
// Responce Pakadge Infomation
// ----------------------------------------------------------------------------
    .resp_info                      (resp_info[19:0]            ), // (input )
    .resp_info_valid                (resp_info_valid            ), // (input )
// ----------------------------------------------------------------------------
// Pakadge Source
// ----------------------------------------------------------------------------
    .pc_tx_data                     (pc_tx_data[7:0]            ), // (output)
    .pc_tx_data_valid               (pc_tx_data_valid           )  // (output)
);

endmodule



