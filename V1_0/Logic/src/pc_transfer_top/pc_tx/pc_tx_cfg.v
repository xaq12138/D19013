// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/09 15:48:11
// File Name    : pc_tx_cfg.v
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
// pc_tx_cfg
//    |---
// 
`timescale 1ns/1ps

module pc_tx_cfg #
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
// SLR Config Data FIFO Read (FWFT FIFO)
//
// Determine whether there is a frame of data in FIFO according to the PFULL signal.
// The PFULL threshold value is the frame length.
// ----------------------------------------------------------------------------
    output reg                      slr_fifo_rd_en              , 
    input                     [7:0] slr_fifo_rd_data            , 
    input                           slr_fifo_pfull              , 
// ----------------------------------------------------------------------------
// Up Convert Config Data FIFO Read (FWFT FIFO)
//
// Determine whether there is a frame of data in FIFO according to the PFULL signal.
// The PFULL threshold value is the frame length.
// ----------------------------------------------------------------------------
    output reg                      upc_fifo_rd_en              , 
    input                     [7:0] upc_fifo_rd_data            , 
    input                           upc_fifo_pfull              , 
// ----------------------------------------------------------------------------
// Internal Config Data FIFO Read (FWFT FIFO)
// ----------------------------------------------------------------------------
    output reg                      inter_fifo_rd_en            , 
    input                    [47:0] inter_fifo_rd_data          , 
    input                           inter_fifo_empty            , 
// ----------------------------------------------------------------------------
// Instruct Data FIFO Read (FWFT FIFO)
// ----------------------------------------------------------------------------
    output reg                      inst_ififo_rd_en            , 
    input                    [15:0] inst_ififo_rd_data          , 

    output reg                      inst_dfifo_rd_en            , 
    input                   [511:0] inst_dfifo_rd_data          , 
    input                           inst_dfifo_empty            , 
// ----------------------------------------------------------------------------
// Config Register Data
// ----------------------------------------------------------------------------
    input                    [15:0] cfg_ins_length              , 
// ----------------------------------------------------------------------------
// Response Pakadge Frame
// ----------------------------------------------------------------------------
    output reg                      cfg_wr_req                  , 
    input                           cfg_wr_ack                  , 
    output reg                      cfg_wr_done                 , 

    output reg                      cfg_wr_en                   , 
    output reg                [7:0] cfg_wr_data                   
);

localparam IDLE         = 2'b00;
localparam ARBIT        = 2'b01; 
localparam WRITE_DATA   = 2'b11;

reg                           [1:0] c_state                     ; 
reg                           [1:0] n_state                     ; 

wire                          [3:0] user_req                    ; 
reg                           [3:0] c_user                      ; 
wire                          [3:0] user_reqn                   ; 

reg                                 step_en                     ; 
reg                           [7:0] step_data                   ; 
reg                           [7:0] step_cnt                    ; 

reg                                 slr_wr_en                   ; 
reg                           [7:0] slr_wr_data                 ; 

reg                                 upc_wr_en                   ; 
reg                           [7:0] upc_wr_data                 ; 

reg                                 inter_wr_en                 ; 
reg                           [7:0] inter_wr_data               ; 

reg                                 inst_wr_en                  ; 
reg                           [7:0] inst_wr_data                ; 

reg                                 cfg_wr_done_tmp             ; 

assign user_req = {inst_dfifo_empty,inter_fifo_empty,~upc_fifo_pfull,~slr_fifo_pfull};
assign user_reqn = ~user_req;

// ============================================================================
// FSM - 1
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        c_state <= #U_DLY IDLE;
    else
        c_state <= #U_DLY n_state;
end

// ============================================================================
// FSM - 2
// ============================================================================
always @ (*)
begin
    case(c_state)
        IDLE        : n_state = ARBIT;
        ARBIT       : 
            begin
                if(&user_req == 1'b0)
                    n_state = WRITE_DATA;
                else
                    n_state = ARBIT;
            end
        WRITE_DATA  :
            begin
                if(cfg_wr_done == 1'b1)
                    n_state = IDLE;
                else
                    n_state = WRITE_DATA;
            end
        default     : n_state = IDLE;
    endcase
end

// ============================================================================
// User select
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        c_user <= #U_DLY 4'd0;
    else
        begin
            if(c_state == ARBIT)
                case({c_user[2:0],user_reqn})
                    7'h00   : c_user <= #U_DLY 4'd0;
                    7'h01   : c_user <= #U_DLY 4'd0;
                    7'h02   : c_user <= #U_DLY 4'd1; 
                    7'h03   : c_user <= #U_DLY 4'd1;
                    7'h04   : c_user <= #U_DLY 4'd2;
                    7'h05   : c_user <= #U_DLY 4'd2;
                    7'h06   : c_user <= #U_DLY 4'd1;
                    7'h07   : c_user <= #U_DLY 4'd1;
                    7'h08   : c_user <= #U_DLY 4'd3;
                    7'h09   : c_user <= #U_DLY 4'd3;
                    7'h0a   : c_user <= #U_DLY 4'd1;
                    7'h0b   : c_user <= #U_DLY 4'd1;
                    7'h0c   : c_user <= #U_DLY 4'd2;
                    7'h0d   : c_user <= #U_DLY 4'd2;
                    7'h0e   : c_user <= #U_DLY 4'd1;
                    7'h0f   : c_user <= #U_DLY 4'd1;
                           
                    7'h10   : c_user <= #U_DLY 4'd1;
                    7'h11   : c_user <= #U_DLY 4'd0;
                    7'h12   : c_user <= #U_DLY 4'd1; 
                    7'h13   : c_user <= #U_DLY 4'd0;
                    7'h14   : c_user <= #U_DLY 4'd2;
                    7'h15   : c_user <= #U_DLY 4'd2;
                    7'h16   : c_user <= #U_DLY 4'd2;
                    7'h17   : c_user <= #U_DLY 4'd2;
                    7'h18   : c_user <= #U_DLY 4'd3;
                    7'h19   : c_user <= #U_DLY 4'd3;
                    7'h1a   : c_user <= #U_DLY 4'd3;
                    7'h1b   : c_user <= #U_DLY 4'd3;
                    7'h1c   : c_user <= #U_DLY 4'd2;
                    7'h1d   : c_user <= #U_DLY 4'd2;
                    7'h1e   : c_user <= #U_DLY 4'd2;
                    7'h1f   : c_user <= #U_DLY 4'd2;
                                       
                    7'h20   : c_user <= #U_DLY 4'd2;
                    7'h21   : c_user <= #U_DLY 4'd0;
                    7'h22   : c_user <= #U_DLY 4'd1; 
                    7'h23   : c_user <= #U_DLY 4'd0;
                    7'h24   : c_user <= #U_DLY 4'd2;
                    7'h25   : c_user <= #U_DLY 4'd0;
                    7'h26   : c_user <= #U_DLY 4'd1;
                    7'h27   : c_user <= #U_DLY 4'd0;
                    7'h28   : c_user <= #U_DLY 4'd3;
                    7'h29   : c_user <= #U_DLY 4'd3;
                    7'h2a   : c_user <= #U_DLY 4'd3;
                    7'h2b   : c_user <= #U_DLY 4'd3;
                    7'h2c   : c_user <= #U_DLY 4'd3;
                    7'h2d   : c_user <= #U_DLY 4'd3;
                    7'h2e   : c_user <= #U_DLY 4'd3;
                    7'h2f   : c_user <= #U_DLY 4'd3;
                                        
                    7'h30   : c_user <= #U_DLY 4'd3;
                    7'h31   : c_user <= #U_DLY 4'd0;
                    7'h32   : c_user <= #U_DLY 4'd1; 
                    7'h33   : c_user <= #U_DLY 4'd0;
                    7'h34   : c_user <= #U_DLY 4'd2;
                    7'h35   : c_user <= #U_DLY 4'd0;
                    7'h36   : c_user <= #U_DLY 4'd1;
                    7'h37   : c_user <= #U_DLY 4'd0;
                    7'h38   : c_user <= #U_DLY 4'd3;
                    7'h39   : c_user <= #U_DLY 4'd0;
                    7'h3a   : c_user <= #U_DLY 4'd1;
                    7'h3b   : c_user <= #U_DLY 4'd0;
                    7'h3c   : c_user <= #U_DLY 4'd2;
                    7'h3d   : c_user <= #U_DLY 4'd0;
                    7'h3e   : c_user <= #U_DLY 4'd1;
                    7'h3f   : c_user <= #U_DLY 4'd0;
                    default : c_user <= #U_DLY 4'd0;
                endcase
            else
                ;
        end
end 

// ============================================================================
// Request send frame permission.
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        cfg_wr_req <= #U_DLY 1'b0;
    else
        begin
            if((c_state == ARBIT) && (&user_req == 1'b0))
                cfg_wr_req <= #U_DLY 1'b1;
            else if(cfg_wr_ack == 1'b1)
                cfg_wr_req <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        cfg_wr_done_tmp <= #U_DLY 1'b0;
    else
        begin
            if(step_cnt == step_data)
                cfg_wr_done_tmp <= #U_DLY 1'b1;
            else
                cfg_wr_done_tmp <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        cfg_wr_done <= #U_DLY 1'b0;
    else
        cfg_wr_done <= #U_DLY cfg_wr_done_tmp;
end

// ============================================================================
// Step control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_data <= #U_DLY 8'd0;
    else
        case(c_user)
            4'd0    : step_data <= #U_DLY 8'd22;
            4'd1    : step_data <= #U_DLY 8'd22;
            4'd2    : step_data <= #U_DLY 8'd16;
            4'd3    : step_data <= #U_DLY cfg_ins_length[7:0] + 8'd16;
            default : step_data <= #U_DLY 8'd0;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        if(cfg_wr_ack == 1'b1)
            step_en <= #U_DLY 1'b1;
        else if(step_cnt >= step_data)
            step_en <= #U_DLY 1'b0;
        else
            ;
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 8'd0;
    else
        if(step_en == 1'b1)
            step_cnt <= #U_DLY step_cnt + 8'd1;
        else
            step_cnt <= #U_DLY 8'd0;
end

// ============================================================================
// SLR config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        slr_wr_en <= #U_DLY 1'b0;
    else 
        begin
            if((c_user == 4'd0) && (step_en == 1'b1) && (step_cnt >= 8'd0) && (step_cnt < step_data))
                slr_wr_en <= #U_DLY 1'b1;
            else
                slr_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        slr_wr_data <= #U_DLY 8'd0;
    else
        case(step_cnt)
            8'd0    : slr_wr_data <= #U_DLY 8'h00;
            8'd1    : slr_wr_data <= #U_DLY 8'h00;
            8'd2    : slr_wr_data <= #U_DLY 8'h00;
            8'd3    : slr_wr_data <= #U_DLY 8'd28;
            8'd4    : slr_wr_data <= #U_DLY 8'h00;
            8'd5    : slr_wr_data <= #U_DLY 8'h00;
            8'd6    : slr_wr_data <= #U_DLY 8'h00;
            8'd7    : slr_wr_data <= #U_DLY 8'h00;
            8'd8    : slr_wr_data <= #U_DLY 8'h00;
            8'd9    : slr_wr_data <= #U_DLY 8'h06;
            default : slr_wr_data <= #U_DLY slr_fifo_rd_data;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        slr_fifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_user == 4'd0) && (step_cnt >= 8'h9) && (step_cnt < step_data-8'd1))
                slr_fifo_rd_en <= #U_DLY 1'b1;
            else
                slr_fifo_rd_en <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Up Convert config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        upc_wr_en <= #U_DLY 1'b0;
    else 
        begin
            if((c_user == 4'd1) && (step_en == 1'b1) && (step_cnt >= 8'd0) && (step_cnt < step_data))
                upc_wr_en <= #U_DLY 1'b1;
            else
                upc_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        upc_wr_data <= #U_DLY 8'd0;
    else
        case(step_cnt)
            8'd0    : upc_wr_data <= #U_DLY 8'h00;
            8'd1    : upc_wr_data <= #U_DLY 8'h00;
            8'd2    : upc_wr_data <= #U_DLY 8'h00;
            8'd3    : upc_wr_data <= #U_DLY 8'd28;
            8'd4    : upc_wr_data <= #U_DLY 8'h00;
            8'd5    : upc_wr_data <= #U_DLY 8'h00;
            8'd6    : upc_wr_data <= #U_DLY 8'h00;
            8'd7    : upc_wr_data <= #U_DLY 8'h00;
            8'd8    : upc_wr_data <= #U_DLY 8'h00;
            8'd9    : upc_wr_data <= #U_DLY 8'h09;
            default : upc_wr_data <= #U_DLY upc_fifo_rd_data;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        upc_fifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_user == 4'd1) && (step_cnt >= 8'h9) && (step_cnt < step_data-8'd1))
                upc_fifo_rd_en <= #U_DLY 1'b1;
            else
                upc_fifo_rd_en <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Internal config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_wr_en <= #U_DLY 1'b0;
    else 
        begin
            if((c_user == 4'd2) && (step_en == 1'b1) && (step_cnt >= 8'd0) && (step_cnt < step_data))
                inter_wr_en <= #U_DLY 1'b1;
            else
                inter_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_wr_data <= #U_DLY 8'd0;
    else
        case(step_cnt)
            8'd0    : inter_wr_data <= #U_DLY 8'h00;
            8'd1    : inter_wr_data <= #U_DLY 8'h00;
            8'd2    : inter_wr_data <= #U_DLY 8'h00;
            8'd3    : inter_wr_data <= #U_DLY 8'd22;
            8'd4    : inter_wr_data <= #U_DLY 8'h00;
            8'd5    : inter_wr_data <= #U_DLY 8'h00;
            8'd6    : inter_wr_data <= #U_DLY 8'h00;
            8'd7    : inter_wr_data <= #U_DLY 8'h00;
            8'd8    : inter_wr_data <= #U_DLY 8'h00;
            8'd9    : inter_wr_data <= #U_DLY 8'h09;
            default : inter_wr_data <= #U_DLY inter_fifo_rd_data[(8'd15-step_cnt)*8+:8];
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inter_fifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_user == 4'd2) && (step_cnt == step_data))
                inter_fifo_rd_en <= #U_DLY 1'b1;
            else
                inter_fifo_rd_en <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Instruct config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_wr_en <= #U_DLY 1'b0;
    else 
        begin
            if((c_user == 4'd3) && (step_en == 1'b1) && (step_cnt >= 8'd0) && (step_cnt < step_data))
                inst_wr_en <= #U_DLY 1'b1;
            else
                inst_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_wr_data <= #U_DLY 8'd0;
    else
        case(step_cnt)
            8'd0    : inst_wr_data <= #U_DLY 8'h00;
            8'd1    : inst_wr_data <= #U_DLY 8'h00;
            8'd2    : inst_wr_data <= #U_DLY 8'h00;
            8'd3    : inst_wr_data <= #U_DLY cfg_ins_length[7:0] + 8'd22;
            8'd4    : inst_wr_data <= #U_DLY 8'h00;
            8'd5    : inst_wr_data <= #U_DLY 8'h00;
            8'd6    : inst_wr_data <= #U_DLY 8'h00;
            8'd7    : inst_wr_data <= #U_DLY 8'h00;
            8'd8    : inst_wr_data <= #U_DLY 8'h00;
            8'd9    : inst_wr_data <= #U_DLY 8'h0a;
            8'd10   : inst_wr_data <= #U_DLY inst_ififo_rd_data[15:8];
            8'd11   : inst_wr_data <= #U_DLY inst_ififo_rd_data[15:8];
            8'd12   : inst_wr_data <= #U_DLY 8'h00;
            8'd13   : inst_wr_data <= #U_DLY 8'h00;
            8'd14   : inst_wr_data <= #U_DLY 8'h00;
            8'd15   : inst_wr_data <= #U_DLY 8'h00;
            default : inst_wr_data <= #U_DLY inst_dfifo_rd_data[(79-step_cnt)*8+:8];
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_ififo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_user == 4'd3) && (step_cnt == step_data))
                inst_ififo_rd_en <= #U_DLY 1'b1;
            else
                inst_ififo_rd_en <= #U_DLY 1'b0;
                
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        inst_dfifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_user == 4'd3) && (step_cnt == step_data))
                inst_dfifo_rd_en <= #U_DLY 1'b1;
            else
                inst_dfifo_rd_en <= #U_DLY 1'b0;
                
        end
end

// ============================================================================
// Response pakadge frame Data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        cfg_wr_en <= #U_DLY 1'b0;
    else
        case(c_user)
            4'd0    : cfg_wr_en <= #U_DLY slr_wr_en;
            4'd1    : cfg_wr_en <= #U_DLY upc_wr_en;
            4'd2    : cfg_wr_en <= #U_DLY inter_wr_en;
            4'd3    : cfg_wr_en <= #U_DLY inst_wr_en;
            default : cfg_wr_en <= #U_DLY 1'b0;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        cfg_wr_data <= #U_DLY 8'd0;
    else
        case(c_user)
            4'd0    : cfg_wr_data <= #U_DLY slr_wr_data;
            4'd1    : cfg_wr_data <= #U_DLY upc_wr_data;
            4'd2    : cfg_wr_data <= #U_DLY inter_wr_data;
            4'd3    : cfg_wr_data <= #U_DLY inst_wr_data;
            default : cfg_wr_data <= #U_DLY 8'd0;
        endcase
end


endmodule



