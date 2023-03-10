
# (C) 2001-2020 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 14.1 186 win32 2020.08.11.15:32:20

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "TriSEthIP"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "I:/intel/14_1/quartus/"
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

set Aldec "Riviera"
if { [ string match "*Active-HDL*" [ vsim -version ] ] } {
  set Aldec "Active"
}

if { [ string match "Active" $Aldec ] } {
  scripterconf -tcl
  createdesign "$TOP_LEVEL_NAME"  "."
  opendesign "$TOP_LEVEL_NAME"
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries     
ensure_lib      ./libraries/work
vmap       work ./libraries/work
ensure_lib                       ./libraries/altera_ver           
vmap       altera_ver            ./libraries/altera_ver           
ensure_lib                       ./libraries/lpm_ver              
vmap       lpm_ver               ./libraries/lpm_ver              
ensure_lib                       ./libraries/sgate_ver            
vmap       sgate_ver             ./libraries/sgate_ver            
ensure_lib                       ./libraries/altera_mf_ver        
vmap       altera_mf_ver         ./libraries/altera_mf_ver        
ensure_lib                       ./libraries/altera_lnsim_ver     
vmap       altera_lnsim_ver      ./libraries/altera_lnsim_ver     
ensure_lib                       ./libraries/cyclonev_ver         
vmap       cyclonev_ver          ./libraries/cyclonev_ver         
ensure_lib                       ./libraries/cyclonev_hssi_ver    
vmap       cyclonev_hssi_ver     ./libraries/cyclonev_hssi_ver    
ensure_lib                       ./libraries/cyclonev_pcie_hip_ver
vmap       cyclonev_pcie_hip_ver ./libraries/cyclonev_pcie_hip_ver
ensure_lib           ./libraries/i_tse_mac
vmap       i_tse_mac ./libraries/i_tse_mac

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                    -work altera_ver           
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                             -work lpm_ver              
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                                -work sgate_ver            
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                            -work altera_mf_ver        
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                        -work altera_lnsim_ver     
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/aldec/cyclonev_atoms_ncrypt.v"          -work cyclonev_ver         
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/aldec/cyclonev_hmi_atoms_ncrypt.v"      -work cyclonev_ver         
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.v"                       -work cyclonev_ver         
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/aldec/cyclonev_hssi_atoms_ncrypt.v"     -work cyclonev_hssi_ver    
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_hssi_atoms.v"                  -work cyclonev_hssi_ver    
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/aldec/cyclonev_pcie_hip_atoms_ncrypt.v" -work cyclonev_pcie_hip_ver
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_pcie_hip_atoms.v"              -work cyclonev_pcie_hip_ver
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_eth_tse_mac.v"                  -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_clk_cntl.v"                 -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_crc328checker.v"            -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_crc328generator.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_crc32ctl8.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_crc32galois8.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_gmii_io.v"                  -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_lb_read_cntl.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_lb_wrt_cntl.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_hashing.v"                  -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_host_control.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_host_control_small.v"       -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_mac_control.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_register_map.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_register_map_small.v"       -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rx_counter_cntl.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_shared_mac_control.v"       -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_shared_register_map.v"      -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_counter_cntl.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_lfsr_10.v"                  -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_loopback_ff.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_altshifttaps.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_fifoless_mac_rx.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_mac_rx.v"                   -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_fifoless_mac_tx.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_mac_tx.v"                   -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_magic_detection.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_mdio.v"                     -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_mdio_clk_gen.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_mdio_cntl.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_top_mdio.v"                 -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_mii_rx_if.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_mii_tx_if.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_pipeline_base.v"            -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_pipeline_stage.sv"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_dpram_16x32.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_dpram_8x32.v"               -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_dpram_ecc_16x32.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_quad_16x32.v"               -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_quad_8x32.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_fifoless_retransmit_cntl.v" -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_retransmit_cntl.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rgmii_in1.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rgmii_in4.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_nf_rgmii_module.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rgmii_module.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rgmii_out1.v"               -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rgmii_out4.v"               -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rx_ff.v"                    -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rx_min_ff.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rx_ff_cntrl.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rx_ff_cntrl_32.v"           -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rx_ff_cntrl_32_shift16.v"   -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rx_ff_length.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_rx_stat_extract.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_timing_adapter32.v"         -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_timing_adapter8.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_timing_adapter_fifo32.v"    -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_timing_adapter_fifo8.v"     -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_top_1geth.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_top_fifoless_1geth.v"       -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_top_w_fifo.v"               -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_top_w_fifo_10_100_1000.v"   -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_top_wo_fifo.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_top_wo_fifo_10_100_1000.v"  -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_top_gen_host.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_ff.v"                    -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_min_ff.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_ff_cntrl.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_ff_cntrl_32.v"           -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_ff_cntrl_32_shift16.v"   -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_ff_length.v"             -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_ff_read_cntl.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_tx_stat_extract.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_false_path_marker.v"        -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_reset_synchronizer.v"       -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_clock_crosser.v"            -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_a_fifo_13.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_a_fifo_24.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_a_fifo_34.v"                -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_a_fifo_opt_1246.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_a_fifo_opt_14_44.v"         -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_a_fifo_opt_36_10.v"         -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_gray_cnt.v"                 -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_sdpm_altsyncram.v"          -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_altsyncram_dpm_fifo.v"      -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_bin_cnt.v"                  -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ph_calculator.sv"           -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_sdpm_gen.v"                 -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_dec_x10.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x10.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x10_wrapper.v"      -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_dec_x14.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x14.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x14_wrapper.v"      -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_dec_x2.v"               -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x2.v"               -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x2_wrapper.v"       -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_dec_x23.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x23.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x23_wrapper.v"      -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_dec_x36.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x36.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x36_wrapper.v"      -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_dec_x40.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x40.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x40_wrapper.v"      -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_dec_x30.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x30.v"              -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_enc_x30_wrapper.v"      -work i_tse_mac
  vlog  "$QSYS_SIMDIR/altera_eth_tse_mac/aldec/altera_tse_ecc_status_crosser.v"       -work i_tse_mac
  vlog  "$QSYS_SIMDIR/TriSEthIP.v"                                                                   
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim +access +r -t ps $ELAB_OPTIONS -L work -L i_tse_mac -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with -dbg -O2 option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -dbg -O2 +access +r -t ps $ELAB_OPTIONS -L work -L i_tse_mac -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -dbg -O2
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with -dbg -O2 option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -dbg -O2"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
h
