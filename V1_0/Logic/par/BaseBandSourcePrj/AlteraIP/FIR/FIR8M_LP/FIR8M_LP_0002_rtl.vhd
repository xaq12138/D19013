-- ------------------------------------------------------------------------- 
-- Altera DSP Builder Advanced Flow Tools Release Version 14.1
-- Quartus II development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2014 Altera Corporation.  All rights reserved.
-- Your use of  Altera  Corporation's design tools,  logic functions and other
-- software and tools,  and its AMPP  partner logic functions, and  any output
-- files  any of the  foregoing  device programming or simulation files),  and
-- any associated  documentation or information are expressly subject  to  the
-- terms and conditions  of the Altera Program License Subscription Agreement,
-- Altera  MegaCore  Function  License  Agreement, or other applicable license
-- agreement,  including,  without limitation,  that your use  is for the sole
-- purpose of  programming  logic  devices  manufactured by Altera and sold by
-- Altera or its authorized  distributors.  Please  refer  to  the  applicable
-- agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from FIR8M_LP_0002_rtl
-- VHDL created on Sat Jul 01 14:04:48 2017


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity FIR8M_LP_0002_rtl is
    port (
        xIn_v : in std_logic_vector(0 downto 0);  -- sfix1
        xIn_c : in std_logic_vector(7 downto 0);  -- sfix8
        xIn_0 : in std_logic_vector(11 downto 0);  -- sfix12
        xOut_v : out std_logic_vector(0 downto 0);  -- ufix1
        xOut_c : out std_logic_vector(7 downto 0);  -- ufix8
        xOut_0 : out std_logic_vector(30 downto 0);  -- sfix31
        clk : in std_logic;
        areset : in std_logic
    );
end FIR8M_LP_0002_rtl;

