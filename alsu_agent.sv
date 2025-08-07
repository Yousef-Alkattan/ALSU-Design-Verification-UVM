package alsu_agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import alsu_config_pkg::*;
  import alsu_sequence_item_pkg::*;
  import alsu_sequencer_pkg::*;
  import alsu_driver_pkg::*;
  import alsu_monitor_pkg::*;

  class alsu_agent extends uvm_agent;
    `uvm_component_utils(alsu_agent)

    alsu_driver    m_driver;
    alsu_monitor   m_monitor;
    alsu_sequencer m_sequencer;
    alsu_config alsu_cfg;
    uvm_analysis_port #(alsu_sequence_item) agt_ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if (!uvm_config_db#(alsu_config)::get(this, "", "CFG", alsu_cfg))
        `uvm_fatal("AGENT_VIF", "Failed to get alsu_vif")

      m_driver    = alsu_driver::type_id::create("m_driver", this);
      m_monitor   = alsu_monitor::type_id::create("m_monitor", this);
      m_sequencer = alsu_sequencer::type_id::create("m_sequencer", this);
      agt_ap = new("agt_ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      	super.connect_phase(phase);
	m_driver.alsu_driver_vif = alsu_cfg.alsu_vif;
	m_monitor.alsu_mon_vif = alsu_cfg.alsu_vif;
      	m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
	m_monitor.mon_ap.connect(agt_ap);
    endfunction
  endclass

endpackage