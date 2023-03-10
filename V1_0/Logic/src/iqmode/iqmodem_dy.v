// +FHDR============================================================================/
// Author       : huangjie
// Creat Time   : 2020/08/05 16:38:29
// File Name    : iqmodem_dy.v
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
// iqmodem_dy
//    |---
// 
`timescale 1ns/1ps

module iqmodem_dy #
(
    parameter                   U_DLY = 1
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Config
// ----------------------------------------------------------------------------
    input                           cfg_dy_load_en              , 
    input                           cfg_dy_keyer_en             , 
    input                    [15:0] cfg_dy_fbias                , 
// ----------------------------------------------------------------------------
// DY Instruct Data
// ----------------------------------------------------------------------------
    input                           dy_tx_en                    , 
    input                   [127:0] dy_tx_data                  , 
// ----------------------------------------------------------------------------
// DAC data
// ----------------------------------------------------------------------------
    output reg               [11:0] dy_idata                    , 
    output reg               [11:0] dy_qdata                      
);

reg                         [127:0] dy_tx_data_latch            ; 

wire                                baud_5ms                    ; 
reg                                 start_req                   ; 
reg                                 step_en                     ; 
reg                           [3:0] step_cnt                    ; 
reg                          [15:0] nco_ch_en                   ; 

reg                          [31:0] nco_fcfg_mem [15:0]         ; 
wire                        [255:0] nco_out                     ; 
reg                         [287:0] nco_ch_data                 ; 

reg                          [17:0] add_sum                     ; 
wire                         [31:0] mult_data                   ; 
reg                          [31:0] mult_reg                    ; 

wire                         [15:0] sin_data                    ; 
wire                         [15:0] cos_data                    ; 
 
genvar                              i                           ;

cb_baud_gen #
(
    .U_DLY                          (U_DLY                      ), 
    .DW                             (20                         )  
)
u_cb_baud_gen
(
//-----------------------------------------------------------------------------------
// Golbal Signals
//-----------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------------
// Other Signals
//-----------------------------------------------------------------------------------
    .baud_rate                      (20'd312499                 ), // (input )
    .baud_en                        (baud_5ms                   )  // (output)
);

// ============================================================================
// TX control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        dy_tx_data_latch <= #U_DLY 128'd0;
    else
        begin
            if(dy_tx_en == 1'b1)
                dy_tx_data_latch <= #U_DLY dy_tx_data;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        start_req <= #U_DLY 1'b0;
    else
        begin
            if(dy_tx_en == 1'b1)
                start_req <= #U_DLY 1'b1;
            else if(baud_5ms == 1'b1)
                start_req <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        begin
            if((baud_5ms == 1'b1) && (start_req == 1'b1))
                step_en <= #U_DLY 1'b1;
            else if((baud_5ms == 1'b1) && (step_cnt >= 4'd8))
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 4'd0;
    else
        begin
            if(step_en == 1'b1)
                begin
                    if(baud_5ms == 1'b1)
                        step_cnt <= #U_DLY step_cnt + 4'd1;
                    else
                        ;
                end
            else
                step_cnt <= #U_DLY 4'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        nco_ch_en <= #U_DLY 16'd0;
    else
        begin
            if(step_en == 1'b1)
                case(step_cnt)
                    4'd0    : nco_ch_en <= #U_DLY dy_tx_data_latch[7*16+:16];
                    4'd1    : nco_ch_en <= #U_DLY dy_tx_data_latch[7*16+:16];
                    4'd2    : nco_ch_en <= #U_DLY dy_tx_data_latch[6*16+:16];
                    4'd3    : nco_ch_en <= #U_DLY dy_tx_data_latch[5*16+:16];
                    4'd4    : nco_ch_en <= #U_DLY dy_tx_data_latch[4*16+:16];
                    4'd5    : nco_ch_en <= #U_DLY dy_tx_data_latch[3*16+:16];
                    4'd6    : nco_ch_en <= #U_DLY dy_tx_data_latch[2*16+:16];
                    4'd7    : nco_ch_en <= #U_DLY dy_tx_data_latch[1*16+:16]; 
                    4'd8    : nco_ch_en <= #U_DLY dy_tx_data_latch[0*16+:16];
                    default : nco_ch_en <= #U_DLY 16'd0;
                endcase
            else
                nco_ch_en <= #U_DLY 16'd0;
        end 
end

always @ (posedge clk_sys)
begin
    nco_fcfg_mem[0]  <= #U_DLY 32'h0005_5E63;//5.12k---clk60M
    nco_fcfg_mem[1]  <= #U_DLY 32'h0006_B5FC;//6.40k---clk60M
    nco_fcfg_mem[2]  <= #U_DLY 32'h0007_215C;//6.80k---clk60M
    nco_fcfg_mem[3]  <= #U_DLY 32'h0007_8CBC;//7.20k---clk60M
    nco_fcfg_mem[4]  <= #U_DLY 32'h0007_F81C;//7.60k---clk60M
    nco_fcfg_mem[5]  <= #U_DLY 32'h0008_637B;//8.00k---clk60M
    nco_fcfg_mem[6]  <= #U_DLY 32'h0008_CEDB;//8.40k---clk60M
    nco_fcfg_mem[7]  <= #U_DLY 32'h0009_3A3B;//8.80k---clk60M
    nco_fcfg_mem[8]  <= #U_DLY 32'h0009_A59B;//9.20k---clk60M
    nco_fcfg_mem[9]  <= #U_DLY 32'h000A_10FA;//9.60k---clk60M
    nco_fcfg_mem[10] <= #U_DLY 32'h000A_7C5A;//10.0k---clk60M
    nco_fcfg_mem[11] <= #U_DLY 32'h000A_E7BA;//10.4k---clk60M
    nco_fcfg_mem[12] <= #U_DLY 32'h000B_531A;//10.8k---clk60M
    nco_fcfg_mem[13] <= #U_DLY 32'h000B_BE7A;//11.2k---clk60M
    nco_fcfg_mem[14] <= #U_DLY 32'h000C_29D9;//11.6k---clk60M
    nco_fcfg_mem[15] <= #U_DLY 32'h000C_9539;//12.0k---clk60M
end

generate
for(i=0;i<16;i=i+1)
begin:nco_loop
NCODY u_NCODY
(				
    .clk                            (clk_sys                    ), 
    .reset_n                        (rst_n                      ), 
    .clken                          (1'b1                       ), 
    .phi_inc_i                      (nco_fcfg_mem[i]            ), 
    .freq_mod_i                     (32'h0                      ), 
    .phase_mod_i                    (16'h0                      ), 
    .fsin_o                         (nco_out[i*16+:16]          ), 
    .fcos_o                         (                           ), 
    .out_valid                      (                           )  
);

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        nco_ch_data[i*18+:18] <= #U_DLY 18'd0;
    else
        begin
            if(nco_ch_en[i] == 1'b1)
                nco_ch_data[i*18+:18] <= #U_DLY {nco_out[i*16+15],nco_out[i*16+15],nco_out[i*16+:16]};
            else
                nco_ch_data[i*18+:18] <= #U_DLY 18'd0;
        end
end
end
endgenerate

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        add_sum <= #U_DLY 18'd0;
    else
        add_sum <= #U_DLY nco_ch_data[0*18+:18] + nco_ch_data[1*18+:18] + nco_ch_data[2*18+:18] + nco_ch_data[3*18+:18] + 
                          nco_ch_data[4*18+:18] + nco_ch_data[5*18+:18] + nco_ch_data[6*18+:18] + nco_ch_data[7*18+:18] +  
                          nco_ch_data[8*18+:18] + nco_ch_data[9*18+:18] + nco_ch_data[10*18+:18] + nco_ch_data[11*18+:18] +  
                          nco_ch_data[12*18+:18] + nco_ch_data[13*18+:18] + nco_ch_data[14*18+:18] + nco_ch_data[15*18+:18];
end

MUL32_DY u_MUL32_DY 
(
    .dataa                          (add_sum[17:2]              ), 
    .datab                          (cfg_dy_fbias[15:0]         ), //clk,62.5M  16'd25  DYPP
    .result                         (mult_data                  )  
);	

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mult_reg <= #U_DLY 32'd0;
    else
        mult_reg <= #U_DLY mult_data;
end

NCODY_DY u_NCODY_DY 
(
    .clk                            (clk_sys                    ), 
    .reset_n                        (rst_n                      ), 
    .clken                          (1'b1                       ), 
    .phi_inc_i                      (32'h0                      ), 
    .freq_mod_i                     (mult_reg[31:0]             ), 
    .phase_mod_i                    (16'h0                      ), 
    .fsin_o                         (sin_data[15:0]             ), 
    .fcos_o                         (cos_data[15:0]             ), 
    .out_valid                      (                           )  
);

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            dy_idata <= #U_DLY 12'd0;
            dy_qdata <= #U_DLY 12'd0;
        end
    else
        begin
            if(cfg_dy_keyer_en == 1'b1)
                begin
                    if(cfg_dy_load_en == 1'b1)
                        begin
                            dy_idata <= #U_DLY cos_data[15:4];
                            dy_qdata <= #U_DLY sin_data[15:4];
                        end
                    else
                        begin
                            dy_idata <= #U_DLY 12'ha81;
                            dy_qdata <= #U_DLY 12'ha81;
                        end
                end
            else
                begin
                    dy_idata <= #U_DLY 12'd0;
                    dy_qdata <= #U_DLY 12'd0;
                end
        end
end

endmodule



