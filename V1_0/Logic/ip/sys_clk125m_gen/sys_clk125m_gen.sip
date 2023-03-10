set_global_assignment -entity "sys_clk125m_gen" -library "lib_sys_clk125m_gen" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "sys_clk125m_gen" -library "lib_sys_clk125m_gen" -name IP_TOOL_VERSION "14.1"
set_global_assignment -entity "sys_clk125m_gen" -library "lib_sys_clk125m_gen" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_sys_clk125m_gen" -name SPD_FILE [file join $::quartus(sip_path) "sys_clk125m_gen.spd"]

set_global_assignment -library "lib_sys_clk125m_gen" -name MISC_FILE [file join $::quartus(sip_path) "sys_clk125m_gen_sim/sys_clk125m_gen.vo"]
