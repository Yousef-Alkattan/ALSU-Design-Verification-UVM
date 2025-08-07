package alsu_sequence_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import alsu_sequence_item_pkg::*;

  class alsu_sequence extends uvm_sequence#(alsu_sequence_item);
    `uvm_object_utils(alsu_sequence)
      alsu_sequence_item req;

    function new(string name = "alsu_sequence");
      super.new(name);
    endfunction

    task body();

      req = alsu_sequence_item::type_id::create("req");
      req.constraint8.constraint_mode(0);
      repeat (10000) begin
        start_item(req);
        assert(req.randomize());
        finish_item(req);
    end

    endtask

  endclass

endpackage
