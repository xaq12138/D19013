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

// DATE "08/11/2020 19:33:18"

// 
// Device: Altera 5CEFA9F23I7 Package FBGA484
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module clkctr (
	inclk3x,
	inclk2x,
	inclk1x,
	inclk0x,
	clkselect,
	outclk)/* synthesis synthesis_greybox=0 */;
input 	inclk3x;
input 	inclk2x;
input 	inclk1x;
input 	inclk0x;
input 	[1:0] clkselect;
output 	outclk;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \altclkctrl_0|clkctr_altclkctrl_0_sub_component|wire_sd1_outclk ;
wire \inclk0x~input_o ;
wire \inclk1x~input_o ;
wire \inclk2x~input_o ;
wire \inclk3x~input_o ;
wire \clkselect[0]~input_o ;
wire \clkselect[1]~input_o ;


clkctr_clkctr_altclkctrl_0 altclkctrl_0(
	.outclk(\altclkctrl_0|clkctr_altclkctrl_0_sub_component|wire_sd1_outclk ),
	.inclk0x(\inclk0x~input_o ),
	.inclk1x(\inclk1x~input_o ),
	.inclk2x(\inclk2x~input_o ),
	.inclk3x(\inclk3x~input_o ),
	.clkselect_0(\clkselect[0]~input_o ),
	.clkselect_1(\clkselect[1]~input_o ));

assign \inclk0x~input_o  = inclk0x;

assign \inclk1x~input_o  = inclk1x;

assign \inclk2x~input_o  = inclk2x;

assign \inclk3x~input_o  = inclk3x;

assign \clkselect[0]~input_o  = clkselect[0];

assign \clkselect[1]~input_o  = clkselect[1];

assign outclk = \altclkctrl_0|clkctr_altclkctrl_0_sub_component|wire_sd1_outclk ;

endmodule

module clkctr_clkctr_altclkctrl_0 (
	outclk,
	inclk0x,
	inclk1x,
	inclk2x,
	inclk3x,
	clkselect_0,
	clkselect_1)/* synthesis synthesis_greybox=0 */;
output 	outclk;
input 	inclk0x;
input 	inclk1x;
input 	inclk2x;
input 	inclk3x;
input 	clkselect_0;
input 	clkselect_1;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



clkctr_clkctr_altclkctrl_0_sub clkctr_altclkctrl_0_sub_component(
	.outclk(outclk),
	.inclk({inclk3x,inclk2x,inclk1x,inclk0x}),
	.clkselect({clkselect_1,clkselect_0}));

endmodule

module clkctr_clkctr_altclkctrl_0_sub (
	outclk,
	inclk,
	clkselect)/* synthesis synthesis_greybox=0 */;
output 	outclk;
input 	[3:0] inclk;
input 	[1:0] clkselect;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire wire_sd2_outclk;


cyclonev_clkena sd1(
	.inclk(wire_sd2_outclk),
	.ena(vcc),
	.outclk(outclk),
	.enaout());
defparam sd1.clock_type = "global clock";
defparam sd1.disable_mode = "low";
defparam sd1.ena_register_mode = "always enabled";
defparam sd1.ena_register_power_up = "high";
defparam sd1.test_syn = "high";

cyclonev_clkselect sd2(
	.inclk({inclk[3],inclk[2],inclk[1],inclk[0]}),
	.clkselect({clkselect[1],clkselect[0]}),
	.outclk(wire_sd2_outclk));
defparam sd2.test_cff = "low";

endmodule
