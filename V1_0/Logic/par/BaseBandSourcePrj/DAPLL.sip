set_global_assignment -entity "DAPLL" -library "lib_DAPLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "DAPLL" -library "lib_DAPLL" -name IP_TOOL_VERSION "14.1"
set_global_assignment -entity "DAPLL" -library "lib_DAPLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_DAPLL" -name SPD_FILE [file join $::quartus(sip_path) "DAPLL.spd"]

set_global_assignment -library "lib_DAPLL" -name MISC_FILE [file join $::quartus(sip_path) "DAPLL_sim/DAPLL.vo"]
