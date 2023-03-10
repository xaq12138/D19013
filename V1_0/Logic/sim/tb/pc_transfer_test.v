// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 09:08:33
// File Name    : pc_transfer_test.v
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
// pc_transfer_test
//    |---
// 
`timescale 1ns/1ns

module pc_transfer_test ;

wire                                clk_sys                     ; 
reg                                 rst_n                       ; 

reg                           [7:0] pc_lcrx_data                ; 
reg                                 pc_lcrx_data_valid          ; 

reg                           [7:0] pc_rmrx_data                ; 
reg                                 pc_rmrx_data_valid          ; 

reg                          [15:0] key_data                    ; 
reg                                 key_data_valid              ; 

reg                         [575:0] txins_data                  ; 
reg                                 txins_data_valid            ; 

reg                         [575:0] rxins_data                  ; 
reg                                 rxins_data_valid            ; 

reg                         [519:0] memins_data                 ; 
reg                                 memins_data_valid           ; 

reg                           [7:0] slr_rd_data                 ; 
reg                                 slr_rd_data_valid           ; 
                         
reg                           [7:0] upcovert_rd_data            ; 
reg                                 upcovert_rd_data_valid      ; 

wire                                inter_cfg_wr_en             ; 
wire                                inter_cfg_rd_en             ; 
wire                         [15:0] inter_cfg_addr              ; 
wire                         [31:0] inter_cfg_wr_data           ; 
wire                         [31:0] inter_cfg_rd_data           ; 
wire                                inter_cfg_rd_data_valid     ; 


wire                                mem_rd_en                   ; 
wire                         [15:0] mem_rd_addr                 ; 

wire                         [31:0] mem_rd_data                 ; 
wire                                mem_rd_data_valid           ; 

wire                         [15:0] cfg_ins_length              ; 
wire                         [31:0] cfg_status_waittime         ; 

reg                           [7:0] src_data                    ; 
reg                                 src_data_valid              ; 
reg                                 crc_clr                     ; 
wire                         [31:0] crc_data                    ; 

reg                           [7:0] pkg_data [127:0]            ; 
reg                          [31:0] crc_latch                   ; 

sim_clk_mdl #
(
    .CLK_PERIOD                     (10                         )  
)
u_sim_clk_mdl
(
// ----------------------------------------------------------------------------
// Clock Source
// ----------------------------------------------------------------------------
    .clk_p                          (clk_sys                    ), // (output)
    .clk_n                          (                           )  // (output)
);

pc_transfer_top #
(
    .U_DLY                          (1                          ), 
    .STATUS_SAMPLE_DATA             (4499                       )  
)
u_transfer_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Local PC data
// ----------------------------------------------------------------------------
    .pc_lcrx_data                   (pc_lcrx_data[7:0]          ), // (input )
    .pc_lcrx_data_valid             (pc_lcrx_data_valid         ), // (input )
    
    .pc_lctx_en                     (                           ), // (output)
    .pc_lctx_data                   (                           ), // (output)
// ----------------------------------------------------------------------------
// Remote PC data
// ----------------------------------------------------------------------------
    .pc_rmrx_data                   (pc_rmrx_data[7:0]          ), // (input )
    .pc_rmrx_data_valid             (pc_rmrx_data_valid         ), // (input )

    .pc_rmtx_en                     (                           ), // (output)
    .pc_rmtx_data                   (                           ), // (output)
// ----------------------------------------------------------------------------
// Monitor Data
// ----------------------------------------------------------------------------
    .debug_port_status              (32'h0011_aa55              ), // (input )
    .debug_power_current            (16'h0055                   ), // (input )
    .debug_power_voltage            (16'h00aa                   ), // (input )
    .debug_power_status             (16'h0001                   ), // (input )
    .debug_local_time               (64'h55443322_aabbccdd      ), // (input )
// ----------------------------------------------------------------------------
// Key Data
// ----------------------------------------------------------------------------
    .key_data                       (key_data[15:0]             ), // (input )
    .key_data_valid                 (key_data_valid             ), // (input )
// ----------------------------------------------------------------------------
// TX Instruct Data
// dfifo_rd_data[576:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    .txins_data                     (txins_data[575:0]          ), // (input )
    .txins_data_valid               (txins_data_valid           ), // (input )
// ----------------------------------------------------------------------------
// SLR RX Instruct Data
// dfifo_rd_data[576:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    .rxins_data                     (rxins_data[575:0]          ), // (input )
    .rxins_data_valid               (rxins_data_valid           ), // (input )
// ----------------------------------------------------------------------------
// Read Instruct Data
//
// instruct_rd_data[511:0]      : instruct data
// ----------------------------------------------------------------------------
    .memins_data                    (memins_data[511:0]         ), // (input )
    .memins_data_valid              (memins_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Instruct Config Data 
//
// instruct_cfg_data[15:0] insInstruct sign
// ----------------------------------------------------------------------------
    .instruct_cfg_data              (                           ), // (output)
    .instruct_cfg_data_valid        (                           ), // (output)
// ----------------------------------------------------------------------------
// SLR Config Data
// ----------------------------------------------------------------------------
    .slr_cfg_data                   (                           ), // (output)
    .slr_cfg_data_valid             (                           ), // (output)

    .slr_rd_data                    (slr_rd_data[7:0]           ), // (input )
    .slr_rd_data_valid              (slr_rd_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Up Convert Config Data
// ----------------------------------------------------------------------------
    .upconvert_cfg_data             (                           ), // (output)
    .upconvert_cfg_data_valid       (                           ), // (output)

    .upcovert_rd_data               (upcovert_rd_data[7:0]      ), // (input )
    .upcovert_rd_data_valid         (upcovert_rd_data_valid     ), // (input )
// ----------------------------------------------------------------------------
// Config Data To Memory
// ----------------------------------------------------------------------------
    .mem_cfg_data                   (                           ), // (output)
    .mem_cfg_data_valid             (                           ), // (output)
// ----------------------------------------------------------------------------
// Internal Config Port
// ----------------------------------------------------------------------------
    .inter_cfg_wr_en                (inter_cfg_wr_en            ), // (output)
    .inter_cfg_rd_en                (inter_cfg_rd_en            ), // (output)
    .inter_cfg_addr                 (inter_cfg_addr[15:0]       ), // (output)
    .inter_cfg_wr_data              (inter_cfg_wr_data[31:0]    ), // (output)
    .inter_cfg_rd_data              (inter_cfg_rd_data[31:0]    ), // (input )
    .inter_cfg_rd_data_valid        (inter_cfg_rd_data_valid    ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .pc_ch_mode                     (pc_ch_mode                 ), // (output)

    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (input ) 指令长度
    .cfg_status_waittime            (cfg_status_waittime[31:0]  )  // (input )  
);

inter_cfg_top # 
(
    .U_DLY                          (1                          ), 
    .FPGA_VER                       (32'h00000010               )  
)
u_inter_cfg_top
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Internal Config Data
// ----------------------------------------------------------------------------
    .inter_cfg_wr_en                (inter_cfg_wr_en            ), // (input )
    .inter_cfg_rd_en                (inter_cfg_rd_en            ), // (input )
    .inter_cfg_addr                 (inter_cfg_addr[15:0]       ), // (input )
    .inter_cfg_wr_data              (inter_cfg_wr_data[31:0]    ), // (input )
    .inter_cfg_rd_data              (inter_cfg_rd_data[31:0]    ), // (output)
    .inter_cfg_rd_data_valid        (inter_cfg_rd_data_valid    ), // (output)
// ----------------------------------------------------------------------------
// Memory Read
// ----------------------------------------------------------------------------
    .mem_rd_en                      (mem_rd_en                  ), // (output)
    .mem_rd_addr                    (mem_rd_addr[15:0]          ), // (output)

    .mem_rd_data                    (mem_rd_data[31:0]          ), // (input )
    .mem_rd_data_valid              (mem_rd_data_valid          ), // (input )
// ----------------------------------------------------------------------------
// Config Data
// ----------------------------------------------------------------------------
    .cfg_ins_txcnt                  (                           ), // (output) 指令发送次数
    .cfg_ins_enable                 (                           ), // (output) 指令有效标志
    .cfg_ins_length                 (cfg_ins_length[15:0]       ), // (output) 指令长度
    .cfg_ins_waittime               (                           ), // (output) 发送间隔时间

    .cfg_pcm_bitrate                (                           ), // (output) PCM码率
    .cfg_pcm_fbias                  (                           ), // (output) PCM频偏
    .cfg_pcm_multsubc               (                           ), // (output) 副载波倍数
    .cfg_pcm_codesel                (                           ), // (output) 码型选择
    .cfg_pcm_load_en                (                           ), // (output) 加载使能
    .cfg_pcm_keyer_en               (                           ), // (output) 加调使能

    .dy_cfg_data                    (                           ), // (output)

    .cfg_keyer_sel                  (                           ), // (output)调制体制选择  

    .cfg_status_waittime            (cfg_status_waittime[31:0]  )  // (output)
);

sim_cfg_mem #
(
    .U_DLY                          (1                          )  
)
u_sim_cfg_mem
(
// ----------------------------------------------------------------------------
// Clock Source
// ----------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
// ----------------------------------------------------------------------------
// Memory Read
// ----------------------------------------------------------------------------
    .mem_rd_en                      (mem_rd_en                  ), // (input )
    .mem_rd_addr                    (mem_rd_addr[15:0]          ), // (input )
    
    .mem_rd_data                    (mem_rd_data[31:0]          ), // (output)
    .mem_rd_data_valid              (mem_rd_data_valid          )  // (output)
);

cb_crc32 #
(
    .U_DLY                          (1                          )  
)
u_cb_crc32
(
//-----------------------------------------------------------------------------------
// Clock & Reset
//-----------------------------------------------------------------------------------
    .clk_sys                        (clk_sys                    ), // (input )
    .rst_n                          (rst_n                      ), // (input )
//-----------------------------------------------------------------------------------
// CRC32 Clear Signal
//-----------------------------------------------------------------------------------
    .crc_clear                      (crc_clr                    ), // (input )
//-----------------------------------------------------------------------------------
// Source Data
//-----------------------------------------------------------------------------------
    .src_data                       (src_data[7:0]              ), // (input )
    .src_data_valid                 (src_data_valid             ), // (input )
//-----------------------------------------------------------------------------------
// Source Data
//-----------------------------------------------------------------------------------
    .crc_data                       (crc_data[31:0]             ), // (output)
    .crc_data_valid                 (                           )  // (output)
);

CRC32ForPhy
u_CRC32ForPhy
(
    .data_in                        (src_data[7:0]              ), // (input )
    .crc_en                         (src_data_valid             ), // (input )
    .crc_out                        (                           ), // (output)
    .rst                            (!rst_n                     ), // (input )
    .clk                            (clk_sys                    )  // (input )
);

always @ (*)
begin
    if(rst_n == 1'b0)
        src_data = 0;
    else if(pc_lcrx_data_valid == 1'b1)
        src_data = pc_lcrx_data;
    else if(pc_rmrx_data_valid == 1'b1)
        src_data = pc_rmrx_data;
    else
        ;
end

always @ (*)
begin
    if(rst_n == 1'b0)
        src_data_valid = 0;
    else if((pc_lcrx_data_valid == 1'b1) || (pc_rmrx_data_valid == 1'b1))
        src_data_valid = 1;
    else
        src_data_valid = 0;
end

initial
begin
    rst_n = 0;

    pc_lcrx_data = 0;     
    pc_lcrx_data_valid = 0;                    
    pc_rmrx_data = 0;
    pc_rmrx_data_valid = 0;    
    key_data = 0;
    key_data_valid = 0;
    txins_data = 0;         
    txins_data_valid = 0;                     
    rxins_data = 0;          
    rxins_data_valid = 0;                       
    memins_data =0;         
    memins_data_valid =0;   
    slr_rd_data = 0;
    slr_rd_data_valid = 0;
    upcovert_rd_data = 0;
    upcovert_rd_data_valid = 0;
    crc_clr =0;             
    crc_latch = 0;

    #2000;
    rst_n = 1;
end


initial
begin

    #1000;

    if(rst_n == 0)
        @(posedge rst_n);
    
    test_process(0);

    pkg_data[0] = 8'h01;
    test_pkg_gen(0,16'h8002,32'd16);

    #3000;
 //   test_process(1);

    #500;
    user_key_process(16'h0010);
    user_txins_process({64'h99aa_bbcc_eedd_ff00,64'h1122_3344_5566_7788,448'd0});
    user_rxins_process({64'h99aa_bbcc_eedd_ff00,64'h1122_3344_5566_7788,448'd0});

    test_slr_process(8'h02,32'haabbccdd);
    test_upc_process();
    #3000;
    test_process(0);
end


always @ (*)
    begin
        if(u_transfer_top.u_pc_rx_wrapper.u_pc_rx_cfg.fififo_rd_data_valid == 1'b0)
            @(posedge u_transfer_top.u_pc_rx_wrapper.u_pc_rx_cfg.fififo_rd_en);
        if(u_transfer_top.u_pc_rx_wrapper.u_pc_rx_cfg.fififo_rd_data[71:56] == 16'h000a)
        begin
            #2000;
            user_mem_process({8'h08,64'h1122_3344_5566_7788,448'd0});
        end 
    end



task user_lcrx_process;
input   [7:0]    tx_data;

begin
    @(posedge clk_sys);
    pc_lcrx_data <= #1 tx_data;
    pc_lcrx_data_valid <= #1 1;

    @(posedge clk_sys);
    pc_lcrx_data_valid <= #1 0; 
    repeat(7)
    @(posedge clk_sys);
end

endtask

task user_rmrx_process;
input   [7:0]    tx_data;

begin
    @(posedge clk_sys);
    pc_rmrx_data <= #1 tx_data;
    pc_rmrx_data_valid <= #1 1;

    @(posedge clk_sys);
    pc_rmrx_data_valid <= #1 0; 
    repeat(7)
    @(posedge clk_sys);
end

endtask

task user_key_process;
input   [15:0]    tx_data;

begin
    @(posedge clk_sys);
    key_data <= #1 tx_data;
    key_data_valid <= #1 1;

    @(posedge clk_sys);
    key_data_valid <= #1 0; 
    @(posedge clk_sys);
end
endtask

task user_txins_process;
input   [575:0]    tx_data;

begin
    @(posedge clk_sys);
    txins_data <= #1 tx_data;
    txins_data_valid <= #1 1;

    @(posedge clk_sys);
    txins_data_valid <= #1 0; 
    @(posedge clk_sys);
end

endtask

task user_rxins_process;
input   [575:0]    tx_data;

begin
    @(posedge clk_sys);
    rxins_data <= #1 tx_data;
    rxins_data_valid <= #1 1;

    @(posedge clk_sys);
    rxins_data_valid <= #1 0; 
    @(posedge clk_sys);
end

endtask

task user_mem_process;
input   [519:0]    tx_data;

begin
    @(posedge clk_sys);
    memins_data <= #1 tx_data;
    memins_data_valid <= #1 1;

    @(posedge clk_sys);
    memins_data_valid <= #1 0; 
    @(posedge clk_sys);
end

endtask

task user_slr_process;
input   [7:0]    tx_data;

begin
    @(posedge clk_sys);
    slr_rd_data <= #1 tx_data;
    slr_rd_data_valid <= #1 1;

    @(posedge clk_sys);
    slr_rd_data_valid <= #1 0; 
    @(posedge clk_sys);
end

endtask

task user_upc_process;
input   [7:0]    tx_data;

begin
    @(posedge clk_sys);
    upcovert_rd_data <= #1 tx_data;
    upcovert_rd_data_valid <= #1 1;

    @(posedge clk_sys);
    upcovert_rd_data_valid <= #1 0; 
    @(posedge clk_sys);
end

endtask

task test_pkg_gen;
    input   ch_sel ;
    input   [15:0] pkg_type ;
    input   [31:0] pkg_length;

begin:task_b

integer     i   ;

@(posedge clk_sys);
crc_clr <= #1 1;
@(posedge clk_sys);
crc_clr <= #1 0;

//if(ch_sel)
    `define user_ch user_rmrx_process
