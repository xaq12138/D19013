// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/14 21:37:41
// File Name    : uart_top_test.v
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
// uart_top_test
//    |---
// 
`timescale 1ns/1ps

module uart_top_test ;

wire                                clk_sys                     ; 
reg                                 rst_n                       ; 

reg                                 uart_tx_en                  ; 
reg                           [7:0] uart_tx_data                ; 

wire                                uart_rx                     ; 

sim_clk_mdl #
(
    .CLK_PERIOD                     (16.667                     )  
)
u_sim_clk_mdl
(
// ----------------------------------------------------------------------------
// Clock Source
// ----------------------------------------------------------------------------
    .clk_p                          (clk_sys                    ), // (output)
    .clk_n                          (                           )  // (output)
);

uart_top #
(
    .U_DLY                          (1                          )  
)
u_uart_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------
// Config Port
//-----------------------------------------------------------------------------
    .baud_rate                      (16'd64                     ), // (input )
    .data_width                     (4'd8                       ), // (input )
    .check_en                       (1'b1                       ), // (input )
    .check_sel                      (1'b1                       ), // (input )
    .check_filter                   (1'b1                       ), // (input )
    .stop_bit                       (1'b0                       ), // (input )
// ----------------------------------------------------------------------------
// Send Data 
// ----------------------------------------------------------------------------
    .uart_tx_en                     (uart_tx_en                 ), // (input )
    .uart_tx_data                   (uart_tx_data[7:0]          ), // (input )
// ----------------------------------------------------------------------------
// Receive Data
// ----------------------------------------------------------------------------
    .uart_rx_data                   (                           ), // (output)
    .uart_rx_data_valid             (                           ), // (output)
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    .uart_rx                        (uart_rx                    ), // (input )
    .uart_tx                        (uart_rx                    )  // (output)
);


initial
begin

    rst_n = 0;
    uart_tx_en = 0;
    uart_tx_data = 0;

    #500;

    rst_n = 1;

    repeat(5)
    begin
        @(posedge clk_sys);
        uart_tx_data =$random()%256;
        uart_tx_en = 1'b1;
        @(posedge clk_sys);
        uart_tx_en = 1'b0;
        repeat(15)
            @(posedge clk_sys);
    end

end

endmodule




