// Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus II License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// VENDOR "Altera"
// PROGRAM "Quartus II 64-Bit"
// VERSION "Version 14.1.0 Build 186 12/03/2014 SJ Full Version"

// DATE "08/11/2020 19:31:40"

// 
// Device: Altera 5CEFA9F23I7 Package FBGA484
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module clkctr_s (
	inclk,
	outclk)/* synthesis synthesis_greybox=0 */;
input 	inclk;
output 	outclk;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \altclkctrl_0|clkctr_s_altclkctrl_0_sub_component|wire_sd1_outclk ;
wire \inclk~input_o ;


clkctr_s_clkctr_s_altclkctrl_0 altclkctrl_0(
	.outclk(\altclkctrl_0|clkctr_s_altclkctrl_0_sub_component|wire_sd1_outclk ),
	.inclk(\inclk~input_o ));

assign \inclk~input_o  = inclk;

assign outclk = \altclkctrl_0|clkctr_s_altclkctrl_0_sub_component|wire_sd1_outclk ;

endmodule

module clkctr_s_clkctr_s_altclkctrl_0 (
	outclk,
	inclk)/* synthesis synthesis_greybox=0 */;
output 	outclk;
input 	inclk;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



clkctr_s_clkctr_s_altclkctrl_0_sub clkctr_s_altclkctrl_0_sub_component(
	.outclk(outclk),
	.inclk({gnd,gnd,gnd,inclk}));

endmodule

module clkctr_s_clkctr_s_altclkctrl_0_sub (
	outclk,
	inclk)/* synthesis synthesis_greybox=0 */;
output 	outclk;
input 	[3:0] inclk;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



cyclonev_clkena sd1(
	.inclk(inclk[0]),
	.ena(vcc),
	.outclk(outclk),
	.enaout());
defparam sd1.clock_type = "global clock";
defparam sd1.disable_mode = "low";
defparam sd1.ena_register_mode = "always enabled";
defparam sd1.ena_register_power_up = "high";
defparam sd1.test_syn = "high";

endmodule
