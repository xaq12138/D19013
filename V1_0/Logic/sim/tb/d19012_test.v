// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/18 21:40:23
// File Name    : d19012_test.v
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
// d19012_test
//    |---
// 
`timescale 1ns/1ps

module d19012_test;

wire                                clk_sys                     ; 

reg                           [5:0] uart_rx                     ; 
wire                          [3:0] uart_tx                     ; 

reg                         [207:0] mem_data                    ; 
reg                           [7:0] j                           ; 

reg                        [2047:0] pkg_data                    ; 

wire                                spi_csn                     ; 
wire                                spi_sck                     ; 
wire                                spi_sdi                     ; 
wire                                spi_sdo                     ; 

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

d19012_sec_ctrl_top # 
(
    .U_DLY                          (1                          ), 
    .FPGA_VER                       (32'h0000_0010              ), 
    .STATUS_SAMPLE_DATA             (32'h0000_ffff              )  
)
u_d19012_sec_ctrl_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    .uart_rx                        (uart_rx[5:0]               ), // (input )
    .uart_tx                        (uart_tx[3:0]               ), // (output)
// ----------------------------------------------------------------------------
// IRIG-B
// ----------------------------------------------------------------------------
    .irigb_rx                       (1'b0                       ), // (input )
// ----------------------------------------------------------------------------
// Power Monitor 
// ----------------------------------------------------------------------------
    .pwr_sw_sel                     (1'b0                       ), // (input )
// ----------------------------------------------------------------------------
// Key
// ----------------------------------------------------------------------------
    .key_in                         (16'd0                      ), // (input )
// ----------------------------------------------------------------------------
// Flash
// ----------------------------------------------------------------------------
    .flash_holdn                    (                           ), // (output)
    .flash_csn                      (spi_csn                    ), // (output)
    .flash_sck                      (spi_sck                    ), // (output)
    .flash_si                       (spi_sdi                    ), // (output)
    .flash_so                       (spi_sdo                    ), // (input )
// ----------------------------------------------------------------------------
// AD9785
// ---------------------------------------------------------------------------- 
    .ad9785_dclk                    (1'b0                       ), // (input )

    .ad9785_rst                     (                           ), // (output)
    .ad9785_sdio                    (                           ), // (output)
    .ad9785_sclk                    (                           ), // (output)
    .ad9785_csn                     (                           ), // (output)
    .ad9785_if_txen                 (                           ), // (output)

    .ad_si_data                     (                           ), // (output)
    .ad_sq_data                     (                           ), // (output)
// ----------------------------------------------------------------------------
// Debug
// ---------------------------------------------------------------------------- 
    .debug_led                      (                           )  // (output)
);

sim_falsh_top u_sim_falsh_top
(
67
// Clock Source
// ----------------------------------------------------------------------------
    .spi_csn                        (spi_csn                    ), // (input )
    .spi_sck                        (spi_sck                    ), // (input )
    .spi_sdi                        (spi_sdi                    ), // (input )
    .spi_sdo                        (spi_sdo                    )  // (output)
);

initial
begin
    uart_rx = 6'h3f;
    pkg_data = 2048'd0;

    if(u_d19012_sec_ctrl_top.rst_n == 1'b0)
        @(posedge u_d19012_sec_ctrl_top.rst_n);
    
    pkg_data = 'h0010_00000005_BA019AD9;
    test_pkg_gen(16'h0002,32'h0000_0016,16'h0005);

    pkg_data = 'h0012_00000009_1D17CEA7;
    test_pkg_gen(16'h0002,32'h0000_0016,16'h0005);

    pkg_data = 'h0013_000493DA_AF966A5E;
    test_pkg_gen(16'h0002,32'h0000_0016,16'h0005);

    pkg_data = 'h0050_0000FFFF_54469691;
    test_pkg_gen(16'h0002,32'h0000_0016,16'h0005);

    pkg_data = 'h0000_0000_0000_FFFFFFEB90C6D872FF_B1E87563;
    test_pkg_gen(16'h0002,32'h0000_001f,16'h0007);

    pkg_data = 'h0011_00000001_E0088B88;
    test_pkg_gen(16'h0002,32'h0000_0016,16'h0005);

    pkg_data = 'h0000_0000_0000_6C6B73D9;
    test_pkg_gen(16'h0001,32'h0000_0012,16'h0000);

    pkg_data = 'h0000_B496FF52;
    test_pkg_gen(16'h0003,32'h0000_0012,16'h000a);
end

task test_pkg_gen;
    input [15:0] pkg_type;
    input [31:0] pkg_length;
    input [15:0] opt_type;

    integer     i       ;
begin
    uart_tx_gen(1,115200,8'hef);
    uart_tx_gen(1,115200,8'h91);
    uart_tx_gen(1,115200,8'h19);
    uart_tx_gen(1,115200,8'hfe);

    uart_tx_gen(1,115200,pkg_type[1*8+:8]);
    uart_tx_gen(1,115200,pkg_type[0*8+:8]);

    uart_tx_gen(1,115200,pkg_length[3*8+:8]);
    uart_tx_gen(1,115200,pkg_length[2*8+:8]);
    uart_tx_gen(1,115200,pkg_length[1*8+:8]);
    uart_tx_gen(1,115200,pkg_length[0*8+:8]);

    repeat(4)
        uart_tx_gen(1,115200,8'h00);
    if(pkg_type != 16'h8002)
    begin
        uart_tx_gen(1,115200,opt_type[1*8+:8]);
        uart_tx_gen(1,115200,opt_type[0*8+:8]);
    end
    
    for(i=0;i<(pkg_length-16+4);i=i+1)
        uart_tx_gen(1,115200,pkg_data[(pkg_length-13-i)*8+:8]);
end
endtask

task uart_tx_gen;
    input       uart_ch;
    input   integer baud_rate;
    input   [7:0] tx_data;

    integer       baud_time;
    integer       i     ;

reg                                 sum_data                    ; 

    begin

    baud_time = 1000000000/baud_rate;
    i = 0;
    sum_data = 0;
    uart_rx[uart_ch] = 0;
    #baud_time;

    for(i=0;i<8;i=i+1)
    begin
        uart_rx[uart_ch] = tx_data[i];
        sum_data = sum_data ^ uart_rx[uart_ch];
        #baud_time;
    end

    uart_rx[uart_ch] = sum_data;
    #baud_time;

    uart_rx[uart_ch] = 1'b1;
    #baud_time;

    end

endtask

endmodule




