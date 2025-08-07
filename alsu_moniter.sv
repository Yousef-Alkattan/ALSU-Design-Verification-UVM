package alsu_monitor_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import alsu_sequence_item_pkg::*;

  class alsu_monitor extends uvm_monitor;
    `uvm_component_utils(alsu_monitor)

    virtual interface alsu_if alsu_mon_vif;
    alsu_sequence_item item;
    uvm_analysis_port#(alsu_sequence_item) mon_ap;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      	super.build_phase(phase);
	mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
      forever begin
        item = alsu_sequence_item::type_id::create("item", this);
        @(negedge alsu_mon_vif.clk);
        item.A         = alsu_mon_vif.A;
        item.B         = alsu_mon_vif.B;
	item.opcode = opcode_e'(alsu_mon_vif.opcode);
        item.cin       = alsu_mon_vif.cin;
        item.red_op_A  = alsu_mon_vif.red_op_A;
        item.red_op_B  = alsu_mon_vif.red_op_B;
        item.bypass_A  = alsu_mon_vif.bypass_A;
        item.bypass_B  = alsu_mon_vif.bypass_B;
        item.direction = alsu_mon_vif.direction;
        item.serial_in = alsu_mon_vif.serial_in;
        mon_ap.write(item);
        `uvm_info("monitor_run", $sformatf("Generated item: %s", item.convert2string()), UVM_HIGH)
      end
    endtask
  endclass

endpackage
