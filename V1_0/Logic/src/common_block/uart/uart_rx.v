// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/07/14 14:34:24
// File Name    : uart_rx.v
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
// uart_rx
//    |---
// 
`timescale 1ns/1ps

module uart_rx #
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
// Config Data 
// ----------------------------------------------------------------------------
    input                           baud_en                     , 

    input                     [3:0] data_width                  , 
    input                           check_en                    , 
    input                           check_sel                   , 
    input                           check_filter                , 
    input                           stop_bit                    , 
// ----------------------------------------------------------------------------
// Uart
// ----------------------------------------------------------------------------
    input                           uart_rx                     , 
// ----------------------------------------------------------------------------
// Receive Data 
// ----------------------------------------------------------------------------
    output reg                [7:0] driver_rx_data              , 
    output reg                      driver_rx_data_valid        , 
// ----------------------------------------------------------------------------
// Debug
// ----------------------------------------------------------------------------
    output reg                      debug_check_error           , 
    output reg                      debug_stop_error              
);

reg                                 uart_rx_1dly                ; 
reg                                 uart_rx_2dly                ; 
reg                                 uart_rx_3dly                ; 
reg                                 uart_rx_f                   ; 

reg                           [6:0] step_data                   ; 
reg                                 step_en                     ; 
reg                           [6:0] step_cnt                    ; 

reg                           [2:0] shift_bit                   ; 
reg                                 rxbit_data                  ; 

reg                                 check_data                  ; 

// ============================================================================
// Uart RX sync
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        begin
            uart_rx_1dly <= #U_DLY 1'b1;
            uart_rx_2dly <= #U_DLY 1'b1;
            uart_rx_3dly <= #U_DLY 1'b1;
        end
    else
        begin
            uart_rx_1dly <= #U_DLY uart_rx;
            uart_rx_2dly <= #U_DLY uart_rx_1dly;
            uart_rx_3dly <= #U_DLY uart_rx_2dly;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        uart_rx_f <= #U_DLY 1'b0;
    else
        begin
            if((uart_rx_3dly == 1'b1) && (uart_rx_2dly == 1'b0))
                uart_rx_f <= #U_DLY 1'b1;
            else
                uart_rx_f <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Step control
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_data <= #U_DLY 7'd0;
    else
        case({stop_bit,check_en,data_width})
        6'h05   : step_data <= #U_DLY 7'd56;
        6'h06   : step_data <= #U_DLY 7'd64;
        6'h07   : step_data <= #U_DLY 7'd72;
        6'h08   : step_data <= #U_DLY 7'd80;
        6'h15   : step_data <= #U_DLY 7'd64;
        6'h16   : step_data <= #U_DLY 7'd72;
        6'h17   : step_data <= #U_DLY 7'd80;
        6'h18   : step_data <= #U_DLY 7'd88;
        6'h25   : step_data <= #U_DLY 7'd64;
        6'h26   : step_data <= #U_DLY 7'd72;
        6'h27   : step_data <= #U_DLY 7'd80;
        6'h28   : step_data <= #U_DLY 7'd88;
        6'h35   : step_data <= #U_DLY 7'd72;
        6'h36   : step_data <= #U_DLY 7'd80;
        6'h37   : step_data <= #U_DLY 7'd88;
        6'h38   : step_data <= #U_DLY 7'd96;
        default : step_data <= #U_DLY 7'd80;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_en <= #U_DLY 1'b0;
    else
        begin
            if((step_cnt == 7'd6) && (rxbit_data == 1'b1))
                step_en <= #U_DLY 1'b0;
            else if(uart_rx_f == 1'b1)
                step_en <= #U_DLY 1'b1;
            else if(step_cnt >= step_data-8'd1)
                step_en <= #U_DLY 1'b0;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        step_cnt <= #U_DLY 7'd0;
    else
        begin
            if(step_en == 1'b1)
                begin
                    if(baud_en == 1'b1)
                        step_cnt <= #U_DLY step_cnt + 7'd1;
                    else
                        ;
                end
            else
                step_cnt <= #U_DLY 7'd0;
        end
end

// ============================================================================
// Over sample
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        shift_bit <= #U_DLY 3'd0;
    else
        case(step_cnt[2:0])
            3'd2    : shift_bit[2] <= #U_DLY uart_rx_2dly;
            3'd3    : shift_bit[1] <= #U_DLY uart_rx_2dly;
            3'd4    : shift_bit[0] <= #U_DLY uart_rx_2dly;
            default : ;
        endcase
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        rxbit_data <= #U_DLY 1'b0;
    else
        begin
            if(step_cnt[2:0] == 3'd5)
                case(shift_bit)
                    3'b000  : rxbit_data <= #U_DLY 1'b0;
                    3'b001  : rxbit_data <= #U_DLY 1'b0;
                    3'b010  : rxbit_data <= #U_DLY 1'b0;
                    3'b011  : rxbit_data <= #U_DLY 1'b1;
                    3'b100  : rxbit_data <= #U_DLY 1'b0;
                    3'b101  : rxbit_data <= #U_DLY 1'b1;
                    3'b110  : rxbit_data <= #U_DLY 1'b1;
                    3'b111  : rxbit_data <= #U_DLY 1'b1;
                    default : rxbit_data <= #U_DLY 1'b0;
                endcase
            else
                ;
        end
end

// ============================================================================
// Data get
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        driver_rx_data <= #U_DLY 8'd0;
    else
        begin
            if((step_cnt[6:3] >= 4'd1) && (step_cnt[6:3] <= data_width) && (step_cnt[2:0] == 3'd6))
                driver_rx_data[step_cnt[6:3] - 4'd1] <= #U_DLY rxbit_data;
            else
                ;
        end
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        driver_rx_data_valid <= #U_DLY 1'b0;
    else
        begin
            if((step_cnt == step_data - 7'd3) && (baud_en == 1'b1) && (debug_stop_error == 1'b0))
                case({check_filter,check_en,debug_check_error})
                    3'b111  : driver_rx_data_valid <= #U_DLY 1'b0;
                    default : driver_rx_data_valid <= #U_DLY 1'b1;
                endcase       
            else
                driver_rx_data_valid <= #U_DLY 1'b0;
        end
end

// ============================================================================
// Data check
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        check_data <= #U_DLY 1'b0;
    else
        begin
            if((check_en == 1'b1) && (step_cnt[6:3] == data_width + 4'd1) && (step_cnt[2:0] == 3'd0))
                case(data_width)
                    4'd8    : check_data <= #U_DLY check_sel^driver_rx_data[0]^driver_rx_data[1]^driver_rx_data[2]^driver_rx_data[3]^driver_rx_data[4]^driver_rx_data[5]^driver_rx_data[6]^driver_rx_data[7];
                    4'd7    : check_data <= #U_DLY check_sel^driver_rx_data[0]^driver_rx_data[1]^driver_rx_data[2]^driver_rx_data[3]^driver_rx_data[4]^driver_rx_data[5]^driver_rx_data[6];
                    4'd6    : check_data <= #U_DLY check_sel^driver_rx_data[0]^driver_rx_data[1]^driver_rx_data[2]^driver_rx_data[3]^driver_rx_data[4]^driver_rx_data[5];
                    4'd5    : check_data <= #U_DLY check_sel^driver_rx_data[0]^driver_rx_data[1]^driver_rx_data[2]^driver_rx_data[3]^driver_rx_data[4];
                    default : check_data <= #U_DLY check_sel^driver_rx_data[0]^driver_rx_data[1]^driver_rx_data[2]^driver_rx_data[3]^driver_rx_data[4];
                endcase
            else
                ;
        end 
end

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        debug_check_error <= #U_DLY 1'b0;
    else
        begin
            if((uart_rx_f == 1'b1) && (step_en == 1'b0))
                debug_check_error <= #U_DLY 1'b0;
            else if((check_en == 1'b1) && (step_cnt[6:3] == data_width + 4'd1) && (step_cnt[2:0] == 3'd6) && (check_data != rxbit_data))
                debug_check_error <= #U_DLY 1'b1;
            else
                ;
        end
end

// ============================================================================
// Stop bit check
// ============================================================================
always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        debug_stop_error <= #U_DLY 1'b0;
    else
        begin
            if((uart_rx_f == 1'b1) && (step_en == 1'b0))
                debug_stop_error <= #U_DLY 1'b0;
            else if((step_cnt == step_data - 7'd4) && (uart_rx_2dly == 1'b0))
                debug_stop_error <= #U_DLY 1'b1;
            else
                ;
        end
end



endmodule



