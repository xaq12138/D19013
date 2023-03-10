// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:32:50
// File Name    : pc_tx_wrapper.v
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

module pc_tx_wrapper  #
(
    parameter                       U_DLY = 1                   ,
    parameter                       SAMPLE_DATA = 32'd99_9999    
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
    input                    [15:0] cfg_ins_length              , 
    input                    [31:0] cfg_status_waittime         , 
// ----------------------------------------------------------------------------
// Monitor Data
// ----------------------------------------------------------------------------
    input                     [7:0] debug_lr_sel                , 
    input                    [31:0] debug_port_status           , 
    input                    [31:0] debug_power_current         , 
    input                    [31:0] debug_power_voltage         , 
    input                    [31:0] debug_power_data            , 
    input                    [63:0] debug_local_time            , 
// ----------------------------------------------------------------------------
// Instruct Sign
// ----------------------------------------------------------------------------
    input                    [15:0] rm_inst                     , 
    input                           rm_inst_valid               , 

    input                    [15:0] lc_inst                     , 
    input                           lc_inst_valid               , 
// ----------------------------------------------------------------------------
// TX Instruct Data
// dfifo_rd_data[575:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    input                   [575:0] txins_data                  , 
    input                           txins_data_valid            , 
// ----------------------------------------------------------------------------
// SLR RX Instruct Data
// dfifo_rd_data[575:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    input                   [575:0] rxins_data                  , 
    input                           rxins_data_valid            , 
// ----------------------------------------------------------------------------
// SLR Config Data
// ----------------------------------------------------------------------------
    input                     [7:0] slr_rd_data                 , 
    input                           slr_rd_data_valid           , 
// ----------------------------------------------------------------------------
// Up Convert Config Data
// ----------------------------------------------------------------------------
    input                     [7:0] upcovert_rd_data            , 
    input                           upcovert_rd_data_valid      , 
// ----------------------------------------------------------------------------
// Read Instruct Data
//
// instruct_rd_data[511:0]      : instruct data
// ----------------------------------------------------------------------------
    input                    [15:0] inst_resp_data              , 
    input                           inst_resp_data_valid        , 

    input                   [511:0] memins_data                 , 
    input                           memins_data_valid           , 
// ----------------------------------------------------------------------------
// Internal Config Data
// ----------------------------------------------------------------------------
    input                    [15:0] inter_cfg_addr              , 
    input                    [31:0] inter_cfg_rd_data           , 
    input                           inter_cfg_rd_data_valid     , 
// ----------------------------------------------------------------------------
// Responce Pakadge Infomation
// ----------------------------------------------------------------------------
    input                    [19:0] resp_info                   , 
    input                           resp_info_valid             , 
// ----------------------------------------------------------------------------
// Pakadge Source
// ----------------------------------------------------------------------------
    output                    [7:0] pc_tx_data                  , 
    output                          pc_tx_data_valid              
);

wire                                resp_ififo_rd_en            ; 
wire                         [19:0] resp_ififo_rd_data          ; 
wire                                resp_ififo_empty            ; 

wire                                resp_wr_req                 ; 
wire                                resp_wr_ack                 ; 
wire                                resp_wr_done                ; 
wire                                resp_wr_en                  ; 
wire                          [7:0] resp_wr_data                ; 

wire                                txins_fifo_rd_en            ; 
wire                        [575:0] txins_fifo_rd_data          ; 
wire                          [3:0] txins_fifo_empty            ; 

wire                                rxins_fifo_rd_en            ; 
wire                        [575:0] rxins_fifo_rd_data          ; 
wire                          [3:0] rxins_fifo_empty            ; 

wire                                key_fifo_wr_en              ; 
wire                                inst_src                    ; 
wire                         [15:0] key_fifo_inst               ; 

wire                                key_fifo_rd_en              ; 
wire                         [80:0] key_fifo_rd_data            ; 
wire                                key_fifo_empty              ; 

wire                                ins_wr_req                  ; 
wire                                ins_wr_ack                  ; 
wire                                ins_wr_done                 ; 
wire                                ins_wr_en                   ; 
wire                          [7:0] ins_wr_data                 ; 

wire                                status_wr_req               ; 
wire                                status_wr_ack               ; 
wire                                status_wr_done              ; 
wire                                status_wr_en                ; 
wire                          [7:0] status_wr_data              ; 

wire                                slr_fifo_rd_en              ; 
wire                          [7:0] slr_fifo_rd_data            ; 
wire                                slr_fifo_pfull              ; 

wire                                upc_fifo_rd_en              ; 
wire                          [7:0] upc_fifo_rd_data            ; 
wire                                upc_fifo_pfull              ; 

