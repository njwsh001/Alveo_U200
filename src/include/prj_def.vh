`define XILINX
//`define ALTERA
`define PRJ_SIMULATION

//ECC_MODE: block fifo, std fifo,block ram or ultra ram used for ECC,
// "en_ecc" or "no_ecc" 
`define ECC_MODE                    "no_ecc"

`ifdef PRJ_SIMULATION   
    `define SIM_ASSERT_CHK          1
`else   
    `define SIM_ASSERT_CHK          0
`endif