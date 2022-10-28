`timescale 1ps / 1ps
module top # (

)(
    input                                           sys_clk_p,
    input                                           sys_clk_n,
    input                                           sys_rst_n,

    input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_rxp,
    input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_rxn,
    output  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_txp,
    output  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_txn,

    // Board LED Logic IO
    // 300 MHz clock for the board
    input  wire                                     clk_300MHz_p,
    input  wire                                     clk_300MHz_n,   

    output                                          led_0       ,
    output                                          led_1       ,
    output                                          led_2       

);

slr0_top#    slr0_top(
    .sys_clk_p          (sys_clk_p      ),
    .sys_clk_n          (sys_clk_n      ),
    .sys_rst_n          (sys_rst_n      ),
    .pci_exp_rxp        (pci_exp_rxp    ),
    .pci_exp_rxn        (pci_exp_rxn    ),
    .pci_exp_txp        (pci_exp_txp    ),
    .pci_exp_txn        (pci_exp_txn    ),

);

pipe_slr0_slr1    pipe_slr0_slr1(
    

);

slr1_top    slr1_top(


);


pipe_slr1_slr2    pipe_slr1_slr2(


);

slr1_top    slr1_top(


);
