onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/clk_sys
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rst_n
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/cfg_udp_filter
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/cfg_udp_rxdstport
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/udp_rx_length
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/udp_rxdst_port
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/udp_rxdata
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/udp_rx_data_valid
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxdfifo_wr_en
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/pkg_wr_mask
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxdfifo_wr_data
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxififo_wr_en
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxififo_wr_data
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxififo_rd_en
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxififo_rd_data
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxififo_empty
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxififo_rd_data_valid
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxififo_rd_mask
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rd_step_en
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxdfifo_rd_en
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxdfifo_rd_data
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rxdfifo_rd_data_valid
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/user_rx_data
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/user_rx_data_valid
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rx_step_data
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rx_step_cnt
add wave -noupdate /udp_rxctrl_test/u_internet_rx_ctrl/rd_step_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {200112 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 169
configure wave -valuecolwidth 92
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {172965 ps} {372121 ps}