architecture normal of FIR8M_LP_0002_rtl is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_memread_q_11_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_memread_q_13_q : STD_LOGIC_VECTOR (0 downto 0);
    type u0_m0_wo0_cma0_a_type is array(0 to 31) of SIGNED(11 downto 0);
    signal u0_m0_wo0_cma0_a0 : u0_m0_wo0_cma0_a_type;
    attribute preserve : boolean;
    attribute preserve of u0_m0_wo0_cma0_a0 : signal is true;
    type u0_m0_wo0_cma0_c_type is array(0 to 31) of UNSIGNED(2 downto 0);
    signal u0_m0_wo0_cma0_c0 : u0_m0_wo0_cma0_c_type;
    attribute preserve of u0_m0_wo0_cma0_c0 : signal is true;
    type u0_m0_wo0_cma0_r_type is array(0 to 31) of SIGNED(10 downto 0);
    signal u0_m0_wo0_cma0_r : u0_m0_wo0_cma0_r_type;
    type u0_m0_wo0_cma0_p_type is array(0 to 31) of SIGNED(22 downto 0);
    signal u0_m0_wo0_cma0_p : u0_m0_wo0_cma0_p_type;
    type u0_m0_wo0_cma0_u_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma0_u : u0_m0_wo0_cma0_u_type;
    type u0_m0_wo0_cma0_w_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma0_w : u0_m0_wo0_cma0_w_type;
    type u0_m0_wo0_cma0_x_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma0_x : u0_m0_wo0_cma0_x_type;
    type u0_m0_wo0_cma0_y_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma0_y : u0_m0_wo0_cma0_y_type;
    type u0_m0_wo0_cma0_romtype is array(0 to 7) of SIGNED(10 downto 0);
    signal u0_m0_wo0_cma0_k0 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(20,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k1 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k2 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k3 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k4 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k5 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(20,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k6 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(19,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k7 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(17,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k8 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(13,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k9 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(7,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k10 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(0,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k11 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-9,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k12 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k13 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-35,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k14 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-52,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k15 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-70,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k16 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-91,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k17 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-112,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k18 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-133,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k19 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-153,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k20 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-172,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k21 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-188,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k22 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-200,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k23 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-207,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k24 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-207,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k25 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-199,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k26 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-181,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k27 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-153,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k28 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-114,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k29 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(-63,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k30 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(0,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma0_k31 : u0_m0_wo0_cma0_romtype := (
        0 => TO_SIGNED(76,11),
        others => (others => '0'));
    type u0_m0_wo0_cma0_s_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma0_s : u0_m0_wo0_cma0_s_type;
    signal u0_m0_wo0_cma0_qq : std_logic_vector(27 downto 0);
    signal u0_m0_wo0_cma0_q : std_logic_vector(27 downto 0);
    type u0_m0_wo0_cma1_a_type is array(0 to 31) of SIGNED(11 downto 0);
    signal u0_m0_wo0_cma1_a0 : u0_m0_wo0_cma1_a_type;
    attribute preserve of u0_m0_wo0_cma1_a0 : signal is true;
    type u0_m0_wo0_cma1_c_type is array(0 to 31) of UNSIGNED(2 downto 0);
    signal u0_m0_wo0_cma1_c0 : u0_m0_wo0_cma1_c_type;
    attribute preserve of u0_m0_wo0_cma1_c0 : signal is true;
    type u0_m0_wo0_cma1_r_type is array(0 to 31) of SIGNED(11 downto 0);
    signal u0_m0_wo0_cma1_r : u0_m0_wo0_cma1_r_type;
    type u0_m0_wo0_cma1_p_type is array(0 to 31) of SIGNED(23 downto 0);
    signal u0_m0_wo0_cma1_p : u0_m0_wo0_cma1_p_type;
    type u0_m0_wo0_cma1_u_type is array(0 to 31) of SIGNED(28 downto 0);
    signal u0_m0_wo0_cma1_u : u0_m0_wo0_cma1_u_type;
    type u0_m0_wo0_cma1_w_type is array(0 to 31) of SIGNED(28 downto 0);
    signal u0_m0_wo0_cma1_w : u0_m0_wo0_cma1_w_type;
    type u0_m0_wo0_cma1_x_type is array(0 to 31) of SIGNED(28 downto 0);
    signal u0_m0_wo0_cma1_x : u0_m0_wo0_cma1_x_type;
    type u0_m0_wo0_cma1_y_type is array(0 to 31) of SIGNED(28 downto 0);
    signal u0_m0_wo0_cma1_y : u0_m0_wo0_cma1_y_type;
    type u0_m0_wo0_cma1_romtype is array(0 to 7) of SIGNED(11 downto 0);
    signal u0_m0_wo0_cma1_k0 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(164,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k1 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(265,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k2 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(376,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k3 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(497,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k4 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(627,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k5 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(763,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k6 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(904,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k7 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1046,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k8 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1188,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k9 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1327,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k10 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1461,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k11 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1586,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k12 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1700,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k13 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1801,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k14 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1887,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k15 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1956,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k16 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(2006,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k17 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(2036,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k18 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(2047,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k19 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(2036,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k20 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(2006,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k21 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1956,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k22 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1887,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k23 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1801,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k24 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1700,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k25 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1586,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k26 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1461,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k27 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1327,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k28 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1188,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k29 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(1046,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k30 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(904,12),
        others => (others => '0'));
    signal u0_m0_wo0_cma1_k31 : u0_m0_wo0_cma1_romtype := (
        0 => TO_SIGNED(763,12),
        others => (others => '0'));
    type u0_m0_wo0_cma1_s_type is array(0 to 31) of SIGNED(28 downto 0);
    signal u0_m0_wo0_cma1_s : u0_m0_wo0_cma1_s_type;
    signal u0_m0_wo0_cma1_qq : std_logic_vector(28 downto 0);
    signal u0_m0_wo0_cma1_q : std_logic_vector(28 downto 0);
    type u0_m0_wo0_cma2_a_type is array(0 to 31) of SIGNED(11 downto 0);
    signal u0_m0_wo0_cma2_a0 : u0_m0_wo0_cma2_a_type;
    attribute preserve of u0_m0_wo0_cma2_a0 : signal is true;
    type u0_m0_wo0_cma2_c_type is array(0 to 31) of UNSIGNED(2 downto 0);
    signal u0_m0_wo0_cma2_c0 : u0_m0_wo0_cma2_c_type;
    attribute preserve of u0_m0_wo0_cma2_c0 : signal is true;
    type u0_m0_wo0_cma2_r_type is array(0 to 31) of SIGNED(10 downto 0);
    signal u0_m0_wo0_cma2_r : u0_m0_wo0_cma2_r_type;
    type u0_m0_wo0_cma2_p_type is array(0 to 31) of SIGNED(22 downto 0);
    signal u0_m0_wo0_cma2_p : u0_m0_wo0_cma2_p_type;
    type u0_m0_wo0_cma2_u_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma2_u : u0_m0_wo0_cma2_u_type;
    type u0_m0_wo0_cma2_w_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma2_w : u0_m0_wo0_cma2_w_type;
    type u0_m0_wo0_cma2_x_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma2_x : u0_m0_wo0_cma2_x_type;
    type u0_m0_wo0_cma2_y_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma2_y : u0_m0_wo0_cma2_y_type;
    type u0_m0_wo0_cma2_romtype is array(0 to 7) of SIGNED(10 downto 0);
    signal u0_m0_wo0_cma2_k0 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(627,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k1 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(497,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k2 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(376,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k3 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(265,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k4 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(164,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k5 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(76,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k6 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(0,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k7 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-63,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k8 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-114,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k9 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-153,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k10 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-181,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k11 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-199,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k12 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-207,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k13 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-207,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k14 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-200,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k15 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-188,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k16 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-172,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k17 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-153,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k18 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-133,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k19 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-112,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k20 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-91,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k21 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-70,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k22 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-52,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k23 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-35,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k24 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k25 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(-9,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k26 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(0,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k27 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(7,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k28 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(13,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k29 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(17,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k30 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(19,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma2_k31 : u0_m0_wo0_cma2_romtype := (
        0 => TO_SIGNED(20,11),
        others => (others => '0'));
    type u0_m0_wo0_cma2_s_type is array(0 to 31) of SIGNED(27 downto 0);
    signal u0_m0_wo0_cma2_s : u0_m0_wo0_cma2_s_type;
    signal u0_m0_wo0_cma2_qq : std_logic_vector(27 downto 0);
    signal u0_m0_wo0_cma2_q : std_logic_vector(27 downto 0);
    type u0_m0_wo0_cma3_a_type is array(0 to 5) of SIGNED(11 downto 0);
    signal u0_m0_wo0_cma3_a0 : u0_m0_wo0_cma3_a_type;
    attribute preserve of u0_m0_wo0_cma3_a0 : signal is true;
    type u0_m0_wo0_cma3_c_type is array(0 to 5) of UNSIGNED(2 downto 0);
    signal u0_m0_wo0_cma3_c0 : u0_m0_wo0_cma3_c_type;
    attribute preserve of u0_m0_wo0_cma3_c0 : signal is true;
    type u0_m0_wo0_cma3_r_type is array(0 to 5) of SIGNED(10 downto 0);
    signal u0_m0_wo0_cma3_r : u0_m0_wo0_cma3_r_type;
    type u0_m0_wo0_cma3_p_type is array(0 to 5) of SIGNED(22 downto 0);
    signal u0_m0_wo0_cma3_p : u0_m0_wo0_cma3_p_type;
    type u0_m0_wo0_cma3_u_type is array(0 to 5) of SIGNED(25 downto 0);
    signal u0_m0_wo0_cma3_u : u0_m0_wo0_cma3_u_type;
    type u0_m0_wo0_cma3_w_type is array(0 to 5) of SIGNED(25 downto 0);
    signal u0_m0_wo0_cma3_w : u0_m0_wo0_cma3_w_type;
    type u0_m0_wo0_cma3_x_type is array(0 to 5) of SIGNED(25 downto 0);
    signal u0_m0_wo0_cma3_x : u0_m0_wo0_cma3_x_type;
    type u0_m0_wo0_cma3_y_type is array(0 to 5) of SIGNED(25 downto 0);
    signal u0_m0_wo0_cma3_y : u0_m0_wo0_cma3_y_type;
    type u0_m0_wo0_cma3_romtype is array(0 to 7) of SIGNED(10 downto 0);
    signal u0_m0_wo0_cma3_k0 : u0_m0_wo0_cma3_romtype := (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma3_k1 : u0_m0_wo0_cma3_romtype := (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma3_k2 : u0_m0_wo0_cma3_romtype := (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma3_k3 : u0_m0_wo0_cma3_romtype := (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma3_k4 : u0_m0_wo0_cma3_romtype := (
        0 => TO_SIGNED(20,11),
        others => (others => '0'));
    signal u0_m0_wo0_cma3_k5 : u0_m0_wo0_cma3_romtype := (
        others => (others => '0'));
    type u0_m0_wo0_cma3_s_type is array(0 to 5) of SIGNED(25 downto 0);
    signal u0_m0_wo0_cma3_s : u0_m0_wo0_cma3_s_type;
    signal u0_m0_wo0_cma3_qq : std_logic_vector(25 downto 0);
    signal u0_m0_wo0_cma3_q : std_logic_vector(25 downto 0);
    signal u0_m0_wo0_mtree_add0_0_a : STD_LOGIC_VECTOR (29 downto 0);
    signal u0_m0_wo0_mtree_add0_0_b : STD_LOGIC_VECTOR (29 downto 0);
    signal u0_m0_wo0_mtree_add0_0_o : STD_LOGIC_VECTOR (29 downto 0);
    signal u0_m0_wo0_mtree_add0_0_q : STD_LOGIC_VECTOR (29 downto 0);
    signal u0_m0_wo0_mtree_add0_1_a : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add0_1_b : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add0_1_o : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add0_1_q : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add1_0_a : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_add1_0_b : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_add1_0_o : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_add1_0_q : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_oseq_gated_reg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_mem_reset0 : std_logic;
    signal u0_m0_wo0_wi0_delayr32_replace_mem_ia : STD_LOGIC_VECTOR (35 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_mem_aa : STD_LOGIC_VECTOR (4 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_mem_ab : STD_LOGIC_VECTOR (4 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_mem_iq : STD_LOGIC_VECTOR (35 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_mem_q : STD_LOGIC_VECTOR (35 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_rdcnt_q : STD_LOGIC_VECTOR (4 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_rdcnt_i : UNSIGNED (4 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_rdcnt_eq : std_logic;
    signal u0_m0_wo0_wi0_delayr32_replace_rdreg_q : STD_LOGIC_VECTOR (4 downto 0);
    signal u0_m0_wo0_wi0_delayr32_mem_top_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_delayr32_cmpReg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_sticky_ena_q : STD_LOGIC_VECTOR (0 downto 0);
    attribute preserve of u0_m0_wo0_wi0_delayr32_sticky_ena_q : signal is true;
    signal u0_m0_wo0_wi0_delayr32_replace_rdmux_s : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_replace_rdmux_q : STD_LOGIC_VECTOR (4 downto 0);
    signal u0_m0_wo0_wi0_delayr32_cmp_a : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_delayr32_cmp_b : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_delayr32_cmp_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_notEnable_a : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_notEnable_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_nor_a : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_nor_b : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_nor_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_enaAnd_a : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_enaAnd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_delayr32_enaAnd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_split32_in : STD_LOGIC_VECTOR (35 downto 0);
    signal u0_m0_wo0_wi0_split32_b : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_split32_c : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_split32_d : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_join32_q : STD_LOGIC_VECTOR (35 downto 0);

begin


    -- VCC(CONSTANT,1)@0
    VCC_q <= "1";

    -- u0_m0_wo0_wi0_delayr32_notEnable(LOGICAL,230)@10
    u0_m0_wo0_wi0_delayr32_notEnable_a <= xIn_v;
    u0_m0_wo0_wi0_delayr32_notEnable_q <= not (u0_m0_wo0_wi0_delayr32_notEnable_a);

    -- u0_m0_wo0_wi0_delayr32_nor(LOGICAL,231)@10
    u0_m0_wo0_wi0_delayr32_nor_a <= u0_m0_wo0_wi0_delayr32_notEnable_q;
    u0_m0_wo0_wi0_delayr32_nor_b <= u0_m0_wo0_wi0_delayr32_sticky_ena_q;
    u0_m0_wo0_wi0_delayr32_nor_q <= not (u0_m0_wo0_wi0_delayr32_nor_a or u0_m0_wo0_wi0_delayr32_nor_b);

    -- u0_m0_wo0_wi0_delayr32_mem_top(CONSTANT,227)
    u0_m0_wo0_wi0_delayr32_mem_top_q <= "011110";

    -- u0_m0_wo0_wi0_delayr32_cmp(LOGICAL,228)@10
    u0_m0_wo0_wi0_delayr32_cmp_a <= u0_m0_wo0_wi0_delayr32_mem_top_q;
    u0_m0_wo0_wi0_delayr32_cmp_b <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_delayr32_replace_rdmux_q);
    u0_m0_wo0_wi0_delayr32_cmp_q <= "1" WHEN u0_m0_wo0_wi0_delayr32_cmp_a = u0_m0_wo0_wi0_delayr32_cmp_b ELSE "0";

    -- u0_m0_wo0_wi0_delayr32_cmpReg(REG,229)@10
    u0_m0_wo0_wi0_delayr32_cmpReg: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_delayr32_cmpReg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (xIn_v = "1") THEN
                u0_m0_wo0_wi0_delayr32_cmpReg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_delayr32_cmp_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_delayr32_sticky_ena(REG,232)@10
    u0_m0_wo0_wi0_delayr32_sticky_ena: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_delayr32_sticky_ena_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_wi0_delayr32_nor_q = "1") THEN
                u0_m0_wo0_wi0_delayr32_sticky_ena_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_delayr32_cmpReg_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_delayr32_enaAnd(LOGICAL,233)@10
    u0_m0_wo0_wi0_delayr32_enaAnd_a <= u0_m0_wo0_wi0_delayr32_sticky_ena_q;
    u0_m0_wo0_wi0_delayr32_enaAnd_b <= xIn_v;
    u0_m0_wo0_wi0_delayr32_enaAnd_q <= u0_m0_wo0_wi0_delayr32_enaAnd_a and u0_m0_wo0_wi0_delayr32_enaAnd_b;

    -- u0_m0_wo0_wi0_delayr32_replace_rdcnt(COUNTER,223)@10
    -- every=1, low=0, high=30, step=1, init=1
    u0_m0_wo0_wi0_delayr32_replace_rdcnt: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_delayr32_replace_rdcnt_i <= TO_UNSIGNED(1, 5);
            u0_m0_wo0_wi0_delayr32_replace_rdcnt_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (xIn_v = "1") THEN
                IF (u0_m0_wo0_wi0_delayr32_replace_rdcnt_i = TO_UNSIGNED(29, 5)) THEN
                    u0_m0_wo0_wi0_delayr32_replace_rdcnt_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_delayr32_replace_rdcnt_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_delayr32_replace_rdcnt_eq = '1') THEN
                    u0_m0_wo0_wi0_delayr32_replace_rdcnt_i <= u0_m0_wo0_wi0_delayr32_replace_rdcnt_i - 30;
                ELSE
                    u0_m0_wo0_wi0_delayr32_replace_rdcnt_i <= u0_m0_wo0_wi0_delayr32_replace_rdcnt_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_delayr32_replace_rdcnt_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_delayr32_replace_rdcnt_i, 5)));

    -- u0_m0_wo0_wi0_delayr32_replace_rdmux(MUX,225)@10
    u0_m0_wo0_wi0_delayr32_replace_rdmux_s <= xIn_v;
    u0_m0_wo0_wi0_delayr32_replace_rdmux: PROCESS (u0_m0_wo0_wi0_delayr32_replace_rdmux_s, u0_m0_wo0_wi0_delayr32_replace_rdreg_q, u0_m0_wo0_wi0_delayr32_replace_rdcnt_q)
    BEGIN
        CASE (u0_m0_wo0_wi0_delayr32_replace_rdmux_s) IS
            WHEN "0" => u0_m0_wo0_wi0_delayr32_replace_rdmux_q <= u0_m0_wo0_wi0_delayr32_replace_rdreg_q;
            WHEN "1" => u0_m0_wo0_wi0_delayr32_replace_rdmux_q <= u0_m0_wo0_wi0_delayr32_replace_rdcnt_q;
            WHEN OTHERS => u0_m0_wo0_wi0_delayr32_replace_rdmux_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- u0_m0_wo0_wi0_join32(BITJOIN,39)@10
    u0_m0_wo0_wi0_join32_q <= u0_m0_wo0_wi0_split32_c & u0_m0_wo0_wi0_split32_b & xIn_0;

    -- u0_m0_wo0_wi0_delayr32_replace_rdreg(REG,224)@10
    u0_m0_wo0_wi0_delayr32_replace_rdreg: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_delayr32_replace_rdreg_q <= "00000";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (xIn_v = "1") THEN
                u0_m0_wo0_wi0_delayr32_replace_rdreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_delayr32_replace_rdcnt_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_delayr32_replace_mem(DUALMEM,222)@10
    u0_m0_wo0_wi0_delayr32_replace_mem_ia <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_join32_q);
    u0_m0_wo0_wi0_delayr32_replace_mem_aa <= u0_m0_wo0_wi0_delayr32_replace_rdreg_q;
    u0_m0_wo0_wi0_delayr32_replace_mem_ab <= u0_m0_wo0_wi0_delayr32_replace_rdmux_q;
    u0_m0_wo0_wi0_delayr32_replace_mem_reset0 <= areset;
    u0_m0_wo0_wi0_delayr32_replace_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 36,
        widthad_a => 5,
        numwords_a => 31,
        width_b => 36,
        widthad_b => 5,
        numwords_b => 31,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_aclr_b => "CLEAR1",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken1 => u0_m0_wo0_wi0_delayr32_enaAnd_q(0),
        clocken0 => '1',
        clock0 => clk,
        aclr1 => u0_m0_wo0_wi0_delayr32_replace_mem_reset0,
        clock1 => clk,
        address_a => u0_m0_wo0_wi0_delayr32_replace_mem_aa,
        data_a => u0_m0_wo0_wi0_delayr32_replace_mem_ia,
        wren_a => xIn_v(0),
        address_b => u0_m0_wo0_wi0_delayr32_replace_mem_ab,
        q_b => u0_m0_wo0_wi0_delayr32_replace_mem_iq
    );
    u0_m0_wo0_wi0_delayr32_replace_mem_q <= u0_m0_wo0_wi0_delayr32_replace_mem_iq(35 downto 0);

    -- u0_m0_wo0_wi0_split32(BITSELECT,40)@10
    u0_m0_wo0_wi0_split32_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_delayr32_replace_mem_q);
    u0_m0_wo0_wi0_split32_b <= u0_m0_wo0_wi0_split32_in(11 downto 0);
    u0_m0_wo0_wi0_split32_c <= u0_m0_wo0_wi0_split32_in(23 downto 12);
    u0_m0_wo0_wi0_split32_d <= u0_m0_wo0_wi0_split32_in(35 downto 24);

    -- d_u0_m0_wo0_memread_q_11(DELAY,220)@10
    d_u0_m0_wo0_memread_q_11 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1 )
    PORT MAP ( xin => xIn_v, xout => d_u0_m0_wo0_memread_q_11_q, clk => clk, aclr => areset );

    -- xIn(PORTIN,2)@10

    -- u0_m0_wo0_cma3(CHAINMULTADD,212)@10
--altera synthesis_off
    u0_m0_wo0_cma3_k0 <= (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    u0_m0_wo0_cma3_k1 <= (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    u0_m0_wo0_cma3_k2 <= (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    u0_m0_wo0_cma3_k3 <= (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    u0_m0_wo0_cma3_k4 <= (
        0 => TO_SIGNED(20,11),
        others => (others => '0'));
    u0_m0_wo0_cma3_k5 <= (
        others => (others => '0'));
--altera synthesis_on
    u0_m0_wo0_cma3_r(0) <= u0_m0_wo0_cma3_k0(TO_INTEGER(u0_m0_wo0_cma3_c0(0)));
    u0_m0_wo0_cma3_r(1) <= u0_m0_wo0_cma3_k1(TO_INTEGER(u0_m0_wo0_cma3_c0(1)));
    u0_m0_wo0_cma3_r(2) <= u0_m0_wo0_cma3_k2(TO_INTEGER(u0_m0_wo0_cma3_c0(2)));
    u0_m0_wo0_cma3_r(3) <= u0_m0_wo0_cma3_k3(TO_INTEGER(u0_m0_wo0_cma3_c0(3)));
    u0_m0_wo0_cma3_r(4) <= u0_m0_wo0_cma3_k4(TO_INTEGER(u0_m0_wo0_cma3_c0(4)));
    u0_m0_wo0_cma3_r(5) <= u0_m0_wo0_cma3_k5(TO_INTEGER(u0_m0_wo0_cma3_c0(5)));
    u0_m0_wo0_cma3_p(0) <= u0_m0_wo0_cma3_a0(0) * u0_m0_wo0_cma3_r(0);
    u0_m0_wo0_cma3_p(1) <= u0_m0_wo0_cma3_a0(1) * u0_m0_wo0_cma3_r(1);
    u0_m0_wo0_cma3_p(2) <= u0_m0_wo0_cma3_a0(2) * u0_m0_wo0_cma3_r(2);
    u0_m0_wo0_cma3_p(3) <= u0_m0_wo0_cma3_a0(3) * u0_m0_wo0_cma3_r(3);
    u0_m0_wo0_cma3_p(4) <= u0_m0_wo0_cma3_a0(4) * u0_m0_wo0_cma3_r(4);
    u0_m0_wo0_cma3_p(5) <= u0_m0_wo0_cma3_a0(5) * u0_m0_wo0_cma3_r(5);
    u0_m0_wo0_cma3_u(0) <= RESIZE(u0_m0_wo0_cma3_p(0),26);
    u0_m0_wo0_cma3_u(1) <= RESIZE(u0_m0_wo0_cma3_p(1),26);
    u0_m0_wo0_cma3_u(2) <= RESIZE(u0_m0_wo0_cma3_p(2),26);
    u0_m0_wo0_cma3_u(3) <= RESIZE(u0_m0_wo0_cma3_p(3),26);
    u0_m0_wo0_cma3_u(4) <= RESIZE(u0_m0_wo0_cma3_p(4),26);
    u0_m0_wo0_cma3_u(5) <= RESIZE(u0_m0_wo0_cma3_p(5),26);
    u0_m0_wo0_cma3_w(0) <= u0_m0_wo0_cma3_u(0);
    u0_m0_wo0_cma3_w(1) <= u0_m0_wo0_cma3_u(1);
    u0_m0_wo0_cma3_w(2) <= u0_m0_wo0_cma3_u(2);
    u0_m0_wo0_cma3_w(3) <= u0_m0_wo0_cma3_u(3);
    u0_m0_wo0_cma3_w(4) <= u0_m0_wo0_cma3_u(4);
    u0_m0_wo0_cma3_w(5) <= u0_m0_wo0_cma3_u(5);
    u0_m0_wo0_cma3_x(0) <= u0_m0_wo0_cma3_w(0);
    u0_m0_wo0_cma3_x(1) <= u0_m0_wo0_cma3_w(1);
    u0_m0_wo0_cma3_x(2) <= u0_m0_wo0_cma3_w(2);
    u0_m0_wo0_cma3_x(3) <= u0_m0_wo0_cma3_w(3);
    u0_m0_wo0_cma3_x(4) <= u0_m0_wo0_cma3_w(4);
    u0_m0_wo0_cma3_x(5) <= u0_m0_wo0_cma3_w(5);
    u0_m0_wo0_cma3_y(0) <= u0_m0_wo0_cma3_s(1) + u0_m0_wo0_cma3_x(0);
    u0_m0_wo0_cma3_y(1) <= u0_m0_wo0_cma3_s(2) + u0_m0_wo0_cma3_x(1);
    u0_m0_wo0_cma3_y(2) <= u0_m0_wo0_cma3_s(3) + u0_m0_wo0_cma3_x(2);
    u0_m0_wo0_cma3_y(3) <= u0_m0_wo0_cma3_s(4) + u0_m0_wo0_cma3_x(3);
    u0_m0_wo0_cma3_y(4) <= u0_m0_wo0_cma3_s(5) + u0_m0_wo0_cma3_x(4);
    u0_m0_wo0_cma3_y(5) <= u0_m0_wo0_cma3_x(5);
    u0_m0_wo0_cma3_chainmultadd: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cma3_a0 <= (others => (others => '0'));
            u0_m0_wo0_cma3_c0 <= (others => (others => '0'));
            u0_m0_wo0_cma3_s <= (others => (others => '0'));
        ELSIF(clk'EVENT AND clk = '1') THEN
            IF (xIn_v = "1") THEN
                u0_m0_wo0_cma3_a0(0) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_d),12);
                u0_m0_wo0_cma3_a0(1) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_d),12);
                u0_m0_wo0_cma3_a0(2) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_d),12);
                u0_m0_wo0_cma3_a0(3) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_d),12);
                u0_m0_wo0_cma3_a0(4) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_d),12);
                u0_m0_wo0_cma3_a0(5) <= (others => '0');
                u0_m0_wo0_cma3_c0(0) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma3_c0(1) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma3_c0(2) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma3_c0(3) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma3_c0(4) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma3_c0(5) <= (others => '0');
            END IF;
            IF (d_u0_m0_wo0_memread_q_11_q = "1") THEN
                u0_m0_wo0_cma3_s(0) <= u0_m0_wo0_cma3_y(0);
                u0_m0_wo0_cma3_s(1) <= u0_m0_wo0_cma3_y(1);
                u0_m0_wo0_cma3_s(2) <= u0_m0_wo0_cma3_y(2);
                u0_m0_wo0_cma3_s(3) <= u0_m0_wo0_cma3_y(3);
                u0_m0_wo0_cma3_s(4) <= u0_m0_wo0_cma3_y(4);
                u0_m0_wo0_cma3_s(5) <= u0_m0_wo0_cma3_y(5);
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_cma3_delay : dspba_delay
    GENERIC MAP (width => 26, depth => 0)
    PORT MAP (xin => STD_LOGIC_VECTOR(u0_m0_wo0_cma3_s(0)(25 downto 0)), xout => u0_m0_wo0_cma3_qq, clk => clk, aclr => areset);
    u0_m0_wo0_cma3_q <= STD_LOGIC_VECTOR(u0_m0_wo0_cma3_qq(25 downto 0));
    -- u0_m0_wo0_cma2(CHAINMULTADD,211)@10
--altera synthesis_off
    u0_m0_wo0_cma2_k0 <= (
        0 => TO_SIGNED(627,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k1 <= (
        0 => TO_SIGNED(497,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k2 <= (
        0 => TO_SIGNED(376,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k3 <= (
        0 => TO_SIGNED(265,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k4 <= (
        0 => TO_SIGNED(164,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k5 <= (
        0 => TO_SIGNED(76,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k6 <= (
        0 => TO_SIGNED(0,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k7 <= (
        0 => TO_SIGNED(-63,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k8 <= (
        0 => TO_SIGNED(-114,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k9 <= (
        0 => TO_SIGNED(-153,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k10 <= (
        0 => TO_SIGNED(-181,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k11 <= (
        0 => TO_SIGNED(-199,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k12 <= (
        0 => TO_SIGNED(-207,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k13 <= (
        0 => TO_SIGNED(-207,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k14 <= (
        0 => TO_SIGNED(-200,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k15 <= (
        0 => TO_SIGNED(-188,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k16 <= (
        0 => TO_SIGNED(-172,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k17 <= (
        0 => TO_SIGNED(-153,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k18 <= (
        0 => TO_SIGNED(-133,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k19 <= (
        0 => TO_SIGNED(-112,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k20 <= (
        0 => TO_SIGNED(-91,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k21 <= (
        0 => TO_SIGNED(-70,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k22 <= (
        0 => TO_SIGNED(-52,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k23 <= (
        0 => TO_SIGNED(-35,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k24 <= (
        0 => TO_SIGNED(-21,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k25 <= (
        0 => TO_SIGNED(-9,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k26 <= (
        0 => TO_SIGNED(0,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k27 <= (
        0 => TO_SIGNED(7,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k28 <= (
        0 => TO_SIGNED(13,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k29 <= (
        0 => TO_SIGNED(17,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k30 <= (
        0 => TO_SIGNED(19,11),
        others => (others => '0'));
    u0_m0_wo0_cma2_k31 <= (
        0 => TO_SIGNED(20,11),
        others => (others => '0'));
--altera synthesis_on
    u0_m0_wo0_cma2_r(0) <= u0_m0_wo0_cma2_k0(TO_INTEGER(u0_m0_wo0_cma2_c0(0)));
    u0_m0_wo0_cma2_r(1) <= u0_m0_wo0_cma2_k1(TO_INTEGER(u0_m0_wo0_cma2_c0(1)));
    u0_m0_wo0_cma2_r(2) <= u0_m0_wo0_cma2_k2(TO_INTEGER(u0_m0_wo0_cma2_c0(2)));
    u0_m0_wo0_cma2_r(3) <= u0_m0_wo0_cma2_k3(TO_INTEGER(u0_m0_wo0_cma2_c0(3)));
    u0_m0_wo0_cma2_r(4) <= u0_m0_wo0_cma2_k4(TO_INTEGER(u0_m0_wo0_cma2_c0(4)));
    u0_m0_wo0_cma2_r(5) <= u0_m0_wo0_cma2_k5(TO_INTEGER(u0_m0_wo0_cma2_c0(5)));
    u0_m0_wo0_cma2_r(6) <= u0_m0_wo0_cma2_k6(TO_INTEGER(u0_m0_wo0_cma2_c0(6)));
    u0_m0_wo0_cma2_r(7) <= u0_m0_wo0_cma2_k7(TO_INTEGER(u0_m0_wo0_cma2_c0(7)));
    u0_m0_wo0_cma2_r(8) <= u0_m0_wo0_cma2_k8(TO_INTEGER(u0_m0_wo0_cma2_c0(8)));
    u0_m0_wo0_cma2_r(9) <= u0_m0_wo0_cma2_k9(TO_INTEGER(u0_m0_wo0_cma2_c0(9)));
    u0_m0_wo0_cma2_r(10) <= u0_m0_wo0_cma2_k10(TO_INTEGER(u0_m0_wo0_cma2_c0(10)));
    u0_m0_wo0_cma2_r(11) <= u0_m0_wo0_cma2_k11(TO_INTEGER(u0_m0_wo0_cma2_c0(11)));
    u0_m0_wo0_cma2_r(12) <= u0_m0_wo0_cma2_k12(TO_INTEGER(u0_m0_wo0_cma2_c0(12)));
    u0_m0_wo0_cma2_r(13) <= u0_m0_wo0_cma2_k13(TO_INTEGER(u0_m0_wo0_cma2_c0(13)));
    u0_m0_wo0_cma2_r(14) <= u0_m0_wo0_cma2_k14(TO_INTEGER(u0_m0_wo0_cma2_c0(14)));
    u0_m0_wo0_cma2_r(15) <= u0_m0_wo0_cma2_k15(TO_INTEGER(u0_m0_wo0_cma2_c0(15)));
    u0_m0_wo0_cma2_r(16) <= u0_m0_wo0_cma2_k16(TO_INTEGER(u0_m0_wo0_cma2_c0(16)));
    u0_m0_wo0_cma2_r(17) <= u0_m0_wo0_cma2_k17(TO_INTEGER(u0_m0_wo0_cma2_c0(17)));
    u0_m0_wo0_cma2_r(18) <= u0_m0_wo0_cma2_k18(TO_INTEGER(u0_m0_wo0_cma2_c0(18)));
    u0_m0_wo0_cma2_r(19) <= u0_m0_wo0_cma2_k19(TO_INTEGER(u0_m0_wo0_cma2_c0(19)));
    u0_m0_wo0_cma2_r(20) <= u0_m0_wo0_cma2_k20(TO_INTEGER(u0_m0_wo0_cma2_c0(20)));
    u0_m0_wo0_cma2_r(21) <= u0_m0_wo0_cma2_k21(TO_INTEGER(u0_m0_wo0_cma2_c0(21)));
    u0_m0_wo0_cma2_r(22) <= u0_m0_wo0_cma2_k22(TO_INTEGER(u0_m0_wo0_cma2_c0(22)));
    u0_m0_wo0_cma2_r(23) <= u0_m0_wo0_cma2_k23(TO_INTEGER(u0_m0_wo0_cma2_c0(23)));
    u0_m0_wo0_cma2_r(24) <= u0_m0_wo0_cma2_k24(TO_INTEGER(u0_m0_wo0_cma2_c0(24)));
    u0_m0_wo0_cma2_r(25) <= u0_m0_wo0_cma2_k25(TO_INTEGER(u0_m0_wo0_cma2_c0(25)));
    u0_m0_wo0_cma2_r(26) <= u0_m0_wo0_cma2_k26(TO_INTEGER(u0_m0_wo0_cma2_c0(26)));
    u0_m0_wo0_cma2_r(27) <= u0_m0_wo0_cma2_k27(TO_INTEGER(u0_m0_wo0_cma2_c0(27)));
    u0_m0_wo0_cma2_r(28) <= u0_m0_wo0_cma2_k28(TO_INTEGER(u0_m0_wo0_cma2_c0(28)));
    u0_m0_wo0_cma2_r(29) <= u0_m0_wo0_cma2_k29(TO_INTEGER(u0_m0_wo0_cma2_c0(29)));
    u0_m0_wo0_cma2_r(30) <= u0_m0_wo0_cma2_k30(TO_INTEGER(u0_m0_wo0_cma2_c0(30)));
    u0_m0_wo0_cma2_r(31) <= u0_m0_wo0_cma2_k31(TO_INTEGER(u0_m0_wo0_cma2_c0(31)));
    u0_m0_wo0_cma2_p(0) <= u0_m0_wo0_cma2_a0(0) * u0_m0_wo0_cma2_r(0);
    u0_m0_wo0_cma2_p(1) <= u0_m0_wo0_cma2_a0(1) * u0_m0_wo0_cma2_r(1);
    u0_m0_wo0_cma2_p(2) <= u0_m0_wo0_cma2_a0(2) * u0_m0_wo0_cma2_r(2);
    u0_m0_wo0_cma2_p(3) <= u0_m0_wo0_cma2_a0(3) * u0_m0_wo0_cma2_r(3);
    u0_m0_wo0_cma2_p(4) <= u0_m0_wo0_cma2_a0(4) * u0_m0_wo0_cma2_r(4);
    u0_m0_wo0_cma2_p(5) <= u0_m0_wo0_cma2_a0(5) * u0_m0_wo0_cma2_r(5);
    u0_m0_wo0_cma2_p(6) <= u0_m0_wo0_cma2_a0(6) * u0_m0_wo0_cma2_r(6);
    u0_m0_wo0_cma2_p(7) <= u0_m0_wo0_cma2_a0(7) * u0_m0_wo0_cma2_r(7);
    u0_m0_wo0_cma2_p(8) <= u0_m0_wo0_cma2_a0(8) * u0_m0_wo0_cma2_r(8);
    u0_m0_wo0_cma2_p(9) <= u0_m0_wo0_cma2_a0(9) * u0_m0_wo0_cma2_r(9);
    u0_m0_wo0_cma2_p(10) <= u0_m0_wo0_cma2_a0(10) * u0_m0_wo0_cma2_r(10);
    u0_m0_wo0_cma2_p(11) <= u0_m0_wo0_cma2_a0(11) * u0_m0_wo0_cma2_r(11);
    u0_m0_wo0_cma2_p(12) <= u0_m0_wo0_cma2_a0(12) * u0_m0_wo0_cma2_r(12);
    u0_m0_wo0_cma2_p(13) <= u0_m0_wo0_cma2_a0(13) * u0_m0_wo0_cma2_r(13);
    u0_m0_wo0_cma2_p(14) <= u0_m0_wo0_cma2_a0(14) * u0_m0_wo0_cma2_r(14);
    u0_m0_wo0_cma2_p(15) <= u0_m0_wo0_cma2_a0(15) * u0_m0_wo0_cma2_r(15);
    u0_m0_wo0_cma2_p(16) <= u0_m0_wo0_cma2_a0(16) * u0_m0_wo0_cma2_r(16);
    u0_m0_wo0_cma2_p(17) <= u0_m0_wo0_cma2_a0(17) * u0_m0_wo0_cma2_r(17);
    u0_m0_wo0_cma2_p(18) <= u0_m0_wo0_cma2_a0(18) * u0_m0_wo0_cma2_r(18);
    u0_m0_wo0_cma2_p(19) <= u0_m0_wo0_cma2_a0(19) * u0_m0_wo0_cma2_r(19);
    u0_m0_wo0_cma2_p(20) <= u0_m0_wo0_cma2_a0(20) * u0_m0_wo0_cma2_r(20);
    u0_m0_wo0_cma2_p(21) <= u0_m0_wo0_cma2_a0(21) * u0_m0_wo0_cma2_r(21);
    u0_m0_wo0_cma2_p(22) <= u0_m0_wo0_cma2_a0(22) * u0_m0_wo0_cma2_r(22);
    u0_m0_wo0_cma2_p(23) <= u0_m0_wo0_cma2_a0(23) * u0_m0_wo0_cma2_r(23);
    u0_m0_wo0_cma2_p(24) <= u0_m0_wo0_cma2_a0(24) * u0_m0_wo0_cma2_r(24);
    u0_m0_wo0_cma2_p(25) <= u0_m0_wo0_cma2_a0(25) * u0_m0_wo0_cma2_r(25);
    u0_m0_wo0_cma2_p(26) <= u0_m0_wo0_cma2_a0(26) * u0_m0_wo0_cma2_r(26);
    u0_m0_wo0_cma2_p(27) <= u0_m0_wo0_cma2_a0(27) * u0_m0_wo0_cma2_r(27);
    u0_m0_wo0_cma2_p(28) <= u0_m0_wo0_cma2_a0(28) * u0_m0_wo0_cma2_r(28);
    u0_m0_wo0_cma2_p(29) <= u0_m0_wo0_cma2_a0(29) * u0_m0_wo0_cma2_r(29);
    u0_m0_wo0_cma2_p(30) <= u0_m0_wo0_cma2_a0(30) * u0_m0_wo0_cma2_r(30);
    u0_m0_wo0_cma2_p(31) <= u0_m0_wo0_cma2_a0(31) * u0_m0_wo0_cma2_r(31);
    u0_m0_wo0_cma2_u(0) <= RESIZE(u0_m0_wo0_cma2_p(0),28);
    u0_m0_wo0_cma2_u(1) <= RESIZE(u0_m0_wo0_cma2_p(1),28);
    u0_m0_wo0_cma2_u(2) <= RESIZE(u0_m0_wo0_cma2_p(2),28);
    u0_m0_wo0_cma2_u(3) <= RESIZE(u0_m0_wo0_cma2_p(3),28);
    u0_m0_wo0_cma2_u(4) <= RESIZE(u0_m0_wo0_cma2_p(4),28);
    u0_m0_wo0_cma2_u(5) <= RESIZE(u0_m0_wo0_cma2_p(5),28);
    u0_m0_wo0_cma2_u(6) <= RESIZE(u0_m0_wo0_cma2_p(6),28);
    u0_m0_wo0_cma2_u(7) <= RESIZE(u0_m0_wo0_cma2_p(7),28);
    u0_m0_wo0_cma2_u(8) <= RESIZE(u0_m0_wo0_cma2_p(8),28);
    u0_m0_wo0_cma2_u(9) <= RESIZE(u0_m0_wo0_cma2_p(9),28);
    u0_m0_wo0_cma2_u(10) <= RESIZE(u0_m0_wo0_cma2_p(10),28);
    u0_m0_wo0_cma2_u(11) <= RESIZE(u0_m0_wo0_cma2_p(11),28);
    u0_m0_wo0_cma2_u(12) <= RESIZE(u0_m0_wo0_cma2_p(12),28);
    u0_m0_wo0_cma2_u(13) <= RESIZE(u0_m0_wo0_cma2_p(13),28);
    u0_m0_wo0_cma2_u(14) <= RESIZE(u0_m0_wo0_cma2_p(14),28);
    u0_m0_wo0_cma2_u(15) <= RESIZE(u0_m0_wo0_cma2_p(15),28);
    u0_m0_wo0_cma2_u(16) <= RESIZE(u0_m0_wo0_cma2_p(16),28);
    u0_m0_wo0_cma2_u(17) <= RESIZE(u0_m0_wo0_cma2_p(17),28);
    u0_m0_wo0_cma2_u(18) <= RESIZE(u0_m0_wo0_cma2_p(18),28);
    u0_m0_wo0_cma2_u(19) <= RESIZE(u0_m0_wo0_cma2_p(19),28);
    u0_m0_wo0_cma2_u(20) <= RESIZE(u0_m0_wo0_cma2_p(20),28);
    u0_m0_wo0_cma2_u(21) <= RESIZE(u0_m0_wo0_cma2_p(21),28);
    u0_m0_wo0_cma2_u(22) <= RESIZE(u0_m0_wo0_cma2_p(22),28);
    u0_m0_wo0_cma2_u(23) <= RESIZE(u0_m0_wo0_cma2_p(23),28);
    u0_m0_wo0_cma2_u(24) <= RESIZE(u0_m0_wo0_cma2_p(24),28);
    u0_m0_wo0_cma2_u(25) <= RESIZE(u0_m0_wo0_cma2_p(25),28);
    u0_m0_wo0_cma2_u(26) <= RESIZE(u0_m0_wo0_cma2_p(26),28);
    u0_m0_wo0_cma2_u(27) <= RESIZE(u0_m0_wo0_cma2_p(27),28);
    u0_m0_wo0_cma2_u(28) <= RESIZE(u0_m0_wo0_cma2_p(28),28);
    u0_m0_wo0_cma2_u(29) <= RESIZE(u0_m0_wo0_cma2_p(29),28);
    u0_m0_wo0_cma2_u(30) <= RESIZE(u0_m0_wo0_cma2_p(30),28);
    u0_m0_wo0_cma2_u(31) <= RESIZE(u0_m0_wo0_cma2_p(31),28);
    u0_m0_wo0_cma2_w(0) <= u0_m0_wo0_cma2_u(0);
    u0_m0_wo0_cma2_w(1) <= u0_m0_wo0_cma2_u(1);
    u0_m0_wo0_cma2_w(2) <= u0_m0_wo0_cma2_u(2);
    u0_m0_wo0_cma2_w(3) <= u0_m0_wo0_cma2_u(3);
    u0_m0_wo0_cma2_w(4) <= u0_m0_wo0_cma2_u(4);
    u0_m0_wo0_cma2_w(5) <= u0_m0_wo0_cma2_u(5);
    u0_m0_wo0_cma2_w(6) <= u0_m0_wo0_cma2_u(6);
    u0_m0_wo0_cma2_w(7) <= u0_m0_wo0_cma2_u(7);
    u0_m0_wo0_cma2_w(8) <= u0_m0_wo0_cma2_u(8);
    u0_m0_wo0_cma2_w(9) <= u0_m0_wo0_cma2_u(9);
    u0_m0_wo0_cma2_w(10) <= u0_m0_wo0_cma2_u(10);
    u0_m0_wo0_cma2_w(11) <= u0_m0_wo0_cma2_u(11);
    u0_m0_wo0_cma2_w(12) <= u0_m0_wo0_cma2_u(12);
    u0_m0_wo0_cma2_w(13) <= u0_m0_wo0_cma2_u(13);
    u0_m0_wo0_cma2_w(14) <= u0_m0_wo0_cma2_u(14);
    u0_m0_wo0_cma2_w(15) <= u0_m0_wo0_cma2_u(15);
    u0_m0_wo0_cma2_w(16) <= u0_m0_wo0_cma2_u(16);
    u0_m0_wo0_cma2_w(17) <= u0_m0_wo0_cma2_u(17);
    u0_m0_wo0_cma2_w(18) <= u0_m0_wo0_cma2_u(18);
    u0_m0_wo0_cma2_w(19) <= u0_m0_wo0_cma2_u(19);
    u0_m0_wo0_cma2_w(20) <= u0_m0_wo0_cma2_u(20);
    u0_m0_wo0_cma2_w(21) <= u0_m0_wo0_cma2_u(21);
    u0_m0_wo0_cma2_w(22) <= u0_m0_wo0_cma2_u(22);
    u0_m0_wo0_cma2_w(23) <= u0_m0_wo0_cma2_u(23);
    u0_m0_wo0_cma2_w(24) <= u0_m0_wo0_cma2_u(24);
    u0_m0_wo0_cma2_w(25) <= u0_m0_wo0_cma2_u(25);
    u0_m0_wo0_cma2_w(26) <= u0_m0_wo0_cma2_u(26);
    u0_m0_wo0_cma2_w(27) <= u0_m0_wo0_cma2_u(27);
    u0_m0_wo0_cma2_w(28) <= u0_m0_wo0_cma2_u(28);
    u0_m0_wo0_cma2_w(29) <= u0_m0_wo0_cma2_u(29);
    u0_m0_wo0_cma2_w(30) <= u0_m0_wo0_cma2_u(30);
    u0_m0_wo0_cma2_w(31) <= u0_m0_wo0_cma2_u(31);
    u0_m0_wo0_cma2_x(0) <= u0_m0_wo0_cma2_w(0);
    u0_m0_wo0_cma2_x(1) <= u0_m0_wo0_cma2_w(1);
    u0_m0_wo0_cma2_x(2) <= u0_m0_wo0_cma2_w(2);
    u0_m0_wo0_cma2_x(3) <= u0_m0_wo0_cma2_w(3);
    u0_m0_wo0_cma2_x(4) <= u0_m0_wo0_cma2_w(4);
    u0_m0_wo0_cma2_x(5) <= u0_m0_wo0_cma2_w(5);
    u0_m0_wo0_cma2_x(6) <= u0_m0_wo0_cma2_w(6);
    u0_m0_wo0_cma2_x(7) <= u0_m0_wo0_cma2_w(7);
    u0_m0_wo0_cma2_x(8) <= u0_m0_wo0_cma2_w(8);
    u0_m0_wo0_cma2_x(9) <= u0_m0_wo0_cma2_w(9);
    u0_m0_wo0_cma2_x(10) <= u0_m0_wo0_cma2_w(10);
    u0_m0_wo0_cma2_x(11) <= u0_m0_wo0_cma2_w(11);
    u0_m0_wo0_cma2_x(12) <= u0_m0_wo0_cma2_w(12);
    u0_m0_wo0_cma2_x(13) <= u0_m0_wo0_cma2_w(13);
    u0_m0_wo0_cma2_x(14) <= u0_m0_wo0_cma2_w(14);
    u0_m0_wo0_cma2_x(15) <= u0_m0_wo0_cma2_w(15);
    u0_m0_wo0_cma2_x(16) <= u0_m0_wo0_cma2_w(16);
    u0_m0_wo0_cma2_x(17) <= u0_m0_wo0_cma2_w(17);
    u0_m0_wo0_cma2_x(18) <= u0_m0_wo0_cma2_w(18);
    u0_m0_wo0_cma2_x(19) <= u0_m0_wo0_cma2_w(19);
    u0_m0_wo0_cma2_x(20) <= u0_m0_wo0_cma2_w(20);
    u0_m0_wo0_cma2_x(21) <= u0_m0_wo0_cma2_w(21);
    u0_m0_wo0_cma2_x(22) <= u0_m0_wo0_cma2_w(22);
    u0_m0_wo0_cma2_x(23) <= u0_m0_wo0_cma2_w(23);
    u0_m0_wo0_cma2_x(24) <= u0_m0_wo0_cma2_w(24);
    u0_m0_wo0_cma2_x(25) <= u0_m0_wo0_cma2_w(25);
    u0_m0_wo0_cma2_x(26) <= u0_m0_wo0_cma2_w(26);
    u0_m0_wo0_cma2_x(27) <= u0_m0_wo0_cma2_w(27);
    u0_m0_wo0_cma2_x(28) <= u0_m0_wo0_cma2_w(28);
    u0_m0_wo0_cma2_x(29) <= u0_m0_wo0_cma2_w(29);
    u0_m0_wo0_cma2_x(30) <= u0_m0_wo0_cma2_w(30);
    u0_m0_wo0_cma2_x(31) <= u0_m0_wo0_cma2_w(31);
    u0_m0_wo0_cma2_y(0) <= u0_m0_wo0_cma2_s(1) + u0_m0_wo0_cma2_x(0);
    u0_m0_wo0_cma2_y(1) <= u0_m0_wo0_cma2_s(2) + u0_m0_wo0_cma2_x(1);
    u0_m0_wo0_cma2_y(2) <= u0_m0_wo0_cma2_s(3) + u0_m0_wo0_cma2_x(2);
    u0_m0_wo0_cma2_y(3) <= u0_m0_wo0_cma2_s(4) + u0_m0_wo0_cma2_x(3);
    u0_m0_wo0_cma2_y(4) <= u0_m0_wo0_cma2_s(5) + u0_m0_wo0_cma2_x(4);
    u0_m0_wo0_cma2_y(5) <= u0_m0_wo0_cma2_s(6) + u0_m0_wo0_cma2_x(5);
    u0_m0_wo0_cma2_y(6) <= u0_m0_wo0_cma2_s(7) + u0_m0_wo0_cma2_x(6);
    u0_m0_wo0_cma2_y(7) <= u0_m0_wo0_cma2_s(8) + u0_m0_wo0_cma2_x(7);
    u0_m0_wo0_cma2_y(8) <= u0_m0_wo0_cma2_s(9) + u0_m0_wo0_cma2_x(8);
    u0_m0_wo0_cma2_y(9) <= u0_m0_wo0_cma2_s(10) + u0_m0_wo0_cma2_x(9);
    u0_m0_wo0_cma2_y(10) <= u0_m0_wo0_cma2_s(11) + u0_m0_wo0_cma2_x(10);
    u0_m0_wo0_cma2_y(11) <= u0_m0_wo0_cma2_s(12) + u0_m0_wo0_cma2_x(11);
    u0_m0_wo0_cma2_y(12) <= u0_m0_wo0_cma2_s(13) + u0_m0_wo0_cma2_x(12);
    u0_m0_wo0_cma2_y(13) <= u0_m0_wo0_cma2_s(14) + u0_m0_wo0_cma2_x(13);
    u0_m0_wo0_cma2_y(14) <= u0_m0_wo0_cma2_s(15) + u0_m0_wo0_cma2_x(14);
    u0_m0_wo0_cma2_y(15) <= u0_m0_wo0_cma2_s(16) + u0_m0_wo0_cma2_x(15);
    u0_m0_wo0_cma2_y(16) <= u0_m0_wo0_cma2_s(17) + u0_m0_wo0_cma2_x(16);
    u0_m0_wo0_cma2_y(17) <= u0_m0_wo0_cma2_s(18) + u0_m0_wo0_cma2_x(17);
    u0_m0_wo0_cma2_y(18) <= u0_m0_wo0_cma2_s(19) + u0_m0_wo0_cma2_x(18);
    u0_m0_wo0_cma2_y(19) <= u0_m0_wo0_cma2_s(20) + u0_m0_wo0_cma2_x(19);
    u0_m0_wo0_cma2_y(20) <= u0_m0_wo0_cma2_s(21) + u0_m0_wo0_cma2_x(20);
    u0_m0_wo0_cma2_y(21) <= u0_m0_wo0_cma2_s(22) + u0_m0_wo0_cma2_x(21);
    u0_m0_wo0_cma2_y(22) <= u0_m0_wo0_cma2_s(23) + u0_m0_wo0_cma2_x(22);
    u0_m0_wo0_cma2_y(23) <= u0_m0_wo0_cma2_s(24) + u0_m0_wo0_cma2_x(23);
    u0_m0_wo0_cma2_y(24) <= u0_m0_wo0_cma2_s(25) + u0_m0_wo0_cma2_x(24);
    u0_m0_wo0_cma2_y(25) <= u0_m0_wo0_cma2_s(26) + u0_m0_wo0_cma2_x(25);
    u0_m0_wo0_cma2_y(26) <= u0_m0_wo0_cma2_s(27) + u0_m0_wo0_cma2_x(26);
    u0_m0_wo0_cma2_y(27) <= u0_m0_wo0_cma2_s(28) + u0_m0_wo0_cma2_x(27);
    u0_m0_wo0_cma2_y(28) <= u0_m0_wo0_cma2_s(29) + u0_m0_wo0_cma2_x(28);
    u0_m0_wo0_cma2_y(29) <= u0_m0_wo0_cma2_s(30) + u0_m0_wo0_cma2_x(29);
    u0_m0_wo0_cma2_y(30) <= u0_m0_wo0_cma2_s(31) + u0_m0_wo0_cma2_x(30);
    u0_m0_wo0_cma2_y(31) <= u0_m0_wo0_cma2_x(31);
    u0_m0_wo0_cma2_chainmultadd: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cma2_a0 <= (others => (others => '0'));
            u0_m0_wo0_cma2_c0 <= (others => (others => '0'));
            u0_m0_wo0_cma2_s <= (others => (others => '0'));
        ELSIF(clk'EVENT AND clk = '1') THEN
            IF (xIn_v = "1") THEN
                u0_m0_wo0_cma2_a0(0) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(1) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(2) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(3) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(4) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(5) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(6) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(7) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(8) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(9) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(10) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(11) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(12) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(13) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(14) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(15) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(16) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(17) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(18) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(19) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(20) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(21) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(22) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(23) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(24) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(25) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(26) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(27) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(28) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(29) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(30) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_a0(31) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_c),12);
                u0_m0_wo0_cma2_c0(0) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(1) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(2) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(3) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(4) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(5) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(6) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(7) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(8) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(9) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(10) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(11) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(12) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(13) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(14) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(15) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(16) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(17) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(18) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(19) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(20) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(21) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(22) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(23) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(24) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(25) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(26) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(27) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(28) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(29) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(30) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma2_c0(31) <= RESIZE(UNSIGNED(GND_q),3);
            END IF;
            IF (d_u0_m0_wo0_memread_q_11_q = "1") THEN
                u0_m0_wo0_cma2_s(0) <= u0_m0_wo0_cma2_y(0);
                u0_m0_wo0_cma2_s(1) <= u0_m0_wo0_cma2_y(1);
                u0_m0_wo0_cma2_s(2) <= u0_m0_wo0_cma2_y(2);
                u0_m0_wo0_cma2_s(3) <= u0_m0_wo0_cma2_y(3);
                u0_m0_wo0_cma2_s(4) <= u0_m0_wo0_cma2_y(4);
                u0_m0_wo0_cma2_s(5) <= u0_m0_wo0_cma2_y(5);
                u0_m0_wo0_cma2_s(6) <= u0_m0_wo0_cma2_y(6);
                u0_m0_wo0_cma2_s(7) <= u0_m0_wo0_cma2_y(7);
                u0_m0_wo0_cma2_s(8) <= u0_m0_wo0_cma2_y(8);
                u0_m0_wo0_cma2_s(9) <= u0_m0_wo0_cma2_y(9);
                u0_m0_wo0_cma2_s(10) <= u0_m0_wo0_cma2_y(10);
                u0_m0_wo0_cma2_s(11) <= u0_m0_wo0_cma2_y(11);
                u0_m0_wo0_cma2_s(12) <= u0_m0_wo0_cma2_y(12);
                u0_m0_wo0_cma2_s(13) <= u0_m0_wo0_cma2_y(13);
                u0_m0_wo0_cma2_s(14) <= u0_m0_wo0_cma2_y(14);
                u0_m0_wo0_cma2_s(15) <= u0_m0_wo0_cma2_y(15);
                u0_m0_wo0_cma2_s(16) <= u0_m0_wo0_cma2_y(16);
                u0_m0_wo0_cma2_s(17) <= u0_m0_wo0_cma2_y(17);
                u0_m0_wo0_cma2_s(18) <= u0_m0_wo0_cma2_y(18);
                u0_m0_wo0_cma2_s(19) <= u0_m0_wo0_cma2_y(19);
                u0_m0_wo0_cma2_s(20) <= u0_m0_wo0_cma2_y(20);
                u0_m0_wo0_cma2_s(21) <= u0_m0_wo0_cma2_y(21);
                u0_m0_wo0_cma2_s(22) <= u0_m0_wo0_cma2_y(22);
                u0_m0_wo0_cma2_s(23) <= u0_m0_wo0_cma2_y(23);
                u0_m0_wo0_cma2_s(24) <= u0_m0_wo0_cma2_y(24);
                u0_m0_wo0_cma2_s(25) <= u0_m0_wo0_cma2_y(25);
                u0_m0_wo0_cma2_s(26) <= u0_m0_wo0_cma2_y(26);
                u0_m0_wo0_cma2_s(27) <= u0_m0_wo0_cma2_y(27);
                u0_m0_wo0_cma2_s(28) <= u0_m0_wo0_cma2_y(28);
                u0_m0_wo0_cma2_s(29) <= u0_m0_wo0_cma2_y(29);
                u0_m0_wo0_cma2_s(30) <= u0_m0_wo0_cma2_y(30);
                u0_m0_wo0_cma2_s(31) <= u0_m0_wo0_cma2_y(31);
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_cma2_delay : dspba_delay
    GENERIC MAP (width => 28, depth => 0)
    PORT MAP (xin => STD_LOGIC_VECTOR(u0_m0_wo0_cma2_s(0)(27 downto 0)), xout => u0_m0_wo0_cma2_qq, clk => clk, aclr => areset);
    u0_m0_wo0_cma2_q <= STD_LOGIC_VECTOR(u0_m0_wo0_cma2_qq(27 downto 0));
    -- u0_m0_wo0_mtree_add0_1(ADD,214)@12
    u0_m0_wo0_mtree_add0_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((28 downto 28 => u0_m0_wo0_cma2_q(27)) & u0_m0_wo0_cma2_q));
    u0_m0_wo0_mtree_add0_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((28 downto 26 => u0_m0_wo0_cma3_q(25)) & u0_m0_wo0_cma3_q));
    u0_m0_wo0_mtree_add0_1: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_1_a) + SIGNED(u0_m0_wo0_mtree_add0_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_1_q <= u0_m0_wo0_mtree_add0_1_o(28 downto 0);

    -- u0_m0_wo0_cma1(CHAINMULTADD,210)@10
--altera synthesis_off
    u0_m0_wo0_cma1_k0 <= (
        0 => TO_SIGNED(164,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k1 <= (
        0 => TO_SIGNED(265,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k2 <= (
        0 => TO_SIGNED(376,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k3 <= (
        0 => TO_SIGNED(497,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k4 <= (
        0 => TO_SIGNED(627,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k5 <= (
        0 => TO_SIGNED(763,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k6 <= (
        0 => TO_SIGNED(904,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k7 <= (
        0 => TO_SIGNED(1046,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k8 <= (
        0 => TO_SIGNED(1188,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k9 <= (
        0 => TO_SIGNED(1327,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k10 <= (
        0 => TO_SIGNED(1461,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k11 <= (
        0 => TO_SIGNED(1586,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k12 <= (
        0 => TO_SIGNED(1700,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k13 <= (
        0 => TO_SIGNED(1801,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k14 <= (
        0 => TO_SIGNED(1887,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k15 <= (
        0 => TO_SIGNED(1956,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k16 <= (
        0 => TO_SIGNED(2006,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k17 <= (
        0 => TO_SIGNED(2036,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k18 <= (
        0 => TO_SIGNED(2047,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k19 <= (
        0 => TO_SIGNED(2036,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k20 <= (
        0 => TO_SIGNED(2006,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k21 <= (
        0 => TO_SIGNED(1956,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k22 <= (
        0 => TO_SIGNED(1887,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k23 <= (
        0 => TO_SIGNED(1801,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k24 <= (
        0 => TO_SIGNED(1700,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k25 <= (
        0 => TO_SIGNED(1586,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k26 <= (
        0 => TO_SIGNED(1461,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k27 <= (
        0 => TO_SIGNED(1327,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k28 <= (
        0 => TO_SIGNED(1188,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k29 <= (
        0 => TO_SIGNED(1046,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k30 <= (
        0 => TO_SIGNED(904,12),
        others => (others => '0'));
    u0_m0_wo0_cma1_k31 <= (
        0 => TO_SIGNED(763,12),
        others => (others => '0'));
--altera synthesis_on
    u0_m0_wo0_cma1_r(0) <= u0_m0_wo0_cma1_k0(TO_INTEGER(u0_m0_wo0_cma1_c0(0)));
    u0_m0_wo0_cma1_r(1) <= u0_m0_wo0_cma1_k1(TO_INTEGER(u0_m0_wo0_cma1_c0(1)));
    u0_m0_wo0_cma1_r(2) <= u0_m0_wo0_cma1_k2(TO_INTEGER(u0_m0_wo0_cma1_c0(2)));
    u0_m0_wo0_cma1_r(3) <= u0_m0_wo0_cma1_k3(TO_INTEGER(u0_m0_wo0_cma1_c0(3)));
    u0_m0_wo0_cma1_r(4) <= u0_m0_wo0_cma1_k4(TO_INTEGER(u0_m0_wo0_cma1_c0(4)));
    u0_m0_wo0_cma1_r(5) <= u0_m0_wo0_cma1_k5(TO_INTEGER(u0_m0_wo0_cma1_c0(5)));
    u0_m0_wo0_cma1_r(6) <= u0_m0_wo0_cma1_k6(TO_INTEGER(u0_m0_wo0_cma1_c0(6)));
    u0_m0_wo0_cma1_r(7) <= u0_m0_wo0_cma1_k7(TO_INTEGER(u0_m0_wo0_cma1_c0(7)));
    u0_m0_wo0_cma1_r(8) <= u0_m0_wo0_cma1_k8(TO_INTEGER(u0_m0_wo0_cma1_c0(8)));
    u0_m0_wo0_cma1_r(9) <= u0_m0_wo0_cma1_k9(TO_INTEGER(u0_m0_wo0_cma1_c0(9)));
    u0_m0_wo0_cma1_r(10) <= u0_m0_wo0_cma1_k10(TO_INTEGER(u0_m0_wo0_cma1_c0(10)));
    u0_m0_wo0_cma1_r(11) <= u0_m0_wo0_cma1_k11(TO_INTEGER(u0_m0_wo0_cma1_c0(11)));
    u0_m0_wo0_cma1_r(12) <= u0_m0_wo0_cma1_k12(TO_INTEGER(u0_m0_wo0_cma1_c0(12)));
    u0_m0_wo0_cma1_r(13) <= u0_m0_wo0_cma1_k13(TO_INTEGER(u0_m0_wo0_cma1_c0(13)));
    u0_m0_wo0_cma1_r(14) <= u0_m0_wo0_cma1_k14(TO_INTEGER(u0_m0_wo0_cma1_c0(14)));
    u0_m0_wo0_cma1_r(15) <= u0_m0_wo0_cma1_k15(TO_INTEGER(u0_m0_wo0_cma1_c0(15)));
    u0_m0_wo0_cma1_r(16) <= u0_m0_wo0_cma1_k16(TO_INTEGER(u0_m0_wo0_cma1_c0(16)));
    u0_m0_wo0_cma1_r(17) <= u0_m0_wo0_cma1_k17(TO_INTEGER(u0_m0_wo0_cma1_c0(17)));
    u0_m0_wo0_cma1_r(18) <= u0_m0_wo0_cma1_k18(TO_INTEGER(u0_m0_wo0_cma1_c0(18)));
    u0_m0_wo0_cma1_r(19) <= u0_m0_wo0_cma1_k19(TO_INTEGER(u0_m0_wo0_cma1_c0(19)));
    u0_m0_wo0_cma1_r(20) <= u0_m0_wo0_cma1_k20(TO_INTEGER(u0_m0_wo0_cma1_c0(20)));
    u0_m0_wo0_cma1_r(21) <= u0_m0_wo0_cma1_k21(TO_INTEGER(u0_m0_wo0_cma1_c0(21)));
    u0_m0_wo0_cma1_r(22) <= u0_m0_wo0_cma1_k22(TO_INTEGER(u0_m0_wo0_cma1_c0(22)));
    u0_m0_wo0_cma1_r(23) <= u0_m0_wo0_cma1_k23(TO_INTEGER(u0_m0_wo0_cma1_c0(23)));
    u0_m0_wo0_cma1_r(24) <= u0_m0_wo0_cma1_k24(TO_INTEGER(u0_m0_wo0_cma1_c0(24)));
    u0_m0_wo0_cma1_r(25) <= u0_m0_wo0_cma1_k25(TO_INTEGER(u0_m0_wo0_cma1_c0(25)));
    u0_m0_wo0_cma1_r(26) <= u0_m0_wo0_cma1_k26(TO_INTEGER(u0_m0_wo0_cma1_c0(26)));
    u0_m0_wo0_cma1_r(27) <= u0_m0_wo0_cma1_k27(TO_INTEGER(u0_m0_wo0_cma1_c0(27)));
    u0_m0_wo0_cma1_r(28) <= u0_m0_wo0_cma1_k28(TO_INTEGER(u0_m0_wo0_cma1_c0(28)));
    u0_m0_wo0_cma1_r(29) <= u0_m0_wo0_cma1_k29(TO_INTEGER(u0_m0_wo0_cma1_c0(29)));
    u0_m0_wo0_cma1_r(30) <= u0_m0_wo0_cma1_k30(TO_INTEGER(u0_m0_wo0_cma1_c0(30)));
    u0_m0_wo0_cma1_r(31) <= u0_m0_wo0_cma1_k31(TO_INTEGER(u0_m0_wo0_cma1_c0(31)));
    u0_m0_wo0_cma1_p(0) <= u0_m0_wo0_cma1_a0(0) * u0_m0_wo0_cma1_r(0);
    u0_m0_wo0_cma1_p(1) <= u0_m0_wo0_cma1_a0(1) * u0_m0_wo0_cma1_r(1);
    u0_m0_wo0_cma1_p(2) <= u0_m0_wo0_cma1_a0(2) * u0_m0_wo0_cma1_r(2);
    u0_m0_wo0_cma1_p(3) <= u0_m0_wo0_cma1_a0(3) * u0_m0_wo0_cma1_r(3);
    u0_m0_wo0_cma1_p(4) <= u0_m0_wo0_cma1_a0(4) * u0_m0_wo0_cma1_r(4);
    u0_m0_wo0_cma1_p(5) <= u0_m0_wo0_cma1_a0(5) * u0_m0_wo0_cma1_r(5);
    u0_m0_wo0_cma1_p(6) <= u0_m0_wo0_cma1_a0(6) * u0_m0_wo0_cma1_r(6);
    u0_m0_wo0_cma1_p(7) <= u0_m0_wo0_cma1_a0(7) * u0_m0_wo0_cma1_r(7);
    u0_m0_wo0_cma1_p(8) <= u0_m0_wo0_cma1_a0(8) * u0_m0_wo0_cma1_r(8);
    u0_m0_wo0_cma1_p(9) <= u0_m0_wo0_cma1_a0(9) * u0_m0_wo0_cma1_r(9);
    u0_m0_wo0_cma1_p(10) <= u0_m0_wo0_cma1_a0(10) * u0_m0_wo0_cma1_r(10);
    u0_m0_wo0_cma1_p(11) <= u0_m0_wo0_cma1_a0(11) * u0_m0_wo0_cma1_r(11);
    u0_m0_wo0_cma1_p(12) <= u0_m0_wo0_cma1_a0(12) * u0_m0_wo0_cma1_r(12);
    u0_m0_wo0_cma1_p(13) <= u0_m0_wo0_cma1_a0(13) * u0_m0_wo0_cma1_r(13);
    u0_m0_wo0_cma1_p(14) <= u0_m0_wo0_cma1_a0(14) * u0_m0_wo0_cma1_r(14);
    u0_m0_wo0_cma1_p(15) <= u0_m0_wo0_cma1_a0(15) * u0_m0_wo0_cma1_r(15);
    u0_m0_wo0_cma1_p(16) <= u0_m0_wo0_cma1_a0(16) * u0_m0_wo0_cma1_r(16);
    u0_m0_wo0_cma1_p(17) <= u0_m0_wo0_cma1_a0(17) * u0_m0_wo0_cma1_r(17);
    u0_m0_wo0_cma1_p(18) <= u0_m0_wo0_cma1_a0(18) * u0_m0_wo0_cma1_r(18);
    u0_m0_wo0_cma1_p(19) <= u0_m0_wo0_cma1_a0(19) * u0_m0_wo0_cma1_r(19);
    u0_m0_wo0_cma1_p(20) <= u0_m0_wo0_cma1_a0(20) * u0_m0_wo0_cma1_r(20);
    u0_m0_wo0_cma1_p(21) <= u0_m0_wo0_cma1_a0(21) * u0_m0_wo0_cma1_r(21);
    u0_m0_wo0_cma1_p(22) <= u0_m0_wo0_cma1_a0(22) * u0_m0_wo0_cma1_r(22);
    u0_m0_wo0_cma1_p(23) <= u0_m0_wo0_cma1_a0(23) * u0_m0_wo0_cma1_r(23);
    u0_m0_wo0_cma1_p(24) <= u0_m0_wo0_cma1_a0(24) * u0_m0_wo0_cma1_r(24);
    u0_m0_wo0_cma1_p(25) <= u0_m0_wo0_cma1_a0(25) * u0_m0_wo0_cma1_r(25);
    u0_m0_wo0_cma1_p(26) <= u0_m0_wo0_cma1_a0(26) * u0_m0_wo0_cma1_r(26);
    u0_m0_wo0_cma1_p(27) <= u0_m0_wo0_cma1_a0(27) * u0_m0_wo0_cma1_r(27);
    u0_m0_wo0_cma1_p(28) <= u0_m0_wo0_cma1_a0(28) * u0_m0_wo0_cma1_r(28);
    u0_m0_wo0_cma1_p(29) <= u0_m0_wo0_cma1_a0(29) * u0_m0_wo0_cma1_r(29);
    u0_m0_wo0_cma1_p(30) <= u0_m0_wo0_cma1_a0(30) * u0_m0_wo0_cma1_r(30);
    u0_m0_wo0_cma1_p(31) <= u0_m0_wo0_cma1_a0(31) * u0_m0_wo0_cma1_r(31);
    u0_m0_wo0_cma1_u(0) <= RESIZE(u0_m0_wo0_cma1_p(0),29);
    u0_m0_wo0_cma1_u(1) <= RESIZE(u0_m0_wo0_cma1_p(1),29);
    u0_m0_wo0_cma1_u(2) <= RESIZE(u0_m0_wo0_cma1_p(2),29);
    u0_m0_wo0_cma1_u(3) <= RESIZE(u0_m0_wo0_cma1_p(3),29);
    u0_m0_wo0_cma1_u(4) <= RESIZE(u0_m0_wo0_cma1_p(4),29);
    u0_m0_wo0_cma1_u(5) <= RESIZE(u0_m0_wo0_cma1_p(5),29);
    u0_m0_wo0_cma1_u(6) <= RESIZE(u0_m0_wo0_cma1_p(6),29);
    u0_m0_wo0_cma1_u(7) <= RESIZE(u0_m0_wo0_cma1_p(7),29);
    u0_m0_wo0_cma1_u(8) <= RESIZE(u0_m0_wo0_cma1_p(8),29);
    u0_m0_wo0_cma1_u(9) <= RESIZE(u0_m0_wo0_cma1_p(9),29);
    u0_m0_wo0_cma1_u(10) <= RESIZE(u0_m0_wo0_cma1_p(10),29);
    u0_m0_wo0_cma1_u(11) <= RESIZE(u0_m0_wo0_cma1_p(11),29);
    u0_m0_wo0_cma1_u(12) <= RESIZE(u0_m0_wo0_cma1_p(12),29);
    u0_m0_wo0_cma1_u(13) <= RESIZE(u0_m0_wo0_cma1_p(13),29);
    u0_m0_wo0_cma1_u(14) <= RESIZE(u0_m0_wo0_cma1_p(14),29);
    u0_m0_wo0_cma1_u(15) <= RESIZE(u0_m0_wo0_cma1_p(15),29);
    u0_m0_wo0_cma1_u(16) <= RESIZE(u0_m0_wo0_cma1_p(16),29);
    u0_m0_wo0_cma1_u(17) <= RESIZE(u0_m0_wo0_cma1_p(17),29);
    u0_m0_wo0_cma1_u(18) <= RESIZE(u0_m0_wo0_cma1_p(18),29);
    u0_m0_wo0_cma1_u(19) <= RESIZE(u0_m0_wo0_cma1_p(19),29);
    u0_m0_wo0_cma1_u(20) <= RESIZE(u0_m0_wo0_cma1_p(20),29);
    u0_m0_wo0_cma1_u(21) <= RESIZE(u0_m0_wo0_cma1_p(21),29);
    u0_m0_wo0_cma1_u(22) <= RESIZE(u0_m0_wo0_cma1_p(22),29);
    u0_m0_wo0_cma1_u(23) <= RESIZE(u0_m0_wo0_cma1_p(23),29);
    u0_m0_wo0_cma1_u(24) <= RESIZE(u0_m0_wo0_cma1_p(24),29);
    u0_m0_wo0_cma1_u(25) <= RESIZE(u0_m0_wo0_cma1_p(25),29);
    u0_m0_wo0_cma1_u(26) <= RESIZE(u0_m0_wo0_cma1_p(26),29);
    u0_m0_wo0_cma1_u(27) <= RESIZE(u0_m0_wo0_cma1_p(27),29);
    u0_m0_wo0_cma1_u(28) <= RESIZE(u0_m0_wo0_cma1_p(28),29);
    u0_m0_wo0_cma1_u(29) <= RESIZE(u0_m0_wo0_cma1_p(29),29);
    u0_m0_wo0_cma1_u(30) <= RESIZE(u0_m0_wo0_cma1_p(30),29);
    u0_m0_wo0_cma1_u(31) <= RESIZE(u0_m0_wo0_cma1_p(31),29);
    u0_m0_wo0_cma1_w(0) <= u0_m0_wo0_cma1_u(0);
    u0_m0_wo0_cma1_w(1) <= u0_m0_wo0_cma1_u(1);
    u0_m0_wo0_cma1_w(2) <= u0_m0_wo0_cma1_u(2);
    u0_m0_wo0_cma1_w(3) <= u0_m0_wo0_cma1_u(3);
    u0_m0_wo0_cma1_w(4) <= u0_m0_wo0_cma1_u(4);
    u0_m0_wo0_cma1_w(5) <= u0_m0_wo0_cma1_u(5);
    u0_m0_wo0_cma1_w(6) <= u0_m0_wo0_cma1_u(6);
    u0_m0_wo0_cma1_w(7) <= u0_m0_wo0_cma1_u(7);
    u0_m0_wo0_cma1_w(8) <= u0_m0_wo0_cma1_u(8);
    u0_m0_wo0_cma1_w(9) <= u0_m0_wo0_cma1_u(9);
    u0_m0_wo0_cma1_w(10) <= u0_m0_wo0_cma1_u(10);
    u0_m0_wo0_cma1_w(11) <= u0_m0_wo0_cma1_u(11);
    u0_m0_wo0_cma1_w(12) <= u0_m0_wo0_cma1_u(12);
    u0_m0_wo0_cma1_w(13) <= u0_m0_wo0_cma1_u(13);
    u0_m0_wo0_cma1_w(14) <= u0_m0_wo0_cma1_u(14);
    u0_m0_wo0_cma1_w(15) <= u0_m0_wo0_cma1_u(15);
    u0_m0_wo0_cma1_w(16) <= u0_m0_wo0_cma1_u(16);
    u0_m0_wo0_cma1_w(17) <= u0_m0_wo0_cma1_u(17);
    u0_m0_wo0_cma1_w(18) <= u0_m0_wo0_cma1_u(18);
    u0_m0_wo0_cma1_w(19) <= u0_m0_wo0_cma1_u(19);
    u0_m0_wo0_cma1_w(20) <= u0_m0_wo0_cma1_u(20);
    u0_m0_wo0_cma1_w(21) <= u0_m0_wo0_cma1_u(21);
    u0_m0_wo0_cma1_w(22) <= u0_m0_wo0_cma1_u(22);
    u0_m0_wo0_cma1_w(23) <= u0_m0_wo0_cma1_u(23);
    u0_m0_wo0_cma1_w(24) <= u0_m0_wo0_cma1_u(24);
    u0_m0_wo0_cma1_w(25) <= u0_m0_wo0_cma1_u(25);
    u0_m0_wo0_cma1_w(26) <= u0_m0_wo0_cma1_u(26);
    u0_m0_wo0_cma1_w(27) <= u0_m0_wo0_cma1_u(27);
    u0_m0_wo0_cma1_w(28) <= u0_m0_wo0_cma1_u(28);
    u0_m0_wo0_cma1_w(29) <= u0_m0_wo0_cma1_u(29);
    u0_m0_wo0_cma1_w(30) <= u0_m0_wo0_cma1_u(30);
    u0_m0_wo0_cma1_w(31) <= u0_m0_wo0_cma1_u(31);
    u0_m0_wo0_cma1_x(0) <= u0_m0_wo0_cma1_w(0);
    u0_m0_wo0_cma1_x(1) <= u0_m0_wo0_cma1_w(1);
    u0_m0_wo0_cma1_x(2) <= u0_m0_wo0_cma1_w(2);
    u0_m0_wo0_cma1_x(3) <= u0_m0_wo0_cma1_w(3);
    u0_m0_wo0_cma1_x(4) <= u0_m0_wo0_cma1_w(4);
    u0_m0_wo0_cma1_x(5) <= u0_m0_wo0_cma1_w(5);
    u0_m0_wo0_cma1_x(6) <= u0_m0_wo0_cma1_w(6);
    u0_m0_wo0_cma1_x(7) <= u0_m0_wo0_cma1_w(7);
    u0_m0_wo0_cma1_x(8) <= u0_m0_wo0_cma1_w(8);
    u0_m0_wo0_cma1_x(9) <= u0_m0_wo0_cma1_w(9);
    u0_m0_wo0_cma1_x(10) <= u0_m0_wo0_cma1_w(10);
    u0_m0_wo0_cma1_x(11) <= u0_m0_wo0_cma1_w(11);
    u0_m0_wo0_cma1_x(12) <= u0_m0_wo0_cma1_w(12);
    u0_m0_wo0_cma1_x(13) <= u0_m0_wo0_cma1_w(13);
    u0_m0_wo0_cma1_x(14) <= u0_m0_wo0_cma1_w(14);
    u0_m0_wo0_cma1_x(15) <= u0_m0_wo0_cma1_w(15);
    u0_m0_wo0_cma1_x(16) <= u0_m0_wo0_cma1_w(16);
    u0_m0_wo0_cma1_x(17) <= u0_m0_wo0_cma1_w(17);
    u0_m0_wo0_cma1_x(18) <= u0_m0_wo0_cma1_w(18);
    u0_m0_wo0_cma1_x(19) <= u0_m0_wo0_cma1_w(19);
    u0_m0_wo0_cma1_x(20) <= u0_m0_wo0_cma1_w(20);
    u0_m0_wo0_cma1_x(21) <= u0_m0_wo0_cma1_w(21);
    u0_m0_wo0_cma1_x(22) <= u0_m0_wo0_cma1_w(22);
    u0_m0_wo0_cma1_x(23) <= u0_m0_wo0_cma1_w(23);
    u0_m0_wo0_cma1_x(24) <= u0_m0_wo0_cma1_w(24);
    u0_m0_wo0_cma1_x(25) <= u0_m0_wo0_cma1_w(25);
    u0_m0_wo0_cma1_x(26) <= u0_m0_wo0_cma1_w(26);
    u0_m0_wo0_cma1_x(27) <= u0_m0_wo0_cma1_w(27);
    u0_m0_wo0_cma1_x(28) <= u0_m0_wo0_cma1_w(28);
    u0_m0_wo0_cma1_x(29) <= u0_m0_wo0_cma1_w(29);
    u0_m0_wo0_cma1_x(30) <= u0_m0_wo0_cma1_w(30);
    u0_m0_wo0_cma1_x(31) <= u0_m0_wo0_cma1_w(31);
    u0_m0_wo0_cma1_y(0) <= u0_m0_wo0_cma1_s(1) + u0_m0_wo0_cma1_x(0);
    u0_m0_wo0_cma1_y(1) <= u0_m0_wo0_cma1_s(2) + u0_m0_wo0_cma1_x(1);
    u0_m0_wo0_cma1_y(2) <= u0_m0_wo0_cma1_s(3) + u0_m0_wo0_cma1_x(2);
    u0_m0_wo0_cma1_y(3) <= u0_m0_wo0_cma1_s(4) + u0_m0_wo0_cma1_x(3);
    u0_m0_wo0_cma1_y(4) <= u0_m0_wo0_cma1_s(5) + u0_m0_wo0_cma1_x(4);
    u0_m0_wo0_cma1_y(5) <= u0_m0_wo0_cma1_s(6) + u0_m0_wo0_cma1_x(5);
    u0_m0_wo0_cma1_y(6) <= u0_m0_wo0_cma1_s(7) + u0_m0_wo0_cma1_x(6);
    u0_m0_wo0_cma1_y(7) <= u0_m0_wo0_cma1_s(8) + u0_m0_wo0_cma1_x(7);
    u0_m0_wo0_cma1_y(8) <= u0_m0_wo0_cma1_s(9) + u0_m0_wo0_cma1_x(8);
    u0_m0_wo0_cma1_y(9) <= u0_m0_wo0_cma1_s(10) + u0_m0_wo0_cma1_x(9);
    u0_m0_wo0_cma1_y(10) <= u0_m0_wo0_cma1_s(11) + u0_m0_wo0_cma1_x(10);
    u0_m0_wo0_cma1_y(11) <= u0_m0_wo0_cma1_s(12) + u0_m0_wo0_cma1_x(11);
    u0_m0_wo0_cma1_y(12) <= u0_m0_wo0_cma1_s(13) + u0_m0_wo0_cma1_x(12);
    u0_m0_wo0_cma1_y(13) <= u0_m0_wo0_cma1_s(14) + u0_m0_wo0_cma1_x(13);
    u0_m0_wo0_cma1_y(14) <= u0_m0_wo0_cma1_s(15) + u0_m0_wo0_cma1_x(14);
    u0_m0_wo0_cma1_y(15) <= u0_m0_wo0_cma1_s(16) + u0_m0_wo0_cma1_x(15);
    u0_m0_wo0_cma1_y(16) <= u0_m0_wo0_cma1_s(17) + u0_m0_wo0_cma1_x(16);
    u0_m0_wo0_cma1_y(17) <= u0_m0_wo0_cma1_s(18) + u0_m0_wo0_cma1_x(17);
    u0_m0_wo0_cma1_y(18) <= u0_m0_wo0_cma1_s(19) + u0_m0_wo0_cma1_x(18);
    u0_m0_wo0_cma1_y(19) <= u0_m0_wo0_cma1_s(20) + u0_m0_wo0_cma1_x(19);
    u0_m0_wo0_cma1_y(20) <= u0_m0_wo0_cma1_s(21) + u0_m0_wo0_cma1_x(20);
    u0_m0_wo0_cma1_y(21) <= u0_m0_wo0_cma1_s(22) + u0_m0_wo0_cma1_x(21);
    u0_m0_wo0_cma1_y(22) <= u0_m0_wo0_cma1_s(23) + u0_m0_wo0_cma1_x(22);
    u0_m0_wo0_cma1_y(23) <= u0_m0_wo0_cma1_s(24) + u0_m0_wo0_cma1_x(23);
    u0_m0_wo0_cma1_y(24) <= u0_m0_wo0_cma1_s(25) + u0_m0_wo0_cma1_x(24);
    u0_m0_wo0_cma1_y(25) <= u0_m0_wo0_cma1_s(26) + u0_m0_wo0_cma1_x(25);
    u0_m0_wo0_cma1_y(26) <= u0_m0_wo0_cma1_s(27) + u0_m0_wo0_cma1_x(26);
    u0_m0_wo0_cma1_y(27) <= u0_m0_wo0_cma1_s(28) + u0_m0_wo0_cma1_x(27);
    u0_m0_wo0_cma1_y(28) <= u0_m0_wo0_cma1_s(29) + u0_m0_wo0_cma1_x(28);
    u0_m0_wo0_cma1_y(29) <= u0_m0_wo0_cma1_s(30) + u0_m0_wo0_cma1_x(29);
    u0_m0_wo0_cma1_y(30) <= u0_m0_wo0_cma1_s(31) + u0_m0_wo0_cma1_x(30);
    u0_m0_wo0_cma1_y(31) <= u0_m0_wo0_cma1_x(31);
    u0_m0_wo0_cma1_chainmultadd: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cma1_a0 <= (others => (others => '0'));
            u0_m0_wo0_cma1_c0 <= (others => (others => '0'));
            u0_m0_wo0_cma1_s <= (others => (others => '0'));
        ELSIF(clk'EVENT AND clk = '1') THEN
            IF (xIn_v = "1") THEN
                u0_m0_wo0_cma1_a0(0) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(1) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(2) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(3) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(4) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(5) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(6) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(7) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(8) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(9) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(10) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(11) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(12) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(13) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(14) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(15) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(16) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(17) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(18) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(19) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(20) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(21) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(22) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(23) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(24) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(25) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(26) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(27) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(28) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(29) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(30) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_a0(31) <= RESIZE(SIGNED(u0_m0_wo0_wi0_split32_b),12);
                u0_m0_wo0_cma1_c0(0) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(1) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(2) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(3) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(4) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(5) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(6) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(7) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(8) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(9) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(10) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(11) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(12) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(13) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(14) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(15) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(16) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(17) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(18) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(19) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(20) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(21) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(22) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(23) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(24) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(25) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(26) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(27) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(28) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(29) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(30) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma1_c0(31) <= RESIZE(UNSIGNED(GND_q),3);
            END IF;
            IF (d_u0_m0_wo0_memread_q_11_q = "1") THEN
                u0_m0_wo0_cma1_s(0) <= u0_m0_wo0_cma1_y(0);
                u0_m0_wo0_cma1_s(1) <= u0_m0_wo0_cma1_y(1);
                u0_m0_wo0_cma1_s(2) <= u0_m0_wo0_cma1_y(2);
                u0_m0_wo0_cma1_s(3) <= u0_m0_wo0_cma1_y(3);
                u0_m0_wo0_cma1_s(4) <= u0_m0_wo0_cma1_y(4);
                u0_m0_wo0_cma1_s(5) <= u0_m0_wo0_cma1_y(5);
                u0_m0_wo0_cma1_s(6) <= u0_m0_wo0_cma1_y(6);
                u0_m0_wo0_cma1_s(7) <= u0_m0_wo0_cma1_y(7);
                u0_m0_wo0_cma1_s(8) <= u0_m0_wo0_cma1_y(8);
                u0_m0_wo0_cma1_s(9) <= u0_m0_wo0_cma1_y(9);
                u0_m0_wo0_cma1_s(10) <= u0_m0_wo0_cma1_y(10);
                u0_m0_wo0_cma1_s(11) <= u0_m0_wo0_cma1_y(11);
                u0_m0_wo0_cma1_s(12) <= u0_m0_wo0_cma1_y(12);
                u0_m0_wo0_cma1_s(13) <= u0_m0_wo0_cma1_y(13);
                u0_m0_wo0_cma1_s(14) <= u0_m0_wo0_cma1_y(14);
                u0_m0_wo0_cma1_s(15) <= u0_m0_wo0_cma1_y(15);
                u0_m0_wo0_cma1_s(16) <= u0_m0_wo0_cma1_y(16);
                u0_m0_wo0_cma1_s(17) <= u0_m0_wo0_cma1_y(17);
                u0_m0_wo0_cma1_s(18) <= u0_m0_wo0_cma1_y(18);
                u0_m0_wo0_cma1_s(19) <= u0_m0_wo0_cma1_y(19);
                u0_m0_wo0_cma1_s(20) <= u0_m0_wo0_cma1_y(20);
                u0_m0_wo0_cma1_s(21) <= u0_m0_wo0_cma1_y(21);
                u0_m0_wo0_cma1_s(22) <= u0_m0_wo0_cma1_y(22);
                u0_m0_wo0_cma1_s(23) <= u0_m0_wo0_cma1_y(23);
                u0_m0_wo0_cma1_s(24) <= u0_m0_wo0_cma1_y(24);
                u0_m0_wo0_cma1_s(25) <= u0_m0_wo0_cma1_y(25);
                u0_m0_wo0_cma1_s(26) <= u0_m0_wo0_cma1_y(26);
                u0_m0_wo0_cma1_s(27) <= u0_m0_wo0_cma1_y(27);
                u0_m0_wo0_cma1_s(28) <= u0_m0_wo0_cma1_y(28);
                u0_m0_wo0_cma1_s(29) <= u0_m0_wo0_cma1_y(29);
                u0_m0_wo0_cma1_s(30) <= u0_m0_wo0_cma1_y(30);
                u0_m0_wo0_cma1_s(31) <= u0_m0_wo0_cma1_y(31);
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_cma1_delay : dspba_delay
    GENERIC MAP (width => 29, depth => 0)
    PORT MAP (xin => STD_LOGIC_VECTOR(u0_m0_wo0_cma1_s(0)(28 downto 0)), xout => u0_m0_wo0_cma1_qq, clk => clk, aclr => areset);
    u0_m0_wo0_cma1_q <= STD_LOGIC_VECTOR(u0_m0_wo0_cma1_qq(28 downto 0));
    -- u0_m0_wo0_cma0(CHAINMULTADD,209)@10
--altera synthesis_off
    u0_m0_wo0_cma0_k0 <= (
        0 => TO_SIGNED(20,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k1 <= (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k2 <= (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k3 <= (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k4 <= (
        0 => TO_SIGNED(21,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k5 <= (
        0 => TO_SIGNED(20,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k6 <= (
        0 => TO_SIGNED(19,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k7 <= (
        0 => TO_SIGNED(17,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k8 <= (
        0 => TO_SIGNED(13,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k9 <= (
        0 => TO_SIGNED(7,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k10 <= (
        0 => TO_SIGNED(0,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k11 <= (
        0 => TO_SIGNED(-9,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k12 <= (
        0 => TO_SIGNED(-21,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k13 <= (
        0 => TO_SIGNED(-35,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k14 <= (
        0 => TO_SIGNED(-52,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k15 <= (
        0 => TO_SIGNED(-70,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k16 <= (
        0 => TO_SIGNED(-91,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k17 <= (
        0 => TO_SIGNED(-112,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k18 <= (
        0 => TO_SIGNED(-133,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k19 <= (
        0 => TO_SIGNED(-153,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k20 <= (
        0 => TO_SIGNED(-172,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k21 <= (
        0 => TO_SIGNED(-188,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k22 <= (
        0 => TO_SIGNED(-200,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k23 <= (
        0 => TO_SIGNED(-207,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k24 <= (
        0 => TO_SIGNED(-207,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k25 <= (
        0 => TO_SIGNED(-199,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k26 <= (
        0 => TO_SIGNED(-181,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k27 <= (
        0 => TO_SIGNED(-153,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k28 <= (
        0 => TO_SIGNED(-114,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k29 <= (
        0 => TO_SIGNED(-63,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k30 <= (
        0 => TO_SIGNED(0,11),
        others => (others => '0'));
    u0_m0_wo0_cma0_k31 <= (
        0 => TO_SIGNED(76,11),
        others => (others => '0'));
--altera synthesis_on
    u0_m0_wo0_cma0_r(0) <= u0_m0_wo0_cma0_k0(TO_INTEGER(u0_m0_wo0_cma0_c0(0)));
    u0_m0_wo0_cma0_r(1) <= u0_m0_wo0_cma0_k1(TO_INTEGER(u0_m0_wo0_cma0_c0(1)));
    u0_m0_wo0_cma0_r(2) <= u0_m0_wo0_cma0_k2(TO_INTEGER(u0_m0_wo0_cma0_c0(2)));
    u0_m0_wo0_cma0_r(3) <= u0_m0_wo0_cma0_k3(TO_INTEGER(u0_m0_wo0_cma0_c0(3)));
    u0_m0_wo0_cma0_r(4) <= u0_m0_wo0_cma0_k4(TO_INTEGER(u0_m0_wo0_cma0_c0(4)));
    u0_m0_wo0_cma0_r(5) <= u0_m0_wo0_cma0_k5(TO_INTEGER(u0_m0_wo0_cma0_c0(5)));
    u0_m0_wo0_cma0_r(6) <= u0_m0_wo0_cma0_k6(TO_INTEGER(u0_m0_wo0_cma0_c0(6)));
    u0_m0_wo0_cma0_r(7) <= u0_m0_wo0_cma0_k7(TO_INTEGER(u0_m0_wo0_cma0_c0(7)));
    u0_m0_wo0_cma0_r(8) <= u0_m0_wo0_cma0_k8(TO_INTEGER(u0_m0_wo0_cma0_c0(8)));
    u0_m0_wo0_cma0_r(9) <= u0_m0_wo0_cma0_k9(TO_INTEGER(u0_m0_wo0_cma0_c0(9)));
    u0_m0_wo0_cma0_r(10) <= u0_m0_wo0_cma0_k10(TO_INTEGER(u0_m0_wo0_cma0_c0(10)));
    u0_m0_wo0_cma0_r(11) <= u0_m0_wo0_cma0_k11(TO_INTEGER(u0_m0_wo0_cma0_c0(11)));
    u0_m0_wo0_cma0_r(12) <= u0_m0_wo0_cma0_k12(TO_INTEGER(u0_m0_wo0_cma0_c0(12)));
    u0_m0_wo0_cma0_r(13) <= u0_m0_wo0_cma0_k13(TO_INTEGER(u0_m0_wo0_cma0_c0(13)));
    u0_m0_wo0_cma0_r(14) <= u0_m0_wo0_cma0_k14(TO_INTEGER(u0_m0_wo0_cma0_c0(14)));
    u0_m0_wo0_cma0_r(15) <= u0_m0_wo0_cma0_k15(TO_INTEGER(u0_m0_wo0_cma0_c0(15)));
    u0_m0_wo0_cma0_r(16) <= u0_m0_wo0_cma0_k16(TO_INTEGER(u0_m0_wo0_cma0_c0(16)));
    u0_m0_wo0_cma0_r(17) <= u0_m0_wo0_cma0_k17(TO_INTEGER(u0_m0_wo0_cma0_c0(17)));
    u0_m0_wo0_cma0_r(18) <= u0_m0_wo0_cma0_k18(TO_INTEGER(u0_m0_wo0_cma0_c0(18)));
    u0_m0_wo0_cma0_r(19) <= u0_m0_wo0_cma0_k19(TO_INTEGER(u0_m0_wo0_cma0_c0(19)));
    u0_m0_wo0_cma0_r(20) <= u0_m0_wo0_cma0_k20(TO_INTEGER(u0_m0_wo0_cma0_c0(20)));
    u0_m0_wo0_cma0_r(21) <= u0_m0_wo0_cma0_k21(TO_INTEGER(u0_m0_wo0_cma0_c0(21)));
    u0_m0_wo0_cma0_r(22) <= u0_m0_wo0_cma0_k22(TO_INTEGER(u0_m0_wo0_cma0_c0(22)));
    u0_m0_wo0_cma0_r(23) <= u0_m0_wo0_cma0_k23(TO_INTEGER(u0_m0_wo0_cma0_c0(23)));
    u0_m0_wo0_cma0_r(24) <= u0_m0_wo0_cma0_k24(TO_INTEGER(u0_m0_wo0_cma0_c0(24)));
    u0_m0_wo0_cma0_r(25) <= u0_m0_wo0_cma0_k25(TO_INTEGER(u0_m0_wo0_cma0_c0(25)));
    u0_m0_wo0_cma0_r(26) <= u0_m0_wo0_cma0_k26(TO_INTEGER(u0_m0_wo0_cma0_c0(26)));
    u0_m0_wo0_cma0_r(27) <= u0_m0_wo0_cma0_k27(TO_INTEGER(u0_m0_wo0_cma0_c0(27)));
    u0_m0_wo0_cma0_r(28) <= u0_m0_wo0_cma0_k28(TO_INTEGER(u0_m0_wo0_cma0_c0(28)));
    u0_m0_wo0_cma0_r(29) <= u0_m0_wo0_cma0_k29(TO_INTEGER(u0_m0_wo0_cma0_c0(29)));
    u0_m0_wo0_cma0_r(30) <= u0_m0_wo0_cma0_k30(TO_INTEGER(u0_m0_wo0_cma0_c0(30)));
    u0_m0_wo0_cma0_r(31) <= u0_m0_wo0_cma0_k31(TO_INTEGER(u0_m0_wo0_cma0_c0(31)));
    u0_m0_wo0_cma0_p(0) <= u0_m0_wo0_cma0_a0(0) * u0_m0_wo0_cma0_r(0);
    u0_m0_wo0_cma0_p(1) <= u0_m0_wo0_cma0_a0(1) * u0_m0_wo0_cma0_r(1);
    u0_m0_wo0_cma0_p(2) <= u0_m0_wo0_cma0_a0(2) * u0_m0_wo0_cma0_r(2);
    u0_m0_wo0_cma0_p(3) <= u0_m0_wo0_cma0_a0(3) * u0_m0_wo0_cma0_r(3);
    u0_m0_wo0_cma0_p(4) <= u0_m0_wo0_cma0_a0(4) * u0_m0_wo0_cma0_r(4);
    u0_m0_wo0_cma0_p(5) <= u0_m0_wo0_cma0_a0(5) * u0_m0_wo0_cma0_r(5);
    u0_m0_wo0_cma0_p(6) <= u0_m0_wo0_cma0_a0(6) * u0_m0_wo0_cma0_r(6);
    u0_m0_wo0_cma0_p(7) <= u0_m0_wo0_cma0_a0(7) * u0_m0_wo0_cma0_r(7);
    u0_m0_wo0_cma0_p(8) <= u0_m0_wo0_cma0_a0(8) * u0_m0_wo0_cma0_r(8);
    u0_m0_wo0_cma0_p(9) <= u0_m0_wo0_cma0_a0(9) * u0_m0_wo0_cma0_r(9);
    u0_m0_wo0_cma0_p(10) <= u0_m0_wo0_cma0_a0(10) * u0_m0_wo0_cma0_r(10);
    u0_m0_wo0_cma0_p(11) <= u0_m0_wo0_cma0_a0(11) * u0_m0_wo0_cma0_r(11);
    u0_m0_wo0_cma0_p(12) <= u0_m0_wo0_cma0_a0(12) * u0_m0_wo0_cma0_r(12);
    u0_m0_wo0_cma0_p(13) <= u0_m0_wo0_cma0_a0(13) * u0_m0_wo0_cma0_r(13);
    u0_m0_wo0_cma0_p(14) <= u0_m0_wo0_cma0_a0(14) * u0_m0_wo0_cma0_r(14);
    u0_m0_wo0_cma0_p(15) <= u0_m0_wo0_cma0_a0(15) * u0_m0_wo0_cma0_r(15);
    u0_m0_wo0_cma0_p(16) <= u0_m0_wo0_cma0_a0(16) * u0_m0_wo0_cma0_r(16);
    u0_m0_wo0_cma0_p(17) <= u0_m0_wo0_cma0_a0(17) * u0_m0_wo0_cma0_r(17);
    u0_m0_wo0_cma0_p(18) <= u0_m0_wo0_cma0_a0(18) * u0_m0_wo0_cma0_r(18);
    u0_m0_wo0_cma0_p(19) <= u0_m0_wo0_cma0_a0(19) * u0_m0_wo0_cma0_r(19);
    u0_m0_wo0_cma0_p(20) <= u0_m0_wo0_cma0_a0(20) * u0_m0_wo0_cma0_r(20);
    u0_m0_wo0_cma0_p(21) <= u0_m0_wo0_cma0_a0(21) * u0_m0_wo0_cma0_r(21);
    u0_m0_wo0_cma0_p(22) <= u0_m0_wo0_cma0_a0(22) * u0_m0_wo0_cma0_r(22);
    u0_m0_wo0_cma0_p(23) <= u0_m0_wo0_cma0_a0(23) * u0_m0_wo0_cma0_r(23);
    u0_m0_wo0_cma0_p(24) <= u0_m0_wo0_cma0_a0(24) * u0_m0_wo0_cma0_r(24);
    u0_m0_wo0_cma0_p(25) <= u0_m0_wo0_cma0_a0(25) * u0_m0_wo0_cma0_r(25);
    u0_m0_wo0_cma0_p(26) <= u0_m0_wo0_cma0_a0(26) * u0_m0_wo0_cma0_r(26);
    u0_m0_wo0_cma0_p(27) <= u0_m0_wo0_cma0_a0(27) * u0_m0_wo0_cma0_r(27);
    u0_m0_wo0_cma0_p(28) <= u0_m0_wo0_cma0_a0(28) * u0_m0_wo0_cma0_r(28);
    u0_m0_wo0_cma0_p(29) <= u0_m0_wo0_cma0_a0(29) * u0_m0_wo0_cma0_r(29);
    u0_m0_wo0_cma0_p(30) <= u0_m0_wo0_cma0_a0(30) * u0_m0_wo0_cma0_r(30);
    u0_m0_wo0_cma0_p(31) <= u0_m0_wo0_cma0_a0(31) * u0_m0_wo0_cma0_r(31);
    u0_m0_wo0_cma0_u(0) <= RESIZE(u0_m0_wo0_cma0_p(0),28);
    u0_m0_wo0_cma0_u(1) <= RESIZE(u0_m0_wo0_cma0_p(1),28);
    u0_m0_wo0_cma0_u(2) <= RESIZE(u0_m0_wo0_cma0_p(2),28);
    u0_m0_wo0_cma0_u(3) <= RESIZE(u0_m0_wo0_cma0_p(3),28);
    u0_m0_wo0_cma0_u(4) <= RESIZE(u0_m0_wo0_cma0_p(4),28);
    u0_m0_wo0_cma0_u(5) <= RESIZE(u0_m0_wo0_cma0_p(5),28);
    u0_m0_wo0_cma0_u(6) <= RESIZE(u0_m0_wo0_cma0_p(6),28);
    u0_m0_wo0_cma0_u(7) <= RESIZE(u0_m0_wo0_cma0_p(7),28);
    u0_m0_wo0_cma0_u(8) <= RESIZE(u0_m0_wo0_cma0_p(8),28);
    u0_m0_wo0_cma0_u(9) <= RESIZE(u0_m0_wo0_cma0_p(9),28);
    u0_m0_wo0_cma0_u(10) <= RESIZE(u0_m0_wo0_cma0_p(10),28);
    u0_m0_wo0_cma0_u(11) <= RESIZE(u0_m0_wo0_cma0_p(11),28);
    u0_m0_wo0_cma0_u(12) <= RESIZE(u0_m0_wo0_cma0_p(12),28);
    u0_m0_wo0_cma0_u(13) <= RESIZE(u0_m0_wo0_cma0_p(13),28);
    u0_m0_wo0_cma0_u(14) <= RESIZE(u0_m0_wo0_cma0_p(14),28);
    u0_m0_wo0_cma0_u(15) <= RESIZE(u0_m0_wo0_cma0_p(15),28);
    u0_m0_wo0_cma0_u(16) <= RESIZE(u0_m0_wo0_cma0_p(16),28);
    u0_m0_wo0_cma0_u(17) <= RESIZE(u0_m0_wo0_cma0_p(17),28);
    u0_m0_wo0_cma0_u(18) <= RESIZE(u0_m0_wo0_cma0_p(18),28);
    u0_m0_wo0_cma0_u(19) <= RESIZE(u0_m0_wo0_cma0_p(19),28);
    u0_m0_wo0_cma0_u(20) <= RESIZE(u0_m0_wo0_cma0_p(20),28);
    u0_m0_wo0_cma0_u(21) <= RESIZE(u0_m0_wo0_cma0_p(21),28);
    u0_m0_wo0_cma0_u(22) <= RESIZE(u0_m0_wo0_cma0_p(22),28);
    u0_m0_wo0_cma0_u(23) <= RESIZE(u0_m0_wo0_cma0_p(23),28);
    u0_m0_wo0_cma0_u(24) <= RESIZE(u0_m0_wo0_cma0_p(24),28);
    u0_m0_wo0_cma0_u(25) <= RESIZE(u0_m0_wo0_cma0_p(25),28);
    u0_m0_wo0_cma0_u(26) <= RESIZE(u0_m0_wo0_cma0_p(26),28);
    u0_m0_wo0_cma0_u(27) <= RESIZE(u0_m0_wo0_cma0_p(27),28);
    u0_m0_wo0_cma0_u(28) <= RESIZE(u0_m0_wo0_cma0_p(28),28);
    u0_m0_wo0_cma0_u(29) <= RESIZE(u0_m0_wo0_cma0_p(29),28);
    u0_m0_wo0_cma0_u(30) <= RESIZE(u0_m0_wo0_cma0_p(30),28);
    u0_m0_wo0_cma0_u(31) <= RESIZE(u0_m0_wo0_cma0_p(31),28);
    u0_m0_wo0_cma0_w(0) <= u0_m0_wo0_cma0_u(0);
    u0_m0_wo0_cma0_w(1) <= u0_m0_wo0_cma0_u(1);
    u0_m0_wo0_cma0_w(2) <= u0_m0_wo0_cma0_u(2);
    u0_m0_wo0_cma0_w(3) <= u0_m0_wo0_cma0_u(3);
    u0_m0_wo0_cma0_w(4) <= u0_m0_wo0_cma0_u(4);
    u0_m0_wo0_cma0_w(5) <= u0_m0_wo0_cma0_u(5);
    u0_m0_wo0_cma0_w(6) <= u0_m0_wo0_cma0_u(6);
    u0_m0_wo0_cma0_w(7) <= u0_m0_wo0_cma0_u(7);
    u0_m0_wo0_cma0_w(8) <= u0_m0_wo0_cma0_u(8);
    u0_m0_wo0_cma0_w(9) <= u0_m0_wo0_cma0_u(9);
    u0_m0_wo0_cma0_w(10) <= u0_m0_wo0_cma0_u(10);
    u0_m0_wo0_cma0_w(11) <= u0_m0_wo0_cma0_u(11);
    u0_m0_wo0_cma0_w(12) <= u0_m0_wo0_cma0_u(12);
    u0_m0_wo0_cma0_w(13) <= u0_m0_wo0_cma0_u(13);
    u0_m0_wo0_cma0_w(14) <= u0_m0_wo0_cma0_u(14);
    u0_m0_wo0_cma0_w(15) <= u0_m0_wo0_cma0_u(15);
    u0_m0_wo0_cma0_w(16) <= u0_m0_wo0_cma0_u(16);
    u0_m0_wo0_cma0_w(17) <= u0_m0_wo0_cma0_u(17);
    u0_m0_wo0_cma0_w(18) <= u0_m0_wo0_cma0_u(18);
    u0_m0_wo0_cma0_w(19) <= u0_m0_wo0_cma0_u(19);
    u0_m0_wo0_cma0_w(20) <= u0_m0_wo0_cma0_u(20);
    u0_m0_wo0_cma0_w(21) <= u0_m0_wo0_cma0_u(21);
    u0_m0_wo0_cma0_w(22) <= u0_m0_wo0_cma0_u(22);
    u0_m0_wo0_cma0_w(23) <= u0_m0_wo0_cma0_u(23);
    u0_m0_wo0_cma0_w(24) <= u0_m0_wo0_cma0_u(24);
    u0_m0_wo0_cma0_w(25) <= u0_m0_wo0_cma0_u(25);
    u0_m0_wo0_cma0_w(26) <= u0_m0_wo0_cma0_u(26);
    u0_m0_wo0_cma0_w(27) <= u0_m0_wo0_cma0_u(27);
    u0_m0_wo0_cma0_w(28) <= u0_m0_wo0_cma0_u(28);
    u0_m0_wo0_cma0_w(29) <= u0_m0_wo0_cma0_u(29);
    u0_m0_wo0_cma0_w(30) <= u0_m0_wo0_cma0_u(30);
    u0_m0_wo0_cma0_w(31) <= u0_m0_wo0_cma0_u(31);
    u0_m0_wo0_cma0_x(0) <= u0_m0_wo0_cma0_w(0);
    u0_m0_wo0_cma0_x(1) <= u0_m0_wo0_cma0_w(1);
    u0_m0_wo0_cma0_x(2) <= u0_m0_wo0_cma0_w(2);
    u0_m0_wo0_cma0_x(3) <= u0_m0_wo0_cma0_w(3);
    u0_m0_wo0_cma0_x(4) <= u0_m0_wo0_cma0_w(4);
    u0_m0_wo0_cma0_x(5) <= u0_m0_wo0_cma0_w(5);
    u0_m0_wo0_cma0_x(6) <= u0_m0_wo0_cma0_w(6);
    u0_m0_wo0_cma0_x(7) <= u0_m0_wo0_cma0_w(7);
    u0_m0_wo0_cma0_x(8) <= u0_m0_wo0_cma0_w(8);
    u0_m0_wo0_cma0_x(9) <= u0_m0_wo0_cma0_w(9);
    u0_m0_wo0_cma0_x(10) <= u0_m0_wo0_cma0_w(10);
    u0_m0_wo0_cma0_x(11) <= u0_m0_wo0_cma0_w(11);
    u0_m0_wo0_cma0_x(12) <= u0_m0_wo0_cma0_w(12);
    u0_m0_wo0_cma0_x(13) <= u0_m0_wo0_cma0_w(13);
    u0_m0_wo0_cma0_x(14) <= u0_m0_wo0_cma0_w(14);
    u0_m0_wo0_cma0_x(15) <= u0_m0_wo0_cma0_w(15);
    u0_m0_wo0_cma0_x(16) <= u0_m0_wo0_cma0_w(16);
    u0_m0_wo0_cma0_x(17) <= u0_m0_wo0_cma0_w(17);
    u0_m0_wo0_cma0_x(18) <= u0_m0_wo0_cma0_w(18);
    u0_m0_wo0_cma0_x(19) <= u0_m0_wo0_cma0_w(19);
    u0_m0_wo0_cma0_x(20) <= u0_m0_wo0_cma0_w(20);
    u0_m0_wo0_cma0_x(21) <= u0_m0_wo0_cma0_w(21);
    u0_m0_wo0_cma0_x(22) <= u0_m0_wo0_cma0_w(22);
    u0_m0_wo0_cma0_x(23) <= u0_m0_wo0_cma0_w(23);
    u0_m0_wo0_cma0_x(24) <= u0_m0_wo0_cma0_w(24);
    u0_m0_wo0_cma0_x(25) <= u0_m0_wo0_cma0_w(25);
    u0_m0_wo0_cma0_x(26) <= u0_m0_wo0_cma0_w(26);
    u0_m0_wo0_cma0_x(27) <= u0_m0_wo0_cma0_w(27);
    u0_m0_wo0_cma0_x(28) <= u0_m0_wo0_cma0_w(28);
    u0_m0_wo0_cma0_x(29) <= u0_m0_wo0_cma0_w(29);
    u0_m0_wo0_cma0_x(30) <= u0_m0_wo0_cma0_w(30);
    u0_m0_wo0_cma0_x(31) <= u0_m0_wo0_cma0_w(31);
    u0_m0_wo0_cma0_y(0) <= u0_m0_wo0_cma0_s(1) + u0_m0_wo0_cma0_x(0);
    u0_m0_wo0_cma0_y(1) <= u0_m0_wo0_cma0_s(2) + u0_m0_wo0_cma0_x(1);
    u0_m0_wo0_cma0_y(2) <= u0_m0_wo0_cma0_s(3) + u0_m0_wo0_cma0_x(2);
    u0_m0_wo0_cma0_y(3) <= u0_m0_wo0_cma0_s(4) + u0_m0_wo0_cma0_x(3);
    u0_m0_wo0_cma0_y(4) <= u0_m0_wo0_cma0_s(5) + u0_m0_wo0_cma0_x(4);
    u0_m0_wo0_cma0_y(5) <= u0_m0_wo0_cma0_s(6) + u0_m0_wo0_cma0_x(5);
    u0_m0_wo0_cma0_y(6) <= u0_m0_wo0_cma0_s(7) + u0_m0_wo0_cma0_x(6);
    u0_m0_wo0_cma0_y(7) <= u0_m0_wo0_cma0_s(8) + u0_m0_wo0_cma0_x(7);
    u0_m0_wo0_cma0_y(8) <= u0_m0_wo0_cma0_s(9) + u0_m0_wo0_cma0_x(8);
    u0_m0_wo0_cma0_y(9) <= u0_m0_wo0_cma0_s(10) + u0_m0_wo0_cma0_x(9);
    u0_m0_wo0_cma0_y(10) <= u0_m0_wo0_cma0_s(11) + u0_m0_wo0_cma0_x(10);
    u0_m0_wo0_cma0_y(11) <= u0_m0_wo0_cma0_s(12) + u0_m0_wo0_cma0_x(11);
    u0_m0_wo0_cma0_y(12) <= u0_m0_wo0_cma0_s(13) + u0_m0_wo0_cma0_x(12);
    u0_m0_wo0_cma0_y(13) <= u0_m0_wo0_cma0_s(14) + u0_m0_wo0_cma0_x(13);
    u0_m0_wo0_cma0_y(14) <= u0_m0_wo0_cma0_s(15) + u0_m0_wo0_cma0_x(14);
    u0_m0_wo0_cma0_y(15) <= u0_m0_wo0_cma0_s(16) + u0_m0_wo0_cma0_x(15);
    u0_m0_wo0_cma0_y(16) <= u0_m0_wo0_cma0_s(17) + u0_m0_wo0_cma0_x(16);
    u0_m0_wo0_cma0_y(17) <= u0_m0_wo0_cma0_s(18) + u0_m0_wo0_cma0_x(17);
    u0_m0_wo0_cma0_y(18) <= u0_m0_wo0_cma0_s(19) + u0_m0_wo0_cma0_x(18);
    u0_m0_wo0_cma0_y(19) <= u0_m0_wo0_cma0_s(20) + u0_m0_wo0_cma0_x(19);
    u0_m0_wo0_cma0_y(20) <= u0_m0_wo0_cma0_s(21) + u0_m0_wo0_cma0_x(20);
    u0_m0_wo0_cma0_y(21) <= u0_m0_wo0_cma0_s(22) + u0_m0_wo0_cma0_x(21);
    u0_m0_wo0_cma0_y(22) <= u0_m0_wo0_cma0_s(23) + u0_m0_wo0_cma0_x(22);
    u0_m0_wo0_cma0_y(23) <= u0_m0_wo0_cma0_s(24) + u0_m0_wo0_cma0_x(23);
    u0_m0_wo0_cma0_y(24) <= u0_m0_wo0_cma0_s(25) + u0_m0_wo0_cma0_x(24);
    u0_m0_wo0_cma0_y(25) <= u0_m0_wo0_cma0_s(26) + u0_m0_wo0_cma0_x(25);
    u0_m0_wo0_cma0_y(26) <= u0_m0_wo0_cma0_s(27) + u0_m0_wo0_cma0_x(26);
    u0_m0_wo0_cma0_y(27) <= u0_m0_wo0_cma0_s(28) + u0_m0_wo0_cma0_x(27);
    u0_m0_wo0_cma0_y(28) <= u0_m0_wo0_cma0_s(29) + u0_m0_wo0_cma0_x(28);
    u0_m0_wo0_cma0_y(29) <= u0_m0_wo0_cma0_s(30) + u0_m0_wo0_cma0_x(29);
    u0_m0_wo0_cma0_y(30) <= u0_m0_wo0_cma0_s(31) + u0_m0_wo0_cma0_x(30);
    u0_m0_wo0_cma0_y(31) <= u0_m0_wo0_cma0_x(31);
    u0_m0_wo0_cma0_chainmultadd: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cma0_a0 <= (others => (others => '0'));
            u0_m0_wo0_cma0_c0 <= (others => (others => '0'));
            u0_m0_wo0_cma0_s <= (others => (others => '0'));
        ELSIF(clk'EVENT AND clk = '1') THEN
            IF (xIn_v = "1") THEN
                u0_m0_wo0_cma0_a0(0) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(1) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(2) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(3) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(4) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(5) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(6) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(7) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(8) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(9) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(10) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(11) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(12) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(13) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(14) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(15) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(16) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(17) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(18) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(19) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(20) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(21) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(22) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(23) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(24) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(25) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(26) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(27) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(28) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(29) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(30) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_a0(31) <= RESIZE(SIGNED(xIn_0),12);
                u0_m0_wo0_cma0_c0(0) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(1) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(2) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(3) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(4) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(5) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(6) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(7) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(8) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(9) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(10) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(11) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(12) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(13) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(14) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(15) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(16) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(17) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(18) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(19) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(20) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(21) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(22) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(23) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(24) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(25) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(26) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(27) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(28) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(29) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(30) <= RESIZE(UNSIGNED(GND_q),3);
                u0_m0_wo0_cma0_c0(31) <= RESIZE(UNSIGNED(GND_q),3);
            END IF;
            IF (d_u0_m0_wo0_memread_q_11_q = "1") THEN
                u0_m0_wo0_cma0_s(0) <= u0_m0_wo0_cma0_y(0);
                u0_m0_wo0_cma0_s(1) <= u0_m0_wo0_cma0_y(1);
                u0_m0_wo0_cma0_s(2) <= u0_m0_wo0_cma0_y(2);
                u0_m0_wo0_cma0_s(3) <= u0_m0_wo0_cma0_y(3);
                u0_m0_wo0_cma0_s(4) <= u0_m0_wo0_cma0_y(4);
                u0_m0_wo0_cma0_s(5) <= u0_m0_wo0_cma0_y(5);
                u0_m0_wo0_cma0_s(6) <= u0_m0_wo0_cma0_y(6);
                u0_m0_wo0_cma0_s(7) <= u0_m0_wo0_cma0_y(7);
                u0_m0_wo0_cma0_s(8) <= u0_m0_wo0_cma0_y(8);
                u0_m0_wo0_cma0_s(9) <= u0_m0_wo0_cma0_y(9);
                u0_m0_wo0_cma0_s(10) <= u0_m0_wo0_cma0_y(10);
                u0_m0_wo0_cma0_s(11) <= u0_m0_wo0_cma0_y(11);
                u0_m0_wo0_cma0_s(12) <= u0_m0_wo0_cma0_y(12);
                u0_m0_wo0_cma0_s(13) <= u0_m0_wo0_cma0_y(13);
                u0_m0_wo0_cma0_s(14) <= u0_m0_wo0_cma0_y(14);
                u0_m0_wo0_cma0_s(15) <= u0_m0_wo0_cma0_y(15);
                u0_m0_wo0_cma0_s(16) <= u0_m0_wo0_cma0_y(16);
                u0_m0_wo0_cma0_s(17) <= u0_m0_wo0_cma0_y(17);
                u0_m0_wo0_cma0_s(18) <= u0_m0_wo0_cma0_y(18);
                u0_m0_wo0_cma0_s(19) <= u0_m0_wo0_cma0_y(19);
                u0_m0_wo0_cma0_s(20) <= u0_m0_wo0_cma0_y(20);
                u0_m0_wo0_cma0_s(21) <= u0_m0_wo0_cma0_y(21);
                u0_m0_wo0_cma0_s(22) <= u0_m0_wo0_cma0_y(22);
                u0_m0_wo0_cma0_s(23) <= u0_m0_wo0_cma0_y(23);
                u0_m0_wo0_cma0_s(24) <= u0_m0_wo0_cma0_y(24);
                u0_m0_wo0_cma0_s(25) <= u0_m0_wo0_cma0_y(25);
                u0_m0_wo0_cma0_s(26) <= u0_m0_wo0_cma0_y(26);
                u0_m0_wo0_cma0_s(27) <= u0_m0_wo0_cma0_y(27);
                u0_m0_wo0_cma0_s(28) <= u0_m0_wo0_cma0_y(28);
                u0_m0_wo0_cma0_s(29) <= u0_m0_wo0_cma0_y(29);
                u0_m0_wo0_cma0_s(30) <= u0_m0_wo0_cma0_y(30);
                u0_m0_wo0_cma0_s(31) <= u0_m0_wo0_cma0_y(31);
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_cma0_delay : dspba_delay
    GENERIC MAP (width => 28, depth => 0)
    PORT MAP (xin => STD_LOGIC_VECTOR(u0_m0_wo0_cma0_s(0)(27 downto 0)), xout => u0_m0_wo0_cma0_qq, clk => clk, aclr => areset);
    u0_m0_wo0_cma0_q <= STD_LOGIC_VECTOR(u0_m0_wo0_cma0_qq(27 downto 0));
    -- u0_m0_wo0_mtree_add0_0(ADD,213)@12
    u0_m0_wo0_mtree_add0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 28 => u0_m0_wo0_cma0_q(27)) & u0_m0_wo0_cma0_q));
    u0_m0_wo0_mtree_add0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 29 => u0_m0_wo0_cma1_q(28)) & u0_m0_wo0_cma1_q));
    u0_m0_wo0_mtree_add0_0: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_0_a) + SIGNED(u0_m0_wo0_mtree_add0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_0_q <= u0_m0_wo0_mtree_add0_0_o(29 downto 0);

    -- u0_m0_wo0_mtree_add1_0(ADD,215)@13
    u0_m0_wo0_mtree_add1_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 30 => u0_m0_wo0_mtree_add0_0_q(29)) & u0_m0_wo0_mtree_add0_0_q));
    u0_m0_wo0_mtree_add1_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 29 => u0_m0_wo0_mtree_add0_1_q(28)) & u0_m0_wo0_mtree_add0_1_q));
    u0_m0_wo0_mtree_add1_0: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_0_a) + SIGNED(u0_m0_wo0_mtree_add1_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_0_q <= u0_m0_wo0_mtree_add1_0_o(30 downto 0);

    -- GND(CONSTANT,0)@0
    GND_q <= "0";

    -- d_u0_m0_wo0_memread_q_13(DELAY,221)@11
    d_u0_m0_wo0_memread_q_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2 )
    PORT MAP ( xin => d_u0_m0_wo0_memread_q_11_q, xout => d_u0_m0_wo0_memread_q_13_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_oseq_gated_reg(REG,216)@13
    u0_m0_wo0_oseq_gated_reg: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= STD_LOGIC_VECTOR(d_u0_m0_wo0_memread_q_13_q);
        END IF;
    END PROCESS;

    -- xOut(PORTOUT,219)@14
    xOut_v <= u0_m0_wo0_oseq_gated_reg_q;
    xOut_c <= STD_LOGIC_VECTOR("0000000" & GND_q);
    xOut_0 <= u0_m0_wo0_mtree_add1_0_q;

END normal;