//else
      

// send header
`user_ch(8'hef);
`user_ch(8'h91);
`user_ch(8'h19);
`user_ch(8'hfe);

// send type
`user_ch(pkg_type[15:8]);
`user_ch(pkg_type[7:0]);

// send length

`user_ch(pkg_length[3*8+:8]);
`user_ch(pkg_length[2*8+:8]);
`user_ch(pkg_length[1*8+:8]);
`user_ch(pkg_length[0*8+:8]);

// reserve data
`user_ch(8'h00);
`user_ch(8'h00);
`user_ch(8'h00);
`user_ch(8'h00);

// pkg data
for(i=0;i<pkg_length-14;i=i+1)
    `user_ch(pkg_data[i]);

// crc data
crc_latch = crc_data;

`user_ch(crc_latch[3*8+:8]);
`user_ch(crc_latch[2*8+:8]);
`user_ch(crc_latch[1*8+:8]);
`user_ch(crc_latch[0*8+:8]);

end 
endtask

task test_process;
    input   ch_sel;
begin:task_a
    integer     i   ;

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h05;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h50;
    pkg_data[4] = 8'h00;
    pkg_data[5] = 8'h00;
    pkg_data[6] = 8'hff;
    pkg_data[7] = 8'hff;

    test_pkg_gen(ch_sel,16'h0002,32'd22);
// instruct pkg
    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h00;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h01;

    test_pkg_gen(ch_sel,16'h0001,32'd18);

// cfg pkg
    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h03;
    pkg_data[2] = 8'h0f;
    pkg_data[3] = 8'hf0;
    pkg_data[4] = 8'h00;
    pkg_data[5] = 8'h10;
    pkg_data[6] = 8'h55;
    pkg_data[7] = 8'h11;
    pkg_data[8] = 8'h22;
    pkg_data[9] = 8'h33;
    pkg_data[10] = 8'h44;
    pkg_data[11] = 8'h0f;
    pkg_data[12] = 8'heb;
    pkg_data[13] = 8'h90;

    test_pkg_gen(ch_sel,16'h0002,32'd28);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h01;

    test_pkg_gen(ch_sel,16'h0002,32'd28);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h02;

    test_pkg_gen(ch_sel,16'h0002,32'd28);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h04;
    pkg_data[2] = 8'h7b;
    pkg_data[3] = 8'h31;
    pkg_data[4] = 8'h11;
    pkg_data[5] = 8'h22;
    pkg_data[6] = 8'h33;
    pkg_data[7] = 8'h44;
    pkg_data[8] = 8'h55;
    pkg_data[9] = 8'h66;
    pkg_data[10] = 8'h77;
    pkg_data[11] = 8'h7d;

    test_pkg_gen(ch_sel,16'h0002,32'd26);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h05;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h01;
    pkg_data[4] = 8'h11;
    pkg_data[5] = 8'h22;
    pkg_data[6] = 8'h33;
    pkg_data[7] = 8'h44;
    
    test_pkg_gen(ch_sel,16'h0002,32'd22);

// instruct length 
    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h05;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h12;
    pkg_data[4] = 8'h00;
    pkg_data[5] = 8'h00;
    pkg_data[6] = 8'h00;
    pkg_data[7] = 8'h04;

    test_pkg_gen(ch_sel,16'h0002,32'd22);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h07;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h01;
    pkg_data[4] = 8'h00;
    pkg_data[5] = 8'h00;
    pkg_data[6] = 8'h00;
    pkg_data[7] = 8'h00;
    pkg_data[8] = 8'haa;
    pkg_data[9] = 8'hbb;
    pkg_data[10] = 8'hcc;
    pkg_data[11] = 8'hdd;
    
    test_pkg_gen(ch_sel,16'h0002,32'd26);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h06;
    pkg_data[2] = 8'h0f;
    pkg_data[3] = 8'hf0;
    pkg_data[4] = 8'h00;
    pkg_data[5] = 8'h80;
    pkg_data[6] = 8'h55;
    pkg_data[7] = 8'h11;
    pkg_data[8] = 8'h22;
    pkg_data[9] = 8'h33;
    pkg_data[10] = 8'h44;
    pkg_data[11] = 8'h7e;
    pkg_data[12] = 8'heb;
    pkg_data[13] = 8'h90;

    test_pkg_gen(ch_sel,16'h0003,32'd28);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h08;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h01;
    pkg_data[4] = 8'h00;
    pkg_data[5] = 8'h00;
    pkg_data[6] = 8'h00;
    pkg_data[7] = 8'h00;
    
    test_pkg_gen(ch_sel,16'h0003,32'd22);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h09;
    pkg_data[2] = 8'h7b;
    pkg_data[3] = 8'h32;
    pkg_data[4] = 8'h30;
    pkg_data[5] = 8'h7d;
    
    test_pkg_gen(ch_sel,16'h0003,32'd20);

    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h0a;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h01;

    test_pkg_gen(ch_sel,16'h0003,32'd18);

    // instruct pkg
    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h00;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h00;
    test_pkg_gen(ch_sel,16'h0001,32'd18);

    // instruct pkg
    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h00;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h01;
    test_pkg_gen(ch_sel,16'h0001,32'd18);

    // instruct pkg
    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h00;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h02;
    test_pkg_gen(ch_sel,16'h0001,32'd18);

    // instruct pkg
    pkg_data[0] = 8'h00;
    pkg_data[1] = 8'h00;
    pkg_data[2] = 8'h00;
    pkg_data[3] = 8'h03;
    test_pkg_gen(ch_sel,16'h0001,32'd18);
end
endtask


task test_slr_process;
    input   [7:0]addr;
    input  [31:0]data;

begin
    user_slr_process(8'h0f);
    user_slr_process(8'hf0);
    user_slr_process(8'h00);
    user_slr_process(addr);
    user_slr_process(8'haa);
    user_slr_process(data[3*8+:8]);
    user_slr_process(data[2*8+:8]);
    user_slr_process(data[1*8+:8]);
    user_slr_process(data[0*8+:8]);
    user_slr_process(8'hbb);
    user_slr_process(8'heb);
    user_slr_process(8'h90);
end
endtask

task test_upc_process;
begin
    user_upc_process(8'h7b);
    user_upc_process(8'h32);
    user_upc_process(8'h00);
    user_upc_process(8'h11);
    user_upc_process(8'h22);
    user_upc_process(8'h33);
    user_upc_process(8'h44);
    user_upc_process(8'h55);
    user_upc_process(8'h66);
    user_upc_process(8'h31);
    user_upc_process(8'h31);
    user_upc_process(8'h7d);
end
endtask

endmodule




