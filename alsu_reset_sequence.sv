package alsu_reset_sequence_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import alsu_sequence_item_pkg::*;

  class alsu_reset_sequence extends uvm_sequence#(alsu_sequence_item);
    `uvm_object_utils(alsu_reset_sequence)
      alsu_sequence_item req;

    function new(string name = "alsu_reset_sequence");
      super.new(name);
    endfunction

    task body();

      req = alsu_sequence_item::type_id::create("req");
        start_item(req);
	req.rst=1;
	req.A=0;
	req.B=0;
        finish_item(req);

    endtask

  endclass

endpackage