// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/13 16:00:31
// File Name    : inter_cfg_top.v
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
// inter_cfg_top
//    |---
// 
`timescale 1ns/1ps

module inter_cfg_top # 
(
    parameter                       U_DLY = 1                   ,
    parameter                       FPGA_VER = 32'h00000010     
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Internal Config Data
// ----------------------------------------------------------------------------
    input                           inter_cfg_wr_en             , 
    input                           inter_cfg_rd_en             , 
    input                    [15:0] inter_cfg_addr              , 
    input                    [31:0] inter_cfg_wr_data           , 
    output                   [31:0] inter_cfg_rd_data           , 
    output                          inter_cfg_rd_data_valid     , 
// ----------------------------------------------------------------------------
// Memory Read
// ----------------------------------------------------------------------------
    output                          mem_rd_en                   , 
    output                   [15:0] mem_rd_addr                 , 

    input                    [31:0] mem_rd_data                 , 
    input                           mem_rd_data_valid           , 
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    output                          soft_rst_en                 , 

    output                   [15:0] cfg_ins_txcnt               , // 指令发送次数
    output                    [7:0] cfg_ins_enable              , // 指令有效标志
    output                   [15:0] cfg_ins_length              , // 指令长度
    output                   [31:0] cfg_ins_waittime            , // 发送间隔时间

    output                   [31:0] cfg_pcm_bitrate             , // PCM码率
    output                   [31:0] cfg_pcm_fbias               , // PCM频偏
    output                    [7:0] cfg_pcm_multsubc            , // 副载波倍数
    output                    [3:0] cfg_pcm_codesel             , // 码型选择
    output                          cfg_pcm_load_en             , // 加载使能
    output                          cfg_pcm_keyer_en            , // 加调使能
    output                    [7:0] cfg_pcm_header              , 

    output                  [159:0] dy_cfg_data                 , 
    output                    [7:0] cfg_dy_header               , 

    output                          cfg_keyer_sel               , //调制体制选择  

    output                   [31:0] cfg_status_waittime         , 
    output                   [31:0] cfg_key_filter_data         , 

    output                          cfg_rm_time_valid           , 
    output                   [31:0] cfg_rm_time                 , 

    output                    [3:0] cfg_udp_socket              ,  // 4'b0001 point-to-point,4'b0100 multicast.
    output                   [15:0] cfg_udp_srcport             , 
    output                   [15:0] cfg_udp_dstport             , 
    output                   [31:0] cfg_phy_srcip               , 
    output                   [31:0] cfg_phy_dstip               , 
    output                   [47:0] cfg_phy_srcmac              , 
    output                   [47:0] cfg_phy_dstmac                
);

wire                                init_cfg_rstn               ; 

wire                                init_cfg_wr_en              ; 
wire                         [15:0] init_cfg_addr               ; 
wire                         [31:0] init_cfg_data               ; 

inter_cfg_init #
(
    .U_DLY                          (U_DLY                      )  
)
u_inter_cfg_init
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n & init_cfg_rstn      ), // (input )
// ----------------------------------------------------------------------------
// Memory Read
// ----------------------------------------------------------------------------
    .mem_rd_en                      (mem_rd_en                  ), // (output)
    .mem_rd_addr                    (mem_rd_addr[15:0]          ), // (output)

    .mem_rd_data                    (mem_rd_data[31:0]          ), // (input )
    .mem_rd_data_valid              (mem_rd_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Inition Write 
// ----------------------------------------------------------------------------
    .init_cfg_wr_en                 (init_cfg_wr_en             ), // (output)
    .init_cfg_addr                  (init_cfg_addr[15:0]        ), // (output)
    .init_cfg_data                  (init_cfg_data[31:0]        )  // (output)
);

inter_cfg_reg #
(
    .U_DLY                          (U_DLY                      ), 
    .FPGA_VER                       (FPGA_VER                   )  
)
u_inter_cfg_reg
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Internal Config Data
// ----------------------------------------------------------------------------
    .inter_cfg_wr_en                (inter_cfg_wr_en            ), // (input )
    .inter_cfg_rd_en                (inter_cfg_rd_en            ), // (input )
    .inter_cfg_addr                 (inter_cfg_addr[15:0]       ), // (input )
    .inter_cfg_wr_data              (inter_cfg_wr_data[31:0]    ), // (input )
    .inter_cfg_rd_data              (inter_cfg_rd_data[31:0]    ), // (output)
    .inter_cfg_rd_data_valid        (inter_cfg_rd_data_valid    ), // (output)
// ----------------------------------------------------------------------------
// Initialization Config Data
// ---------------------------------------------------------------------------- 
    .init_cfg_wr_en                 (init_cfg_wr_en             ), // (input )
    .init_cfg_addr                  (init_cfg_addr[15:0]        ), // (input )
    .init_cfg_data                  (init_cfg_data[31:0]        ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .init_cfg_rstn                  (init_cfg_rstn              ), // (output)
    .soft_rst_en                    (soft_rst_en                ), // (output)

    .cfg_ins_txcnt                  (cfg_ins_txcnt[15:0]        ), // (output) 指令发送次数
    .cfg_ins_enable                 (cfg_ins_enable[7:0]        ), // (output) 指令有效标志
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (output) 指令长度
    .cfg_ins_waittime               (cfg_ins_waittime[31:0]     ), // (output) 发送间隔时间

    .cfg_pcm_bitrate                (cfg_pcm_bitrate[31:0]      ), // (output) PCM码率
    .cfg_pcm_fbias                  (cfg_pcm_fbias[31:0]        ), // (output) PCM频偏
    .cfg_pcm_multsubc               (cfg_pcm_multsubc[7:0]      ), // (output) 副载波倍数
    .cfg_pcm_codesel                (cfg_pcm_codesel[3:0]       ), // (output) 码型选择
    .cfg_pcm_load_en                (cfg_pcm_load_en            ), // (output) 加载使能
    .cfg_pcm_keyer_en               (cfg_pcm_keyer_en           ), // (output) 加调使能
    .cfg_pcm_header                 (cfg_pcm_header[7:0]        ), // (output)

    .dy_cfg_data                    (dy_cfg_data[159:0]         ), // (output)
    .cfg_dy_header                  (cfg_dy_header[7:0]         ), // (output)

    .cfg_keyer_sel                  (cfg_keyer_sel              ), // (output)调制体制选择  

    .cfg_status_waittime            (cfg_status_waittime[31:0]  ), // (output)
    .cfg_key_filter_data            (cfg_key_filter_data[31:0]  ), // (output)

    .cfg_rm_time_valid              (cfg_rm_time_valid          ), // (output)
    .cfg_rm_time                    (cfg_rm_time[31:0]          ), // (output)

    .cfg_udp_socket                 (cfg_udp_socket[3:0]        ), // (output) 4'b0001 point-to-point,4'b0100 multicast.
    .cfg_udp_srcport                (cfg_udp_srcport[15:0]      ), // (output)
    .cfg_udp_dstport                (cfg_udp_dstport[15:0]      ), // (output)
    .cfg_phy_srcip                  (cfg_phy_srcip[31:0]        ), // (output)
    .cfg_phy_dstip                  (cfg_phy_dstip[31:0]        ), // (output)
    .cfg_phy_srcmac                 (cfg_phy_srcmac[47:0]       ), // (output)
    .cfg_phy_dstmac                 (cfg_phy_dstmac[47:0]       )  // (output)
);

endmodule

