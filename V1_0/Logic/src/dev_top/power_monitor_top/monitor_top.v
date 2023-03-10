`timescale  1ns/1ns
module monitor_top(
input			   		      sclk,//60MHZ
input			  		     rst_n,
input			     	        rx,
output				[95:0]		data_ov
);

wire                          [7:0] uart_rx_data                ; 
wire                                uart_rx_data_valid          ; 

wire                                fifo_empty                  ; 
wire                          [7:0] fifo_data                   ; 
wire                                fifo_rd_en                  ; 

uart_top #
(
    .U_DLY                          (1                          )  
)
u_uart_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (sclk                       ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------
// Config Port
//-----------------------------------------------------------------------------
    .baud_rate                      (16'd67                     ), // (input )
    .data_width                     (4'd8                       ), // (input )
    .check_en                       (1'b0                       ), // (input )
    .check_sel                      (1'b0                       ), // (input )
    .check_filter                   (1'b0                       ), // (input )
    .stop_bit                       (1'b0                       ), // (input )
// ----------------------------------------------------------------------------
// Send Data 
// ----------------------------------------------------------------------------
    .uart_tx_en                     (1'b0                       ), // (input )
    .uart_tx_data                   (8'd0                       ), // (input )
// ----------------------------------------------------------------------------
// Receive Data
// ----------------------------------------------------------------------------
    .uart_rx_data                   (uart_rx_data[7:0]          ), // (output)
    .uart_rx_data_valid             (uart_rx_data_valid         ), // (output)
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    .uart_rx                        (rx                         ), // (input )
    .uart_tx                        (/* not used */             )  // (output)
);

fifo_d1kw8_st	u_fifo_d1kw8_st
(
    .aclr                           (!rst_n                     ), 
    .clock                          (sclk                       ), 
    .wrreq                          (uart_rx_data_valid         ), 
    .data                           (uart_rx_data[7:0]          ), 
    .rdreq                          (fifo_rd_en                 ), 
    .q                              (fifo_data[7:0]             ), 
    .empty                          (fifo_empty                 ), 
    .full                           (                           ), 
    .usedw                          (/* not used */             )  
);

//--------
monitor_rx_ctrl  monitor_rx_ctrl_inst(
    .sclk                           (sclk                       ), 
    .rst_n                          (rst_n                      ), 
    .fifo_empty                     (fifo_empty                 ), 
    .fifo_data                      (fifo_data                  ), 
    .fifo_rd_en                     (fifo_rd_en                 ), 
    .data_ov                        (data_ov                    )  
);

endmodule
