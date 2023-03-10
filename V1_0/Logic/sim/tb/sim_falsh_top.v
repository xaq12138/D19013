// +FHDR============================================================================/
// Author       : guo
// Creat Time   : 2020/07/24 11:04:24
// File Name    : sim_falsh_top.v
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
// sim_falsh_top
//    |---
// 
`timescale 1ns/1ps

module sim_falsh_top 
(
// ----------------------------------------------------------------------------
// Clock Source
// ----------------------------------------------------------------------------
    input                           spi_csn                     , 
    input                           spi_sck                     , 
    input                           spi_sdi                     , 
    output reg                      spi_sdo                       
);

reg                           [7:0] mem_ban0 [65535:0]          ; 
reg                           [7:0] mem_ban1 [65535:0]          ; 
reg                           [7:0] mem_ban2 [65535:0]          ; 
reg                           [7:0] mem_ban3 [65535:0]          ; 

reg                           [7:0] cmd                         ; 
reg                           [1:0] bank                        ; 
reg                          [15:0] addr                        ; 

localparam IDLE  = 4'd0;
localparam START = 4'd1; 
localparam CMD   = 4'd2; 
localparam WRITE = 4'd3; 
localparam READ  = 4'd1; 
localparam END   = 4'd1; 

reg [3:0]  state;

initial
begin
    spi_sdo = 0;
    cmd = 0;
    bank = 0;
    addr = 0;
    state = 0;
end



always @ (*)
begin
    if(spi_csn == 1'b0)
        FLASH_WRRD();
end

task SPI_RX_BYTE;
output [7:0]rx_data;

integer         i;
begin
    i=7;
    rx_data = 0;
    if(spi_csn == 1'b0)
    begin
        repeat(8)
        begin
            @(posedge spi_sck);
            rx_data[i] = spi_sdi;
            i=i-1;
        end
    end
end
endtask

task SPI_TX_BYTE;
input [7:0] tx_data;

integer     i;
begin
    i=7;
    if(spi_csn == 1'b0)
    begin
        repeat(8)
        begin
            @(negedge spi_sck);
            spi_sdo = tx_data[i];
            i=i-1;
        end
    end
end
endtask

task FLASH_WRRD;
reg [7:0] rx_data;
reg [7:0] tx_data;
reg [15:0] addr_cnt;
begin
    SPI_RX_BYTE(rx_data);
    if(rx_data == 8'h06)
    begin
        SPI_RX_BYTE(rx_data);
        cmd = rx_data;
    end
    else
        cmd = rx_data;

    SPI_RX_BYTE(rx_data);
    bank[1:0] = rx_data[1:0];
    SPI_RX_BYTE(rx_data);
    addr[15:8] = rx_data;
    SPI_RX_BYTE(rx_data);
    addr[7:0] = rx_data;

    while((cmd == 8'h02) && (spi_csn == 1'b0))
    begin
        addr_cnt = addr;
        SPI_RX_BYTE(rx_data);

        case(bank)
            3'd0    : mem_ban0[addr_cnt] = rx_data;
            3'd1    : mem_ban1[addr_cnt] = rx_data;
            3'd2    : mem_ban2[addr_cnt] = rx_data;
            3'd3    : mem_ban3[addr_cnt] = rx_data;
            default : ;
        endcase

        addr_cnt = addr_cnt + 1;
    end

    while((cmd == 8'h03) && (spi_csn == 1'b0))
    begin
        addr_cnt = addr;

        case(bank)
            3'd0    : tx_data = mem_ban0[addr_cnt];
            3'd1    : tx_data = mem_ban1[addr_cnt];
            3'd2    : tx_data = mem_ban2[addr_cnt];
            3'd3    : tx_data = mem_ban3[addr_cnt];
            default : ;
        endcase

        SPI_TX_BYTE(tx_data);
        
        addr_cnt = addr_cnt + 1;
    end
end
endtask

endmodule




