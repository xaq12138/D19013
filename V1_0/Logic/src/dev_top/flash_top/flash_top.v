// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/23 11:54:30
// File Name    : flash_top.v
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
// flash_top
//    |---
// 
`timescale 1ns/1ps

module flash_top #
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
// Instruct Config Data
// ----------------------------------------------------------------------------
    input                     [7:0] mem_cfg_data                , 
    input                           mem_cfg_data_valid          , 

    output                  [511:0] mem_inst_data               , 
    output                          mem_inst_data_valid         , 
// ----------------------------------------------------------------------------
// Initial Config Data
// ----------------------------------------------------------------------------
    input                           mem_rd_en                   , 
    input                    [15:0] mem_rd_addr                 , 

    output                   [31:0] mem_rd_data                 , 
    output                          mem_rd_data_valid           , 
// ----------------------------------------------------------------------------
// Instruct Send Port
// ----------------------------------------------------------------------------
    input                    [15:0] key_inst                    , 
    input                           key_inst_valid              , 

    input                    [15:0] rm_inst                     , 
    input                           rm_inst_valid               , 

    output                  [511:0] tx_inst_data                , 
    output                          tx_inst_data_valid          , 
// ----------------------------------------------------------------------------
// Flash 
// ----------------------------------------------------------------------------
    output                          flash_hold_n                , 
    output                          flash_cs_n                  , 
    output                          flash_clk                   , 
    output                          flash_mosi                  , 
    input                           flash_miso                    
);

wire                                cfgfifo_rd_en               ; 
wire                          [7:0] cfgfifo_rd_data             ; 
wire                                cfgfifo_empty               ; 

wire                          [2:0] user_req                    ; 
wire                          [2:0] user_ack                    ; 
wire                          [2:0] user_done                   ; 

wire                          [2:0] user_en                     ; 
wire                         [95:0] user_cmd                    ; 
wire                         [23:0] user_wr_data                ; 
    
wire                         [23:0] user_rd_data                ; 
wire                          [2:0] user_rd_data_valid          ; 

wire                                inst_fifo_wr_en             ; 
wire                         [15:0] inst_fifo_wr_data           ; 
wire                                inst_fifo_rd_en             ; 
wire                         [15:0] inst_fifo_rd_data           ; 
wire                                inst_fifo_empty             ; 

wire                                arbit_ififo_wr_en           ; 
wire                         [15:0] arbit_ififo_wr_data         ; 
wire                                arbit_ififo_rd_en           ; 
wire                         [15:0] arbit_ififo_rd_data         ; 

wire                                flash_ififo_wr_en           ; 
wire                         [31:0] flash_ififo_wr_data         ; 
wire                                flash_ififo_rd_en           ; 
wire                         [31:0] flash_ififo_rd_data         ; 
wire                                flash_ififo_empty           ; 

wire                                flash_dfifo_wr_en           ; 
wire                          [7:0] flash_dfifo_wr_data         ; 
wire                                flash_dfifo_rd_en           ; 
wire                          [7:0] flash_dfifo_rd_data         ; 

wire                          [7:0] flash_rd_data               ; 
wire                                flash_rd_data_valid         ; 

wire                                spi_tx_en                   ; 
wire                         [15:0] spi_tx_data                 ; 

wire                          [7:0] spi_rx_data                 ; 
wire                                spi_rx_data_valid           ; 

wire                          [7:0] spi_cs_n                    ; 

fifo_d4kw8_st u0_fifo_d4kw8_st
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (mem_cfg_data_valid         ), 
    .data                           (mem_cfg_data[7:0]          ), 
    .rdreq                          (cfgfifo_rd_en              ), 
    .q                              (cfgfifo_rd_data[7:0]       ), 
    .empty                          (cfgfifo_empty              ), 
    .full                           (                           ), 
    .usedw                          (                           )  
);

flash_user_cfg #
(
    .U_DLY                          (U_DLY                      )  
)
u_flash_user_cfg
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .inst_length                    (inst_length[15:0]          ), // (input )
// ----------------------------------------------------------------------------
// FIFO Read Port
// ----------------------------------------------------------------------------
    .cfgfifo_rd_en                  (cfgfifo_rd_en              ), // (output)
    .cfgfifo_rd_data                (cfgfifo_rd_data[7:0]       ), // (input )
    .cfgfifo_empty                  (cfgfifo_empty              ), // (input )
// ----------------------------------------------------------------------------
// Read Instruct Data
// ----------------------------------------------------------------------------
    .inst_data                      (mem_inst_data[511:0]       ), // (output)
    .inst_data_valid                (mem_inst_data_valid        ), // (output)
// ----------------------------------------------------------------------------
// Arbit Port
//  user_cmd[31]    --> write(0)/read(1).
//  user_cmd[30:24] --> reserved
//  user_cmd[23:16] --> length
//  user_cmd[15:0]  --> addr
// ----------------------------------------------------------------------------
    .user_req                       (user_req[0]                ), // (output)
    .user_ack                       (user_ack[0]                ), // (input )
    .user_done                      (user_done[0]               ), // (output)

    .user_en                        (user_en[0]                 ), // (output)
    .user_cmd                       (user_cmd[0*32+:32]         ), // (output)
    .user_wr_data                   (user_wr_data[0*8+:8]       ), // (output)
    
    .user_rd_data                   (user_rd_data[0*8+:8]       ), // (input )
    .user_rd_data_valid             (user_rd_data_valid[0]      )  // (input )
);

flash_user_init #
(
    .U_DLY                          (U_DLY                      )  
)
u_flash_user_init
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Initial Config Data
// ----------------------------------------------------------------------------
    .mem_rd_en                      (mem_rd_en                  ), // (input )
    .mem_rd_addr                    (mem_rd_addr[15:0]          ), // (input )

    .mem_rd_data                    (mem_rd_data[31:0]          ), // (output)
    .mem_rd_data_valid              (mem_rd_data_valid          ), // (output)
// ----------------------------------------------------------------------------
// Arbit Port
//  user_cmd[31]    --> write(0)/read(1).
//  user_cmd[30:24] --> reserved
//  user_cmd[23:16] --> length
//  user_cmd[15:0]  --> addr
// ----------------------------------------------------------------------------
    .user_req                       (user_req[1]                ), // (output)
    .user_ack                       (user_ack[1]                ), // (input )
    .user_done                      (user_done[1]               ), // (output)

    .user_en                        (user_en[1]                 ), // (output)
    .user_cmd                       (user_cmd[1*32+:32]         ), // (output)
    
    .user_rd_data                   (user_rd_data[1*8+:8]       ), // (input )
    .user_rd_data_valid             (user_rd_data_valid[1]      )  // (input )
);

flash_user_inst #
(
    .U_DLY                          (U_DLY                      )  
)
u_flash_user_inst
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .inst_length                    (inst_length[15:0]          ), // (input )
    .cfg_ins_enable                 (cfg_ins_enable[7:0]        ), // (input )
// ----------------------------------------------------------------------------
// Instruct Data
// ----------------------------------------------------------------------------
    .key_inst                       (key_inst[15:0]             ), // (input )
    .key_inst_valid                 (key_inst_valid             ), // (input )

    .rm_inst                        (rm_inst[15:0]              ), // (input )
    .rm_inst_valid                  (rm_inst_valid              ), // (input )
// ----------------------------------------------------------------------------
// Info FIFO(FWFT) Write Or Read Data
// ----------------------------------------------------------------------------
    .inst_fifo_wr_en                (inst_fifo_wr_en            ), // (output)
    .inst_fifo_wr_data              (inst_fifo_wr_data[15:0]    ), // (output)
    .inst_fifo_rd_en                (inst_fifo_rd_en            ), // (output)
    .inst_fifo_rd_data              (inst_fifo_rd_data[15:0]    ), // (input )
    .inst_fifo_empty                (inst_fifo_empty            ), // (input )
// ----------------------------------------------------------------------------
// Instruct Data
// ----------------------------------------------------------------------------
    .inst_data                      (tx_inst_data[511:0]        ), // (output)
    .inst_data_valid                (tx_inst_data_valid         ), // (output)
// ----------------------------------------------------------------------------
// Arbit Port
//  user_cmd[31]    --> write(0)/read(1).
//  user_cmd[30:24] --> reserved
//  user_cmd[23:16] --> length
//  user_cmd[15:0]  --> addr
// ----------------------------------------------------------------------------
    .user_req                       (user_req[2]                ), // (output)
    .user_ack                       (user_ack[2]                ), // (input )
    .user_done                      (user_done[2]               ), // (output)

    .user_en                        (user_en[2]                 ), // (output)
    .user_cmd                       (user_cmd[2*32+:32]         ), // (output)
    
    .user_rd_data                   (user_rd_data[2*8+:8]       ), // (input )
    .user_rd_data_valid             (user_rd_data_valid[2]      )  // (input )
);

fifo_d512w16_fwft u0_fifo_d512w16_fwft
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (inst_fifo_wr_en            ), 
    .data                           (inst_fifo_wr_data[15:0]    ), 
    .rdreq                          (inst_fifo_rd_en            ), 
    .q                              (inst_fifo_rd_data[15:0]    ), 
    .empty                          (inst_fifo_empty            ), 
    .full                           (                           )  
);

flash_arbit #
(
    .U_DLY                          (U_DLY                      )  
)
u_flash_arbit
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Arbit Port
//  user_cmd[31]    --> write(0)/read(1).
//  user_cmd[30:24] --> reserved
//  user_cmd[23:16] --> length
//  user_cmd[15:0]  --> addr
// ----------------------------------------------------------------------------
    .user_req                       (user_req[2:0]              ), // (input )
    .user_ack                       (user_ack[2:0]              ), // (output)
    .user_done                      (user_done[2:0]             ), // (input )

    .user_en                        (user_en[2:0]               ), // (input )
    .user_cmd                       (user_cmd[95:0]             ), // (input )
    .user_wr_data                   (user_wr_data[23:0]         ), // (input )
    
    .user_rd_data                   (user_rd_data[23:0]         ), // (output)
    .user_rd_data_valid             (user_rd_data_valid[2:0]    ), // (output)
// ----------------------------------------------------------------------------
// Info FIFO(fwft)
//
// arbit_ififo_wr_data[15:10] --> reserved
// arbit_ififo_wr_data[9:8] --> c_user
// arbit_ififo_wr_data[7:0] --> length 
// ----------------------------------------------------------------------------
    .arbit_ififo_wr_en              (arbit_ififo_wr_en          ), // (output)
    .arbit_ififo_wr_data            (arbit_ififo_wr_data[15:0]  ), // (output)
    .arbit_ififo_rd_en              (arbit_ififo_rd_en          ), // (output)
    .arbit_ififo_rd_data            (arbit_ififo_rd_data[15:0]  ), // (input )
// ----------------------------------------------------------------------------
// Write TO FLASH Control
// ----------------------------------------------------------------------------
    .flash_ififo_wr_en              (flash_ififo_wr_en          ), // (output)
    .flash_ififo_wr_data            (flash_ififo_wr_data[31:0]  ), // (output)

    .flash_dfifo_wr_en              (flash_dfifo_wr_en          ), // (output)
    .flash_dfifo_wr_data            (flash_dfifo_wr_data[7:0]   ), // (output)

    .flash_rd_data                  (flash_rd_data[7:0]         ), // (input )
    .flash_rd_data_valid            (flash_rd_data_valid        )  // (input )
);

fifo_d512w16_fwft u1_fifo_d512w16_fwft
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (arbit_ififo_wr_en          ), 
    .data                           (arbit_ififo_wr_data[15:0]  ), 
    .rdreq                          (arbit_ififo_rd_en          ), 
    .q                              (arbit_ififo_rd_data[15:0]  ), 
    .empty                          (                           ), 
    .full                           (                           )  
);

fifo_d1kw32_fwft u_fifo_d1kw32_fwft
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (flash_ififo_wr_en          ), 
    .data                           (flash_ififo_wr_data[31:0]  ), 
    .rdreq                          (flash_ififo_rd_en          ), 
    .q                              (flash_ififo_rd_data[31:0]  ), 
    .empty                          (flash_ififo_empty          ), 
    .full                           (                           )  
);

fifo_d4kw8_st u1_fifo_d4kw8_st
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (flash_dfifo_wr_en          ), 
    .data                           (flash_dfifo_wr_data[7:0]   ), 
    .rdreq                          (flash_dfifo_rd_en          ), 
    .q                              (flash_dfifo_rd_data[7:0]   ), 
    .empty                          (                           ), 
    .full                           (                           ), 
    .usedw                          (                           )  
);

flash_ctrl #
(
    .U_DLY                          (U_DLY                      )  
)
u_flash_ctrl
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Read Commond & Data
// ----------------------------------------------------------------------------
    .flash_ififo_rd_en              (flash_ififo_rd_en          ), // (output)
    .flash_ififo_rd_data            (flash_ififo_rd_data[31:0]  ), // (input )
    .flash_ififo_empty              (flash_ififo_empty          ), // (input )

    .flash_dfifo_rd_en              (flash_dfifo_rd_en          ), // (output)
    .flash_dfifo_rd_data            (flash_dfifo_rd_data[7:0]   ), // (input )
                           
    .flash_rd_data                  (flash_rd_data[7:0]         ), // (output)
    .flash_rd_data_valid            (flash_rd_data_valid        ), // (output)
// ----------------------------------------------------------------------------
// Write & Read Data By SPI
//
// spi_tx_data[15:10] --> reserved 
// spi_tx_data[10]    --> last byte(1)
// spi_tx_data[9]     --> write(0)/read(1)
// spi_tx_data[7:0]   --> data
// ----------------------------------------------------------------------------
    .spi_tx_en                      (spi_tx_en                  ), // (output)
    .spi_tx_data                    (spi_tx_data[15:0]          ), // (output)

    .spi_rx_data                    (spi_rx_data[7:0]           ), // (input )
    .spi_rx_data_valid              (spi_rx_data_valid          )  // (input )
);

spi_top #
(
    .U_DLY                          (U_DLY                      )  
)
u_spi_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .baud_rate                      (16'd8                      ), // (input )

    .cfg_cplo                       (1'b0                       ), // (input )
    .cfg_cpha                       (1'b0                       ), // (input )
    .cfg_mlsb                       (1'b1                       ), // (input )
    .cfg_dev_sel                    (8'd1                       ), // (input ) Select the device by asserting the relevant bit.
// ----------------------------------------------------------------------------
// TX Data
// ----------------------------------------------------------------------------
    .spi_tx_en                      (spi_tx_en                  ), // (input )
    .spi_tx_data                    (spi_tx_data[15:0]          ), // (input )
// ----------------------------------------------------------------------------
// RX Data
// ----------------------------------------------------------------------------
    .spi_rx_data                    (spi_rx_data[7:0]           ), // (output)
    .spi_rx_data_valid              (spi_rx_data_valid          ), // (output)
// ----------------------------------------------------------------------------
// SPI Port
// ----------------------------------------------------------------------------
    .spi_cs_n                       (spi_cs_n[7:0]              ), // (output)
    .spi_clk                        (flash_clk                  ), // (output)
    .spi_sdi                        (flash_miso                 ), // (input )
    .spi_sdo                        (flash_mosi                 ), // (output)
    .spi_sdo_en                     (                           )  // (output)
);

assign flash_hold_n = 1'b1; 
assign flash_cs_n = spi_cs_n[0];

endmodule



