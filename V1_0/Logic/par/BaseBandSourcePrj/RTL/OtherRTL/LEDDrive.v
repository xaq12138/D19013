module LEDDrive(clk,led);
input clk;
output reg [3:0]led;
reg [31:0] cnt;
always@(posedge clk)
begin
if (cnt[31:0]==32'h01C9C380 )
	begin
	led[0]<=!led[0];
	led[1]<=led[0];
	led[2]<=led[1];
	led[3]<=led[2];
	cnt<=32'h00000000;
	end 
else 
	begin
	cnt<=cnt+1'b1;
	end 
end 
endmodule 