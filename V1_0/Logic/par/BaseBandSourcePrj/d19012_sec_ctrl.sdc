## Generated SDC file "d19012_sec_ctrl.sdc"

## Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 14.1.0 Build 186 12/03/2014 SJ Full Version"

## DATE    "Tue Jul 28 14:19:59 2020"

##
## DEVICE  "5CEFA9F23I7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_60m} -period 16.667 -waveform { 0.000 8.333 } [get_ports {clk_sys}]
create_clock -name {dac_clk} -period 16.000 -waveform { 0.000 8.000 } [get_ports {ad9785_dclk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {dac_clk}] -rise_to [get_clocks {dac_clk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {dac_clk}] -rise_to [get_clocks {dac_clk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {dac_clk}] -fall_to [get_clocks {dac_clk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {dac_clk}] -fall_to [get_clocks {dac_clk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {dac_clk}] -rise_to [get_clocks {clk_60m}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {dac_clk}] -fall_to [get_clocks {clk_60m}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {dac_clk}] -rise_to [get_clocks {dac_clk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {dac_clk}] -rise_to [get_clocks {dac_clk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {dac_clk}] -fall_to [get_clocks {dac_clk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {dac_clk}] -fall_to [get_clocks {dac_clk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {dac_clk}] -rise_to [get_clocks {clk_60m}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {dac_clk}] -fall_to [get_clocks {clk_60m}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {clk_60m}] -rise_to [get_clocks {dac_clk}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {clk_60m}] -fall_to [get_clocks {dac_clk}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {clk_60m}] -rise_to [get_clocks {clk_60m}]  0.140  
set_clock_uncertainty -rise_from [get_clocks {clk_60m}] -fall_to [get_clocks {clk_60m}]  0.140  
set_clock_uncertainty -fall_from [get_clocks {clk_60m}] -rise_to [get_clocks {dac_clk}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {clk_60m}] -fall_to [get_clocks {dac_clk}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {clk_60m}] -rise_to [get_clocks {clk_60m}]  0.140  
set_clock_uncertainty -fall_from [get_clocks {clk_60m}] -fall_to [get_clocks {clk_60m}]  0.140  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from  [get_clocks {clk_60m}]  -to  [get_clocks {dac_clk}] 16.000
set_max_delay -from  [get_clocks {dac_clk}]  -to  [get_clocks {clk_60m}] 16.000


#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

