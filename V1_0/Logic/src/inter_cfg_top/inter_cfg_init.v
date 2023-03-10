// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/13 09:28:24
// File Name    : inter_cfg_init.v
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
// inter_cfg_init
//    |---
// 
`timescale 1ns/1ps

module inter_cfg_init #
(
    parameter                       U_DLY = 1                   
)
(
// ----------------------------------------------------------------------------
// Clock & Reset
// ----------------------------------------------------------------------------
    input                           clk_sys                     , 
    input                           rst_n                       , 
// ----------------------------------------------------------------------------
// Memory Read
// ----------------------------------------------------------------------------
    output reg                      mem_rd_en                   , 
    output reg               [15:0] mem_rd_addr                 , 

    input                    [31:0] mem_rd_data                 , 
    input                           mem_rd_data_valid           , 
// ----------------------------------------------------------------------------
// Inition Write 
// ----------------------------------------------------------------------------
    output reg                      init_cfg_wr_en              , 
    output reg               [15:0] init_cfg_addr               , 
    output reg               [31:0] init_cfg_data                 
);

localparam  ADDR_NUM = 24;

reg                          [15:0] addr_arry [ADDR_NUM-1:0]    ; 
reg                          [31:0] data_arry [ADDR_NUM-1:0]    ;

reg                                 mem_rd_step_en              ; 
reg                           [7:0] mem_rd_step_cnt             ; 
reg                                 mem_rd_mask                 ; 

reg                                 init_cfg_step_en            ; 
reg                           [7:0] init_cfg_step_cnt           ; 

reg                                 init_cfg_wr_mask            ; 

// ============================================================================
// Read data from FLASH
// ============================================================================
always @ (posedge clk_sys)
begin
    addr_arry[0] <= #U_DLY 16'h0010; 
    addr_arry[1] <= #U_DLY 16'h0011; 
    addr_arry[2] <= #U_DLY 16'h0012; 
    addr_arry[3] <= #U_DLY 16'h0013; 
    addr_arry[4] <= #U_DLY 16'h0020; 
    addr_arry[5] <= #U_DLY 16'h0021; 
    addr_arry[6] <= #U_DLY 16'h0022; 
    addr_arry[7] <= #U_DLY 16'h0023; 
    addr_arry[8] <= #U_DLY 16'h0024; 
    addr_arry[9] <= #U_DLY 16'h0025; 
    addr_arry[10] <= #U_DLY 16'h0026; 
    addr_arry[11] <= #U_DLY 16'h0030; 
    addr_arry[12] <= #U_DLY 16'h0031; 
    addr_arry[13] <= #U_DLY 16'h0032; 
    addr_arry[14] <= #U_DLY 16'h0033; 
    addr_arry[15] <= #U_DLY 16'h0034; 
    addr_arry[16] <= #U_DLY 16'h0035; 
    addr_arry[17] <= #U_DLY 16'h0040; 
    addr_arry[18] <= #U_DLY 16'h0050; 
    addr_arry[19] <= #U_DLY 16'h0051; 
    addr_arry[20] <= #U_DLY 16'h0061; 
    addr_arry[21] <= #U_DLY 16'h0062; 
    addr_arry[22] <= #U_DLY 16'h0063; 
    addr_arry[23] <= #U_DLY 16'h0064; 
end           

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_step_en <= #U_DLY 1'b0;
    else
        begin
            if(mem_rd_step_cnt <= ADDR_NUM-1)
                mem_rd_step_en <= #U_DLY 1'b1;
            else
                mem_rd_step_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_step_cnt <= #U_DLY 8'd0;
    else
        begin
            if((mem_rd_step_en == 1'b1) && (mem_rd_data_valid == 1'b1))
                mem_rd_step_cnt <= #U_DLY mem_rd_step_cnt + 8'd1;
            else
                ;
        end
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_mask <= #U_DLY 1'b0;
    else
        begin
            if(mem_rd_data_valid == 1'b1)
                mem_rd_mask <= #U_DLY 1'b0;
            else if(mem_rd_step_en == 1'b1)
                mem_rd_mask <= #U_DLY 1'b1;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((mem_rd_step_en == 1'b1) && (mem_rd_mask == 1'b0) && (mem_rd_step_cnt <= ADDR_NUM-1))
                mem_rd_en <= #U_DLY 1'b1;
            else
                mem_rd_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        mem_rd_addr <= #U_DLY 16'd0;
    else
        mem_rd_addr <= #U_DLY addr_arry[mem_rd_step_cnt];
end

always @ (posedge clk_sys)
begin
    if(mem_rd_data_valid == 1'b1)
        data_arry[mem_rd_step_cnt] <= #U_DLY mem_rd_data;
    else
        ;
end

// ============================================================================
// Internal regester configration process
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        init_cfg_step_en <= #U_DLY 1'b0;
    else
        begin
            if((mem_rd_data_valid == 1'b1) && (mem_rd_step_cnt == ADDR_NUM-1))
                init_cfg_step_en <= #U_DLY 1'b1;
            else if(init_cfg_step_cnt >= ADDR_NUM-1)
                init_cfg_step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        init_cfg_step_cnt <= #U_DLY 8'd0;
    else
        begin
            if(init_cfg_step_en == 1'b1)
                begin
                    if(init_cfg_wr_en == 1'b1)
                        init_cfg_step_cnt <= #U_DLY init_cfg_step_cnt + 8'd1;
                    else
                        ;
                end
            else
                init_cfg_step_cnt <= #U_DLY 8'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        init_cfg_wr_mask <= #U_DLY 1'b0;
    else
        begin
            if(init_cfg_wr_en == 1'b1)
                init_cfg_wr_mask <= #U_DLY 1'b0;
            else if(init_cfg_step_en == 1'b1)
                init_cfg_wr_mask <= #U_DLY 1'b1;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        init_cfg_wr_en <= #U_DLY 1'b0;
    else
        begin
            if((init_cfg_step_en == 1'b1) && (init_cfg_wr_mask == 1'b0))
                init_cfg_wr_en <= #U_DLY 1'b1;
            else
                init_cfg_wr_en <= #U_DLY 1'b0;
        end 
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        init_cfg_addr <= #U_DLY 16'd0;
    else
        init_cfg_addr <= #U_DLY addr_arry[init_cfg_step_cnt];
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        init_cfg_data <= #U_DLY 32'd0;
    else
        init_cfg_data <= #U_DLY data_arry[init_cfg_step_cnt];
end

endmodule





