set simlib_road I:/INTEL/14_1/quartus/eda/sim_lib
set ip_road E:/GH_Prj/D19012/V1_0/Logic/ip


vlib work
vmap work work

transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver $simlib_road/altera_primitives.v

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver $simlib_road/220model.v

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver $simlib_road/sgate.v

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver $simlib_road/altera_mf.v

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver $simlib_road/altera_lnsim.sv

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver $simlib_road/mentor/cyclonev_atoms_ncrypt.v
vlog -vlog01compat -work cyclonev_ver $simlib_road/mentor/cyclonev_hmi_atoms_ncrypt.v
vlog -vlog01compat -work cyclonev_ver $simlib_road/cyclonev_atoms.v

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver $simlib_road/mentor/cyclonev_hssi_atoms_ncrypt.v
vlog -vlog01compat -work cyclonev_hssi_ver $simlib_road/cyclonev_hssi_atoms.v

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver $simlib_road/mentor/cyclonev_pcie_hip_atoms_ncrypt.v
vlog -vlog01compat -work cyclonev_pcie_hip_ver $simlib_road/cyclonev_pcie_hip_atoms.v

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


vlog -work work ../../ip/fifo_d1kw8_st/fifo_d1kw8_st.v

vlog -work work ../../src/common_block/*.v
vlog -work work ../../src/common_block/*/*.v

vlog -work work ../tb/sim_clk_mdl.v
vlog -work work ../tb/uart_top_test.v
vlog -work work ../tb/glbl.v

vsim \
-novopt \
-L altera_ver \
-L lpm_ver \
-L sgate_ver \
-L altera_mf_ver \
-L altera_lnsim_ver \
-L cyclonev_ver \
-L cyclonev_hssi_ver \
-L cyclonev_pcie_hip_ver \
-L rtl_work \
-L sys_clk125m_gen \
-L sys_clk60m_gen \
glbl uart_top_test

add log -r /*

do wave.do

run 100us

