// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/19 16:37:03
// File Name    : cb_crc32.v
// Module Ver   : Vx.x
//
//
// All Rights Reserved
//
// ---------------------------------------------------------------------------------/
//
// Modification History:
// V1.0         initial
//
// -FHDR============================================================================/
// 
// cb_crc32
//    |---
// 
`timescale 1ns/1ns

module cb_crc32 #
(
    parameter               U_DLY = 1
)
(
//-----------------------------------------------------------------------------------
// Clock & Reset
//-----------------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
//-----------------------------------------------------------------------------------
// CRC32 Clear Signal
//-----------------------------------------------------------------------------------
    input                           crc_clear                   , 
//-----------------------------------------------------------------------------------
// Source Data
//-----------------------------------------------------------------------------------
    input                     [7:0] src_data                    , 
    input                           src_data_valid              , 
//-----------------------------------------------------------------------------------
// Source Data
//-----------------------------------------------------------------------------------
    output reg               [31:0] crc_data                    , 
    output reg                      crc_data_valid                
);

reg                          [31:0] lfsr_c                      ; 
reg                          [31:0] lfsr_q                      ; 

always @ (*)
begin
    lfsr_c[0] = lfsr_q[24] ^ lfsr_q[30] ^ src_data[0] ^ src_data[6];
    lfsr_c[1] = lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[30] ^ lfsr_q[31] ^ src_data[0] ^ src_data[1] ^ src_data[6] ^ src_data[7];
    lfsr_c[2] = lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[30] ^ lfsr_q[31] ^ src_data[0] ^ src_data[1] ^ src_data[2] ^ src_data[6] ^ src_data[7];
    lfsr_c[3] = lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[31] ^ src_data[1] ^ src_data[2] ^ src_data[3] ^ src_data[7];
    lfsr_c[4] = lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[30] ^ src_data[0] ^ src_data[2] ^ src_data[3] ^ src_data[4] ^ src_data[6];
    lfsr_c[5] = lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ src_data[0] ^ src_data[1] ^ src_data[3] ^ src_data[4] ^ src_data[5] ^ src_data[6] ^ src_data[7];
    lfsr_c[6] = lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ src_data[1] ^ src_data[2] ^ src_data[4] ^ src_data[5] ^ src_data[6] ^ src_data[7];
    lfsr_c[7] = lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ lfsr_q[31] ^ src_data[0] ^ src_data[2] ^ src_data[3] ^ src_data[5] ^ src_data[7];
    lfsr_c[8] = lfsr_q[0] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[28] ^ src_data[0] ^ src_data[1] ^ src_data[3] ^ src_data[4];
    lfsr_c[9] = lfsr_q[1] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[29] ^ src_data[1] ^ src_data[2] ^ src_data[4] ^ src_data[5];
    lfsr_c[10] = lfsr_q[2] ^ lfsr_q[24] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ src_data[0] ^ src_data[2] ^ src_data[3] ^ src_data[5];
    lfsr_c[11] = lfsr_q[3] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[27] ^ lfsr_q[28] ^ src_data[0] ^ src_data[1] ^ src_data[3] ^ src_data[4];
    lfsr_c[12] = lfsr_q[4] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[30] ^ src_data[0] ^ src_data[1] ^ src_data[2] ^ src_data[4] ^ src_data[5] ^ src_data[6];
    lfsr_c[13] = lfsr_q[5] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[29] ^ lfsr_q[30] ^ lfsr_q[31] ^ src_data[1] ^ src_data[2] ^ src_data[3] ^ src_data[5] ^ src_data[6] ^ src_data[7];
    lfsr_c[14] = lfsr_q[6] ^ lfsr_q[26] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[30] ^ lfsr_q[31] ^ src_data[2] ^ src_data[3] ^ src_data[4] ^ src_data[6] ^ src_data[7];
    lfsr_c[15] = lfsr_q[7] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[31] ^ src_data[3] ^ src_data[4] ^ src_data[5] ^ src_data[7];
    lfsr_c[16] = lfsr_q[8] ^ lfsr_q[24] ^ lfsr_q[28] ^ lfsr_q[29] ^ src_data[0] ^ src_data[4] ^ src_data[5];
    lfsr_c[17] = lfsr_q[9] ^ lfsr_q[25] ^ lfsr_q[29] ^ lfsr_q[30] ^ src_data[1] ^ src_data[5] ^ src_data[6];
    lfsr_c[18] = lfsr_q[10] ^ lfsr_q[26] ^ lfsr_q[30] ^ lfsr_q[31] ^ src_data[2] ^ src_data[6] ^ src_data[7];
    lfsr_c[19] = lfsr_q[11] ^ lfsr_q[27] ^ lfsr_q[31] ^ src_data[3] ^ src_data[7];
    lfsr_c[20] = lfsr_q[12] ^ lfsr_q[28] ^ src_data[4];
    lfsr_c[21] = lfsr_q[13] ^ lfsr_q[29] ^ src_data[5];
    lfsr_c[22] = lfsr_q[14] ^ lfsr_q[24] ^ src_data[0];
    lfsr_c[23] = lfsr_q[15] ^ lfsr_q[24] ^ lfsr_q[25] ^ lfsr_q[30] ^ src_data[0] ^ src_data[1] ^ src_data[6];
    lfsr_c[24] = lfsr_q[16] ^ lfsr_q[25] ^ lfsr_q[26] ^ lfsr_q[31] ^ src_data[1] ^ src_data[2] ^ src_data[7];
    lfsr_c[25] = lfsr_q[17] ^ lfsr_q[26] ^ lfsr_q[27] ^ src_data[2] ^ src_data[3];
    lfsr_c[26] = lfsr_q[18] ^ lfsr_q[24] ^ lfsr_q[27] ^ lfsr_q[28] ^ lfsr_q[30] ^ src_data[0] ^ src_data[3] ^ src_data[4] ^ src_data[6];
    lfsr_c[27] = lfsr_q[19] ^ lfsr_q[25] ^ lfsr_q[28] ^ lfsr_q[29] ^ lfsr_q[31] ^ src_data[1] ^ src_data[4] ^ src_data[5] ^ src_data[7];
    lfsr_c[28] = lfsr_q[20] ^ lfsr_q[26] ^ lfsr_q[29] ^ lfsr_q[30] ^ src_data[2] ^ src_data[5] ^ src_data[6];
    lfsr_c[29] = lfsr_q[21] ^ lfsr_q[27] ^ lfsr_q[30] ^ lfsr_q[31] ^ src_data[3] ^ src_data[6] ^ src_data[7];
    lfsr_c[30] = lfsr_q[22] ^ lfsr_q[28] ^ lfsr_q[31] ^ src_data[4] ^ src_data[7];
    lfsr_c[31] = lfsr_q[23] ^ lfsr_q[29] ^ src_data[5];

end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        lfsr_q <= #U_DLY {32{1'b1}};
    else
        begin
            if(crc_clear == 1'b1)
                lfsr_q <= #U_DLY {32{1'b1}};
            else if(src_data_valid == 1'b1)
                lfsr_q <= #U_DLY lfsr_c;
            else
                ;
        end

end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        crc_data <= #U_DLY 32'd0;
    else
        begin
            if(src_data_valid == 1'b1)
                crc_data <= #U_DLY lfsr_c;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        crc_data_valid <= #U_DLY 1'b0;
    else
        crc_data_valid <= #U_DLY src_data_valid;
end

endmodule