wire                                inter_fifo_rd_en            ; 
wire                         [47:0] inter_fifo_rd_data          ; 
wire                                inter_fifo_empty            ; 

wire                                inst_ififo_rd_en            ; 
wire                         [15:0] inst_ififo_rd_data          ; 

wire                                inst_dfifo_rd_en            ; 
wire                        [511:0] inst_dfifo_rd_data          ; 
wire                          [1:0] inst_dfifo_empty            ; 

wire                                cfg_wr_req                  ; 
wire                                cfg_wr_ack                  ; 
wire                                cfg_wr_done                 ; 
wire                                cfg_wr_en                   ; 
wire                          [7:0] cfg_wr_data                 ; 

wire                          [3:0] pkg_wr_req                  ; 
wire                          [3:0] pkg_wr_ack                  ; 
wire                          [3:0] pkg_wr_done                 ; 
wire                          [3:0] pkg_wr_en                   ; 
wire                         [31:0] pkg_wr_data                 ; 

genvar                              i                           ;

fifo_d256w20_st	u_fifo_d256w20_st
(
    .clock                          (clk_sys                    ), 
    .aclr                           (!rst_n                     ), 
    .wrreq                          (resp_info_valid            ), 
    .data                           (resp_info[19:0]            ), 
    .rdreq                          (resp_ififo_rd_en           ), 
    .q                              (resp_ififo_rd_data[19:0]   ), 
    .empty                          (resp_ififo_empty           ), 
    .full                           (/* not used */             )  
);

pc_tx_resp #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_tx_resp
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Info & Data FIFO Read Pot
// ----------------------------------------------------------------------------
    .ififo_rd_en                    (resp_ififo_rd_en           ), // (output)
    .ififo_rd_data                  (resp_ififo_rd_data[19:0]   ), // (input )
    .ififo_empty                    (resp_ififo_empty           ), // (input )
// ----------------------------------------------------------------------------
// Response Pakadge Frame
// ----------------------------------------------------------------------------
    .resp_wr_req                    (resp_wr_req                ), // (output)
    .resp_wr_ack                    (resp_wr_ack                ), // (input )
    .resp_wr_done                   (resp_wr_done               ), // (output)

    .resp_wr_en                     (resp_wr_en                 ), // (output)
    .resp_wr_data                   (resp_wr_data[7:0]          )  // (output)
);

generate
for(i=0;i<4;i=i+1)
begin:txins_fifo_loop

fifo_d128w144_fwft	u0_fifo_d128w144_fwft
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (txins_data_valid           ), 
    .data                           (txins_data[i*144+:144]     ), 
    .rdreq                          (txins_fifo_rd_en           ), 
    .q                              (txins_fifo_rd_data[i*144+:144]), 
    .empty                          (txins_fifo_empty[i]        ), 
    .full                           (/* not used */             )  
);   

end
endgenerate

generate
for(i=0;i<4;i=i+1)
begin:rxins_fifo_loop

fifo_d128w144_fwft	u1_fifo_d128w144_fwft
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (rxins_data_valid           ), 
    .data                           (rxins_data[i*144+:144]     ), 
    .rdreq                          (rxins_fifo_rd_en           ), 
    .q                              (rxins_fifo_rd_data[i*144+:144]), 
    .empty                          (rxins_fifo_empty[i]        ), 
    .full                           (/* not used */             )  
);   

end
endgenerate

