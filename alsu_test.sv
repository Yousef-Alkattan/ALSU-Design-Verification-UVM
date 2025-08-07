package alsu_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import alsu_env_pkg::*;
import alsu_config_pkg::*;
import alsu_sequence_pkg::*;
import alsu_reset_sequence_pkg::*;

class alsu_test extends uvm_test;
   `uvm_component_utils(alsu_test)
    
    alsu_env env;
    alsu_config alsu_cfg;
    alsu_sequence seq1;
    alsu_reset_sequence seq2;

    function new(string name = "alsu_test", uvm_component parent = null);
      	super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      	super.build_phase(phase);
      	env = alsu_env::type_id::create("env", this);
	alsu_cfg = alsu_config::type_id::create("alsu_cfg");
	seq1 = alsu_sequence::type_id::create("seq1");
	seq2 = alsu_reset_sequence::type_id::create("seq2");
      	
	if (!uvm_config_db#(virtual alsu_if)::get(this, "", "alsu_vif", alsu_cfg.alsu_vif))
        `uvm_fatal("VIF_GET", "Failed to get virtual interface in alsu_test")

      	uvm_config_db#(alsu_config)::set(this, "*", "CFG", alsu_cfg);
    endfunction

    task run_phase(uvm_phase phase);
	super.run_phase(phase);
      	phase.raise_objection(this);
      	`uvm_info("ALSU_TEST", "Inside the ALSU test", UVM_MEDIUM)
	
	seq2.start(env.m_agent.m_sequencer);
	seq1.start(env.m_agent.m_sequencer);

      	phase.drop_objection(this);
    endtask

endclass

endpackage
