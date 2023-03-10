`timescale 1ns/1ps

module power_state(

input 	           clk_i,
input			         rst_n,
input 	        signal_i,
output 	 reg    signal_o
);

localparam U_DLY = 1;

reg                                 signal_i_1dly               ; 
reg                                 signal_i_2dly               ; 

always@(posedge clk_i or negedge rst_n)
begin
	if(rst_n==1'b0)
        begin
            signal_i_1dly <= #U_DLY 1'b0;
            signal_i_2dly <= #U_DLY 1'b0;
        end
    else
        begin
            signal_i_1dly <= #U_DLY signal_i;
            signal_i_2dly <= #U_DLY signal_i_1dly;
        end
end

always@(posedge clk_i or negedge rst_n)
begin
	if(rst_n==1'b0)
		signal_o <= 1'b0;
	else
		signal_o <= signal_i_2dly;
end

endmodule
