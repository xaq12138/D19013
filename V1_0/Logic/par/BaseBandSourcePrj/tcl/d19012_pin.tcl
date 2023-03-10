###########################################################################
# CLOCK
###########################################################################
set_location_assignment PIN_N9  -to clk_sys; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to clk_sys;

###########################################################################
# UART
###########################################################################
set_location_assignment PIN_R6  -to uart_rx[0]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rx[0];# RS422_RXD2_3V3
set_location_assignment PIN_V6  -to uart_rx[1]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rx[1];# RS422_RXD1_3V3
set_location_assignment PIN_M8  -to uart_rx[2]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rx[2];# RS422_RXD3_3V3
set_location_assignment PIN_U6  -to uart_rx[3]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rx[3];# RS422_RXD5_3V3  
set_location_assignment PIN_N8  -to uart_rx[4]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rx[4];# RS422_RXD9_3V3      
set_location_assignment PIN_P7  -to uart_rx[5]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rx[5];# RS422_RXD4_3V3  
                                                
set_location_assignment PIN_L7  -to uart_tx[0]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_tx[0];# RS422_TXD2_3V3
set_location_assignment PIN_L8  -to uart_tx[1]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_tx[1];# RS422_TXD1_3V3
set_location_assignment PIN_k9  -to uart_tx[2]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_tx[2];# RS422_TXD3_3V3
set_location_assignment PIN_H8  -to uart_tx[3]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_tx[3];# RS422_TXD5_3V3
                                                
###########################################################################
# IRIG-B
###########################################################################
set_location_assignment PIN_R5   -to irigb_rx; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to irigb_rx;

###########################################################################
# POWER STATUS
###########################################################################
set_location_assignment PIN_A14  -to pwr_sw_sel; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to pwr_sw_sel;

###########################################################################
# KEY
###########################################################################
set_location_assignment PIN_A12  -to key_in[0];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[0];
set_location_assignment PIN_C11  -to key_in[1];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[1];
set_location_assignment PIN_D12  -to key_in[2];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[2];
set_location_assignment PIN_C16  -to key_in[3];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[3];
set_location_assignment PIN_A9   -to key_in[4];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[4];
set_location_assignment PIN_A15  -to key_in[5];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[5];
set_location_assignment PIN_B10  -to key_in[6];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[6];
set_location_assignment PIN_D9   -to key_in[7];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[7];
set_location_assignment PIN_B7   -to key_in[8];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[8]; 
set_location_assignment PIN_A7   -to key_in[9];  set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[9];
set_location_assignment PIN_B13  -to key_in[10]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[10];
set_location_assignment PIN_B20  -to key_in[11]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[11];
set_location_assignment PIN_C15  -to key_in[12]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[12];
set_location_assignment PIN_B18  -to key_in[13]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[13];
set_location_assignment PIN_C13  -to key_in[14]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to key_in[14];
#set_location_assignment PIN_A14  -to key_in[15];

###########################################################################
# FLASH
###########################################################################
set_location_assignment PIN_E9   -to flash_holdn;   set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to flash_holdn;
set_location_assignment PIN_F9   -to flash_csn;     set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to flash_csn;
set_location_assignment PIN_E16  -to flash_sck;     set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to flash_sck;
set_location_assignment PIN_D13  -to flash_si;      set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to flash_si;
set_location_assignment PIN_H9   -to flash_so;      set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to flash_so;

###########################################################################
# AD9785
###########################################################################
set_location_assignment PIN_G10  -to ad9785_dclk;    set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad9785_dclk;
set_location_assignment PIN_AA22 -to ad9785_rst;     set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad9785_rst;
set_location_assignment PIN_AB20 -to ad9785_sdio;    set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad9785_sdio;
set_location_assignment PIN_Y21  -to ad9785_sclk;    set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad9785_sclk;
set_location_assignment PIN_AB21 -to ad9785_csn;     set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad9785_csn;
set_location_assignment PIN_Y22  -to ad9785_if_txen; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad9785_if_txen;

