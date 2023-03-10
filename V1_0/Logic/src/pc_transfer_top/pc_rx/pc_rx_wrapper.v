// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:38:14
// File Name    : pc_rx_wrapper.v
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
// pc_tx_wrapper
//    |---
// 
`timescale 1ns/1ns

module pc_rx_wrapper #
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
// Instruct Config Data 
// ----------------------------------------------------------------------------
    output                   [15:0] instruct_cfg_data           , 
    output                          instruct_cfg_data_valid     , 
// ----------------------------------------------------------------------------
// SLR Config Data
// ----------------------------------------------------------------------------
    output                    [7:0] slr_cfg_data                , 
    output                          slr_cfg_data_valid          , 
// ----------------------------------------------------------------------------
// Up Convert Config Data
// ----------------------------------------------------------------------------
    output                    [7:0] upconvert_cfg_data          , 
    output                          upconvert_cfg_data_valid    , 
// ----------------------------------------------------------------------------
// Config Data To Memory
// ----------------------------------------------------------------------------
    output                    [7:0] mem_cfg_data                , 
    output                          mem_cfg_data_valid          , 

    output                   [15:0] inst_resp_data              , 
    output                          inst_resp_data_valid        , 
// ----------------------------------------------------------------------------
// Internal Config Data
// ----------------------------------------------------------------------------
    output                          inter_cfg_wr_en             , 
    output                          inter_cfg_rd_en             , 
    output                   [15:0] inter_cfg_addr              , 
    output                   [31:0] inter_cfg_data              , 
// ----------------------------------------------------------------------------
// Responce Pakadge Infomation
// ----------------------------------------------------------------------------
    output                   [19:0] resp_info                   , 
    output                          resp_info_valid               
);

wire                                fdram_wr_en                 ; 
wire                         [11:0] fdram_wr_addr               ; 
wire                          [7:0] fdram_wr_data               ; 

wire                          [3:0] fififo_wr_en                ; 
wire                         [71:0] fififo_wr_data              ; 

wire                                ins_dram_rd_req             ; 
wire                                ins_dram_rd_ack             ; 
wire                                ins_dram_rd_done            ; 
wire                         [11:0] ins_dram_rd_addr            ; 
wire                          [7:0] ins_dram_rd_data            ; 

wire                                ins_rd_en                   ; 
wire                         [71:0] ins_rd_data                 ; 
wire                                ins_empty                   ; 

wire                                cfg_dram_rd_req             ; 
wire                                cfg_dram_rd_ack             ; 
wire                                cfg_dram_rd_done            ; 
wire                         [11:0] cfg_dram_rd_addr            ; 
wire                          [7:0] cfg_dram_rd_data            ; 

wire                                cfg_rd_en                   ; 
wire                         [71:0] cfg_rd_data                 ; 
wire                                cfg_empty                   ; 

wire                          [1:0] fdram_rd_req                ; 
wire                          [1:0] fdram_rd_ack                ; 
wire                          [1:0] fdram_rd_done               ; 
wire                     [2*12-1:0] fdram_rd_addr               ; 
wire                          [7:0] fdram_rd_data               ; 

wire                         [11:0] mux_ram_rd_addr             ; 
wire                          [7:0] mux_ram_rd_data             ; 

pc_rx_deframe #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_rx_deframe
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
// Frame Data BRAM Write Port
// ----------------------------------------------------------------------------
    .fdram_wr_en                    (fdram_wr_en                ), // (output)
    .fdram_wr_addr                  (fdram_wr_addr[11:0]        ), // (output)
    .fdram_wr_data                  (fdram_wr_data[7:0]         ), // (output)
// ----------------------------------------------------------------------------
// Frame Info Fifo Write Port
// ----------------------------------------------------------------------------
    .fififo_wr_en                   (fififo_wr_en[3:0]          ), // (output)
    .fififo_wr_data                 (fififo_wr_data[71:0]       ), // (output)
// ----------------------------------------------------------------------------
// Responce Pakadge Infomation
// ----------------------------------------------------------------------------
    .resp_info                      (resp_info[19:0]            ), // (output)
    .resp_info_valid                (resp_info_valid            )  // (output)
);

sdpram_d4kw8 u_sdpram_d4kw8 
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wren                           (fdram_wr_en                ), 
    .wraddress                      (fdram_wr_addr[11:0]        ), 
    .data                           (fdram_wr_data[7:0]         ), 
    .rdaddress                      (mux_ram_rd_addr[11:0]      ), 
    .q                              (mux_ram_rd_data[7:0]       )  
);

fifo_d512w72_st	u0_fifo_d512w72_st 
(
    .clock                          (clk_sys                    ), 
    .aclr                           (!rst_n                     ), 
    .wrreq                          (fififo_wr_en[1]            ), 
    .data                           (fififo_wr_data[71:0]       ), 
    .rdreq                          (ins_rd_en                  ), 
    .q                              (ins_rd_data[71:0]          ), 
    .empty                          (ins_empty                  ), 
    .full                           (/* not used */             )  
);

fifo_d512w72_st	u1_fifo_d512w72_st 
(
    .clock                          (clk_sys                    ), 
    .aclr                           (!rst_n                     ), 
    .wrreq                          (fififo_wr_en[2]            ), 
    .data                           (fififo_wr_data[71:0]       ), 
    .rdreq                          (cfg_rd_en                  ), 
    .q                              (cfg_rd_data[71:0]          ), 
    .empty                          (cfg_empty                  ), 
    .full                           (/* not used */             )  
);

pc_rx_instruct #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_rx_instruct
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Frame Data BRAM Read Port
// ----------------------------------------------------------------------------
    .fdram_rd_req                   (ins_dram_rd_req            ), // (output)
    .fdram_rd_ack                   (ins_dram_rd_ack            ), // (input )
    .fdram_rd_done                  (ins_dram_rd_done           ), // (output)

    .fdram_rd_addr                  (ins_dram_rd_addr[11:0]     ), // (output)
    .fdram_rd_data                  (ins_dram_rd_data[7:0]      ), // (input )
// ----------------------------------------------------------------------------
// Frame Info Fifo Read Port
// ----------------------------------------------------------------------------
    .fififo_rd_en                   (ins_rd_en                  ), // (output)
    .fififo_rd_data                 (ins_rd_data[71:0]          ), // (input )
    .fififo_empty                   (ins_empty                  ), // (input )
// ----------------------------------------------------------------------------
// Instruct Config Data 
// ----------------------------------------------------------------------------
    .instruct_cfg_data              (instruct_cfg_data[15:0]    ), // (output)
    .instruct_cfg_data_valid        (instruct_cfg_data_valid    )  // (output)
);

pc_rx_cfg #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_rx_cfg
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Frame Data BRAM Read Port
// ----------------------------------------------------------------------------
    .fdram_rd_req                   (cfg_dram_rd_req            ), // (output)
    .fdram_rd_ack                   (cfg_dram_rd_ack            ), // (input )
    .fdram_rd_done                  (cfg_dram_rd_done           ), // (output)

    .fdram_rd_addr                  (cfg_dram_rd_addr[11:0]     ), // (output)
    .fdram_rd_data                  (cfg_dram_rd_data[7:0]      ), // (input )
// ----------------------------------------------------------------------------
// Frame Info Fifo Read Port
// ----------------------------------------------------------------------------
    .fififo_rd_en                   (cfg_rd_en                  ), // (output)
    .fififo_rd_data                 (cfg_rd_data[71:0]          ), // (input )
    .fififo_empty                   (cfg_empty                  ), // (input )
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
// PCM & DY Config Data
// ----------------------------------------------------------------------------
    .inter_cfg_wr_en                (inter_cfg_wr_en            ), // (output)
    .inter_cfg_rd_en                (inter_cfg_rd_en            ), // (output)
    .inter_cfg_addr                 (inter_cfg_addr[15:0]       ), // (output)
    .inter_cfg_data                 (inter_cfg_data[31:0]       )  // (output)
);

assign fdram_rd_req = {cfg_dram_rd_req,ins_dram_rd_req};
assign fdram_rd_done = {cfg_dram_rd_done,ins_dram_rd_done};
assign fdram_rd_addr = {cfg_dram_rd_addr,ins_dram_rd_addr};

pc_rx_arbit #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_rx_arbit
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// User Read Req Port
// ----------------------------------------------------------------------------
    .fdram_rd_req                   (fdram_rd_req[1:0]          ), // (input )
    .fdram_rd_ack                   (fdram_rd_ack[1:0]          ), // (output)
    .fdram_rd_done                  (fdram_rd_done[1:0]         ), // (input )

    .fdram_rd_addr                  (fdram_rd_addr[2*12-1:0]    ), // (input )
    .fdram_rd_data                  (fdram_rd_data[7:0]         ), // (output)
// ----------------------------------------------------------------------------
// Frame Data BRAM Read Port
// ----------------------------------------------------------------------------
    .mux_ram_rd_addr                (mux_ram_rd_addr[11:0]      ), // (output)
    .mux_ram_rd_data                (mux_ram_rd_data[7:0]       )  // (input )
);

assign ins_dram_rd_ack = fdram_rd_ack[0];
assign ins_dram_rd_data = fdram_rd_data;

assign cfg_dram_rd_ack = fdram_rd_ack[1];
assign cfg_dram_rd_data = fdram_rd_data;

endmodule




