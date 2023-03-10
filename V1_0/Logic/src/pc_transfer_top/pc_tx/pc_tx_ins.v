// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/09 17:36:51
// File Name    : pc_tx_ins.v
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
// pc_tx_ins
//    |---
// 
`timescale 1ns/1ns

module pc_tx_ins#
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
// TX Instruct Data
// dfifo_rd_data[575:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    output reg                      txins_fifo_rd_en            , 
    input                   [575:0] txins_fifo_rd_data          , 
    input                           txins_fifo_empty            , 
// ----------------------------------------------------------------------------
// RX Instruct Data
// dfifo_rd_data[575:512] : (8byte)  time
// dfifo_rd_data[511:0]   : (64byte) instruct data
// ----------------------------------------------------------------------------
    output reg                      rxins_fifo_rd_en            , 
    input                   [575:0] rxins_fifo_rd_data          , 
    input                           rxins_fifo_empty            , 
// ----------------------------------------------------------------------------
// Key Data
// key_fifo_rd_data[79:16] : (8byte) time
// key_fifo_rd_data[15:0]  : (2byte) key data
// ----------------------------------------------------------------------------
    output reg                      key_fifo_rd_en              , 
    input                    [80:0] key_fifo_rd_data            , 
    input                           key_fifo_empty              , 
// ----------------------------------------------------------------------------
// Config Register Data
// ----------------------------------------------------------------------------
    input                    [15:0] cfg_ins_length              , 
// ----------------------------------------------------------------------------
// Instruct Pakadge Frame
// ----------------------------------------------------------------------------
    output reg                      ins_wr_req                  , 
    input                           ins_wr_ack                  , 
    output reg                      ins_wr_done                 , 

    output reg                      ins_wr_en                   , 
    output reg                [7:0] ins_wr_data                   
);

localparam IDLE         = 2'b00;
localparam ARBIT        = 2'b01; 
localparam WRITE_DATA   = 2'b11;

reg                           [1:0] c_state                     ; 
reg                           [1:0] n_state                     ; 

wire                          [2:0] user_req                    ; 
reg                           [2:0] c_user                      ; 
wire                          [2:0] user_reqn                   ; 

reg                                 step_en                     ; 
reg                           [7:0] step_data                   ; 
reg                           [7:0] step_cnt                    ; 

reg                                 txins_wr_en                 ; 
reg                           [7:0] txins_wr_data               ; 

reg                                 rxins_wr_en                 ; 
reg                           [7:0] rxins_wr_data               ; 

reg                                 key_wr_en                   ; 
reg                           [7:0] key_wr_data                 ; 

reg                                 ins_wr_done_tmp             ; 

assign user_req = {key_fifo_empty,rxins_fifo_empty,txins_fifo_empty};
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
                if(ins_wr_done == 1'b1)
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
        c_user <= #U_DLY 3'd0;
    else
        begin
            if(c_state == ARBIT)
                case({c_user[1:0],user_reqn})
                    5'b00_000   : c_user <= #U_DLY 3'd0;
                    5'b00_001   : c_user <= #U_DLY 3'd0;
                    5'b00_010   : c_user <= #U_DLY 3'd1;
                    5'b00_011   : c_user <= #U_DLY 3'd1;
                    5'b00_100   : c_user <= #U_DLY 3'd2;
                    5'b00_101   : c_user <= #U_DLY 3'd2;
                    5'b00_110   : c_user <= #U_DLY 3'd1;
                    5'b00_111   : c_user <= #U_DLY 3'd1;
                    5'b01_000   : c_user <= #U_DLY 3'd1;
                    5'b01_001   : c_user <= #U_DLY 3'd0;
                    5'b01_010   : c_user <= #U_DLY 3'd1;
                    5'b01_011   : c_user <= #U_DLY 3'd0;
                    5'b01_100   : c_user <= #U_DLY 3'd2;
                    5'b01_101   : c_user <= #U_DLY 3'd2;
                    5'b01_110   : c_user <= #U_DLY 3'd2;
                    5'b01_111   : c_user <= #U_DLY 3'd2;      
                    5'b10_000   : c_user <= #U_DLY 3'd2;
                    5'b10_001   : c_user <= #U_DLY 3'd0;
                    5'b10_010   : c_user <= #U_DLY 3'd1;
                    5'b10_011   : c_user <= #U_DLY 3'd0;
                    5'b10_100   : c_user <= #U_DLY 3'd2;
                    5'b10_101   : c_user <= #U_DLY 3'd0;
                    5'b10_110   : c_user <= #U_DLY 3'd1;
                    5'b10_111   : c_user <= #U_DLY 3'd0;             
                    default     : c_user <= #U_DLY 3'd0;
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
        ins_wr_req <= #U_DLY 1'b0;
    else
        begin
            if((c_state == ARBIT) && (&user_req == 1'b0))
                ins_wr_req <= #U_DLY 1'b1;
            else if(ins_wr_ack == 1'b1)
                ins_wr_req <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ins_wr_done_tmp <= #U_DLY 1'b0;
    else
        begin
            if(step_cnt == step_data)
                ins_wr_done_tmp <= #U_DLY 1'b1;
            else
                ins_wr_done_tmp <= #U_DLY 1'b0;
        end
end


always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ins_wr_done <= #U_DLY 1'b0;
    else
        ins_wr_done <= #U_DLY ins_wr_done_tmp;
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
            4'd0    : step_data <= #U_DLY cfg_ins_length[7:0] + 8'd8 + 8'd10;
            4'd1    : step_data <= #U_DLY cfg_ins_length[7:0] + 8'd8 + 8'd10;
            4'd2    : step_data <= #U_DLY 8'd22;
            default : step_data <= #U_DLY 8'd0;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        if(ins_wr_ack == 1'b1)
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
// TX instruct config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txins_wr_en <= #U_DLY 1'b0;
    else 
        begin
            if((c_user == 3'd0) && (step_en == 1'b1) && (step_cnt >= 8'd0) && (step_cnt < step_data))
                txins_wr_en <= #U_DLY 1'b1;
            else
                txins_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txins_wr_data <= #U_DLY 8'd0;
    else
        begin
            if(c_user == 3'd0)
                case(step_cnt)
                    8'd0    : txins_wr_data <= #U_DLY 8'h00;
                    8'd1    : txins_wr_data <= #U_DLY 8'h00;
                    8'd2    : txins_wr_data <= #U_DLY 8'h00;
                    8'd3    : txins_wr_data <= #U_DLY cfg_ins_length[7:0] + 8'd8 + 8'd16;
                    8'd4    : txins_wr_data <= #U_DLY 8'h00;
                    8'd5    : txins_wr_data <= #U_DLY 8'h00;
                    8'd6    : txins_wr_data <= #U_DLY 8'h00;
                    8'd7    : txins_wr_data <= #U_DLY 8'h00;
                    8'd8    : txins_wr_data <= #U_DLY 8'h00;
                    8'd9    : txins_wr_data <= #U_DLY 8'h02;
                    default : txins_wr_data <= #U_DLY txins_fifo_rd_data[(8'd81-step_cnt)*8+:8];
                endcase
            else
                txins_wr_data <= #U_DLY 8'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        txins_fifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_user == 3'd0) && (step_cnt == step_data))
                txins_fifo_rd_en <= #U_DLY 1'b1;
            else
                txins_fifo_rd_en <= #U_DLY 1'b0;
        end
end


// ============================================================================
// RX instruct config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxins_wr_en <= #U_DLY 1'b0;
    else 
        begin
            if((c_user == 3'd1) && (step_en == 1'b1) && (step_cnt >= 8'd0) && (step_cnt < step_data))
                rxins_wr_en <= #U_DLY 1'b1;
            else
                rxins_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxins_wr_data <= #U_DLY 8'd0;
    else
        begin
            if(c_user == 3'd1)
                case(step_cnt)
                    8'd0    : rxins_wr_data <= #U_DLY 8'h00;
                    8'd1    : rxins_wr_data <= #U_DLY 8'h00;
                    8'd2    : rxins_wr_data <= #U_DLY 8'h00;
                    8'd3    : rxins_wr_data <= #U_DLY cfg_ins_length[7:0] + 8'd8 + 8'd16;
                    8'd4    : rxins_wr_data <= #U_DLY 8'h00;
                    8'd5    : rxins_wr_data <= #U_DLY 8'h00;
                    8'd6    : rxins_wr_data <= #U_DLY 8'h00;
                    8'd7    : rxins_wr_data <= #U_DLY 8'h00;
                    8'd8    : rxins_wr_data <= #U_DLY 8'h00;
                    8'd9    : rxins_wr_data <= #U_DLY 8'h03;
                    default : rxins_wr_data <= #U_DLY rxins_fifo_rd_data[(8'd81-step_cnt)*8+:8];
                endcase
            else
                rxins_wr_data <= #U_DLY 8'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxins_fifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_user == 3'd1) && (step_cnt == step_data))
                rxins_fifo_rd_en <= #U_DLY 1'b1;
            else
                rxins_fifo_rd_en <= #U_DLY 1'b0;
        end
end

// ============================================================================
// TX instruct config data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        key_wr_en <= #U_DLY 1'b0;
    else 
        begin
            if((c_user == 3'd2) && (step_en == 1'b1) && (step_cnt >= 8'd0) && (step_cnt < step_data))
                key_wr_en <= #U_DLY 1'b1;
            else
                key_wr_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        key_wr_data <= #U_DLY 8'd0;
    else
        begin
            if(c_user == 3'd2)
                case(step_cnt)
                    8'd0    : key_wr_data <= #U_DLY 8'h00;
                    8'd1    : key_wr_data <= #U_DLY 8'h00;
                    8'd2    : key_wr_data <= #U_DLY 8'h00;
                    8'd3    : key_wr_data <= #U_DLY 8'd28;
                    8'd4    : key_wr_data <= #U_DLY 8'h00;
                    8'd5    : key_wr_data <= #U_DLY 8'h00;
                    8'd6    : key_wr_data <= #U_DLY 8'h00;
                    8'd7    : key_wr_data <= #U_DLY 8'h00;
                    8'd8    : key_wr_data <= #U_DLY 8'h00;
                    8'd9    : key_wr_data <= #U_DLY 8'h01;
                    8'd10   : key_wr_data <= #U_DLY key_fifo_rd_data[9*8+:8];
                    8'd11   : key_wr_data <= #U_DLY key_fifo_rd_data[8*8+:8];
                    8'd12   : key_wr_data <= #U_DLY key_fifo_rd_data[7*8+:8];
                    8'd13   : key_wr_data <= #U_DLY key_fifo_rd_data[6*8+:8];
                    8'd14   : key_wr_data <= #U_DLY key_fifo_rd_data[5*8+:8];
                    8'd15   : key_wr_data <= #U_DLY key_fifo_rd_data[4*8+:8];
                    8'd16   : key_wr_data <= #U_DLY key_fifo_rd_data[3*8+:8];
                    8'd17   : key_wr_data <= #U_DLY key_fifo_rd_data[2*8+:8];
                    8'd18   : key_wr_data <= #U_DLY 8'h00;
                    8'd19   : key_wr_data <= #U_DLY key_fifo_rd_data[80];
                    8'd20   : key_wr_data <= #U_DLY key_fifo_rd_data[1*8+:8];
                    8'd21   : key_wr_data <= #U_DLY key_fifo_rd_data[0*8+:8];
                    default : key_wr_data <= #U_DLY 8'h00;
                endcase
            else
                key_wr_data <= #U_DLY 8'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        key_fifo_rd_en <= #U_DLY 1'b0;
    else
        begin
            if((c_user == 3'd2) && (step_cnt == step_data))
                key_fifo_rd_en <= #U_DLY 1'b1;
            else
                key_fifo_rd_en <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Response pakadge frame Data
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ins_wr_en <= #U_DLY 1'b0;
    else
        case(c_user)
            4'd0    : ins_wr_en <= #U_DLY txins_wr_en;
            4'd1    : ins_wr_en <= #U_DLY rxins_wr_en;
            4'd2    : ins_wr_en <= #U_DLY key_wr_en;
            default : ins_wr_en <= #U_DLY 1'b0;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        ins_wr_data <= #U_DLY 8'd0;
    else
        case(c_user)
            4'd0    : ins_wr_data <= #U_DLY txins_wr_data;
            4'd1    : ins_wr_data <= #U_DLY rxins_wr_data;
            4'd2    : ins_wr_data <= #U_DLY key_wr_data;
            default : ins_wr_data <= #U_DLY 8'd0;
        endcase
end

endmodule