set_location_assignment PIN_V16  -to ad_si_data[0]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[0];
set_location_assignment PIN_Y15  -to ad_si_data[1]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[1];
set_location_assignment PIN_Y14  -to ad_si_data[2]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[2];
set_location_assignment PIN_V13  -to ad_si_data[3]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[3];
set_location_assignment PIN_T12  -to ad_si_data[4]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[4];
set_location_assignment PIN_U8   -to ad_si_data[5]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[5];
set_location_assignment PIN_R9   -to ad_si_data[6]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[6];
set_location_assignment PIN_U10  -to ad_si_data[7]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[7];
set_location_assignment PIN_U11  -to ad_si_data[8]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[8]; 
set_location_assignment PIN_U12  -to ad_si_data[9]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[9];
set_location_assignment PIN_P12  -to ad_si_data[10]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[10];
set_location_assignment PIN_R12  -to ad_si_data[11]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_si_data[11];
                                                    
set_location_assignment PIN_Y16 -to ad_sq_data[0]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[0];
set_location_assignment PIN_AA15 -to ad_sq_data[1]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[1];
set_location_assignment PIN_AB15 -to ad_sq_data[2]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[2];
set_location_assignment PIN_AB12 -to ad_sq_data[3]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[3];
set_location_assignment PIN_AA14 -to ad_sq_data[4]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[4];
set_location_assignment PIN_AA10 -to ad_sq_data[5]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[5];
set_location_assignment PIN_AB13 -to ad_sq_data[6]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[6];
set_location_assignment PIN_Y10  -to ad_sq_data[7]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[7];
set_location_assignment PIN_Y9   -to ad_sq_data[8]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[8];
set_location_assignment PIN_AA9  -to ad_sq_data[9]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[9];
set_location_assignment PIN_AA13 -to ad_sq_data[10]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[10];
set_location_assignment PIN_AA8  -to ad_sq_data[11]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to ad_sq_data[11];

###########################################################################
# 88E1111
###########################################################################
set_location_assignment PIN_T20 -to phy_rst;         set_instance_assignment -name IO_STANDARD "2.5-V" -to phy_rst;         
set_location_assignment PIN_L18 -to phy_col;         set_instance_assignment -name IO_STANDARD "2.5-V" -to phy_col;         
set_location_assignment PIN_M16 -to phy_link1000;    set_instance_assignment -name IO_STANDARD "2.5-V" -to phy_link1000;    
set_location_assignment PIN_N16 -to phy_link100;     set_instance_assignment -name IO_STANDARD "2.5-V" -to phy_link100;     
set_location_assignment PIN_N19 -to rgmii_rxclk;     set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_rxclk;     
set_location_assignment PIN_M22 -to rgmii_rxdv;      set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_rxdv;      
set_location_assignment PIN_N20 -to rgmii_rxdata[0]; set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_rxdata[0]; 
set_location_assignment PIN_P22 -to rgmii_rxdata[1]; set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_rxdata[1]; 
set_location_assignment PIN_N21 -to rgmii_rxdata[2]; set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_rxdata[2]; 
set_location_assignment PIN_K22 -to rgmii_rxdata[3]; set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_rxdata[3]; 
set_location_assignment PIN_L22 -to rgmii_txclk;     set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_txclk;     
set_location_assignment PIN_R15 -to rgmii_txen;      set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_txen;      
set_location_assignment PIN_P17 -to rgmii_txdata[0]; set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_txdata[0]; 
set_location_assignment PIN_R16 -to rgmii_txdata[1]; set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_txdata[1]; 
set_location_assignment PIN_P18 -to rgmii_txdata[2]; set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_txdata[2]; 
set_location_assignment PIN_T19 -to rgmii_txdata[3]; set_instance_assignment -name IO_STANDARD "2.5-V" -to rgmii_txdata[3]; 

###########################################################################
# DEBUG
###########################################################################
set_location_assignment PIN_AB8  -to debug_led[0]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to debug_led[0];
set_location_assignment PIN_W8   -to debug_led[1]; set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to debug_led[1];








