assign key_fifo_wr_en = rm_inst_valid | lc_inst_valid;
assign key_fifo_inst = (rm_inst_valid == 1'b1) ? rm_inst : lc_inst;
assign inst_src = (lc_inst_valid == 1'b1) ? 1'b1:1'b0;

fifo_d128w81_fwft u_fifo_d128w81_fwft 
(
    .clock                          (clk_sys                    ), 
    .aclr                           (!rst_n                     ), 
    .wrreq                          (key_fifo_wr_en             ), 
    .data                           ({inst_src,debug_local_time,key_fifo_inst}), 
    .rdreq                          (key_fifo_rd_en             ), 
    .q                              (key_fifo_rd_data[80:0]     ), 
    .empty                          (key_fifo_empty             ), 
    .full                           (/* not used */             )  
);

pc_tx_ins#
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_tx_ins
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// TX Instruct Data
// dfifo_rd_data[575:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    .txins_fifo_rd_en               (txins_fifo_rd_en           ), // (output)
    .txins_fifo_rd_data             (txins_fifo_rd_data[575:0]  ), // (input )
    .txins_fifo_empty               (txins_fifo_empty[0]        ), // (input )
// ----------------------------------------------------------------------------
// RX Instruct Data
// dfifo_rd_data[575:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    .rxins_fifo_rd_en               (rxins_fifo_rd_en           ), // (output)
    .rxins_fifo_rd_data             (rxins_fifo_rd_data[575:0]  ), // (input )
    .rxins_fifo_empty               (rxins_fifo_empty[0]        ), // (input )
// ----------------------------------------------------------------------------
// Key Data
// key_fifo_rd_data[79:16] : (8byte) time
// key_fifo_rd_data[15:0]  : (2byte) key data
// ----------------------------------------------------------------------------
    .key_fifo_rd_en                 (key_fifo_rd_en             ), // (output)
    .key_fifo_rd_data               (key_fifo_rd_data[80:0]     ), // (input )
    .key_fifo_empty                 (key_fifo_empty             ), // (input )
// ----------------------------------------------------------------------------
// Config Register Data
// ----------------------------------------------------------------------------
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (input )
// ----------------------------------------------------------------------------
// Instruct Pakadge Frame
// ----------------------------------------------------------------------------
    .ins_wr_req                     (ins_wr_req                 ), // (output)
    .ins_wr_ack                     (ins_wr_ack                 ), // (input )
    .ins_wr_done                    (ins_wr_done                ), // (output)

    .ins_wr_en                      (ins_wr_en                  ), // (output)
    .ins_wr_data                    (ins_wr_data[7:0]           )  // (output)
);

pc_tx_status#
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_tx_status
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .cfg_status_waittime            (cfg_status_waittime[31:0]  ), // (input )
// ----------------------------------------------------------------------------
// Monitor Data
// ----------------------------------------------------------------------------
    .debug_lr_sel                   (debug_lr_sel[7:0]          ), // (input )
    .debug_port_status              (debug_port_status[31:0]    ), // (input )
    .debug_power_current            (debug_power_current[31:0]  ), // (input )
    .debug_power_voltage            (debug_power_voltage[31:0]  ), // (input )
    .debug_power_data               (debug_power_data[31:0]     ), // (input )
    .debug_local_time               (debug_local_time[63:0]     ), // (input )
// ----------------------------------------------------------------------------
// Debug Pakadge Frame
// ----------------------------------------------------------------------------
    .status_wr_req                  (status_wr_req              ), // (output)
    .status_wr_ack                  (status_wr_ack              ), // (input )
    .status_wr_done                 (status_wr_done             ), // (output)

    .status_wr_en                   (status_wr_en               ), // (output)
    .status_wr_data                 (status_wr_data[7:0]        )  // (output)
);

fifo_d1kw8_fwft	u0_fifo_d1kw8_fwft 
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (slr_rd_data_valid          ), 
    .data                           (slr_rd_data[7:0]           ), 
    .rdreq                          (slr_fifo_rd_en             ), 
    .q                              (slr_fifo_rd_data[7:0]      ), 
    .almost_full                    (slr_fifo_pfull             ), 
    .empty                          (/* not used */             ), 
    .full                           (/* not used */             )  
);

fifo_d1kw8_fwft	u1_fifo_d1kw8_fwft 
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (upcovert_rd_data_valid     ), 
    .data                           (upcovert_rd_data[7:0]      ), 
    .rdreq                          (upc_fifo_rd_en             ), 
    .q                              (upc_fifo_rd_data[7:0]      ), 
    .almost_full                    (upc_fifo_pfull             ), 
    .empty                          (/* not used */             ), 
    .full                           (/* not used */             )  
);

fifo_d256w48_fwft u_fifo_d256w48_fwft
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (inter_cfg_rd_data_valid    ), 
    .data                           ({inter_cfg_addr,inter_cfg_rd_data}), 
    .rdreq                          (inter_fifo_rd_en           ), 
    .q                              (inter_fifo_rd_data[47:0]   ), 
    .empty                          (inter_fifo_empty           ), 
    .full                           (/* not used */             )  
);

fifo_d512w16_fwft u_fifo_d512w16_fwft
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (inst_resp_data_valid       ), 
    .data                           (inst_resp_data[15:0]       ), 
    .rdreq                          (inst_ififo_rd_en           ), 
    .q                              (inst_ififo_rd_data[15:0]   ), 
    .empty                          (/* not used */             ), 
    .full                           (/* not used */             )  
);

generate
for(i=0;i<2;i=i+1)
begin:memins_fifo_loop

