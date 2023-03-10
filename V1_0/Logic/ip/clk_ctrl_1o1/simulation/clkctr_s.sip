set_global_assignment -entity "clkctr_s" -library "lib_clkctr_s" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "clkctr_s" -library "lib_clkctr_s" -name IP_TOOL_VERSION "14.1"
set_global_assignment -entity "clkctr_s" -library "lib_clkctr_s" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_clkctr_s" -name SPD_FILE [file join $::quartus(sip_path) "../clkctr_s.spd"]
set_global_assignment -library "lib_clkctr_s" -name MISC_FILE [file join $::quartus(sip_path) "../../../par/BaseBandSourcePrj/clkctr_s.qsys"]

set_global_assignment -library "lib_clkctr_s" -name MISC_FILE [file join $::quartus(sip_path) "clkctr_s.v"]
set_global_assignment -library "lib_clkctr_s" -name MISC_FILE [file join $::quartus(sip_path) "submodules/clkctr_s_altclkctrl_0.v"]
