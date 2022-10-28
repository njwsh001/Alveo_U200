`timescale 1ps/1ps
`include "prj_def.vh"
`include "reg_def.vh"
module slr0_top(
    input   logic                                           sys_clk_p               ,
    input   logic                                           sys_clk_n               ,
    input   logic                                           sys_rst_n               ,
 
    input   logic   [`PL_LINK_CAP_MAX_LINK_WIDTH-1:0]       pci_exp_rxp             ,
    input   logic   [`PL_LINK_CAP_MAX_LINK_WIDTH-1:0]       pci_exp_rxn             ,
    output  logic   [`PL_LINK_CAP_MAX_LINK_WIDTH-1:0]       pci_exp_txp             ,
    output  logic   [`PL_LINK_CAP_MAX_LINK_WIDTH-1:0]       pci_exp_txn             ,

);

logic                                                       user_clk                                   ;
logic                                                       user_reset                                 ;
logic                                                       user_lnk_up                                ;
logic[`C_DATA_WIDTH-1:0]                                    s_axis_rq_tdata                            ;
logic[`KEEP_WIDTH-1:0]                                      s_axis_rq_tkeep                            ;
logic                                                       s_axis_rq_tlast                            ;
logic[3:0]                                                  s_axis_rq_tready                           ;
logic[`AXI4_RQ_TUSER_WIDTH-1:0]                             s_axis_rq_tuser                            ;
logic                                                       s_axis_rq_tvalid                           ;
logic[`C_DATA_WIDTH-1:0]                                    m_axis_rc_tdata                            ;
logic[`KEEP_WIDTH-1:0]                                      m_axis_rc_tkeep                            ;
logic                                                       m_axis_rc_tlast                            ;
logic                                                       m_axis_rc_tready                           ;
logic[`AXI4_RC_TUSER_WIDTH-1:0]                             m_axis_rc_tuser                            ;
logic                                                       m_axis_rc_tvalid                           ;
logic[`C_DATA_WIDTH-1:0]                                    m_axis_cq_tdata                            ;
logic[`KEEP_WIDTH-1:0]                                      m_axis_cq_tkeep                            ;
logic                                                       m_axis_cq_tlast                            ;
logic                                                       m_axis_cq_tready                           ;
logic[`AXI4_CQ_TUSER_WIDTH-1:0]                             m_axis_cq_tuser                            ;
logic                                                       m_axis_cq_tvalid                           ;
logic[`C_DATA_WIDTH-1:0]                                    s_axis_cc_tdata                            ;
logic[`KEEP_WIDTH-1:0]                                      s_axis_cc_tkeep                            ;
logic                                                       s_axis_cc_tlast                            ;
logic[3:0]                                                  s_axis_cc_tready                           ;
logic[`AXI4_CC_TUSER_WIDTH-1:0]                             s_axis_cc_tuser                            ;
logic                                                       s_axis_cc_tvalid                           ;
logic[5:0]                                                  pcie_rq_seq_num0                           ;
logic                                                       pcie_rq_seq_num_vld0                       ;
logic[5:0]                                                  pcie_rq_seq_num1                           ;
logic                                                       pcie_rq_seq_num_vld1                       ;
logic[7:0]                                                  pcie_rq_tag0                               ;
logic[7:0]                                                  pcie_rq_tag1                               ;
logic[3:0]                                                  pcie_rq_tag_av                             ;
logic                                                       pcie_rq_tag_vld0                           ;
logic                                                       pcie_rq_tag_vld1                           ;
logic[3:0]                                                  pcie_tfc_nph_av                            ;
logic[3:0]                                                  pcie_tfc_npd_av                            ;

//This input is used by the user application to request the delivery of a Non-Posted request. 
//The core implements a credit-based flow control mechanism to control the delivery of Non-Posted requests across the interface, without blocking Posted TLPs
//2'b00: No change 
//2'b01: Increment by 1
//2'b10: 10 or 11: Increment by 2
logic[1:0]                                                  pcie_cq_np_req                             ;

//This output provides the current value of the credit count maintained by the core for delivery of Non-Posted requests to the user logic. 
//The core delivers a Non-Posted request across the completer request interface only when this credit count is non-zero. 
//This counter saturates at a maximum limit of 32.
logic[5:0]                                                  pcie_cq_np_req_count                       ;

logic                                                       cfg_phy_link_down                          ;
logic[1:0]                                                  cfg_phy_link_status                        ;
logic[2:0]                                                  cfg_negotiated_width                       ;
logic[1:0]                                                  cfg_current_speed                          ;
logic[1:0]                                                  cfg_max_payload                            ;
logic[2:0]                                                  cfg_max_read_req                           ;
logic[15:0]                                                 cfg_function_status                        ;
logic[11:0]                                                 cfg_function_power_state                   ;
logic[503:0]                                                cfg_vf_status                              ;
logic[755:0]                                                cfg_vf_power_state                         ;
logic[1:0]                                                  cfg_link_power_state                       ;
logic[9:0]                                                  cfg_mgmt_addr                              ;
logic[7:0]                                                  cfg_mgmt_function_number                   ;
logic                                                       cfg_mgmt_write                             ;
logic[31:0]                                                 cfg_mgmt_write_data                        ;
logic[3:0]                                                  cfg_mgmt_byte_enable                       ;
logic                                                       cfg_mgmt_read                              ;
logic[31:0]                                                 cfg_mgmt_read_data                         ;
logic                                                       cfg_mgmt_read_write_done                   ;
logic                                                       cfg_mgmt_debug_access                      ;
logic                                                       cfg_err_cor_out                            ;
logic                                                       cfg_err_nonfatal_out                       ;
logic                                                       cfg_err_fatal_out                          ;
logic                                                       cfg_local_error_valid                      ;
logic[4:0]                                                  cfg_local_error_out                        ;
logic[5:0]                                                  cfg_ltssm_state                            ;
logic[1:0]                                                  cfg_rx_pm_state                            ;
logic[1:0]                                                  cfg_tx_pm_state                            ;
logic[3:0]                                                  cfg_rcb_status                             ;
logic[1:0]                                                  cfg_obff_enable                            ;
logic                                                       cfg_pl_status_change                       ;
logic[3:0]                                                  cfg_tph_requester_enable                   ;
logic[11:0]                                                 cfg_tph_st_mode                            ;
logic[251:0]                                                cfg_vf_tph_requester_enable                ;
logic[755:0]                                                cfg_vf_tph_st_mode                         ;
logic                                                       cfg_msg_received                           ;
logic[7:0]                                                  cfg_msg_received_data                      ;
logic[4:0]                                                  cfg_msg_received_type                      ;
logic                                                       cfg_msg_transmit                           ;
logic[2:0]                                                  cfg_msg_transmit_type                      ;
logic[31:0]                                                 cfg_msg_transmit_data                      ;
logic                                                       cfg_msg_transmit_done                      ;
logic[7:0]                                                  cfg_fc_ph                                  ;
logic[11:0]                                                 cfg_fc_pd                                  ;
logic[7:0]                                                  cfg_fc_nph                                 ;
logic[11:0]                                                 cfg_fc_npd                                 ;
logic[7:0]                                                  cfg_fc_cplh                                ;
logic[11:0]                                                 cfg_fc_cpld                                ;
logic[2:0]                                                  cfg_fc_sel                                 ;
logic[63:0]                                                 cfg_dsn                                    ;
logic[7:0]                                                  cfg_bus_number                             ;
logic                                                       cfg_power_state_change_ack                 ;
logic                                                       cfg_power_state_change_interrupt           ;
logic                                                       cfg_err_cor_in                             ;
logic                                                       cfg_err_uncor_in                           ;
logic[3:0]                                                  cfg_flr_in_process                         ;
logic[3:0]                                                  cfg_flr_done                               ;
logic[251:0]                                                cfg_vf_flr_in_process                      ;
logic[7:0]                                                  cfg_vf_flr_func_num                        ;
logic[0:0]                                                  cfg_vf_flr_done                            ;
logic                                                       cfg_link_training_enable                   ;
logic[3:0]                                                  cfg_interrupt_int                          ;
logic[3:0]                                                  cfg_interrupt_pending                      ;
logic                                                       cfg_interrupt_sent                         ;
logic                                                       cfg_interrupt_msi_sent                     ;
logic                                                       cfg_interrupt_msi_fail                     ;
logic[7:0]                                                  cfg_interrupt_msi_function_number          ;
logic[3:0]                                                  cfg_interrupt_msix_enable                  ;
logic[3:0]                                                  cfg_interrupt_msix_mask                    ;
logic[251:0]                                                cfg_interrupt_msix_vf_enable               ;
logic[251:0]                                                cfg_interrupt_msix_vf_mask                 ;
logic                                                       cfg_pm_aspm_l1_entry_reject                ;
logic                                                       cfg_pm_aspm_tx_l0s_entry_disable           ;
logic[31:0]                                                 cfg_interrupt_msix_data                    ;
logic[63:0]                                                 cfg_interrupt_msix_address                 ;
logic                                                       cfg_interrupt_msix_int                     ;
logic[1:0]                                                  cfg_interrupt_msix_vec_pending             ;
logic[0:0]                                                  cfg_interrupt_msix_vec_pending_status      ;
logic                                                       cfg_hot_reset_out                          ;
logic                                                       cfg_config_space_enable                    ;
logic                                                       cfg_req_pm_transition_l23_ready            ;
logic                                                       cfg_hot_reset_in                           ;
logic[7:0]                                                  cfg_ds_port_number                         ;
logic[7:0]                                                  cfg_ds_bus_number                          ;
logic[4:0]                                                  cfg_ds_device_number                       ;
logic[15:0]                                                 cfg_subsys_vend_id                         ;
logic[15:0]                                                 cfg_dev_id_pf0                             ;
logic[15:0]                                                 cfg_vend_id                                ;
logic[7:0]                                                  cfg_rev_id_pf0                             ;
logic[15:0]                                                 cfg_subsys_id_pf0                          ;
logic                                                       sys_clk                                    ;
logic                                                       sys_clk_gt                                 ;
logic                                                       sys_reset                                  ;
logic[25:0]                                                 common_commands_in                         ;
logic[83:0]                                                 pipe_rx_0_sigs                             ;
logic[83:0]                                                 pipe_rx_1_sigs                             ;
logic[83:0]                                                 pipe_rx_2_sigs                             ;
logic[83:0]                                                 pipe_rx_3_sigs                             ;
logic[83:0]                                                 pipe_rx_4_sigs                             ;
logic[83:0]                                                 pipe_rx_5_sigs                             ;
logic[83:0]                                                 pipe_rx_6_sigs                             ;
logic[83:0]                                                 pipe_rx_7_sigs                             ;
logic[83:0]                                                 pipe_rx_8_sigs                             ;
logic[83:0]                                                 pipe_rx_9_sigs                             ;
logic[83:0]                                                 pipe_rx_10_sigs                            ;
logic[83:0]                                                 pipe_rx_11_sigs                            ;
logic[83:0]                                                 pipe_rx_12_sigs                            ;
logic[83:0]                                                 pipe_rx_13_sigs                            ;
logic[83:0]                                                 pipe_rx_14_sigs                            ;
logic[83:0]                                                 pipe_rx_15_sigs                            ;
logic[25:0]                                                 common_commands_out                        ;
logic[83:0]                                                 pipe_tx_0_sigs                             ;
logic[83:0]                                                 pipe_tx_1_sigs                             ;
logic[83:0]                                                 pipe_tx_2_sigs                             ;
logic[83:0]                                                 pipe_tx_3_sigs                             ;
logic[83:0]                                                 pipe_tx_4_sigs                             ;
logic[83:0]                                                 pipe_tx_5_sigs                             ;
logic[83:0]                                                 pipe_tx_6_sigs                             ;
logic[83:0]                                                 pipe_tx_7_sigs                             ;
logic[83:0]                                                 pipe_tx_8_sigs                             ;
logic[83:0]                                                 pipe_tx_9_sigs                             ;
logic[83:0]                                                 pipe_tx_10_sigs                            ;
logic[83:0]                                                 pipe_tx_11_sigs                            ;
logic[83:0]                                                 pipe_tx_12_sigs                            ;
logic[83:0]                                                 pipe_tx_13_sigs                            ;
logic[83:0]                                                 pipe_tx_14_sigs                            ;
logic[83:0]                                                 pipe_tx_15_sigs                            ;
logic                                                       phy_rdy_out                                ;


logic                                                       bar_ren                                    ;
logic   [`BAR_ADDR_WIDTH-1:0]                               bar_raddr                                  ;
logic                                                       bar_wen                                    ;
logic   [`BAR_ADDR_WIDTH-1:0]                               bar_waddr                                  ;
logic   [`BAR_DATA_WIDTH-1:0]                               bar_wdata                                  ;
logic   [`BAR_DATA_WIDTH-1:0]                               bar_rdata                                  ;
logic                                                       bar_rack                                   ;
                    
logic   [`REG_BLOCK_NUM-1:0]                                reg_ren                                    ; 
logic   [`REG_BLOCK_NUM-1:0] [`USER_ADDR_WIDTH-1:0]         reg_raddr                                  ; 
logic   [`REG_BLOCK_NUM-1:0]                                reg_wen                                    ; 
logic   [`REG_BLOCK_NUM-1:0] [`USER_ADDR_WIDTH-1:0]         reg_waddr                                  ; 
logic   [`REG_BLOCK_NUM-1:0] [`USER_DATA_WIDTH-1:0]         reg_wdata                                  ; 
logic   [`REG_BLOCK_NUM-1:0] [`USER_DATA_WIDTH-1:0]         reg_rdata                                  ; 
logic   [`REG_BLOCK_NUM-1:0]                                reg_rack                                   ; 


