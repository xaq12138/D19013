// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/09 13:51:52
// File Name    : lrmode_ctrl_wrapper.v
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
// pc_ch_sel_wrapper
//    |---
// 
`timescale 1ns/1ns

module lrmode_ctrl_wrapper #
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
// Mux PC data
// ----------------------------------------------------------------------------
    input                     [7:0] pc_tx_data                  , 
    input                           pc_tx_data_valid            , 

    output                    [7:0] pc_rx_data                  , 
    output                          pc_rx_data_valid            , 
// ----------------------------------------------------------------------------
// Key Data
// ----------------------------------------------------------------------------
    input                           key_status                  , 
    input                           key_valid                   , 
// ----------------------------------------------------------------------------
// PC Select
// ----------------------------------------------------------------------------
    output reg                      pc_ch_mode                    
);

wire                          [2:0] uart_rmrl_mode              ; 
wire                                uart_rmrl_valid             ; 

wire                          [2:0] udp_rmrl_mode               ; 
wire                                udp_rmrl_valid              ; 

reg                                 rm_route                    ; 
reg                                 test_mode                   ; 

pc_rm_deframe #
(
    .U_DLY                          (U_DLY                      )  
)
u0_pc_rm_deframe
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// PC data
// ----------------------------------------------------------------------------
    .pc_rx_data                     (pc_rmrx_data[7:0]          ), // (input )
    .pc_rx_data_valid               (pc_rmrx_data_valid         ), // (input )
// ----------------------------------------------------------------------------
// PC Remote/Local Select
// ----------------------------------------------------------------------------
    .pc_rmrl_mode                   (uart_rmrl_mode[2:0]        ), // (output)
    .pc_rmrl_valid                  (uart_rmrl_valid            )  // (output)
);

pc_rm_deframe #
(
    .U_DLY                          (U_DLY                      )  
)
u1_pc_rm_deframe
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// PC data
// ----------------------------------------------------------------------------
    .pc_rx_data                     (udp_rx_data[7:0]           ), // (input )
    .pc_rx_data_valid               (udp_rx_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// PC Remote/Local Select
// ----------------------------------------------------------------------------
    .pc_rmrl_mode                   (udp_rmrl_mode[2:0]         ), // (output)
    .pc_rmrl_valid                  (udp_rmrl_valid             )  // (output)
);

pc_ch_sel #
(
    .U_DLY                          (U_DLY                      )  
)
u_pc_ch_sel
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
    .pc_lctx_data                   (pc_lctx_data[7:0]          ), // (output
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
// PC Remote/Local Select
// ----------------------------------------------------------------------------
    .test_mode                      (test_mode                  ), // (input )
    .rm_route                       (rm_route                   ), // (input )
    .pc_ch_mode                     (pc_ch_mode                 )  // (input )
);

// ============================================================================
// PC remote/local select
// pc_ch_mode
//      1'b0 --> remote   
//      1'b1 --> local
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_ch_mode <= #U_DLY 1'b0;
    else
        pc_ch_mode <= #U_DLY ~key_status;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rm_route <= #U_DLY 1'b0;
    else
        rm_route <= #U_DLY 1'b0;
       // begin
       //     if(uart_rmrl_valid == 1'b1)
       //         rm_route <= #U_DLY uart_rmrl_mode[1];
       //     else if(udp_rmrl_valid == 1'b1)
       //         rm_route <= #U_DLY udp_rmrl_mode[1];
       //     else
       //         ;
       // end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        test_mode <= #U_DLY 1'b0;
    else
        test_mode <= #U_DLY 1'b0;
       // begin
       //     if(uart_rmrl_valid == 1'b1)
       //         test_mode <= #U_DLY uart_rmrl_mode[2];
       //     else if(udp_rmrl_valid == 1'b1)
       //         test_mode <= #U_DLY udp_rmrl_mode[2];
       //     else
       //         ;
       // end
end    

endmodule
