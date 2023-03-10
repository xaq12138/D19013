
module mcu (
	clk_0,
	reset_n,
	out_port_from_the_pio_addr,
	out_port_from_the_pio_clk,
	out_port_from_the_pio_ctr_out,
	out_port_from_the_pio_data,
	out_port_from_the_pio_reset,
	out_port_from_the_pio_spi_clk,
	in_port_to_the_pio_spi_di,
	out_port_from_the_pio_spi_do,
	out_port_from_the_pio_spi_le,
	rxd_to_the_uart_0,
	txd_from_the_uart_0,
	rxd_to_the_uart,
	txd_from_the_uart);	

	input		clk_0;
	input		reset_n;
	output	[7:0]	out_port_from_the_pio_addr;
	output		out_port_from_the_pio_clk;
	output	[7:0]	out_port_from_the_pio_ctr_out;
	output	[31:0]	out_port_from_the_pio_data;
	output		out_port_from_the_pio_reset;
	output		out_port_from_the_pio_spi_clk;
	input		in_port_to_the_pio_spi_di;
	output		out_port_from_the_pio_spi_do;
	output		out_port_from_the_pio_spi_le;
	input		rxd_to_the_uart_0;
	output		txd_from_the_uart_0;
	input		rxd_to_the_uart;
	output		txd_from_the_uart;
endmodule
