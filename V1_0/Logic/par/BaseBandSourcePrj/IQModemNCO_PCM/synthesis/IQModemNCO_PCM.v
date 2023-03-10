// IQModemNCO_PCM.v

// Generated using ACDS version 14.1 186 at 2020.07.27.10:44:49

`timescale 1 ps / 1 ps
module IQModemNCO_PCM (
		input  wire        clk,         // clk.clk
		input  wire        clken,       //  in.clken
		input  wire [31:0] phi_inc_i,   //    .phi_inc_i
		input  wire [31:0] freq_mod_i,  //    .freq_mod_i
		input  wire [15:0] phase_mod_i, //    .phase_mod_i
		output wire [15:0] fsin_o,      // out.fsin_o
		output wire [15:0] fcos_o,      //    .fcos_o
		output wire        out_valid,   //    .out_valid
		input  wire        reset_n      // rst.reset_n
	);

	IQModemNCO_PCM_nco_ii_0 nco_ii_0 (
		.clk         (clk),         // clk.clk
		.reset_n     (reset_n),     // rst.reset_n
		.clken       (clken),       //  in.clken
		.phi_inc_i   (phi_inc_i),   //    .phi_inc_i
		.freq_mod_i  (freq_mod_i),  //    .freq_mod_i
		.phase_mod_i (phase_mod_i), //    .phase_mod_i
		.fsin_o      (fsin_o),      // out.fsin_o
		.fcos_o      (fcos_o),      //    .fcos_o
		.out_valid   (out_valid)    //    .out_valid
	);

endmodule