fifo_d128w256_fwft u_fifo_d128w256_fwft
(
    .aclr                           (!rst_n                     ), 
    .clock                          (clk_sys                    ), 
    .wrreq                          (memins_data_valid          ), 
    .data                           (memins_data[i*256+:256]    ), 
    .rdreq                          (inst_dfifo_rd_en           ), 
    .q                              (inst_dfifo_rd_data[i*256+:256]), 
    .empty                          (inst_dfifo_empty[i]        ), 
    .full                           (/* not used */             )  
);

end
endgenerate

pc_tx_cfg #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_tx_cfg
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// SLR Config Data FIFO Read (FWFT FIFO)
//
// Determine whether there is a frame of data in FIFO according to the PFULL signal.
// The PFULL threshold value is the frame length.
// ----------------------------------------------------------------------------
    .slr_fifo_rd_en                 (slr_fifo_rd_en             ), // (output)
    .slr_fifo_rd_data               (slr_fifo_rd_data[7:0]      ), // (input )
    .slr_fifo_pfull                 (slr_fifo_pfull             ), // (input )
// ----------------------------------------------------------------------------
// Up Convert Config Data FIFO Read (FWFT FIFO)
//
// Determine whether there is a frame of data in FIFO according to the PFULL signal.
// The PFULL threshold value is the frame length.
// ----------------------------------------------------------------------------
    .upc_fifo_rd_en                 (upc_fifo_rd_en             ), // (output)
    .upc_fifo_rd_data               (upc_fifo_rd_data[7:0]      ), // (input )
    .upc_fifo_pfull                 (upc_fifo_pfull             ), // (input )
// ----------------------------------------------------------------------------
// Internal Config Data FIFO Read (FWFT FIFO)
// ----------------------------------------------------------------------------
    .inter_fifo_rd_en               (inter_fifo_rd_en           ), // (output)
    .inter_fifo_rd_data             (inter_fifo_rd_data[47:0]   ), // (input )
    .inter_fifo_empty               (inter_fifo_empty           ), // (input )
// ----------------------------------------------------------------------------
// Instruct Data FIFO Read (FWFT FIFO)
// ----------------------------------------------------------------------------
    .inst_ififo_rd_en               (inst_ififo_rd_en           ), // (output)
    .inst_ififo_rd_data             (inst_ififo_rd_data[15:0]   ), // (input )

    .inst_dfifo_rd_en               (inst_dfifo_rd_en           ), // (output)
    .inst_dfifo_rd_data             (inst_dfifo_rd_data[511:0]  ), // (input )
    .inst_dfifo_empty               (inst_dfifo_empty           ), // (input )
// ----------------------------------------------------------------------------
// Config Register Data
// ----------------------------------------------------------------------------
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (input )
// ----------------------------------------------------------------------------
// Response Pakadge Frame
// ----------------------------------------------------------------------------
    .cfg_wr_req                     (cfg_wr_req                 ), // (output)
    .cfg_wr_ack                     (cfg_wr_ack                 ), // (input )
    .cfg_wr_done                    (cfg_wr_done                ), // (output)

    .cfg_wr_en                      (cfg_wr_en                  ), // (output)
    .cfg_wr_data                    (cfg_wr_data[7:0]           )  // (output)
);

assign pkg_wr_req = {cfg_wr_req,status_wr_req,ins_wr_req,resp_wr_req};
assign pkg_wr_done = {cfg_wr_done,status_wr_done,ins_wr_done,resp_wr_done};
assign pkg_wr_en = {cfg_wr_en,status_wr_en,ins_wr_en,resp_wr_en};
assign pkg_wr_data = {cfg_wr_data,status_wr_data,ins_wr_data,resp_wr_data};

pc_tx_frame #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_tx_frame
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Pakadge Source
// ----------------------------------------------------------------------------
    .pkg_wr_req                     (pkg_wr_req[3:0]            ), // (input )
    .pkg_wr_ack                     (pkg_wr_ack[3:0]            ), // (output)
    .pkg_wr_done                    (pkg_wr_done[3:0]           ), // (input )

    .pkg_wr_en                      (pkg_wr_en[3:0]             ), // (input )
    .pkg_wr_data                    (pkg_wr_data[31:0]          ), // (input )
// ----------------------------------------------------------------------------
// Pakadge Source
// ----------------------------------------------------------------------------
    .pc_tx_data                     (pc_tx_data[7:0]            ), // (output)
    .pc_tx_data_valid               (pc_tx_data_valid           )  // (output)
);

assign cfg_wr_ack = pkg_wr_ack[3];
assign status_wr_ack = pkg_wr_ack[2];
assign ins_wr_ack = pkg_wr_ack[1];
assign resp_wr_ack = pkg_wr_ack[0];

endmodule



