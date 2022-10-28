//PCIE DEFINE
`define GEN3X16
`define PCIE_GEN3                     1
//`define PCIE_CFG_MGMT                         //read or write pcie config space/EXT config space
//`define PCIE_CFG_MSG
//`define PCIE_CFG_POWER   
`define PCIE_CFG_FLR 

`define PCIE_PFS                      1         //TOTAL PHYSIC FUNCTION NUMBER    
`define PCIE_VF_ENABLE
`define PCIE_VFS                      1 

  
//X1Y2
`define PCIE0_VENDOR_ID               16'h10EE
`define PCIE0_DEVICE_ID               16'h903F
`define PCIE0_REVISION_ID             8'h00
`define PCIE0_SUBSYSTEM_VENDOR_ID     16'h10EE    
`define PCIE0_SUBSYSTEM_ID            16'h0007

//X1Y4
`define PCIE1_VENDOR_ID               16'h10EE
`define PCIE1_DEVICE_ID               16'h9138
`define PCIE1_REVISION_ID             8'h00
`define PCIE1_SUBSYSTEM_VENDOR_ID     16'h10EE    
`define PCIE1_SUBSYSTEM_ID            16'h0007


`define PCI_EXP_EP_OUI                24'h000A35
`define PCI_EXP_EP_DSN_1              {{8'h1},`PCI_EXP_EP_OUI}
`define PCI_EXP_EP_DSN_2              32'h00000001

`define CFG_DSN                       {`PCI_EXP_EP_DSN_2, `PCI_EXP_EP_DSN_1}
`define CFG_DS_PORT_NUMBER            8'h0
`define CFG_DS_BUS_NUMBER             8'h0
`define CFG_DS_DEVICE_NUMBER          5'h0


//pcie request_type
`define MEM_RD_FMT_TYPE     4'b0000     // Memory Read
`define MEM_WR_FMT_TYPE     4'b0001     // Memory Write
`define IO_RD_FMT_TYPE      4'b0010     // IO Read
`define IO_WR_FMT_TYPE      4'b0011     // IO Write
`define ATOP_FAA_FMT_TYPE   4'b0100     // Fetch and ADD
`define ATOP_UCS_FMT_TYPE   4'b0101     // Unconditional SWAP
`define ATOP_CAS_FMT_TYPE   4'b0110     // Compare and SWAP
`define MEM_LK_RD_FMT_TYPE  4'b0111     // Locked Read Request
`define CFG_RD_FMT_TYPE0    4'b1000     //Type 0 Configuration Read Request (on Requester side only)
`define CFG_RD_FMT_TYPE1    4'b1001     //Type 1 Configuration Read Request (on Requester side only)
`define CFG_WR_FMT_TYPE0    4'b1010     //Type 0 Configuration Write Request (on Requester side only)
`define CFG_WR_FMT_TYPE1    4'b1011     //Type 1 Configuration Write Request (on Requester side only)
`define MSG_FMT_TYPE        4'b1100     // MSG Transaction apart from Vendor Defined and ATS
`define MSG_VD_FMT_TYPE     4'b1101     // MSG Transaction apart from Vendor Defined and ATS
`define MSG_ATS_FMT_TYPE    4'b1110     // MSG Transaction apart from Vendor Defined and ATS

`ifdef GEN3X16

    `define PL_LINK_CAP_MAX_LINK_WIDTH     16  // 1- X1, 2 - X2, 4 - X4, 8 - X8, 16 - X16
    `define C_DATA_WIDTH                   512         // RX/TX interface data width
    `define KEEP_WIDTH                     16
    `define STRB_WIDTH                     64          //DATA WIDTH HAVE STRB_WIDTH Byte
    `define PARITY_WIDTH                   64
    `define AXI4_CQ_TUSER_WIDTH            183
    `define AXI4_CC_TUSER_WIDTH            81
    `define AXI4_RQ_TUSER_WIDTH            137
    `define AXI4_RC_TUSER_WIDTH            161
    `define AXISTEN_IF_RQ_PARITY_CHECK     0
    `define AXISTEN_IF_CC_PARITY_CHECK     0
    `define AXISTEN_IF_RC_PARITY_CHECK     0
    `define AXISTEN_IF_CQ_PARITY_CHECK     0

    typedef struct {
        logic   [63:0]      parity          ;//[182:119]
        logic   [15:0]      tph_st_tag      ;//[118:103]
        logic   [3:0]       tph_type        ;//[102:99]
        logic   [1:0]       tph_present     ;//[98:97]
        logic               discontinue     ;//[96]
        logic   [3:0]       is_eop1_ptr     ;//[95:92]
        logic   [3:0]       is_eop0_ptr     ;//[91:88]
        logic   [1:0]       is_eop          ;//[87:86]
        logic   [1:0]       is_sop1_ptr     ;//[85:84]
        logic   [1:0]       is_sop0_ptr     ;//[83:82]
        logic   [1:0]       is_sop          ;//[81:80]
        logic   [63:0]      byte_en         ;//[79:16]
        logic   [7:0]       last_be         ;//[15:8]
        logic   [7:0]       first_be        ;//[7:0]
    }axis_cq_tuser_t;

    typedef struct {
        logic   [63:0]      parity          ;//[80:17]
        logic               discontinue     ;//[16]
        logic   [3:0]       is_eop1_ptr     ;//[15:12]
        logic   [3:0]       is_eop0_ptr     ;//[11:8]
        logic   [1:0]       is_eop          ;//[7:6]
        logic   [1:0]       is_sop1_ptr     ;//[5:4]
        logic   [1:0]       is_sop0_ptr     ;//[3:2]
        logic   [1:0]       is_sop          ;//[1:0]
    }axis_cc_tuser_t;

    typedef struct {
        logic   [63:0]      parity              ;//[136:73]
        logic   [5:0]       seq_num1            ;//[72:67]
        logic   [5:0]       seq_num0            ;//[66:61]
        logic   [15:0]      tph_st_tag          ;//[60:45]
        logic   [1:0]       tph_indirect_tag_en ;//[44:43]
        logic   [3:0]       tph_type            ;//[42:39]
        logic   [1:0]       tph_present         ;//[38:37]
        logic               discontinue         ;//[36]
        logic   [3:0]       is_eop1_ptr         ;//[35:32]
        logic   [3:0]       is_eop0_ptr         ;//[31:28]
        logic   [1:0]       is_eop              ;//[27:26]
        logic   [1:0]       is_sop1_ptr         ;//[25:24]
        logic   [1:0]       is_sop0_ptr         ;//[23:22]
        logic   [1:0]       is_sop              ;//[21:20]
        logic   [3:0]       addr_offset         ;//[19:16]
        logic   [7:0]       last_be             ;//[15:8]
        logic   [7:0]       first_be            ;//[7:0]
    }axis_rq_tuser_t;

    typedef struct {
        logic   [63:0]      parity          ;//[160:97]
        logic               discontinue     ;//[96]
        logic   [3:0]       is_eop3_ptr     ;//[95:92]
        logic   [3:0]       is_eop2_ptr     ;//[91:88]
        logic   [3:0]       is_eop1_ptr     ;//[87:84]
        logic   [3:0]       is_eop0_ptr     ;//[83:80]
        logic   [3:0]       is_eop          ;//[79:76]
        logic   [1:0]       is_sop3_ptr     ;//[75:74]
        logic   [1:0]       is_sop2_ptr     ;//[73:72]
        logic   [1:0]       is_sop1_ptr     ;//[71:70]
        logic   [1:0]       is_sop0_ptr     ;//[69:68]
        logic   [3:0]       is_sop          ;//[67:64]
        logic   [63:0]      byte_en         ;//[63:0]
    }axis_rc_tuser_t;

    typedef struct {
        logic               rsv1            ;//[127]
        logic   [2:0]       attributes      ;//[126:124]
        logic   [2:0]       tc              ;//[123:121]
        logic   [5:0]       bar_aperture    ;//[120:115]
        logic   [2:0]       bar_id          ;//[114:112]
        logic   [7:0]       target_function ;//[111:104]
        logic   [7:0]       tag             ;//[103:96]
        logic   [15:0]      requester_id    ;//[95:80]
        logic               rsv0            ;//[79]
        logic   [3:0]       request_type    ;//[78:75]
        logic   [10:0]      dword_count     ;//[74:64]
        logic   [61:0]      address         ;//[63:2]
        logic   [1:0]       address_type    ;//[1:0]
    }axis_cq_header_t;


    typedef struct {
        logic               force_ecrc              ;//[95]
        logic   [2:0]       attributes              ;//[94:92]
        logic   [2:0]       transaction_class       ;//[91:89]
        logic               completer_id_enable     ;//[88]
        logic   [15:0]      completer_id            ;//[87:72]
        logic   [7:0]       tag                     ;//[71:64]
        logic   [15:0]      requester_id            ;//[63:48]
        logic               rsv3                    ;//[47]
        logic               poisoned_completion     ;//[46]
        logic   [2:0]       completion_status       ;//[45:43]
        logic   [10:0]      dword_count             ;//[42:32]
        logic   [1:0]       rsv2                    ;//[31:30]
        logic               locked_read_completion  ;//[29]
        logic   [12:0]      byte_count              ;//[28:16]
        logic   [5:0]       rsv1                    ;
        logic   [1:0]       address_type            ;//[9:8]
        logic               rsv0                    ;//[7]
        logic   [6:0]       lower_address           ;//[6:0]
    }axis_cc_header_t;

    typedef struct {
        logic               force_ecrc              ;//[127]
        logic   [2:0]       attributes              ;//[126:124]
        logic   [2:0]       transaction_class       ;//[123:121]
        logic               requester_id_enable     ;//[120]
        logic   [15:0]      completer_id            ;//[119:104]
        logic   [7:0]       tag                     ;//[103:96]
        logic   [15:0]      requester_id            ;//[95:80]
        logic               poisoned_request        ;//[79]
        logic   [3:0]       request_type            ;//[78:75]
        logic   [10:0]      dword_count             ;//[74:64]
        logic   [61:0]      address                 ;//[63:2]
        logic   [1:0]       address_type            ;//[1:0]
    }axis_rq_header_t;


    typedef struct {
        logic               rsv3                    ;//[95]
        logic   [2:0]       attributes              ;//[94:92]
        logic   [2:0]       transaction_class       ;//[91:89]
        logic               rsv2                    ;//[88]
        logic   [15:0]      completer_id            ;//[87:72]
        logic   [7:0]       tag                     ;//[71:64]
        logic   [15:0]      requester_id            ;//[63:48]
        logic               rsv1                    ;//[47]
        logic               poisoned_completion     ;//[46]
        logic   [2:0]       completion_status       ;//[45:43]
        logic   [10:0]      dword_count             ;//[42:32]
        logic               rsv                     ;//[31]
        logic               request_completed       ;//[30]    
        logic               locked_read_completion  ;//[29]
        logic   [12:0]      byte_count              ;//[28:16]
        logic   [3:0]       error_code              ;//[15:12]    
        logic   [11:0]      lower_address           ;//[11:0]    
    }axis_rc_header_t;    
`else 
    `define PL_LINK_CAP_MAX_LINK_WIDTH     8            // 1- X1, 2 - X2, 4 - X4, 8 - X8, 16 - X16
    `define C_DATA_WIDTH                   256         // RX/TX interface data width
    `define KEEP_WIDTH                     8
    `define STRB_WIDTH                     32
    `define PARITY_WIDTH                   32
    `define AXI4_CQ_TUSER_WIDTH            88
    `define AXI4_CC_TUSER_WIDTH            33
    `define AXI4_RQ_TUSER_WIDTH            62
    `define AXI4_RC_TUSER_WIDTH            75
    `define AXISTEN_IF_RQ_PARITY_CHECK     0
    `define AXISTEN_IF_CC_PARITY_CHECK     0
    `define AXISTEN_IF_RC_PARITY_CHECK     0
    `define AXISTEN_IF_CQ_PARITY_CHECK     0

    typedef struct {
        logic   [2:0]       rsv             ;//[87:85]
        logic   [31:0]      parity          ;//[84:53]
        logic   [7:0]       tph_st_tag      ;//[52:45]
        logic   [1:0]       tph_type        ;//[44:43]
        logic               tph_present     ;//[42]
        logic               discontinue     ;//[41]
        logic               is_sop          ;//[40]
        logic   [31:0]      byte_en         ;//[39:8]
        logic   [3:0]       last_be         ;//[7:4]
        logic   [3:0]       first_be        ;//[3:0]
    }axis_cq_tuser_t;   

    typedef struct {
        logic   [31:0]      parity          ;//[32:1]
        logic               discontinue     ;//[0]
    }axis_cc_tuser_t;   

    typedef struct {
        logic   [1:0]       seq_num1            ;//[61:60]
        logic   [31:0]      parity              ;//[59:28]
        logic   [3:0]       seq_num0            ;//[27:24]
        logic   [7:0]       tph_st_tag          ;//[23:16]
        logic               tph_indirect_tag_en ;//[15]
        logic   [1:0]       tph_type            ;//[14:13]
        logic               tph_present         ;//[12]
        logic               discontinue         ;//[11]
        logic   [2:0]       addr_offset         ;//[10:8]
        logic   [3:0]       last_be             ;//[7:4]
        logic   [3:0]       first_be            ;//[3:0]
    }axis_rq_tuser_t;   

    typedef struct {
        logic   [31:0]      parity          ;//[74:43]
        logic               discontinue     ;//[42]
        logic   [3:0]       is_eof_1        ;//[41:38]
        logic   [3:0]       is_eof_0        ;//[37:34]
        logic               is_sof_1        ;//[33]
        logic               is_sof_0        ;//[32]
        logic   [31:0]      byte_en         ;//[31:0]
    }axis_rc_tuser_t;   

    typedef struct {
        logic               rsv1            ;//[127]
        logic   [2:0]       attributes      ;//[126:124]
        logic   [2:0]       tc              ;//[123:121]
        logic   [5:0]       bar_aperture    ;//[120:115]
        logic   [2:0]       bar_id          ;//[114:112]
        logic   [7:0]       target_function ;//[111:104]
        logic   [7:0]       tag             ;//[103:96]
        logic   [15:0]      requester_id    ;//[95:80]
        logic               rsv0            ;//[79]
        logic   [3:0]       request_type    ;//[78:75]
        logic   [10:0]      dword_count     ;//[74:64]
        logic   [61:0]      address         ;//[63:2]
        logic   [1:0]       address_type    ;//[1:0]
    }axis_cq_header_t;  
    

    typedef struct {
        logic               force_ecrc              ;//[95]
        logic   [2:0]       attributes              ;//[94:92]
        logic   [2:0]       transaction_class       ;//[91:89]
        logic               completer_id_enable     ;//[88]
        logic   [15:0]      completer_id            ;//[87:72]
        logic   [7:0]       tag                     ;//[71:64]
        logic   [15:0]      requester_id            ;//[63:48]
        logic               rsv3                    ;//[47]
        logic               poisoned_completion     ;//[46]
        logic   [2:0]       completion_status       ;//[45:43]
        logic   [10:0]      dword_count             ;//[42:32]
        logic   [1:0]       rsv2                    ;//[31:30]
        logic               locked_read_completion  ;//[29]
        logic   [12:0]      byte_count              ;//[28:16]
        logic   [5:0]       rsv1                    ;
        logic   [1:0]       address_type            ;//[9:8]
        logic               rsv0                    ;//[7]
        logic   [6:0]       lower_address           ;//[6:0]
    }axis_cc_header_t;  

    typedef struct {
        logic               force_ecrc              ;//[127]
        logic   [2:0]       attributes              ;//[126:124]
        logic   [2:0]       transaction_class       ;//[123:121]
        logic               requester_id_enable     ;//[120]
        logic   [15:0]      completer_id            ;//[119:104]
        logic   [7:0]       tag                     ;//[103:96]
        logic   [15:0]      requester_id            ;//[95:80]
        logic               poisoned_request        ;//[79]
        logic   [3:0]       request_type            ;//[78:75]
        logic   [10:0]      dword_count             ;//[74:64]
        logic   [61:0]      address                 ;//[63:2]
        logic   [1:0]       address_type            ;//[1:0]
    }axis_rq_header_t;  
    

    typedef struct {
        logic               rsv3                    ;//[95]
        logic   [2:0]       attributes              ;//[94:92]
        logic   [2:0]       transaction_class       ;//[91:89]
        logic               rsv2                    ;//[88]
        logic   [15:0]      completer_id            ;//[87:72]
        logic   [7:0]       tag                     ;//[71:64]
        logic   [15:0]      requester_id            ;//[63:48]
        logic               rsv1                    ;//[47]
        logic               poisoned_completion     ;//[46]
        logic   [2:0]       completion_status       ;//[45:43]
        logic   [10:0]      dword_count             ;//[42:32]
        logic               rsv                     ;//[31]
        logic               request_completed       ;//[30]    
        logic               locked_read_completion  ;//[29]
        logic   [12:0]      byte_count              ;//[28:16]
        logic   [3:0]       error_code              ;//[15:12]    
        logic   [11:0]      lower_address           ;//[11:0]    
    }axis_rc_header_t;      
`endif    

