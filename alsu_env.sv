package alsu_env_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_agent_pkg::*;
import alsu_coverage_pkg::*;
import alsu_scoreboard_pkg::*;

  class alsu_env extends uvm_env;
    `uvm_component_utils(alsu_env)

    alsu_agent         m_agent;
    alsu_scoreboard    m_scoreboard;
    alsu_coverage      m_coverage;

    function new(string name = "alsu_env", uvm_component parent = null);
      	super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      	super.build_phase(phase);
      m_agent      = alsu_agent::type_id::create("m_agent", this);
      m_coverage   = alsu_coverage::type_id::create("m_coverage", this);
      m_scoreboard = alsu_scoreboard::type_id::create("m_scoreboard", this);
    
    endfunction
    
    function void connect_phase(uvm_phase phase);
      
      m_agent.agt_ap.connect(m_scoreboard.sb_export);
      m_agent.agt_ap.connect(m_coverage.cov_ap);

    endfunction
  
endclass

endpackage
