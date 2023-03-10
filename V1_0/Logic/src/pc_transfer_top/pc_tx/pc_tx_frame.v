// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:34:44
// File Name    : pc_tx_frame.v
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
// pc_tx_frame
//    |---
// 
`timescale 1ns/1ns

module pc_tx_frame #
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
// Pakadge Source
// ----------------------------------------------------------------------------
    input                     [3:0] pkg_wr_req                  , 
    output reg                [3:0] pkg_wr_ack                  , 
    input                     [3:0] pkg_wr_done                 , 

    input                     [3:0] pkg_wr_en                   , 
    input                    [31:0] pkg_wr_data                 , 
// ----------------------------------------------------------------------------
// Pakadge Source
// ----------------------------------------------------------------------------
    output reg                [7:0] pc_tx_data                  , 
    output reg                      pc_tx_data_valid              
);

localparam IDLE     = 4'b0000;
localparam ARBIT    = 4'b0001; 
localparam WRHEAD   = 4'b0011;
localparam WRDATA   = 4'b0111; 
localparam WRCRC    = 4'b0101;

reg                           [3:0] c_state                     ; 
reg                           [3:0] n_state                     ; 

reg                           [2:0] c_user                      ; 

reg                           [3:0] head_step_cnt               ; 
reg                           [3:0] crc_step_cnt                ; 

reg                                 crc_clear                   ; 
reg                                 crc_en                      ; 

wire                         [31:0] crc_data                    ; 

reg                          [15:0] frame_type                  ; 

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
        IDLE    : n_state = ARBIT;
        ARBIT   :
            begin
                if(|pkg_wr_req == 1'b1)
                    n_state = WRHEAD;
                else
                    n_state = ARBIT;
            end
        WRHEAD  : 
            begin
                if(head_step_cnt >= 4'd5)
                    n_state = WRDATA;
                else
                    n_state = WRHEAD;
            end 
        WRDATA  :
            begin
                if(pkg_wr_done[c_user] == 1'b1)
                    n_state = WRCRC;
                else
                    n_state = WRDATA;
            end
        WRCRC   :
            begin
                if(crc_step_cnt >= 4'd3)
                    n_state = ARBIT;
                else
                    n_state = WRCRC;
            end
        default : n_state = IDLE;
    endcase
end

// ============================================================================
// Respond to the request
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        c_user <= #U_DLY 3'd0;
    else
        begin
            if(c_state == ARBIT)
                case({c_user,pkg_wr_req})
                    7'h00   : c_user <= #U_DLY 3'd0;
                    7'h01   : c_user <= #U_DLY 3'd0;
                    7'h02   : c_user <= #U_DLY 3'd1; 
                    7'h03   : c_user <= #U_DLY 3'd1;
                    7'h04   : c_user <= #U_DLY 3'd2;
                    7'h05   : c_user <= #U_DLY 3'd2;
                    7'h06   : c_user <= #U_DLY 3'd1;
                    7'h07   : c_user <= #U_DLY 3'd1;
                    7'h08   : c_user <= #U_DLY 3'd3;
                    7'h09   : c_user <= #U_DLY 3'd3;
                    7'h0a   : c_user <= #U_DLY 3'd1;
                    7'h0b   : c_user <= #U_DLY 3'd1;
                    7'h0c   : c_user <= #U_DLY 3'd2;
                    7'h0d   : c_user <= #U_DLY 3'd2;
                    7'h0e   : c_user <= #U_DLY 3'd1;
                    7'h0f   : c_user <= #U_DLY 3'd1;
                           
                    7'h10   : c_user <= #U_DLY 3'd1;
                    7'h11   : c_user <= #U_DLY 3'd0;
                    7'h12   : c_user <= #U_DLY 3'd1; 
                    7'h13   : c_user <= #U_DLY 3'd0;
                    7'h14   : c_user <= #U_DLY 3'd2;
                    7'h15   : c_user <= #U_DLY 3'd2;
                    7'h16   : c_user <= #U_DLY 3'd2;
                    7'h17   : c_user <= #U_DLY 3'd2;
                    7'h18   : c_user <= #U_DLY 3'd3;
                    7'h19   : c_user <= #U_DLY 3'd3;
                    7'h1a   : c_user <= #U_DLY 3'd3;
                    7'h1b   : c_user <= #U_DLY 3'd3;
                    7'h1c   : c_user <= #U_DLY 3'd2;
                    7'h1d   : c_user <= #U_DLY 3'd2;
                    7'h1e   : c_user <= #U_DLY 3'd2;
                    7'h1f   : c_user <= #U_DLY 3'd2;
                                       
                    7'h20   : c_user <= #U_DLY 3'd2;
                    7'h21   : c_user <= #U_DLY 3'd0;
                    7'h22   : c_user <= #U_DLY 3'd1; 
                    7'h23   : c_user <= #U_DLY 3'd0;
                    7'h24   : c_user <= #U_DLY 3'd2;
                    7'h25   : c_user <= #U_DLY 3'd0;
                    7'h26   : c_user <= #U_DLY 3'd1;
                    7'h27   : c_user <= #U_DLY 3'd0;
                    7'h28   : c_user <= #U_DLY 3'd3;
                    7'h29   : c_user <= #U_DLY 3'd3;
                    7'h2a   : c_user <= #U_DLY 3'd3;
                    7'h2b   : c_user <= #U_DLY 3'd3;
                    7'h2c   : c_user <= #U_DLY 3'd3;
                    7'h2d   : c_user <= #U_DLY 3'd3;
                    7'h2e   : c_user <= #U_DLY 3'd3;
                    7'h2f   : c_user <= #U_DLY 3'd3;
                                        
                    7'h30   : c_user <= #U_DLY 3'd3;
                    7'h31   : c_user <= #U_DLY 3'd0;
                    7'h32   : c_user <= #U_DLY 3'd1; 
                    7'h33   : c_user <= #U_DLY 3'd0;
                    7'h34   : c_user <= #U_DLY 3'd2;
                    7'h35   : c_user <= #U_DLY 3'd0;
                    7'h36   : c_user <= #U_DLY 3'd1;
                    7'h37   : c_user <= #U_DLY 3'd0;
                    7'h38   : c_user <= #U_DLY 3'd3;
                    7'h39   : c_user <= #U_DLY 3'd0;
                    7'h3a   : c_user <= #U_DLY 3'd1;
                    7'h3b   : c_user <= #U_DLY 3'd0;
                    7'h3c   : c_user <= #U_DLY 3'd2;
                    7'h3d   : c_user <= #U_DLY 3'd0;
                    7'h3e   : c_user <= #U_DLY 3'd1;
                    7'h3f   : c_user <= #U_DLY 3'd0;
                    default : c_user <= #U_DLY 3'd0;
                endcase
            else
                ;
        end
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pkg_wr_ack <= #U_DLY 4'd0;
    else
        begin
            if((c_state == WRDATA) && (pkg_wr_req[c_user] == 1'b1))
                pkg_wr_ack[c_user] <= #U_DLY 1'b1;
            else
                pkg_wr_ack <= #U_DLY 4'd0;
        end
end

// ============================================================================
// Frame generate Control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        head_step_cnt <= #U_DLY 4'd0;
    else
        begin
            if(c_state == WRHEAD)
                head_step_cnt <= #U_DLY head_step_cnt + 4'd1;
            else
                head_step_cnt <= #U_DLY 4'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        crc_step_cnt <= #U_DLY 4'd0;
    else
        begin
            if(c_state == WRCRC)
                crc_step_cnt <= #U_DLY crc_step_cnt + 4'd1;
            else
                crc_step_cnt <= #U_DLY 4'd0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        crc_clear <= #U_DLY 1'b0;
    else
        begin
            if(c_state == ARBIT)
                crc_clear <= #U_DLY 1'b1;
            else
                crc_clear <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        crc_en <= #U_DLY 1'b0;
    else
        begin
           if(((c_state == WRHEAD) && (head_step_cnt <= 4'd5)) ||
               ((c_state == WRDATA) && (pkg_wr_en[c_user] == 1'b1)))
                crc_en <= #U_DLY 1'b1;
            else
                crc_en <= #U_DLY 1'b0;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        frame_type <= #U_DLY 16'd0;
    else
        case(c_user)
            3'd0    : frame_type <= #U_DLY 16'h4000;
            3'd1    : frame_type <= #U_DLY 16'h4001;
            3'd2    : frame_type <= #U_DLY 16'h4002;
            3'd3    : frame_type <= #U_DLY 16'h4003;
            default :;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_tx_data <= #U_DLY 8'd0;
    else
        begin
            if(c_state == WRHEAD)
                case(head_step_cnt)
                    4'd0    : pc_tx_data <= #U_DLY 8'hef;
                    4'd1    : pc_tx_data <= #U_DLY 8'h91;
                    4'd2    : pc_tx_data <= #U_DLY 8'h19;
                    4'd3    : pc_tx_data <= #U_DLY 8'hfe;
                    4'd4    : pc_tx_data <= #U_DLY frame_type[15:8];
                    4'd5    : pc_tx_data <= #U_DLY frame_type[7:0];
                    default :;
                endcase
            else if(c_state == WRDATA)
                pc_tx_data <= #U_DLY pkg_wr_data[c_user*8+:8];
            else if(c_state == WRCRC)
                case(crc_step_cnt)
                    4'd0    : pc_tx_data <= #U_DLY crc_data[3*8+:8];
                    4'd1    : pc_tx_data <= #U_DLY crc_data[2*8+:8];
                    4'd2    : pc_tx_data <= #U_DLY crc_data[1*8+:8];
                    4'd3    : pc_tx_data <= #U_DLY crc_data[0*8+:8];
                    default :;
                endcase
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        pc_tx_data_valid <= #U_DLY 1'b0;
    else 
        begin
            if(((c_state == WRHEAD) && (head_step_cnt <= 4'd5)) ||
               ((c_state == WRDATA) && (pkg_wr_en[c_user] == 1'b1)) ||
               ((c_state == WRCRC) && (crc_step_cnt <= 4'd3)))
                pc_tx_data_valid <= #U_DLY 1'b1;
            else
                pc_tx_data_valid <= #U_DLY 1'b0;
        end
end

cb_crc32 #
(
    .U_DLY                          (U_DLY                      )  
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
    .crc_clear                      (crc_clear                  ), // (input )
//-----------------------------------------------------------------------------------
// Source Data
//-----------------------------------------------------------------------------------
    .src_data                       (pc_tx_data[7:0]            ), // (input )
    .src_data_valid                 (crc_en                     ), // (input )
//-----------------------------------------------------------------------------------
// Source Data
//-----------------------------------------------------------------------------------
    .crc_data                       (crc_data[31:0]             ), // (output)
    .crc_data_valid                 (                           )  // (output)
);

endmodule




