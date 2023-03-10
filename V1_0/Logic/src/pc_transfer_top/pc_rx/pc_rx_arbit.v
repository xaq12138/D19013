// +FHDR============================================================================/
// Author       : mayia
// Creat Time   : 2020/06/21 08:38:48
// File Name    : pc_rx_arbit.v
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
// pc_rx_arbit
//    |---
// 
`timescale 1ns/1ns

module pc_rx_arbit #
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
// User Read Req Port
// ----------------------------------------------------------------------------
    input                     [1:0] fdram_rd_req                , 
    output reg                [1:0] fdram_rd_ack                , 
    input                     [1:0] fdram_rd_done               , 

    input                    [23:0] fdram_rd_addr               , 
    output                    [7:0] fdram_rd_data               , 
// ----------------------------------------------------------------------------
// Frame Data BRAM Read Port
// ----------------------------------------------------------------------------
    output                   [11:0] mux_ram_rd_addr             , 
    input                     [7:0] mux_ram_rd_data               
);

localparam IDLE     = 2'b00;
localparam ARBIT    = 2'b01; 
localparam RDRAM    = 2'b11; 

reg                           [1:0] c_state                     ; 
reg                           [1:0] n_state                     ; 

reg                                 c_user                      ; 

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
                if(|fdram_rd_req == 1'b1)
                    n_state = RDRAM;
                else
                    n_state = ARBIT;
            end
        RDRAM   :
            begin
                if(fdram_rd_done[c_user] == 1'b1)
                    n_state = ARBIT;
                else
                    n_state = RDRAM;
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
        c_user <= #U_DLY 1'b0;
    else
        begin
            if(c_state == ARBIT)
                case({c_user,fdram_rd_req})
                    3'b000  : c_user <= #U_DLY 1'b0;
                    3'b001  : c_user <= #U_DLY 1'b0;
                    3'b010  : c_user <= #U_DLY 1'b1;
                    3'b011  : c_user <= #U_DLY 1'b1;
                    3'b100  : c_user <= #U_DLY 1'b1;
                    3'b101  : c_user <= #U_DLY 1'b0;
                    3'b110  : c_user <= #U_DLY 1'b1;
                    3'b111  : c_user <= #U_DLY 1'b0;
                    default : c_user <= #U_DLY 1'b0;
                endcase
            else
                ;
        end
end 

always @ (posedge clk_sys or negedge rst_n)
begin
    if(rst_n == 1'b0)
        fdram_rd_ack <= #U_DLY 2'b0;
    else
        begin
            if((c_state == RDRAM) && (fdram_rd_req[c_user] == 1'b1))
                fdram_rd_ack[c_user] <= #U_DLY 1'b1;
            else
                fdram_rd_ack <= #U_DLY 2'b0;
        end
end

// ============================================================================
// Read RAM data
// ============================================================================
assign mux_ram_rd_addr = fdram_rd_addr[c_user*12+:12];
assign fdram_rd_data =mux_ram_rd_data;

endmodule



