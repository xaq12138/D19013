set_global_assignment -entity "pll_internet" -library "lib_pll_internet" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_internet" -library "lib_pll_internet" -name IP_TOOL_VERSION "14.1"
set_global_assignment -entity "pll_internet" -library "lib_pll_internet" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_internet" -name SPD_FILE [file join $::quartus(sip_path) "pll_internet.spd"]

set_global_assignment -library "lib_pll_internet" -name MISC_FILE [file join $::quartus(sip_path) "pll_internet_sim/pll_internet.vo"]