//userd for signal pipeline:
//slr0 to slr1,or slr0 to slr2;
//slr1 to slr0,or slr2 to slr0;
slr0_pipe slr0_pipe(

);

//pcie sys reset,used in gen3x16 or split into gen3x8(x2)
IBUF   sys_reset_n_ibuf (.O(sys_reset), .I(sys_rst_n));

//pcie sys reset,used in gen3x16 or split into gen3x8(x2)
IBUFDS_GTE4 refclk_ibuf (.O(sys_clk_gt), .ODIV2(sys_clk), .I(sys_clk_p), .CEB(1'b0), .IB(sys_clk_n));

//pcie spilt into small module,in order to pr mode in the future;
pcie_wrapper pcie_wrapper(
    .pci_exp_rxp                                (pci_exp_rxp                              ),
    .pci_exp_rxn                                (pci_exp_rxn                              ),
    .pci_exp_txp                                (pci_exp_txp                              ),
    .pci_exp_txn                                (pci_exp_txn                              ),
    .user_clk                                   (user_clk                                 ),
    .user_reset                                 (user_reset                               ),
    .user_lnk_up                                (user_lnk_up                              ),
    .s_axis_rq_tdata                            (s_axis_rq_tdata                          ),
    .s_axis_rq_tkeep                            (s_axis_rq_tkeep                          ),
    .s_axis_rq_tlast                            (s_axis_rq_tlast                          ),
    .s_axis_rq_tready                           (s_axis_rq_tready                         ),
    .s_axis_rq_tuser                            (s_axis_rq_tuser                          ),
    .s_axis_rq_tvalid                           (s_axis_rq_tvalid                         ),
    .m_axis_rc_tdata                            (m_axis_rc_tdata                          ),
    .m_axis_rc_tkeep                            (m_axis_rc_tkeep                          ),
    .m_axis_rc_tlast                            (m_axis_rc_tlast                          ),
    .m_axis_rc_tready                           (m_axis_rc_tready                         ),
    .m_axis_rc_tuser                            (m_axis_rc_tuser                          ),
    .m_axis_rc_tvalid                           (m_axis_rc_tvalid                         ),
    .m_axis_cq_tdata                            (m_axis_cq_tdata                          ),
    .m_axis_cq_tkeep                            (m_axis_cq_tkeep                          ),
    .m_axis_cq_tlast                            (m_axis_cq_tlast                          ),
    .m_axis_cq_tready                           (m_axis_cq_tready                         ),
    .m_axis_cq_tuser                            (m_axis_cq_tuser                          ),
    .m_axis_cq_tvalid                           (m_axis_cq_tvalid                         ),
    .s_axis_cc_tdata                            (s_axis_cc_tdata                          ),
    .s_axis_cc_tkeep                            (s_axis_cc_tkeep                          ),
    .s_axis_cc_tlast                            (s_axis_cc_tlast                          ),
    .s_axis_cc_tready                           (s_axis_cc_tready                         ),
    .s_axis_cc_tuser                            (s_axis_cc_tuser                          ),
    .s_axis_cc_tvalid                           (s_axis_cc_tvalid                         ),
    .pcie_rq_seq_num0                           (pcie_rq_seq_num0                         ),
    .pcie_rq_seq_num_vld0                       (pcie_rq_seq_num_vld0                     ),
    .pcie_rq_seq_num1                           (pcie_rq_seq_num1                         ),
    .pcie_rq_seq_num_vld1                       (pcie_rq_seq_num_vld1                     ),
    .pcie_rq_tag0                               (pcie_rq_tag0                             ),
    .pcie_rq_tag1                               (pcie_rq_tag1                             ),
    .pcie_rq_tag_av                             (pcie_rq_tag_av                           ),
    .pcie_rq_tag_vld0                           (pcie_rq_tag_vld0                         ),
    .pcie_rq_tag_vld1                           (pcie_rq_tag_vld1                         ),
    .pcie_tfc_nph_av                            (pcie_tfc_nph_av                          ),
    .pcie_tfc_npd_av                            (pcie_tfc_npd_av                          ),
    .pcie_cq_np_req                             (pcie_cq_np_req                           ),
    .pcie_cq_np_req_count                       (pcie_cq_np_req_count                     ),
    .cfg_phy_link_down                          (cfg_phy_link_down                        ),
    .cfg_phy_link_status                        (cfg_phy_link_status                      ),
    .cfg_negotiated_width                       (cfg_negotiated_width                     ),
    .cfg_current_speed                          (cfg_current_speed                        ),
    .cfg_max_payload                            (cfg_max_payload                          ),
    .cfg_max_read_req                           (cfg_max_read_req                         ),
    .cfg_function_status                        (cfg_function_status                      ),
    .cfg_function_power_state                   (cfg_function_power_state                 ),
    .cfg_vf_status                              (cfg_vf_status                            ),
    .cfg_vf_power_state                         (cfg_vf_power_state                       ),
    .cfg_link_power_state                       (cfg_link_power_state                     ),
    .cfg_mgmt_addr                              (cfg_mgmt_addr                            ),
    .cfg_mgmt_function_number                   (cfg_mgmt_function_number                 ),
    .cfg_mgmt_write                             (cfg_mgmt_write                           ),
    .cfg_mgmt_write_data                        (cfg_mgmt_write_data                      ),
    .cfg_mgmt_byte_enable                       (cfg_mgmt_byte_enable                     ),
    .cfg_mgmt_read                              (cfg_mgmt_read                            ),
    .cfg_mgmt_read_data                         (cfg_mgmt_read_data                       ),
    .cfg_mgmt_read_write_done                   (cfg_mgmt_read_write_done                 ),
    .cfg_mgmt_debug_access                      (cfg_mgmt_debug_access                    ),
    .cfg_err_cor_out                            (cfg_err_cor_out                          ),
    .cfg_err_nonfatal_out                       (cfg_err_nonfatal_out                     ),
    .cfg_err_fatal_out                          (cfg_err_fatal_out                        ),
    .cfg_local_error_valid                      (cfg_local_error_valid                    ),
    .cfg_local_error_out                        (cfg_local_error_out                      ),
    .cfg_ltssm_state                            (cfg_ltssm_state                          ),
    .cfg_rx_pm_state                            (cfg_rx_pm_state                          ),
    .cfg_tx_pm_state                            (cfg_tx_pm_state                          ),
    .cfg_rcb_status                             (cfg_rcb_status                           ),
    .cfg_obff_enable                            (cfg_obff_enable                          ),
    .cfg_pl_status_change                       (cfg_pl_status_change                     ),
    .cfg_tph_requester_enable                   (cfg_tph_requester_enable                 ),
    .cfg_tph_st_mode                            (cfg_tph_st_mode                          ),
    .cfg_vf_tph_requester_enable                (cfg_vf_tph_requester_enable              ),
    .cfg_vf_tph_st_mode                         (cfg_vf_tph_st_mode                       ),
    .cfg_msg_received                           (cfg_msg_received                         ),
    .cfg_msg_received_data                      (cfg_msg_received_data                    ),
    .cfg_msg_received_type                      (cfg_msg_received_type                    ),
    .cfg_msg_transmit                           (cfg_msg_transmit                         ),
    .cfg_msg_transmit_type                      (cfg_msg_transmit_type                    ),
    .cfg_msg_transmit_data                      (cfg_msg_transmit_data                    ),
    .cfg_msg_transmit_done                      (cfg_msg_transmit_done                    ),
    .cfg_fc_ph                                  (cfg_fc_ph                                ),
    .cfg_fc_pd                                  (cfg_fc_pd                                ),
    .cfg_fc_nph                                 (cfg_fc_nph                               ),
    .cfg_fc_npd                                 (cfg_fc_npd                               ),
    .cfg_fc_cplh                                (cfg_fc_cplh                              ),
    .cfg_fc_cpld                                (cfg_fc_cpld                              ),
    .cfg_fc_sel                                 (cfg_fc_sel                               ),
    .cfg_dsn                                    (cfg_dsn                                  ),
    .cfg_bus_number                             (cfg_bus_number                           ),
    .cfg_power_state_change_ack                 (cfg_power_state_change_ack               ),
    .cfg_power_state_change_interrupt           (cfg_power_state_change_interrupt         ),
    .cfg_err_cor_in                             (cfg_err_cor_in                           ),
    .cfg_err_uncor_in                           (cfg_err_uncor_in                         ),
    .cfg_flr_in_process                         (cfg_flr_in_process                       ),
    .cfg_flr_done                               (cfg_flr_done                             ),
    .cfg_vf_flr_in_process                      (cfg_vf_flr_in_process                    ),
    .cfg_vf_flr_func_num                        (cfg_vf_flr_func_num                      ),
    .cfg_vf_flr_done                            (cfg_vf_flr_done                          ),
    .cfg_link_training_enable                   (cfg_link_training_enable                 ),
    .cfg_interrupt_int                          (cfg_interrupt_int                        ),
    .cfg_interrupt_pending                      (cfg_interrupt_pending                    ),
    .cfg_interrupt_sent                         (cfg_interrupt_sent                       ),
    .cfg_interrupt_msi_sent                     (cfg_interrupt_msi_sent                   ),
    .cfg_interrupt_msi_fail                     (cfg_interrupt_msi_fail                   ),
    .cfg_interrupt_msi_function_number          (cfg_interrupt_msi_function_number        ),
    .cfg_interrupt_msix_enable                  (cfg_interrupt_msix_enable                ),
    .cfg_interrupt_msix_mask                    (cfg_interrupt_msix_mask                  ),
    .cfg_interrupt_msix_vf_enable               (cfg_interrupt_msix_vf_enable             ),
    .cfg_interrupt_msix_vf_mask                 (cfg_interrupt_msix_vf_mask               ),
    .cfg_pm_aspm_l1_entry_reject                (cfg_pm_aspm_l1_entry_reject              ),
    .cfg_pm_aspm_tx_l0s_entry_disable           (cfg_pm_aspm_tx_l0s_entry_disable         ),
    .cfg_interrupt_msix_data                    (cfg_interrupt_msix_data                  ),
    .cfg_interrupt_msix_address                 (cfg_interrupt_msix_address               ),
    .cfg_interrupt_msix_int                     (cfg_interrupt_msix_int                   ),
    .cfg_interrupt_msix_vec_pending             (cfg_interrupt_msix_vec_pending           ),
    .cfg_interrupt_msix_vec_pending_status      (cfg_interrupt_msix_vec_pending_status    ),
    .cfg_hot_reset_out                          (cfg_hot_reset_out                        ),
    .cfg_config_space_enable                    (cfg_config_space_enable                  ),
    .cfg_req_pm_transition_l23_ready            (cfg_req_pm_transition_l23_ready          ),
    .cfg_hot_reset_in                           (cfg_hot_reset_in                         ),
    .cfg_ds_port_number                         (cfg_ds_port_number                       ),
    .cfg_ds_bus_number                          (cfg_ds_bus_number                        ),
    .cfg_ds_device_number                       (cfg_ds_device_number                     ),
    .cfg_subsys_vend_id                         (cfg_subsys_vend_id                       ),
    .cfg_dev_id_pf0                             (cfg_dev_id_pf0                           ),
    .cfg_vend_id                                (cfg_vend_id                              ),
    .cfg_rev_id_pf0                             (cfg_rev_id_pf0                           ),
    .cfg_subsys_id_pf0                          (cfg_subsys_id_pf0                        ),
    .sys_clk                                    (sys_clk                                  ),
    .sys_clk_gt                                 (sys_clk_gt                               ),
    .sys_reset                                  (sys_reset                                ),

    .common_commands_in                         (common_commands_in                       ),
    .pipe_rx_0_sigs                             (pipe_rx_0_sigs                           ),
    .pipe_rx_1_sigs                             (pipe_rx_1_sigs                           ),
    .pipe_rx_2_sigs                             (pipe_rx_2_sigs                           ),
    .pipe_rx_3_sigs                             (pipe_rx_3_sigs                           ),
    .pipe_rx_4_sigs                             (pipe_rx_4_sigs                           ),
    .pipe_rx_5_sigs                             (pipe_rx_5_sigs                           ),
    .pipe_rx_6_sigs                             (pipe_rx_6_sigs                           ),
    .pipe_rx_7_sigs                             (pipe_rx_7_sigs                           ),
    .pipe_rx_8_sigs                             (pipe_rx_8_sigs                           ),
    .pipe_rx_9_sigs                             (pipe_rx_9_sigs                           ),
    .pipe_rx_10_sigs                            (pipe_rx_10_sigs                          ),
    .pipe_rx_11_sigs                            (pipe_rx_11_sigs                          ),
    .pipe_rx_12_sigs                            (pipe_rx_12_sigs                          ),
    .pipe_rx_13_sigs                            (pipe_rx_13_sigs                          ),
    .pipe_rx_14_sigs                            (pipe_rx_14_sigs                          ),
    .pipe_rx_15_sigs                            (pipe_rx_15_sigs                          ),
    .common_commands_out                        (common_commands_out                      ),
    .pipe_tx_0_sigs                             (pipe_tx_0_sigs                           ),
    .pipe_tx_1_sigs                             (pipe_tx_1_sigs                           ),
    .pipe_tx_2_sigs                             (pipe_tx_2_sigs                           ),
    .pipe_tx_3_sigs                             (pipe_tx_3_sigs                           ),
    .pipe_tx_4_sigs                             (pipe_tx_4_sigs                           ),
    .pipe_tx_5_sigs                             (pipe_tx_5_sigs                           ),
    .pipe_tx_6_sigs                             (pipe_tx_6_sigs                           ),
    .pipe_tx_7_sigs                             (pipe_tx_7_sigs                           ),
    .pipe_tx_8_sigs                             (pipe_tx_8_sigs                           ),
    .pipe_tx_9_sigs                             (pipe_tx_9_sigs                           ),
    .pipe_tx_10_sigs                            (pipe_tx_10_sigs                          ),
    .pipe_tx_11_sigs                            (pipe_tx_11_sigs                          ),
    .pipe_tx_12_sigs                            (pipe_tx_12_sigs                          ),
    .pipe_tx_13_sigs                            (pipe_tx_13_sigs                          ),
    .pipe_tx_14_sigs                            (pipe_tx_14_sigs                          ),
    .pipe_tx_15_sigs                            (pipe_tx_15_sigs                          ),
    .phy_rdy_out                                (phy_rdy_out                              ),
);
//This input is used by the user application to request the delivery of a Non-Posted request. 
//The core implements a credit-based flow control mechanism to control the delivery of Non-Posted requests across the interface, without blocking Posted TLPs
//2'b00: No change 
//2'b01: Increment by 1
//2'b10: 10 or 11: Increment by 2
assign  pcie_cq_np_req                              = 2'b01     ;

//Infinite credit for transmit credits available (cfg_fc_sel == 3'b100) is signaled as 8'h80, 12'h800 for header and data credits, respectively.
assign  cfg_fc_sel                                  = 3'b100    ;

//Configuration Device Serial Number Indicates the value that should be transferred to the Device Serial Number Capability on PF0.
//Bits [31:0] are transferred to the first (Lower) Dword (byte offset 0x4h of the Capability), 
//and bits [63:32] are transferred to the second (Upper) Dword (byte offset 0x8h of the Capability). 
assign cfg_dsn                                      = `CFG_DSN  ;

//Configuration Downstream Port Number Provides the port number field in the Link Capabilities register.
assign cfg_ds_port_number       = `CFG_DS_PORT_NUMBER           ;
assign cfg_ds_bus_number        = `CFG_DS_BUS_NUMBER            ;
assign cfg_ds_device_number     = `CFG_DS_DEVICE_NUMBER         ;

assign cfg_subsys_vend_id       = `PCIE0_SUBSYSTEM_VENDOR_ID    ;    
assign cfg_dev_id_pf0           = `PCIE0_DEVICE_ID              ;    
assign cfg_vend_id              = `PCIE0_VENDOR_ID              ;    
assign cfg_rev_id_pf0           = `PCIE0_REVISION_ID            ;    
assign cfg_subsys_id_pf0        = `PCIE0_SUBSYSTEM_ID           ;    

//Correctable Error Detected The user application activates this input for one cycle to indicate a correctable error detected within the user
//logic that needs to be reported as an internal error through the PCI Express Advanced Error Reporting (AER) mechanism. 
assign cfg_err_cor_in                               = 1'b0      ;//可以恢复错误上报  

//Uncorrectable Error Detected The user application activates this input for one cycle to indicate a uncorrectable error detected within the user
//logic that needs to be reported as an internal error through the PCI Express Advanced Error Reporting (AER) mechanism. 
assign cfg_err_uncor_in                             = 1'b0      ;//不可恢复错误上报  

//This input must be set to 1 to enable the Link Training Status State Machine (LTSSM) to bring up the link. 
//Setting it to 0 forces the LTSSM to stay in the Detect.Quiet state.
assign cfg_link_training_enable                     = 1'b1      ;

//Configuration Power Management ASPM L1 Entry Reject: 
//When driven to 1b,Downstream Port rejects transition requests to L1 state.
assign cfg_pm_aspm_l1_entry_reject                  = 1'b0      ; //允许进入L1 state

//Configuration Power Management ASPM L0s Entry Disable:
//When driven to 1b, prevents the Port from entering TX L0s.
assign cfg_pm_aspm_tx_l0s_entry_disable             = 1'b1      ; //不允许进入TX L0 state

//Configuration Configuration Space Enable
assign cfg_config_space_enable                      = 1'b1      ;

//When the core is configured as an Endpoint, 
//the user application asserts this input to transition the power management state of the core to L23_READY
assign cfg_req_pm_transition_l23_ready              = 1'b0      ;

//Configuration Hot Reset In In RP mode, assertion transitions LTSSM to hot reset state, active-High.
assign cfg_hot_reset_in                             = 1'b0      ;//not in root point,so set to 1'b0



`ifndef PRJ_SIMULATION
    assign common_commands_in = 26'h0;  
    assign pipe_rx_0_sigs     = 84'h0;
    assign pipe_rx_1_sigs     = 84'h0;
    assign pipe_rx_2_sigs     = 84'h0;
    assign pipe_rx_3_sigs     = 84'h0;
    assign pipe_rx_4_sigs     = 84'h0;
    assign pipe_rx_5_sigs     = 84'h0;
    assign pipe_rx_6_sigs     = 84'h0;
    assign pipe_rx_7_sigs     = 84'h0;
    assign pipe_rx_8_sigs     = 84'h0; 
    assign pipe_rx_9_sigs     = 84'h0; 
    assign pipe_rx_10_sigs    = 84'h0; 
    assign pipe_rx_11_sigs    = 84'h0;    
    assign pipe_rx_12_sigs    = 84'h0;    
    assign pipe_rx_13_sigs    = 84'h0;    
    assign pipe_rx_14_sigs    = 84'h0;    
    assign pipe_rx_15_sigs    = 84'h0;   
`endif 

`ifndef PCIE_CFG_MGMT 
//The Configuration Management interface is used to read and write to the Configuration Space Registers. 
    assign cfg_mgmt_addr                = 10'h0 ;
    assign cfg_mgmt_function_number     = 8'h0  ; 
    assign cfg_mgmt_write               = 1'b0  ;
    assign cfg_mgmt_write_data          = 32'h0 ;
    assign cfg_mgmt_byte_enable         = 4'h0  ;
    assign cfg_mgmt_read                = 1'b0  ;
    assign cfg_mgmt_debug_access        = 1'b0  ;
`endif 

`ifndef PCIE_CFG_MSG
    assign  cfg_msg_transmit                            = 1'b0      ;
    assign  cfg_msg_transmit_type                       = 3'b0      ;
    assign  cfg_msg_transmit_data                       = 32'b0     ;
`endif

//Asserted by the user application whenit is safe to power down.
//电源管理，当收到 cfg_power_state_change_interrupt == 1'b1时，
//等待pcie rq，rc，cq，cc都处于IDLE状态时，返回响应，说明可以断电了
`ifndef PCIE_CFG_POWER
    assign cfg_power_state_change_ack                   = 1'b0      ;
`endif

`ifndef PCIE_CFG_FLR
    assign cfg_flr_done                                 = 4'h0      ;
    assign cfg_vf_flr_func_num                          = 8'h0      ;
    assign cfg_vf_flr_done                              = 1'b0      ;
`endif

pcie_app_uscale pcie_app_uscale(

    .user_clk                                   (user_clk                                 ),
    .user_reset                                 (user_reset                               ),
    .user_lnk_up                                (user_lnk_up                              ),
    .phy_rdy_out                                (phy_rdy_out                              ),

    //Requester Request Interface Operation
    .s_axis_rq_tdata                            (s_axis_rq_tdata                          ),
    .s_axis_rq_tkeep                            (s_axis_rq_tkeep                          ),
    .s_axis_rq_tlast                            (s_axis_rq_tlast                          ),
    .s_axis_rq_tready                           (s_axis_rq_tready                         ),
    .s_axis_rq_tuser                            (s_axis_rq_tuser                          ),
    .s_axis_rq_tvalid                           (s_axis_rq_tvalid                         ),

    //Requester Completion Interface Operation
    .m_axis_rc_tdata                            (m_axis_rc_tdata                          ),
    .m_axis_rc_tkeep                            (m_axis_rc_tkeep                          ),
    .m_axis_rc_tlast                            (m_axis_rc_tlast                          ),
    .m_axis_rc_tready                           (m_axis_rc_tready                         ),
    .m_axis_rc_tuser                            (m_axis_rc_tuser                          ),
    .m_axis_rc_tvalid                           (m_axis_rc_tvalid                         ),

    //Completer Request Interface Operation
    .m_axis_cq_tdata                            (m_axis_cq_tdata                          ),
    .m_axis_cq_tkeep                            (m_axis_cq_tkeep                          ),
    .m_axis_cq_tlast                            (m_axis_cq_tlast                          ),
    .m_axis_cq_tready                           (m_axis_cq_tready                         ),
    .m_axis_cq_tuser                            (m_axis_cq_tuser                          ),
    .m_axis_cq_tvalid                           (m_axis_cq_tvalid                         ),

    //Completer Completion Interface Operation 
    .s_axis_cc_tdata                            (s_axis_cc_tdata                          ),
    .s_axis_cc_tkeep                            (s_axis_cc_tkeep                          ),
    .s_axis_cc_tlast                            (s_axis_cc_tlast                          ),
    .s_axis_cc_tready                           (s_axis_cc_tready                         ),
    .s_axis_cc_tuser                            (s_axis_cc_tuser                          ),
    .s_axis_cc_tvalid                           (s_axis_cc_tvalid                         ),

    //Configuration Status Interface Port Descriptions
    //EP and RP
    .cfg_phy_link_down                          (cfg_phy_link_down                        ),
    .cfg_phy_link_status                        (cfg_phy_link_status                      ),
    .cfg_negotiated_width                       (cfg_negotiated_width                     ),
    .cfg_current_speed                          (cfg_current_speed                        ),
    .cfg_max_payload                            (cfg_max_payload                          ),
    .cfg_max_read_req                           (cfg_max_read_req                         ),
    .cfg_function_status                        (cfg_function_status                      ),
    .cfg_function_power_state                   (cfg_function_power_state                 ),
    .cfg_vf_status                              (cfg_vf_status                            ),
    .cfg_vf_power_state                         (cfg_vf_power_state                       ),
    .cfg_link_power_state                       (cfg_link_power_state                     ),

    // Error Reporting Interface
    .cfg_err_cor_out                            (cfg_err_cor_out                          ),//Correctable Error Detected
    .cfg_err_nonfatal_out                       (cfg_err_nonfatal_out                     ),//Non Fatal Error Detected
    .cfg_err_fatal_out                          (cfg_err_fatal_out                        ),//Fatal Error Detected
    .cfg_local_error_valid                      (cfg_local_error_valid                    ),//Local Error Conditions Valid
    .cfg_local_error_out                        (cfg_local_error_out                      ),//Local Error Conditions
    
    .cfg_ltssm_state                            (cfg_ltssm_state                          ),//LTSSM State
    .cfg_rx_pm_state                            (cfg_rx_pm_state                          ),//Current RX Active State Power Management L0s State
    .cfg_tx_pm_state                            (cfg_tx_pm_state                          ),//Current TX Active State Power Management L0s State
    .cfg_rcb_status                             (cfg_rcb_status                           ),//Provides the setting of the Read Completion Boundary (RCB) bit in the Link Control register of each physical function
    .cfg_obff_enable                            (cfg_obff_enable                          ),//Optimized Buffer Flush Fill Enable
    .cfg_pl_status_change                       (cfg_pl_status_change                     ),//no used,The pl_interrupt output is not active when the core is configured as an Endpoint.
    .cfg_tph_requester_enable                   (cfg_tph_requester_enable                 ),
    .cfg_tph_st_mode                            (cfg_tph_st_mode                          ),
    .cfg_vf_tph_requester_enable                (cfg_vf_tph_requester_enable              ),
    .cfg_vf_tph_st_mode                         (cfg_vf_tph_st_mode                       ),    

    //Configuration Flow Control Interface
    .cfg_fc_ph                                  (cfg_fc_ph                                ),
    .cfg_fc_pd                                  (cfg_fc_pd                                ),
    .cfg_fc_nph                                 (cfg_fc_nph                               ),
    .cfg_fc_npd                                 (cfg_fc_npd                               ),
    .cfg_fc_cplh                                (cfg_fc_cplh                              ),
    .cfg_fc_cpld                                (cfg_fc_cpld                              ),

    `ifdef PCIE_CFG_MGMT
    // MGMT Management Interface
    .cfg_mgmt_addr                              (cfg_mgmt_addr                            ),
    .cfg_mgmt_function_number                   (cfg_mgmt_function_number                 ),
    .cfg_mgmt_write                             (cfg_mgmt_write                           ),
    .cfg_mgmt_write_data                        (cfg_mgmt_write_data                      ),
    .cfg_mgmt_byte_enable                       (cfg_mgmt_byte_enable                     ),
    .cfg_mgmt_read                              (cfg_mgmt_read                            ),
    .cfg_mgmt_read_data                         (cfg_mgmt_read_data                       ),
    .cfg_mgmt_read_write_done                   (cfg_mgmt_read_write_done                 ),
    .cfg_mgmt_debug_access                      (cfg_mgmt_debug_access                    ),
    `endif

    `ifdef PCIE_CFG_MSG
    .cfg_msg_received                           (cfg_msg_received                         ),
    .cfg_msg_received_data                      (cfg_msg_received_data                    ),
    .cfg_msg_received_type                      (cfg_msg_received_type                    ),
    .cfg_msg_transmit                           (cfg_msg_transmit                         ),
    .cfg_msg_transmit_type                      (cfg_msg_transmit_type                    ),
    .cfg_msg_transmit_data                      (cfg_msg_transmit_data                    ),
    .cfg_msg_transmit_done                      (cfg_msg_transmit_done                    ),
    `endif 

    `ifdef PCIE_CFG_POWER
    .cfg_power_state_change_ack                 (cfg_power_state_change_ack               ),
    .cfg_power_state_change_interrupt           (cfg_power_state_change_interrupt         ),
    `endif

    `ifdef PCIE_CFG_FLR
    .cfg_flr_in_process                         (cfg_flr_in_process                       ),
    .cfg_flr_done                               (cfg_flr_done                             ),
    .cfg_vf_flr_in_process                      (cfg_vf_flr_in_process                    ),
    .cfg_vf_flr_func_num                        (cfg_vf_flr_func_num                      ),
    .cfg_vf_flr_done                            (cfg_vf_flr_done                          ),
    `endif

    .bar_ren                                    (bar_ren                                  ),
    .bar_raddr                                  (bar_raddr                                ),
    .bar_wen                                    (bar_wen                                  ),
    .bar_waddr                                  (bar_waddr                                ),
    .bar_wdata                                  (bar_wdata                                ),
    .bar_rdata                                  (bar_rdata                                ),
    .bar_rack                                   (bar_rack                                 )
);


 pcie_bar#(
    .BAR_ADDR_WIDTH      (`BAR_ADDR_WIDTH  ),
    .BAR_DATA_WIDTH      (`BAR_DATA_WIDTH  ),
    .USER_ADDR_WIDTH     (`USER_ADDR_WIDTH ),
    .USER_DATA_WIDTH     (`USER_DATA_WIDTH ),
    .REG_BLOCK_NUM       (`REG_BLOCK_NUM   )      
)pcie_bar(
    .clk             (clk           ),
    .rst             (rst           ),
    .bar_ren         (bar_ren       ),
    .bar_raddr       (bar_raddr     ),
    .bar_wen         (bar_wen       ),
    .bar_waddr       (bar_waddr     ),
    .bar_wdata       (bar_wdata     ),
    .bar_rdata       (bar_rdata     ),
    .bar_rack        (bar_rack      ),
    .reg_ren         (reg_ren       ),
    .reg_raddr       (reg_raddr     ),
    .reg_wen         (reg_wen       ),
    .reg_waddr       (reg_waddr     ),
    .reg_wdata       (reg_wdata     ),
    .reg_rdata       (reg_rdata     ),
    .reg_rack        (reg_rack      )
);


pcie_cq_parser  pcie_cq_parser(
    .clk                (clk)
    .rst                (clk)

    .m_axis_cq_tdata    (m_axis_cq_tdata            ),     
    .m_axis_cq_tkeep    (m_axis_cq_tkeep            ),     
    .m_axis_cq_tlast    (m_axis_cq_tlast            ),     
    .m_axis_cq_tready   (m_axis_cq_tready           ),     
    .m_axis_cq_tuser    (m_axis_cq_tuser            ),     
    .m_axis_cq_tvalid   (m_axis_cq_tvalid           ),     







)  