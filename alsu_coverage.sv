package alsu_coverage_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import alsu_sequence_item_pkg::*;

class alsu_coverage extends uvm_component;
  `uvm_component_utils(alsu_coverage)

  uvm_analysis_export #(alsu_sequence_item) cov_ap;
  uvm_tlm_analysis_fifo #(alsu_sequence_item) cov_fifo;
  alsu_sequence_item item;

  // Mirror interface signals here
  logic signed [2:0] A, B;
  logic [2:0] opcode;
  logic cin, direction, serial_in;
  logic red_op_A, red_op_B;

  typedef enum logic [2:0] {
    OR     = 3'h0,
    XOR    = 3'h1,
    ADD    = 3'h2,
    MULT   = 3'h3,
    SHIFT  = 3'h4,
    ROTATE = 3'h5,
    INVALID_6 = 3'h6,
    INVALID_7 = 3'h7
  } opcode_e;

  covergroup alsu_cg;
    option.per_instance = 1;

      // A 
	coverpoint A {
        bins A_data_0         = {0};
        bins A_data_max       = {3};
        bins A_data_min       = {-4};
        bins A_data_default   = default;
        bins A_data_walkingones[] = {1, 2, -4} iff (red_op_A);
      }

      // B 
	coverpoint B {
        bins B_data_0         = {0};
        bins B_data_max       = {3};
        bins B_data_min       = {-4};
        bins B_data_default   = default;
        bins B_data_walkingones[] = {1, 2, -4} iff (red_op_B && !red_op_A);
      }

      // Opcode 
	coverpoint opcode {
        bins Bins_shift[]     = {SHIFT, ROTATE};
        bins Bins_arith[]     = {ADD, MULT};
        bins Bins_bitwise[]   = {OR, XOR};
        illegal_bins Bins_invalid     = {INVALID_6,INVALID_7};
        bins Bins_trans       = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
      }


    coverpoint cin        { bins c_in_vals[] = {0, 1}; }
    coverpoint direction  { bins dir_vals[] = {0, 1}; }
    coverpoint serial_in  { bins shift_vals[] = {0, 1}; }
    coverpoint red_op_A   { bins active = {1}; }
    coverpoint red_op_B   { bins active = {1}; }

//1
    cross A, B iff (opcode inside {ADD, MULT}) {
      bins cross_arith = binsof(A) intersect {3, -4, 0} &&
                         binsof(B) intersect {3, -4, 0};
      option.cross_auto_bin_max = 0;
    }

//2
  cross opcode, cin {bins cross_add_cin = binsof(opcode) intersect {ADD};
  option.cross_auto_bin_max = 0;
}

//3
  cross opcode, direction {bins cross_shift_dir = binsof(opcode) intersect {SHIFT, ROTATE};
  option.cross_auto_bin_max = 0;
}

//4
  cross opcode, serial_in {bins cross_shift_serialin = binsof(opcode) intersect {SHIFT};
  option.cross_auto_bin_max = 0;
}
  
//5
  cross  A, B iff( opcode == OR || opcode == XOR ){
    bins cross_redA = binsof(A.A_data_walkingones) && binsof(B.B_data_0);
    option.cross_auto_bin_max = 0;
  }

  
//6
  cross  A, B iff( opcode == OR || opcode == XOR ){
    bins cross_redB = binsof(B.B_data_walkingones) && binsof(A.A_data_0);
    option.cross_auto_bin_max = 0;
  } 

//7
cross opcode, red_op_A, red_op_B {
    bins invalid_redA =
      	binsof(opcode) intersect {ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} &&
      	binsof(red_op_A) intersect {1};
    bins invalid_redB =
      	binsof(opcode) intersect {ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} &&
      	binsof(red_op_B) intersect {1};
        option.cross_auto_bin_max = 0;
  }

  endgroup

  function new(string name = "alsu_coverage", uvm_component parent = null);
    super.new(name, parent);
    alsu_cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_ap = new("cov_ap", this);
    cov_fifo = new("cov_fifo", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_ap.connect(cov_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cov_fifo.get(item);

      A          = item.A;
      B          = item.B;
      opcode     = item.opcode;
      cin        = item.cin;
      direction  = item.direction;
      serial_in  = item.serial_in;
      red_op_A   = item.red_op_A;
      red_op_B   = item.red_op_B;

      if (!item.rst && !item.bypass_A && !item.bypass_B) begin
        alsu_cg.sample(); 
      end
    end
  endtask

endclass

endpackage




