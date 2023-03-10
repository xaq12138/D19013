set_global_assignment -entity "clkctr" -library "lib_clkctr" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "clkctr" -library "lib_clkctr" -name IP_TOOL_VERSION "14.1"
set_global_assignment -entity "clkctr" -library "lib_clkctr" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_clkctr" -name SPD_FILE [file join $::quartus(sip_path) "../clkctr.spd"]
set_global_assignment -library "lib_clkctr" -name MISC_FILE [file join $::quartus(sip_path) "../../../par/BaseBandSourcePrj/clkctr.qsys"]

set_global_assignment -library "lib_clkctr" -name MISC_FILE [file join $::quartus(sip_path) "clkctr.v"]
set_global_assignment -library "lib_clkctr" -name MISC_FILE [file join $::quartus(sip_path) "submodules/clkctr_altclkctrl_0.v"]
