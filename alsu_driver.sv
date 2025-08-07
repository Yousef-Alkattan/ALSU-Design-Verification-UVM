package alsu_driver_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_config_pkg::*;
import alsu_sequence_item_pkg::*;

class alsu_driver extends uvm_driver #(alsu_sequence_item);
    `uvm_component_utils(alsu_driver)

    virtual interface alsu_if alsu_driver_vif;
    alsu_config alsu_cfg;
    alsu_sequence_item req;

    function new(string name = "alsu_driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(alsu_config)::get(this, "", "CFG", alsu_cfg))
        `uvm_fatal("build_phase", "Virtual interface not found for alsu_driver")
    endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  alsu_driver_vif = alsu_cfg.alsu_vif;
endfunction

    task run_phase(uvm_phase phase);
  	super.run_phase(phase);
      
      forever begin
	req = alsu_sequence_item::type_id::create("req");
	seq_item_port.get_next_item(req);

        alsu_driver_vif.A = req.A;
        alsu_driver_vif.B = req.B;
	alsu_driver_vif.rst = req.rst;
        alsu_driver_vif.opcode = req.opcode;
	alsu_driver_vif.cin = req.cin;
	alsu_driver_vif.red_op_A = req.red_op_A;
	alsu_driver_vif.red_op_B = req.red_op_B;
	alsu_driver_vif.bypass_A = req.bypass_A;
	alsu_driver_vif.bypass_B = req.bypass_B;
	alsu_driver_vif.direction = req.direction;
	alsu_driver_vif.serial_in = req.serial_in;
	@(negedge alsu_driver_vif.clk);
	seq_item_port.item_done();
      end
    endtask

  endclass

endpackage
