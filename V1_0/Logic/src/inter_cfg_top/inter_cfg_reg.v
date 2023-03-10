// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:47:55
// File Name    : inter_cfg_reg.v
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
// inter_cfg_reg
//    |---
// 
`timescale 1ns/1ns

module inter_cfg_reg #
(
    parameter                       U_DLY = 1                   ,
    parameter                       FPGA_VER = 32'h00000010     
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Internal Config Data
// ----------------------------------------------------------------------------
    input                           inter_cfg_wr_en             , 
    input                           inter_cfg_rd_en             , 
    input                    [15:0] inter_cfg_addr              , 
    input                    [31:0] inter_cfg_wr_data           , 
    output reg               [31:0] inter_cfg_rd_data           , 
    output reg                      inter_cfg_rd_data_valid     , 
// ----------------------------------------------------------------------------
// Initialization Config Data
// ---------------------------------------------------------------------------- 
    input                           init_cfg_wr_en              , 
    input                    [15:0] init_cfg_addr               , 
    input                    [31:0] init_cfg_data               , 
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    output reg                      init_cfg_rstn               , 
    output reg                      soft_rst_en                 , 

    output reg               [15:0] cfg_ins_txcnt               , // 指令发送次数
    output reg                [7:0] cfg_ins_enable              , // 指令有效标志
    output reg               [15:0] cfg_ins_length              , // 指令长度
    output reg               [31:0] cfg_ins_waittime            , // 发送间隔时间

    output reg               [31:0] cfg_pcm_bitrate             , // PCM码率
    output reg               [31:0] cfg_pcm_fbias               , // PCM频偏
    output reg                [7:0] cfg_pcm_multsubc            , // 副载波倍数
    output reg                [3:0] cfg_pcm_codesel             , // 码型选择
    output reg                      cfg_pcm_load_en             , // 加载使能
    output reg                      cfg_pcm_keyer_en            , // 加调使能
    output reg                [7:0] cfg_pcm_header              , 

    output reg              [159:0] dy_cfg_data                 , 
    output reg                [7:0] cfg_dy_header               , 

    output reg                      cfg_keyer_sel               , //调制体制选择  

    output reg               [31:0] cfg_status_waittime         , 
    output reg               [31:0] cfg_key_filter_data         , 
    output reg                      cfg_rm_time_valid           , 
    output reg               [31:0] cfg_rm_time                 , 

    output reg                [3:0] cfg_udp_socket              , // 4'b0001 point-to-point,4'b0100 multicast.
    output reg               [15:0] cfg_udp_srcport             , 
    output reg               [15:0] cfg_udp_dstport             , 
    output reg               [31:0] cfg_phy_srcip               , 
    output reg               [31:0] cfg_phy_dstip               , 
    output reg               [47:0] cfg_phy_srcmac              , 
    output reg               [47:0] cfg_phy_dstmac                
);

reg                          [31:0] test_reg                    ; 

wire                                reg_cfg_wr_en               ; 
wire                         [15:0] reg_cfg_addr                ; 
wire                         [31:0] reg_cfg_wr_data             ; 

assign reg_cfg_wr_en = inter_cfg_wr_en | init_cfg_wr_en;
assign reg_cfg_addr = (init_cfg_wr_en == 1'b1) ? init_cfg_addr : inter_cfg_addr;
assign reg_cfg_wr_data = (init_cfg_wr_en == 1'b1) ? init_cfg_data : inter_cfg_wr_data;

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_cfg_rd_data <= #U_DLY 32'd0;
    else
        begin
            if(inter_cfg_rd_en == 1'b1)
                case(inter_cfg_addr)
                    16'h0000    : inter_cfg_rd_data <= #U_DLY FPGA_VER;
                    16'h0001    : inter_cfg_rd_data <= #U_DLY test_reg;
                    16'h0002    : inter_cfg_rd_data <= #U_DLY {31'd0,init_cfg_rstn};
                    16'h0003    : inter_cfg_rd_data <= #U_DLY {31'd0,soft_rst_en};

                    16'h0010    : inter_cfg_rd_data <= #U_DLY {16'd0,cfg_ins_txcnt};
                    16'h0011    : inter_cfg_rd_data <= #U_DLY {24'd0,cfg_ins_enable};
                    16'h0012    : inter_cfg_rd_data <= #U_DLY {16'd0,cfg_ins_length};
                    16'h0013    : inter_cfg_rd_data  <= #U_DLY cfg_ins_waittime;

                    16'h0020    : inter_cfg_rd_data <= #U_DLY cfg_pcm_bitrate;
                    16'h0021    : inter_cfg_rd_data <= #U_DLY cfg_pcm_fbias;
                    16'h0022    : inter_cfg_rd_data <= #U_DLY {24'd0,cfg_pcm_multsubc};
                    16'h0023    : inter_cfg_rd_data <= #U_DLY {28'd0,cfg_pcm_codesel};
                    16'h0024    : inter_cfg_rd_data <= #U_DLY {31'd0,cfg_pcm_load_en};
                    16'h0025    : inter_cfg_rd_data <= #U_DLY {31'd0,cfg_pcm_keyer_en};
                    16'h0026    : inter_cfg_rd_data <= #U_DLY {24'd0,cfg_pcm_header};

                    16'h0030    : inter_cfg_rd_data <= #U_DLY dy_cfg_data[0*32+:32];                
                    16'h0031    : inter_cfg_rd_data <= #U_DLY dy_cfg_data[1*32+:32];
                    16'h0032    : inter_cfg_rd_data <= #U_DLY dy_cfg_data[2*32+:32];
                    16'h0033    : inter_cfg_rd_data <= #U_DLY dy_cfg_data[3*32+:32];
                    16'h0034    : inter_cfg_rd_data <= #U_DLY dy_cfg_data[4*32+:32];
                    16'h0035    : inter_cfg_rd_data <= #U_DLY {24'd0,cfg_dy_header};

                    16'h0040    : inter_cfg_rd_data <= #U_DLY {31'd0,cfg_keyer_sel};

                    16'h0050    : inter_cfg_rd_data <= #U_DLY cfg_status_waittime;
                    16'h0051    : inter_cfg_rd_data <= #U_DLY cfg_key_filter_data;
                    16'h0052    : inter_cfg_rd_data <= #U_DLY cfg_rm_time;
                    
                    16'h0060    : inter_cfg_rd_data <= #U_DLY {28'd0,cfg_udp_socket};
                    16'h0061    : inter_cfg_rd_data <= #U_DLY {16'd0,cfg_udp_srcport};
                    16'h0062    : inter_cfg_rd_data <= #U_DLY {16'd0,cfg_udp_dstport};
                    16'h0063    : inter_cfg_rd_data <= #U_DLY cfg_phy_srcip; 
                    16'h0064    : inter_cfg_rd_data <= #U_DLY cfg_phy_dstip;
                    16'h0065    : inter_cfg_rd_data <= #U_DLY {16'd0,cfg_phy_srcmac[47:32]};
                    16'h0066    : inter_cfg_rd_data <= #U_DLY cfg_phy_srcmac[31:0];
                    16'h0067    : inter_cfg_rd_data <= #U_DLY {16'd0,cfg_phy_dstmac[47:32]};
                    16'h0068    : inter_cfg_rd_data <= #U_DLY cfg_phy_dstmac[31:0];
                    
                    default     : inter_cfg_rd_data <= #U_DLY 32'd0;
                endcase
            else
                ;
        end 
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_cfg_rd_data_valid <= #U_DLY 1'b0;
    else
        begin
            if(inter_cfg_rd_en == 1'b1)
                inter_cfg_rd_data_valid <= #U_DLY 1'b1;
            else
                inter_cfg_rd_data_valid <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            test_reg <= #U_DLY 32'haaaa_5555;
            init_cfg_rstn <= #U_DLY 1'b1;
            soft_rst_en <= #U_DLY 1'b0;

            cfg_ins_txcnt <= #U_DLY 16'd0;
            cfg_ins_enable <= #U_DLY 8'd0;
            cfg_ins_length <= #U_DLY 16'd0;
            cfg_ins_waittime <= #U_DLY 32'd0;

            cfg_pcm_bitrate <= #U_DLY 32'd0;
            cfg_pcm_fbias <= #U_DLY 32'd0;
            cfg_pcm_multsubc <= #U_DLY 8'd0; 
            cfg_pcm_codesel <= #U_DLY 4'd0;
            cfg_pcm_load_en <= #U_DLY 1'b0;
            cfg_pcm_keyer_en <= #U_DLY 1'b0;
            cfg_pcm_header <= #U_DLY 8'd3;

            dy_cfg_data <= #U_DLY {80'd0,16'd50,64'd0};
            cfg_dy_header <= #U_DLY 8'd2;

            cfg_keyer_sel <= #U_DLY 1'b0;

            cfg_status_waittime <= #U_DLY 32'h23C3_1720;
            cfg_key_filter_data <= #U_DLY 32'd1874_9999;
            cfg_rm_time <= #U_DLY 32'd0;

            cfg_udp_socket <= #U_DLY 4'b0100;
            cfg_udp_srcport <= #U_DLY 16'd30000;
            cfg_udp_dstport <= #U_DLY 16'd30001;
            cfg_phy_srcip <= #U_DLY 32'hc0a86402; // 192.168.100.2
            cfg_phy_dstip <= #U_DLY 32'he0010104; // 192.168.100.1 
            cfg_phy_srcmac <= #U_DLY 48'haabbccddeeff;
            cfg_phy_dstmac <= #U_DLY 48'h0;
        end
    else
        begin
            if(reg_cfg_wr_en == 1'b1)
                case(reg_cfg_addr)
                    16'h0001    : test_reg <= #U_DLY ~reg_cfg_wr_data;
                    16'h0002    : init_cfg_rstn <= reg_cfg_wr_data[0];
                    16'h0003    : soft_rst_en <= #U_DLY reg_cfg_wr_data[0];

                    16'h0010    : cfg_ins_txcnt <= #U_DLY reg_cfg_wr_data[15:0];
                    16'h0011    : cfg_ins_enable <= #U_DLY reg_cfg_wr_data[7:0];
                    16'h0012    : cfg_ins_length <= #U_DLY reg_cfg_wr_data[15:0];
                    16'h0013    : cfg_ins_waittime <= #U_DLY reg_cfg_wr_data;

                    16'h0020    : cfg_pcm_bitrate <= #U_DLY reg_cfg_wr_data;
                    16'h0021    : cfg_pcm_fbias <= #U_DLY reg_cfg_wr_data;
                    16'h0022    : cfg_pcm_multsubc <= #U_DLY reg_cfg_wr_data[7:0];
                    16'h0023    : cfg_pcm_codesel <= #U_DLY reg_cfg_wr_data[3:0];
                    16'h0024    : cfg_pcm_load_en <= #U_DLY reg_cfg_wr_data[0];
                    16'h0025    : cfg_pcm_keyer_en <= #U_DLY reg_cfg_wr_data[0];
                    16'h0026    : cfg_pcm_header <= #U_DLY reg_cfg_wr_data[7:0];

                    16'h0030    : dy_cfg_data[0*32+:32] <= #U_DLY reg_cfg_wr_data;                
                    16'h0031    : dy_cfg_data[1*32+:32] <= #U_DLY reg_cfg_wr_data;
                    16'h0032    : dy_cfg_data[2*32+:32] <= #U_DLY reg_cfg_wr_data;
                    16'h0033    : dy_cfg_data[3*32+:32] <= #U_DLY reg_cfg_wr_data;
                    16'h0034    : dy_cfg_data[4*32+:32] <= #U_DLY reg_cfg_wr_data;
                    16'h0035    : cfg_dy_header <= #U_DLY reg_cfg_wr_data[7:0];

                    16'h0040    : cfg_keyer_sel <= #U_DLY reg_cfg_wr_data[0];

                    16'h0050    : cfg_status_waittime <= #U_DLY reg_cfg_wr_data;
                    16'h0051    : cfg_key_filter_data <= #U_DLY reg_cfg_wr_data;
                    16'h0052    : cfg_rm_time <= #U_DLY reg_cfg_wr_data;

                    16'h0060    : cfg_udp_socket <= #U_DLY reg_cfg_wr_data[3:0];
                    16'h0061    : cfg_udp_srcport <= #U_DLY reg_cfg_wr_data[15:0];
                    16'h0062    : cfg_udp_dstport <= #U_DLY reg_cfg_wr_data[15:0];
                    16'h0063    : cfg_phy_srcip <= #U_DLY reg_cfg_wr_data; // 192.168.100.2
                    16'h0064    : cfg_phy_dstip <= #U_DLY reg_cfg_wr_data; // 192.168.100.1 
                    16'h0065    : cfg_phy_srcmac[47:32] <= #U_DLY reg_cfg_wr_data[15:0];
                    16'h0066    : cfg_phy_srcmac[31:0] <= #U_DLY reg_cfg_wr_data;
                    16'h0067    : cfg_phy_dstmac[47:32] <= #U_DLY reg_cfg_wr_data[15:0];
                    16'h0068    : cfg_phy_dstmac[31:0] <= #U_DLY reg_cfg_wr_data;
                    default :;
                endcase
            else
                begin
                    soft_rst_en <= #U_DLY 1'b0;
                end
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        cfg_rm_time_valid <= #U_DLY 1'b0;
    else
        begin
            if((reg_cfg_wr_en == 1'b1) && (reg_cfg_addr == 16'h0052))
                cfg_rm_time_valid <= #U_DLY 1'b1;
            else
                cfg_rm_time_valid <= #U_DLY 1'b0;
        end
end

endmodule



