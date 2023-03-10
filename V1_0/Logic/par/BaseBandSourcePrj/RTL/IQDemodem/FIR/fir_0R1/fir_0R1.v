// -------------------------------------------------------------
//
// Module: fir_0R1
//
// Generated by MATLAB(R) 7.13 and the Filter Design HDL Coder 2.9.
//
// Generated on: 2015-10-25 16:26:56
//
// -------------------------------------------------------------

// -------------------------------------------------------------
// HDL Code Generation Options:
//
// TargetDirectory: G:\FPGAPROJECT\FIR_DATA_FROM_MATLAB\fir_0R1
// Name: fir_0R1
// TargetLanguage: Verilog
// TestBenchStimulus: impulse step ramp chirp noise 
// GenerateHDLTestBench: off

// -------------------------------------------------------------
// HDL Implementation    : Fully parallel
// Multipliers           : 51
// Folding Factor        : 1
// -------------------------------------------------------------
// Filter Settings:
//
// Discrete-Time FIR Filter (real)
// -------------------------------
// Filter Structure  : Direct-Form FIR
// Filter Length     : 51
// Stable            : Yes
// Linear Phase      : Yes (Type 1)
// Arithmetic        : fixed
// Numerator         : s12,13 -> [-2.500000e-001 2.500000e-001)
// Input             : s12,12 -> [-5.000000e-001 5.000000e-001)
// Filter Internals  : Full Precision
//   Output          : s26,25 -> [-1 1)  (auto determined)
//   Product         : s23,25 -> [-1.250000e-001 1.250000e-001)  (auto determined)
//   Accumulator     : s26,25 -> [-1 1)  (auto determined)
//   Round Mode      : No rounding
//   Overflow Mode   : No overflow
// -------------------------------------------------------------
`timescale 1 ns / 1 ns

module fir_0R1
               (
                clk,
                clk_enable,
                reset,
                filter_in,
                filter_out
                );

  input   clk; 
  input   clk_enable; 
  input   reset; 
  input   signed [11:0] filter_in; //sfix12_En12
  output  signed [25:0] filter_out; //sfix26_En25

////////////////////////////////////////////////////////////////
//Module Architecture: fir_0R1
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  parameter signed [11:0] coeff1 = 12'b000000000010; //sfix12_En13
  parameter signed [11:0] coeff2 = 12'b000000000101; //sfix12_En13
  parameter signed [11:0] coeff3 = 12'b000000001001; //sfix12_En13
  parameter signed [11:0] coeff4 = 12'b000000001110; //sfix12_En13
  parameter signed [11:0] coeff5 = 12'b000000010011; //sfix12_En13
  parameter signed [11:0] coeff6 = 12'b000000010101; //sfix12_En13
  parameter signed [11:0] coeff7 = 12'b000000010011; //sfix12_En13
  parameter signed [11:0] coeff8 = 12'b000000001001; //sfix12_En13
  parameter signed [11:0] coeff9 = 12'b111111110110; //sfix12_En13
  parameter signed [11:0] coeff10 = 12'b111111011010; //sfix12_En13
  parameter signed [11:0] coeff11 = 12'b111110110101; //sfix12_En13
  parameter signed [11:0] coeff12 = 12'b111110001011; //sfix12_En13
  parameter signed [11:0] coeff13 = 12'b111101100010; //sfix12_En13
  parameter signed [11:0] coeff14 = 12'b111101000011; //sfix12_En13
  parameter signed [11:0] coeff15 = 12'b111100111000; //sfix12_En13
  parameter signed [11:0] coeff16 = 12'b111101001001; //sfix12_En13
  parameter signed [11:0] coeff17 = 12'b111101111110; //sfix12_En13
  parameter signed [11:0] coeff18 = 12'b111111011010; //sfix12_En13
  parameter signed [11:0] coeff19 = 12'b000001011110; //sfix12_En13
  parameter signed [11:0] coeff20 = 12'b000100000001; //sfix12_En13
  parameter signed [11:0] coeff21 = 12'b000110110111; //sfix12_En13
  parameter signed [11:0] coeff22 = 12'b001001110010; //sfix12_En13
  parameter signed [11:0] coeff23 = 12'b001100011101; //sfix12_En13
  parameter signed [11:0] coeff24 = 12'b001110101000; //sfix12_En13
  parameter signed [11:0] coeff25 = 12'b010000000010; //sfix12_En13
  parameter signed [11:0] coeff26 = 12'b010000100001; //sfix12_En13
  parameter signed [11:0] coeff27 = 12'b010000000010; //sfix12_En13
  parameter signed [11:0] coeff28 = 12'b001110101000; //sfix12_En13
  parameter signed [11:0] coeff29 = 12'b001100011101; //sfix12_En13
  parameter signed [11:0] coeff30 = 12'b001001110010; //sfix12_En13
  parameter signed [11:0] coeff31 = 12'b000110110111; //sfix12_En13
  parameter signed [11:0] coeff32 = 12'b000100000001; //sfix12_En13
  parameter signed [11:0] coeff33 = 12'b000001011110; //sfix12_En13
  parameter signed [11:0] coeff34 = 12'b111111011010; //sfix12_En13
  parameter signed [11:0] coeff35 = 12'b111101111110; //sfix12_En13
  parameter signed [11:0] coeff36 = 12'b111101001001; //sfix12_En13
  parameter signed [11:0] coeff37 = 12'b111100111000; //sfix12_En13
  parameter signed [11:0] coeff38 = 12'b111101000011; //sfix12_En13
  parameter signed [11:0] coeff39 = 12'b111101100010; //sfix12_En13
  parameter signed [11:0] coeff40 = 12'b111110001011; //sfix12_En13
  parameter signed [11:0] coeff41 = 12'b111110110101; //sfix12_En13
  parameter signed [11:0] coeff42 = 12'b111111011010; //sfix12_En13
  parameter signed [11:0] coeff43 = 12'b111111110110; //sfix12_En13
  parameter signed [11:0] coeff44 = 12'b000000001001; //sfix12_En13
  parameter signed [11:0] coeff45 = 12'b000000010011; //sfix12_En13
  parameter signed [11:0] coeff46 = 12'b000000010101; //sfix12_En13
  parameter signed [11:0] coeff47 = 12'b000000010011; //sfix12_En13
  parameter signed [11:0] coeff48 = 12'b000000001110; //sfix12_En13
  parameter signed [11:0] coeff49 = 12'b000000001001; //sfix12_En13
  parameter signed [11:0] coeff50 = 12'b000000000101; //sfix12_En13
  parameter signed [11:0] coeff51 = 12'b000000000010; //sfix12_En13

  // Signals
  reg  signed [11:0] delay_pipeline [0:50] ; // sfix12_En12
  wire signed [22:0] product51; // sfix23_En25
  wire signed [22:0] product50; // sfix23_En25
  wire signed [23:0] mul_temp; // sfix24_En25
  wire signed [22:0] product49; // sfix23_En25
  wire signed [23:0] mul_temp_1; // sfix24_En25
  wire signed [22:0] product48; // sfix23_En25
  wire signed [23:0] mul_temp_2; // sfix24_En25
  wire signed [22:0] product47; // sfix23_En25
  wire signed [23:0] mul_temp_3; // sfix24_En25
  wire signed [22:0] product46; // sfix23_En25
  wire signed [23:0] mul_temp_4; // sfix24_En25
  wire signed [22:0] product45; // sfix23_En25
  wire signed [23:0] mul_temp_5; // sfix24_En25
  wire signed [22:0] product44; // sfix23_En25
  wire signed [23:0] mul_temp_6; // sfix24_En25
  wire signed [22:0] product43; // sfix23_En25
  wire signed [23:0] mul_temp_7; // sfix24_En25
  wire signed [22:0] product42; // sfix23_En25
  wire signed [23:0] mul_temp_8; // sfix24_En25
  wire signed [22:0] product41; // sfix23_En25
  wire signed [23:0] mul_temp_9; // sfix24_En25
  wire signed [22:0] product40; // sfix23_En25
  wire signed [23:0] mul_temp_10; // sfix24_En25
  wire signed [22:0] product39; // sfix23_En25
  wire signed [23:0] mul_temp_11; // sfix24_En25
  wire signed [22:0] product38; // sfix23_En25
  wire signed [23:0] mul_temp_12; // sfix24_En25
  wire signed [22:0] product37; // sfix23_En25
  wire signed [23:0] mul_temp_13; // sfix24_En25
  wire signed [22:0] product36; // sfix23_En25
  wire signed [23:0] mul_temp_14; // sfix24_En25
  wire signed [22:0] product35; // sfix23_En25
  wire signed [23:0] mul_temp_15; // sfix24_En25
  wire signed [22:0] product34; // sfix23_En25
  wire signed [23:0] mul_temp_16; // sfix24_En25
  wire signed [22:0] product33; // sfix23_En25
  wire signed [23:0] mul_temp_17; // sfix24_En25
  wire signed [22:0] product32; // sfix23_En25
  wire signed [23:0] mul_temp_18; // sfix24_En25
  wire signed [22:0] product31; // sfix23_En25
  wire signed [23:0] mul_temp_19; // sfix24_En25
  wire signed [22:0] product30; // sfix23_En25
  wire signed [23:0] mul_temp_20; // sfix24_En25
  wire signed [22:0] product29; // sfix23_En25
  wire signed [23:0] mul_temp_21; // sfix24_En25
  wire signed [22:0] product28; // sfix23_En25
  wire signed [23:0] mul_temp_22; // sfix24_En25
  wire signed [22:0] product27; // sfix23_En25
  wire signed [23:0] mul_temp_23; // sfix24_En25
  wire signed [22:0] product26; // sfix23_En25
  wire signed [23:0] mul_temp_24; // sfix24_En25
  wire signed [22:0] product25; // sfix23_En25
  wire signed [23:0] mul_temp_25; // sfix24_En25
  wire signed [22:0] product24; // sfix23_En25
  wire signed [23:0] mul_temp_26; // sfix24_En25
  wire signed [22:0] product23; // sfix23_En25
  wire signed [23:0] mul_temp_27; // sfix24_En25
  wire signed [22:0] product22; // sfix23_En25
  wire signed [23:0] mul_temp_28; // sfix24_En25
  wire signed [22:0] product21; // sfix23_En25
  wire signed [23:0] mul_temp_29; // sfix24_En25
  wire signed [22:0] product20; // sfix23_En25
  wire signed [23:0] mul_temp_30; // sfix24_En25
  wire signed [22:0] product19; // sfix23_En25
  wire signed [23:0] mul_temp_31; // sfix24_En25
  wire signed [22:0] product18; // sfix23_En25
  wire signed [23:0] mul_temp_32; // sfix24_En25
  wire signed [22:0] product17; // sfix23_En25
  wire signed [23:0] mul_temp_33; // sfix24_En25
  wire signed [22:0] product16; // sfix23_En25
  wire signed [23:0] mul_temp_34; // sfix24_En25
  wire signed [22:0] product15; // sfix23_En25
  wire signed [23:0] mul_temp_35; // sfix24_En25
  wire signed [22:0] product14; // sfix23_En25
  wire signed [23:0] mul_temp_36; // sfix24_En25
  wire signed [22:0] product13; // sfix23_En25
  wire signed [23:0] mul_temp_37; // sfix24_En25
  wire signed [22:0] product12; // sfix23_En25
  wire signed [23:0] mul_temp_38; // sfix24_En25
  wire signed [22:0] product11; // sfix23_En25
  wire signed [23:0] mul_temp_39; // sfix24_En25
  wire signed [22:0] product10; // sfix23_En25
  wire signed [23:0] mul_temp_40; // sfix24_En25
  wire signed [22:0] product9; // sfix23_En25
  wire signed [23:0] mul_temp_41; // sfix24_En25
  wire signed [22:0] product8; // sfix23_En25
  wire signed [23:0] mul_temp_42; // sfix24_En25
  wire signed [22:0] product7; // sfix23_En25
  wire signed [23:0] mul_temp_43; // sfix24_En25
  wire signed [22:0] product6; // sfix23_En25
  wire signed [23:0] mul_temp_44; // sfix24_En25
  wire signed [22:0] product5; // sfix23_En25
  wire signed [23:0] mul_temp_45; // sfix24_En25
  wire signed [22:0] product4; // sfix23_En25
  wire signed [23:0] mul_temp_46; // sfix24_En25
  wire signed [22:0] product3; // sfix23_En25
  wire signed [23:0] mul_temp_47; // sfix24_En25
  wire signed [22:0] product2; // sfix23_En25
  wire signed [23:0] mul_temp_48; // sfix24_En25
  wire signed [25:0] product1_cast; // sfix26_En25
  wire signed [22:0] product1; // sfix23_En25
  wire signed [25:0] sum1; // sfix26_En25
  wire signed [25:0] add_signext; // sfix26_En25
  wire signed [25:0] add_signext_1; // sfix26_En25
  wire signed [26:0] add_temp; // sfix27_En25
  wire signed [25:0] sum2; // sfix26_En25
  wire signed [25:0] add_signext_2; // sfix26_En25
  wire signed [25:0] add_signext_3; // sfix26_En25
  wire signed [26:0] add_temp_1; // sfix27_En25
  wire signed [25:0] sum3; // sfix26_En25
  wire signed [25:0] add_signext_4; // sfix26_En25
  wire signed [25:0] add_signext_5; // sfix26_En25
  wire signed [26:0] add_temp_2; // sfix27_En25
  wire signed [25:0] sum4; // sfix26_En25
  wire signed [25:0] add_signext_6; // sfix26_En25
  wire signed [25:0] add_signext_7; // sfix26_En25
  wire signed [26:0] add_temp_3; // sfix27_En25
  wire signed [25:0] sum5; // sfix26_En25
  wire signed [25:0] add_signext_8; // sfix26_En25
  wire signed [25:0] add_signext_9; // sfix26_En25
  wire signed [26:0] add_temp_4; // sfix27_En25
  wire signed [25:0] sum6; // sfix26_En25
  wire signed [25:0] add_signext_10; // sfix26_En25
  wire signed [25:0] add_signext_11; // sfix26_En25
  wire signed [26:0] add_temp_5; // sfix27_En25
  wire signed [25:0] sum7; // sfix26_En25
  wire signed [25:0] add_signext_12; // sfix26_En25
  wire signed [25:0] add_signext_13; // sfix26_En25
  wire signed [26:0] add_temp_6; // sfix27_En25
  wire signed [25:0] sum8; // sfix26_En25
  wire signed [25:0] add_signext_14; // sfix26_En25
  wire signed [25:0] add_signext_15; // sfix26_En25
  wire signed [26:0] add_temp_7; // sfix27_En25
  wire signed [25:0] sum9; // sfix26_En25
  wire signed [25:0] add_signext_16; // sfix26_En25
  wire signed [25:0] add_signext_17; // sfix26_En25
  wire signed [26:0] add_temp_8; // sfix27_En25
  wire signed [25:0] sum10; // sfix26_En25
  wire signed [25:0] add_signext_18; // sfix26_En25
  wire signed [25:0] add_signext_19; // sfix26_En25
  wire signed [26:0] add_temp_9; // sfix27_En25
  wire signed [25:0] sum11; // sfix26_En25
  wire signed [25:0] add_signext_20; // sfix26_En25
  wire signed [25:0] add_signext_21; // sfix26_En25
  wire signed [26:0] add_temp_10; // sfix27_En25
  wire signed [25:0] sum12; // sfix26_En25
  wire signed [25:0] add_signext_22; // sfix26_En25
  wire signed [25:0] add_signext_23; // sfix26_En25
  wire signed [26:0] add_temp_11; // sfix27_En25
  wire signed [25:0] sum13; // sfix26_En25
  wire signed [25:0] add_signext_24; // sfix26_En25
  wire signed [25:0] add_signext_25; // sfix26_En25
  wire signed [26:0] add_temp_12; // sfix27_En25
  wire signed [25:0] sum14; // sfix26_En25
  wire signed [25:0] add_signext_26; // sfix26_En25
  wire signed [25:0] add_signext_27; // sfix26_En25
  wire signed [26:0] add_temp_13; // sfix27_En25
  wire signed [25:0] sum15; // sfix26_En25
  wire signed [25:0] add_signext_28; // sfix26_En25
  wire signed [25:0] add_signext_29; // sfix26_En25
  wire signed [26:0] add_temp_14; // sfix27_En25
  wire signed [25:0] sum16; // sfix26_En25
  wire signed [25:0] add_signext_30; // sfix26_En25
  wire signed [25:0] add_signext_31; // sfix26_En25
  wire signed [26:0] add_temp_15; // sfix27_En25
  wire signed [25:0] sum17; // sfix26_En25
  wire signed [25:0] add_signext_32; // sfix26_En25
  wire signed [25:0] add_signext_33; // sfix26_En25
  wire signed [26:0] add_temp_16; // sfix27_En25
  wire signed [25:0] sum18; // sfix26_En25
  wire signed [25:0] add_signext_34; // sfix26_En25
  wire signed [25:0] add_signext_35; // sfix26_En25
  wire signed [26:0] add_temp_17; // sfix27_En25
  wire signed [25:0] sum19; // sfix26_En25
  wire signed [25:0] add_signext_36; // sfix26_En25
  wire signed [25:0] add_signext_37; // sfix26_En25
  wire signed [26:0] add_temp_18; // sfix27_En25
  wire signed [25:0] sum20; // sfix26_En25
  wire signed [25:0] add_signext_38; // sfix26_En25
  wire signed [25:0] add_signext_39; // sfix26_En25
  wire signed [26:0] add_temp_19; // sfix27_En25
  wire signed [25:0] sum21; // sfix26_En25
  wire signed [25:0] add_signext_40; // sfix26_En25
  wire signed [25:0] add_signext_41; // sfix26_En25
  wire signed [26:0] add_temp_20; // sfix27_En25
  wire signed [25:0] sum22; // sfix26_En25
  wire signed [25:0] add_signext_42; // sfix26_En25
  wire signed [25:0] add_signext_43; // sfix26_En25
  wire signed [26:0] add_temp_21; // sfix27_En25
  wire signed [25:0] sum23; // sfix26_En25
  wire signed [25:0] add_signext_44; // sfix26_En25
  wire signed [25:0] add_signext_45; // sfix26_En25
  wire signed [26:0] add_temp_22; // sfix27_En25
  wire signed [25:0] sum24; // sfix26_En25
  wire signed [25:0] add_signext_46; // sfix26_En25
  wire signed [25:0] add_signext_47; // sfix26_En25
  wire signed [26:0] add_temp_23; // sfix27_En25
  wire signed [25:0] sum25; // sfix26_En25
  wire signed [25:0] add_signext_48; // sfix26_En25
  wire signed [25:0] add_signext_49; // sfix26_En25
  wire signed [26:0] add_temp_24; // sfix27_En25
  wire signed [25:0] sum26; // sfix26_En25
  wire signed [25:0] add_signext_50; // sfix26_En25
  wire signed [25:0] add_signext_51; // sfix26_En25
  wire signed [26:0] add_temp_25; // sfix27_En25
  wire signed [25:0] sum27; // sfix26_En25
  wire signed [25:0] add_signext_52; // sfix26_En25
  wire signed [25:0] add_signext_53; // sfix26_En25
  wire signed [26:0] add_temp_26; // sfix27_En25
  wire signed [25:0] sum28; // sfix26_En25
  wire signed [25:0] add_signext_54; // sfix26_En25
  wire signed [25:0] add_signext_55; // sfix26_En25
  wire signed [26:0] add_temp_27; // sfix27_En25
  wire signed [25:0] sum29; // sfix26_En25
  wire signed [25:0] add_signext_56; // sfix26_En25
  wire signed [25:0] add_signext_57; // sfix26_En25
  wire signed [26:0] add_temp_28; // sfix27_En25
  wire signed [25:0] sum30; // sfix26_En25
  wire signed [25:0] add_signext_58; // sfix26_En25
  wire signed [25:0] add_signext_59; // sfix26_En25
  wire signed [26:0] add_temp_29; // sfix27_En25
  wire signed [25:0] sum31; // sfix26_En25
  wire signed [25:0] add_signext_60; // sfix26_En25
  wire signed [25:0] add_signext_61; // sfix26_En25
  wire signed [26:0] add_temp_30; // sfix27_En25
  wire signed [25:0] sum32; // sfix26_En25
  wire signed [25:0] add_signext_62; // sfix26_En25
  wire signed [25:0] add_signext_63; // sfix26_En25
  wire signed [26:0] add_temp_31; // sfix27_En25
  wire signed [25:0] sum33; // sfix26_En25
  wire signed [25:0] add_signext_64; // sfix26_En25
  wire signed [25:0] add_signext_65; // sfix26_En25
  wire signed [26:0] add_temp_32; // sfix27_En25
  wire signed [25:0] sum34; // sfix26_En25
  wire signed [25:0] add_signext_66; // sfix26_En25
  wire signed [25:0] add_signext_67; // sfix26_En25
  wire signed [26:0] add_temp_33; // sfix27_En25
  wire signed [25:0] sum35; // sfix26_En25
  wire signed [25:0] add_signext_68; // sfix26_En25
  wire signed [25:0] add_signext_69; // sfix26_En25
  wire signed [26:0] add_temp_34; // sfix27_En25
  wire signed [25:0] sum36; // sfix26_En25
  wire signed [25:0] add_signext_70; // sfix26_En25
  wire signed [25:0] add_signext_71; // sfix26_En25
  wire signed [26:0] add_temp_35; // sfix27_En25
  wire signed [25:0] sum37; // sfix26_En25
  wire signed [25:0] add_signext_72; // sfix26_En25
  wire signed [25:0] add_signext_73; // sfix26_En25
  wire signed [26:0] add_temp_36; // sfix27_En25
  wire signed [25:0] sum38; // sfix26_En25
  wire signed [25:0] add_signext_74; // sfix26_En25
  wire signed [25:0] add_signext_75; // sfix26_En25
  wire signed [26:0] add_temp_37; // sfix27_En25
  wire signed [25:0] sum39; // sfix26_En25
  wire signed [25:0] add_signext_76; // sfix26_En25
  wire signed [25:0] add_signext_77; // sfix26_En25
  wire signed [26:0] add_temp_38; // sfix27_En25
  wire signed [25:0] sum40; // sfix26_En25
  wire signed [25:0] add_signext_78; // sfix26_En25
  wire signed [25:0] add_signext_79; // sfix26_En25
  wire signed [26:0] add_temp_39; // sfix27_En25
  wire signed [25:0] sum41; // sfix26_En25
  wire signed [25:0] add_signext_80; // sfix26_En25
  wire signed [25:0] add_signext_81; // sfix26_En25
  wire signed [26:0] add_temp_40; // sfix27_En25
  wire signed [25:0] sum42; // sfix26_En25
  wire signed [25:0] add_signext_82; // sfix26_En25
  wire signed [25:0] add_signext_83; // sfix26_En25
  wire signed [26:0] add_temp_41; // sfix27_En25
  wire signed [25:0] sum43; // sfix26_En25
  wire signed [25:0] add_signext_84; // sfix26_En25
  wire signed [25:0] add_signext_85; // sfix26_En25
  wire signed [26:0] add_temp_42; // sfix27_En25
  wire signed [25:0] sum44; // sfix26_En25
  wire signed [25:0] add_signext_86; // sfix26_En25
  wire signed [25:0] add_signext_87; // sfix26_En25
  wire signed [26:0] add_temp_43; // sfix27_En25
  wire signed [25:0] sum45; // sfix26_En25
  wire signed [25:0] add_signext_88; // sfix26_En25
  wire signed [25:0] add_signext_89; // sfix26_En25
  wire signed [26:0] add_temp_44; // sfix27_En25
  wire signed [25:0] sum46; // sfix26_En25
  wire signed [25:0] add_signext_90; // sfix26_En25
  wire signed [25:0] add_signext_91; // sfix26_En25
  wire signed [26:0] add_temp_45; // sfix27_En25
  wire signed [25:0] sum47; // sfix26_En25
  wire signed [25:0] add_signext_92; // sfix26_En25
  wire signed [25:0] add_signext_93; // sfix26_En25
  wire signed [26:0] add_temp_46; // sfix27_En25
  wire signed [25:0] sum48; // sfix26_En25
  wire signed [25:0] add_signext_94; // sfix26_En25
  wire signed [25:0] add_signext_95; // sfix26_En25
  wire signed [26:0] add_temp_47; // sfix27_En25
  wire signed [25:0] sum49; // sfix26_En25
  wire signed [25:0] add_signext_96; // sfix26_En25
  wire signed [25:0] add_signext_97; // sfix26_En25
  wire signed [26:0] add_temp_48; // sfix27_En25
  wire signed [25:0] sum50; // sfix26_En25
  wire signed [25:0] add_signext_98; // sfix26_En25
  wire signed [25:0] add_signext_99; // sfix26_En25
  wire signed [26:0] add_temp_49; // sfix27_En25
  reg  signed [25:0] output_register; // sfix26_En25

  // Block Statements
  always @( posedge clk or posedge reset)
    begin: Delay_Pipeline_process
      if (reset == 1'b1) begin
        delay_pipeline[0] <= 0;
        delay_pipeline[1] <= 0;
        delay_pipeline[2] <= 0;
        delay_pipeline[3] <= 0;
        delay_pipeline[4] <= 0;
        delay_pipeline[5] <= 0;
        delay_pipeline[6] <= 0;
        delay_pipeline[7] <= 0;
        delay_pipeline[8] <= 0;
        delay_pipeline[9] <= 0;
        delay_pipeline[10] <= 0;
        delay_pipeline[11] <= 0;
        delay_pipeline[12] <= 0;
        delay_pipeline[13] <= 0;
        delay_pipeline[14] <= 0;
        delay_pipeline[15] <= 0;
        delay_pipeline[16] <= 0;
        delay_pipeline[17] <= 0;
        delay_pipeline[18] <= 0;
        delay_pipeline[19] <= 0;
        delay_pipeline[20] <= 0;
        delay_pipeline[21] <= 0;
        delay_pipeline[22] <= 0;
        delay_pipeline[23] <= 0;
        delay_pipeline[24] <= 0;
        delay_pipeline[25] <= 0;
        delay_pipeline[26] <= 0;
        delay_pipeline[27] <= 0;
        delay_pipeline[28] <= 0;
        delay_pipeline[29] <= 0;
        delay_pipeline[30] <= 0;
        delay_pipeline[31] <= 0;
        delay_pipeline[32] <= 0;
        delay_pipeline[33] <= 0;
        delay_pipeline[34] <= 0;
        delay_pipeline[35] <= 0;
        delay_pipeline[36] <= 0;
        delay_pipeline[37] <= 0;
        delay_pipeline[38] <= 0;
        delay_pipeline[39] <= 0;
        delay_pipeline[40] <= 0;
        delay_pipeline[41] <= 0;
        delay_pipeline[42] <= 0;
        delay_pipeline[43] <= 0;
        delay_pipeline[44] <= 0;
        delay_pipeline[45] <= 0;
        delay_pipeline[46] <= 0;
        delay_pipeline[47] <= 0;
        delay_pipeline[48] <= 0;
        delay_pipeline[49] <= 0;
        delay_pipeline[50] <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          delay_pipeline[0] <= filter_in;
          delay_pipeline[1] <= delay_pipeline[0];
          delay_pipeline[2] <= delay_pipeline[1];
          delay_pipeline[3] <= delay_pipeline[2];
          delay_pipeline[4] <= delay_pipeline[3];
          delay_pipeline[5] <= delay_pipeline[4];
          delay_pipeline[6] <= delay_pipeline[5];
          delay_pipeline[7] <= delay_pipeline[6];
          delay_pipeline[8] <= delay_pipeline[7];
          delay_pipeline[9] <= delay_pipeline[8];
          delay_pipeline[10] <= delay_pipeline[9];
          delay_pipeline[11] <= delay_pipeline[10];
          delay_pipeline[12] <= delay_pipeline[11];
          delay_pipeline[13] <= delay_pipeline[12];
          delay_pipeline[14] <= delay_pipeline[13];
          delay_pipeline[15] <= delay_pipeline[14];
          delay_pipeline[16] <= delay_pipeline[15];
          delay_pipeline[17] <= delay_pipeline[16];
          delay_pipeline[18] <= delay_pipeline[17];
          delay_pipeline[19] <= delay_pipeline[18];
          delay_pipeline[20] <= delay_pipeline[19];
          delay_pipeline[21] <= delay_pipeline[20];
          delay_pipeline[22] <= delay_pipeline[21];
          delay_pipeline[23] <= delay_pipeline[22];
          delay_pipeline[24] <= delay_pipeline[23];
          delay_pipeline[25] <= delay_pipeline[24];
          delay_pipeline[26] <= delay_pipeline[25];
          delay_pipeline[27] <= delay_pipeline[26];
          delay_pipeline[28] <= delay_pipeline[27];
          delay_pipeline[29] <= delay_pipeline[28];
          delay_pipeline[30] <= delay_pipeline[29];
          delay_pipeline[31] <= delay_pipeline[30];
          delay_pipeline[32] <= delay_pipeline[31];
          delay_pipeline[33] <= delay_pipeline[32];
          delay_pipeline[34] <= delay_pipeline[33];
          delay_pipeline[35] <= delay_pipeline[34];
          delay_pipeline[36] <= delay_pipeline[35];
          delay_pipeline[37] <= delay_pipeline[36];
          delay_pipeline[38] <= delay_pipeline[37];
          delay_pipeline[39] <= delay_pipeline[38];
          delay_pipeline[40] <= delay_pipeline[39];
          delay_pipeline[41] <= delay_pipeline[40];
          delay_pipeline[42] <= delay_pipeline[41];
          delay_pipeline[43] <= delay_pipeline[42];
          delay_pipeline[44] <= delay_pipeline[43];
          delay_pipeline[45] <= delay_pipeline[44];
          delay_pipeline[46] <= delay_pipeline[45];
          delay_pipeline[47] <= delay_pipeline[46];
          delay_pipeline[48] <= delay_pipeline[47];
          delay_pipeline[49] <= delay_pipeline[48];
          delay_pipeline[50] <= delay_pipeline[49];
        end
      end
    end // Delay_Pipeline_process


  assign product51 = $signed({delay_pipeline[50][11:0], 1'b0});

  assign mul_temp = delay_pipeline[49] * coeff50;
  assign product50 = mul_temp[22:0];

  assign mul_temp_1 = delay_pipeline[48] * coeff49;
  assign product49 = mul_temp_1[22:0];

  assign mul_temp_2 = delay_pipeline[47] * coeff48;
  assign product48 = mul_temp_2[22:0];

  assign mul_temp_3 = delay_pipeline[46] * coeff47;
  assign product47 = mul_temp_3[22:0];

  assign mul_temp_4 = delay_pipeline[45] * coeff46;
  assign product46 = mul_temp_4[22:0];

  assign mul_temp_5 = delay_pipeline[44] * coeff45;
  assign product45 = mul_temp_5[22:0];

  assign mul_temp_6 = delay_pipeline[43] * coeff44;
  assign product44 = mul_temp_6[22:0];

  assign mul_temp_7 = delay_pipeline[42] * coeff43;
  assign product43 = mul_temp_7[22:0];

  assign mul_temp_8 = delay_pipeline[41] * coeff42;
  assign product42 = mul_temp_8[22:0];

  assign mul_temp_9 = delay_pipeline[40] * coeff41;
  assign product41 = mul_temp_9[22:0];

  assign mul_temp_10 = delay_pipeline[39] * coeff40;
  assign product40 = mul_temp_10[22:0];

  assign mul_temp_11 = delay_pipeline[38] * coeff39;
  assign product39 = mul_temp_11[22:0];

  assign mul_temp_12 = delay_pipeline[37] * coeff38;
  assign product38 = mul_temp_12[22:0];

  assign mul_temp_13 = delay_pipeline[36] * coeff37;
  assign product37 = mul_temp_13[22:0];

  assign mul_temp_14 = delay_pipeline[35] * coeff36;
  assign product36 = mul_temp_14[22:0];

  assign mul_temp_15 = delay_pipeline[34] * coeff35;
  assign product35 = mul_temp_15[22:0];

  assign mul_temp_16 = delay_pipeline[33] * coeff34;
  assign product34 = mul_temp_16[22:0];

  assign mul_temp_17 = delay_pipeline[32] * coeff33;
  assign product33 = mul_temp_17[22:0];

  assign mul_temp_18 = delay_pipeline[31] * coeff32;
  assign product32 = mul_temp_18[22:0];

  assign mul_temp_19 = delay_pipeline[30] * coeff31;
  assign product31 = mul_temp_19[22:0];

  assign mul_temp_20 = delay_pipeline[29] * coeff30;
  assign product30 = mul_temp_20[22:0];

  assign mul_temp_21 = delay_pipeline[28] * coeff29;
  assign product29 = mul_temp_21[22:0];

  assign mul_temp_22 = delay_pipeline[27] * coeff28;
  assign product28 = mul_temp_22[22:0];

  assign mul_temp_23 = delay_pipeline[26] * coeff27;
  assign product27 = mul_temp_23[22:0];

  assign mul_temp_24 = delay_pipeline[25] * coeff26;
  assign product26 = mul_temp_24[22:0];

  assign mul_temp_25 = delay_pipeline[24] * coeff25;
  assign product25 = mul_temp_25[22:0];

  assign mul_temp_26 = delay_pipeline[23] * coeff24;
  assign product24 = mul_temp_26[22:0];

  assign mul_temp_27 = delay_pipeline[22] * coeff23;
  assign product23 = mul_temp_27[22:0];

  assign mul_temp_28 = delay_pipeline[21] * coeff22;
  assign product22 = mul_temp_28[22:0];

  assign mul_temp_29 = delay_pipeline[20] * coeff21;
  assign product21 = mul_temp_29[22:0];

  assign mul_temp_30 = delay_pipeline[19] * coeff20;
  assign product20 = mul_temp_30[22:0];

  assign mul_temp_31 = delay_pipeline[18] * coeff19;
  assign product19 = mul_temp_31[22:0];

  assign mul_temp_32 = delay_pipeline[17] * coeff18;
  assign product18 = mul_temp_32[22:0];

  assign mul_temp_33 = delay_pipeline[16] * coeff17;
  assign product17 = mul_temp_33[22:0];

  assign mul_temp_34 = delay_pipeline[15] * coeff16;
  assign product16 = mul_temp_34[22:0];

  assign mul_temp_35 = delay_pipeline[14] * coeff15;
  assign product15 = mul_temp_35[22:0];

  assign mul_temp_36 = delay_pipeline[13] * coeff14;
  assign product14 = mul_temp_36[22:0];

  assign mul_temp_37 = delay_pipeline[12] * coeff13;
  assign product13 = mul_temp_37[22:0];

  assign mul_temp_38 = delay_pipeline[11] * coeff12;
  assign product12 = mul_temp_38[22:0];

  assign mul_temp_39 = delay_pipeline[10] * coeff11;
  assign product11 = mul_temp_39[22:0];

  assign mul_temp_40 = delay_pipeline[9] * coeff10;
  assign product10 = mul_temp_40[22:0];

  assign mul_temp_41 = delay_pipeline[8] * coeff9;
  assign product9 = mul_temp_41[22:0];

  assign mul_temp_42 = delay_pipeline[7] * coeff8;
  assign product8 = mul_temp_42[22:0];

  assign mul_temp_43 = delay_pipeline[6] * coeff7;
  assign product7 = mul_temp_43[22:0];

  assign mul_temp_44 = delay_pipeline[5] * coeff6;
  assign product6 = mul_temp_44[22:0];

  assign mul_temp_45 = delay_pipeline[4] * coeff5;
  assign product5 = mul_temp_45[22:0];

  assign mul_temp_46 = delay_pipeline[3] * coeff4;
  assign product4 = mul_temp_46[22:0];

  assign mul_temp_47 = delay_pipeline[2] * coeff3;
  assign product3 = mul_temp_47[22:0];

  assign mul_temp_48 = delay_pipeline[1] * coeff2;
  assign product2 = mul_temp_48[22:0];

  assign product1_cast = $signed({{3{product1[22]}}, product1});

  assign product1 = $signed({delay_pipeline[0][11:0], 1'b0});

  assign add_signext = product1_cast;
  assign add_signext_1 = $signed({{3{product2[22]}}, product2});
  assign add_temp = add_signext + add_signext_1;
  assign sum1 = add_temp[25:0];

  assign add_signext_2 = sum1;
  assign add_signext_3 = $signed({{3{product3[22]}}, product3});
  assign add_temp_1 = add_signext_2 + add_signext_3;
  assign sum2 = add_temp_1[25:0];

  assign add_signext_4 = sum2;
  assign add_signext_5 = $signed({{3{product4[22]}}, product4});
  assign add_temp_2 = add_signext_4 + add_signext_5;
  assign sum3 = add_temp_2[25:0];

  assign add_signext_6 = sum3;
  assign add_signext_7 = $signed({{3{product5[22]}}, product5});
  assign add_temp_3 = add_signext_6 + add_signext_7;
  assign sum4 = add_temp_3[25:0];

  assign add_signext_8 = sum4;
  assign add_signext_9 = $signed({{3{product6[22]}}, product6});
  assign add_temp_4 = add_signext_8 + add_signext_9;
  assign sum5 = add_temp_4[25:0];

  assign add_signext_10 = sum5;
  assign add_signext_11 = $signed({{3{product7[22]}}, product7});
  assign add_temp_5 = add_signext_10 + add_signext_11;
  assign sum6 = add_temp_5[25:0];

  assign add_signext_12 = sum6;
  assign add_signext_13 = $signed({{3{product8[22]}}, product8});
  assign add_temp_6 = add_signext_12 + add_signext_13;
  assign sum7 = add_temp_6[25:0];

  assign add_signext_14 = sum7;
  assign add_signext_15 = $signed({{3{product9[22]}}, product9});
  assign add_temp_7 = add_signext_14 + add_signext_15;
  assign sum8 = add_temp_7[25:0];

  assign add_signext_16 = sum8;
  assign add_signext_17 = $signed({{3{product10[22]}}, product10});
  assign add_temp_8 = add_signext_16 + add_signext_17;
  assign sum9 = add_temp_8[25:0];

  assign add_signext_18 = sum9;
  assign add_signext_19 = $signed({{3{product11[22]}}, product11});
  assign add_temp_9 = add_signext_18 + add_signext_19;
  assign sum10 = add_temp_9[25:0];

  assign add_signext_20 = sum10;
  assign add_signext_21 = $signed({{3{product12[22]}}, product12});
  assign add_temp_10 = add_signext_20 + add_signext_21;
  assign sum11 = add_temp_10[25:0];

  assign add_signext_22 = sum11;
  assign add_signext_23 = $signed({{3{product13[22]}}, product13});
  assign add_temp_11 = add_signext_22 + add_signext_23;
  assign sum12 = add_temp_11[25:0];

  assign add_signext_24 = sum12;
  assign add_signext_25 = $signed({{3{product14[22]}}, product14});
  assign add_temp_12 = add_signext_24 + add_signext_25;
  assign sum13 = add_temp_12[25:0];

  assign add_signext_26 = sum13;
  assign add_signext_27 = $signed({{3{product15[22]}}, product15});
  assign add_temp_13 = add_signext_26 + add_signext_27;
  assign sum14 = add_temp_13[25:0];

  assign add_signext_28 = sum14;
  assign add_signext_29 = $signed({{3{product16[22]}}, product16});
  assign add_temp_14 = add_signext_28 + add_signext_29;
  assign sum15 = add_temp_14[25:0];

  assign add_signext_30 = sum15;
  assign add_signext_31 = $signed({{3{product17[22]}}, product17});
  assign add_temp_15 = add_signext_30 + add_signext_31;
  assign sum16 = add_temp_15[25:0];

  assign add_signext_32 = sum16;
  assign add_signext_33 = $signed({{3{product18[22]}}, product18});
  assign add_temp_16 = add_signext_32 + add_signext_33;
  assign sum17 = add_temp_16[25:0];

  assign add_signext_34 = sum17;
  assign add_signext_35 = $signed({{3{product19[22]}}, product19});
  assign add_temp_17 = add_signext_34 + add_signext_35;
  assign sum18 = add_temp_17[25:0];

  assign add_signext_36 = sum18;
  assign add_signext_37 = $signed({{3{product20[22]}}, product20});
  assign add_temp_18 = add_signext_36 + add_signext_37;
  assign sum19 = add_temp_18[25:0];

  assign add_signext_38 = sum19;
  assign add_signext_39 = $signed({{3{product21[22]}}, product21});
  assign add_temp_19 = add_signext_38 + add_signext_39;
  assign sum20 = add_temp_19[25:0];

  assign add_signext_40 = sum20;
  assign add_signext_41 = $signed({{3{product22[22]}}, product22});
  assign add_temp_20 = add_signext_40 + add_signext_41;
  assign sum21 = add_temp_20[25:0];

  assign add_signext_42 = sum21;
  assign add_signext_43 = $signed({{3{product23[22]}}, product23});
  assign add_temp_21 = add_signext_42 + add_signext_43;
  assign sum22 = add_temp_21[25:0];

  assign add_signext_44 = sum22;
  assign add_signext_45 = $signed({{3{product24[22]}}, product24});
  assign add_temp_22 = add_signext_44 + add_signext_45;
  assign sum23 = add_temp_22[25:0];

  assign add_signext_46 = sum23;
  assign add_signext_47 = $signed({{3{product25[22]}}, product25});
  assign add_temp_23 = add_signext_46 + add_signext_47;
  assign sum24 = add_temp_23[25:0];

  assign add_signext_48 = sum24;
  assign add_signext_49 = $signed({{3{product26[22]}}, product26});
  assign add_temp_24 = add_signext_48 + add_signext_49;
  assign sum25 = add_temp_24[25:0];

  assign add_signext_50 = sum25;
  assign add_signext_51 = $signed({{3{product27[22]}}, product27});
  assign add_temp_25 = add_signext_50 + add_signext_51;
  assign sum26 = add_temp_25[25:0];

  assign add_signext_52 = sum26;
  assign add_signext_53 = $signed({{3{product28[22]}}, product28});
  assign add_temp_26 = add_signext_52 + add_signext_53;
  assign sum27 = add_temp_26[25:0];

  assign add_signext_54 = sum27;
  assign add_signext_55 = $signed({{3{product29[22]}}, product29});
  assign add_temp_27 = add_signext_54 + add_signext_55;
  assign sum28 = add_temp_27[25:0];

  assign add_signext_56 = sum28;
  assign add_signext_57 = $signed({{3{product30[22]}}, product30});
  assign add_temp_28 = add_signext_56 + add_signext_57;
  assign sum29 = add_temp_28[25:0];

  assign add_signext_58 = sum29;
  assign add_signext_59 = $signed({{3{product31[22]}}, product31});
  assign add_temp_29 = add_signext_58 + add_signext_59;
  assign sum30 = add_temp_29[25:0];

  assign add_signext_60 = sum30;
  assign add_signext_61 = $signed({{3{product32[22]}}, product32});
  assign add_temp_30 = add_signext_60 + add_signext_61;
  assign sum31 = add_temp_30[25:0];

  assign add_signext_62 = sum31;
  assign add_signext_63 = $signed({{3{product33[22]}}, product33});
  assign add_temp_31 = add_signext_62 + add_signext_63;
  assign sum32 = add_temp_31[25:0];

  assign add_signext_64 = sum32;
  assign add_signext_65 = $signed({{3{product34[22]}}, product34});
  assign add_temp_32 = add_signext_64 + add_signext_65;
  assign sum33 = add_temp_32[25:0];

  assign add_signext_66 = sum33;
  assign add_signext_67 = $signed({{3{product35[22]}}, product35});
  assign add_temp_33 = add_signext_66 + add_signext_67;
  assign sum34 = add_temp_33[25:0];

  assign add_signext_68 = sum34;
  assign add_signext_69 = $signed({{3{product36[22]}}, product36});
  assign add_temp_34 = add_signext_68 + add_signext_69;
  assign sum35 = add_temp_34[25:0];

  assign add_signext_70 = sum35;
  assign add_signext_71 = $signed({{3{product37[22]}}, product37});
  assign add_temp_35 = add_signext_70 + add_signext_71;
  assign sum36 = add_temp_35[25:0];

  assign add_signext_72 = sum36;
  assign add_signext_73 = $signed({{3{product38[22]}}, product38});
  assign add_temp_36 = add_signext_72 + add_signext_73;
  assign sum37 = add_temp_36[25:0];

  assign add_signext_74 = sum37;
  assign add_signext_75 = $signed({{3{product39[22]}}, product39});
  assign add_temp_37 = add_signext_74 + add_signext_75;
  assign sum38 = add_temp_37[25:0];

  assign add_signext_76 = sum38;
  assign add_signext_77 = $signed({{3{product40[22]}}, product40});
  assign add_temp_38 = add_signext_76 + add_signext_77;
  assign sum39 = add_temp_38[25:0];

  assign add_signext_78 = sum39;
  assign add_signext_79 = $signed({{3{product41[22]}}, product41});
  assign add_temp_39 = add_signext_78 + add_signext_79;
  assign sum40 = add_temp_39[25:0];

  assign add_signext_80 = sum40;
  assign add_signext_81 = $signed({{3{product42[22]}}, product42});
  assign add_temp_40 = add_signext_80 + add_signext_81;
  assign sum41 = add_temp_40[25:0];

  assign add_signext_82 = sum41;
  assign add_signext_83 = $signed({{3{product43[22]}}, product43});
  assign add_temp_41 = add_signext_82 + add_signext_83;
  assign sum42 = add_temp_41[25:0];

  assign add_signext_84 = sum42;
  assign add_signext_85 = $signed({{3{product44[22]}}, product44});
  assign add_temp_42 = add_signext_84 + add_signext_85;
  assign sum43 = add_temp_42[25:0];

  assign add_signext_86 = sum43;
  assign add_signext_87 = $signed({{3{product45[22]}}, product45});
  assign add_temp_43 = add_signext_86 + add_signext_87;
  assign sum44 = add_temp_43[25:0];

  assign add_signext_88 = sum44;
  assign add_signext_89 = $signed({{3{product46[22]}}, product46});
  assign add_temp_44 = add_signext_88 + add_signext_89;
  assign sum45 = add_temp_44[25:0];

  assign add_signext_90 = sum45;
  assign add_signext_91 = $signed({{3{product47[22]}}, product47});
  assign add_temp_45 = add_signext_90 + add_signext_91;
  assign sum46 = add_temp_45[25:0];

  assign add_signext_92 = sum46;
  assign add_signext_93 = $signed({{3{product48[22]}}, product48});
  assign add_temp_46 = add_signext_92 + add_signext_93;
  assign sum47 = add_temp_46[25:0];

  assign add_signext_94 = sum47;
  assign add_signext_95 = $signed({{3{product49[22]}}, product49});
  assign add_temp_47 = add_signext_94 + add_signext_95;
  assign sum48 = add_temp_47[25:0];

  assign add_signext_96 = sum48;
  assign add_signext_97 = $signed({{3{product50[22]}}, product50});
  assign add_temp_48 = add_signext_96 + add_signext_97;
  assign sum49 = add_temp_48[25:0];

  assign add_signext_98 = sum49;
  assign add_signext_99 = $signed({{3{product51[22]}}, product51});
  assign add_temp_49 = add_signext_98 + add_signext_99;
  assign sum50 = add_temp_49[25:0];

  always @ (posedge clk or posedge reset)
    begin: Output_Register_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          output_register <= sum50;
        end
      end
    end // Output_Register_process

  // Assignment Statements
  assign filter_out = output_register;
endmodule  // fir_0R1
