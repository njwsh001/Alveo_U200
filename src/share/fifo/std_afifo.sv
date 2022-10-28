//////////////////////////////////////////////////////////////
// Vendor         : LDYH
// Revision       : $Revision: #1 $
// Date           : $DateTime: 2020/10/28 18:00:00 $
// Last Author    : CARY 
//////////////////////////////////////////////////////////////
// Hierarchy :
//    super_module : 
//      sub_module :
//
// Description:
// 1:   std afifo
// 2:   used xpm_fifo_async 
// 3:   support ECC check,chich config by prj_def.vh
///////////////////////////////////////////////////////////}}}

//-------------------------------------------------------//
/*


logic                     clk       ;
logic                     rst       ;
logic                     wen       ;
logic[31:0]               wdata     ;
logic                     afull     ;
logic[4:0]                wrcnt     ;
logic                     ren       ;
logic[31:0]               rdata     ;
logic                     empty     ;
logic[4:0]                rdcnt     ;
logic                     overflow  ;
logic                     underflow ;
logic                     err       ;

std_afifo#(
    .ECC_MODE               (`ECC_MODE ), // `ECC_MODE or "en_ecc" or "no_ecc" 
    .FIFO_MEMORY_TYPE       ("auto"    ), //"auto" , "block", "distributed", "ultra"    
    .FIFO_WRITE_DEPTH       (32        ),
    .PROG_FULL_THRESH       (24        ),
    .RD_DATA_COUNT_WIDTH    (5         ),
    .READ_DATA_WIDTH        (32        ),
    .WRITE_DATA_WIDTH       (32        ),
    .WR_DATA_COUNT_WIDTH    (5         )
)std_afifo(
    .wrclk                  (wrclk     ),
    .wrrst                  (wrrst     ),
    .wen                    (wen       ),
    .wdata                  (wdata     ),
    .afull                  (afull     ),
    .wrcnt                  (wrcnt     ),

    .rdclk                  (rdclk     ),
    .ren                    (ren       ),
    .rdata                  (rdata     ),
    .empty                  (empty     ),
    .rdcnt                  (rdcnt     ),
    .overflow               (overflow  ),
    .underflow              (underflow ),
    .err                    (err       )
);


*/
//------------------------------------------------------//


`timescale 1ps/1ps
`include "prj_def.vh"

module std_afifo#(
    parameter   ECC_MODE            = `ECC_MODE, //"en_ecc" or "no_ecc" 
    parameter   FIFO_MEMORY_TYPE    = "auto"   , //"auto" , "block", "distributed", "ultra"    
    parameter   FIFO_WRITE_DEPTH    = 32       ,
    parameter   PROG_FULL_THRESH    = FIFO_WRITE_DEPTH -8 ,
    parameter   RD_DATA_COUNT_WIDTH = 5        ,
    parameter   READ_DATA_WIDTH     = 32       , 
    parameter   WRITE_DATA_WIDTH    = 32       ,
    parameter   WR_DATA_COUNT_WIDTH = 5        

)(
    input   logic                                   wrclk       ,
    input   logic                                   wrrst       ,

    input                                           wen         ,
    input   logic[WRITE_DATA_WIDTH-1:0]             wdata       ,
    output  logic                                   afull       ,
    output  logic[WR_DATA_COUNT_WIDTH-1:0]          wrcnt       ,

    input   logic                                   rdclk       ,
    input   logic                                   ren         ,
    output  logic[READ_DATA_WIDTH-1:0]              rdata       ,
    output  logic                                   empty       ,
    output  logic[RD_DATA_COUNT_WIDTH-1:0]          rdcnt       ,

    output logic                                    overflow    ,
    output logic                                    underflow   ,
    output logic                                    err
);

logic                   dbiterr         ;
logic                   sbiterr         ;
logic                   full            ;
logic                   rd_rst_busy     ;
logic                   wr_rst_busy     ;

always@(posedge rdclk)begin
    if(rd_rst_busy)begin
        err <= 1'b0;
    end
    else if(sbiterr || dbiterr)begin
        err <= 1'b1;
    end
end

xpm_fifo_async #(
    .CDC_SYNC_STAGES          (2                  ), 
    .DOUT_RESET_VALUE         ("0"                ),    // String
    .ECC_MODE                 (ECC_MODE           ),    // String
    .FIFO_MEMORY_TYPE         (FIFO_MEMORY_TYPE   ),    // String
    .FIFO_READ_LATENCY        (1                  ),    // DECIMAL
    .FIFO_WRITE_DEPTH         (FIFO_WRITE_DEPTH   ),    // DECIMAL
    .FULL_RESET_VALUE         (0                  ),    // DECIMAL
    .PROG_EMPTY_THRESH        (3                  ),    // DECIMAL
    .PROG_FULL_THRESH         (PROG_FULL_THRESH   ),    // DECIMAL
    .RD_DATA_COUNT_WIDTH      (RD_DATA_COUNT_WIDTH),    // DECIMAL
    .READ_DATA_WIDTH          (READ_DATA_WIDTH    ),    // DECIMAL
    .READ_MODE                ("std"              ),    // String
    .RELATED_CLOCKS           (0                  ),    // DECIMAL
    .SIM_ASSERT_CHK           (`SIM_ASSERT_CHK    ),    // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .USE_ADV_FEATURES         ("0707"             ),    // String
    .WAKEUP_TIME              (0                  ),    // DECIMAL
    .WRITE_DATA_WIDTH         (WRITE_DATA_WIDTH   ),    // DECIMAL
    .WR_DATA_COUNT_WIDTH      (WR_DATA_COUNT_WIDTH)     // DECIMAL
)xpm_fifo_async_inst (
    .almost_empty       (                   ),
    .almost_full        (                   ),
    .data_valid         (                   ),
    .dbiterr            (dbiterr            ),//write clk 
    .dout               (rdata              ),
    .empty              (empty              ),
    .full               (full               ),
    .overflow           (overflow           ),
    .prog_empty         (                   ),
    .prog_full          (afull              ),
    .rd_data_count      (rdcnt              ),
    .rd_rst_busy        (rd_rst_busy        ),
    .sbiterr            (sbiterr            ),//write clk 
    .underflow          (underflow          ),
    .wr_ack             (                   ),
    .wr_data_count      (wrcnt              ),
    .wr_rst_busy        (wr_rst_busy        ),
    .din                (wdata              ),
    .injectdbiterr      (1'b0               ),
    .injectsbiterr      (1'b0               ),
    .rd_clk             (rdclk              ),
    .rd_en              (ren                ),
    .rst                (wrrst              ),
    .sleep              (1'b0               ),
    .wr_clk             (wrclk              ),
    .wr_en              (wen                ) 
);

endmodule