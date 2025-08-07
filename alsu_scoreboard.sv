package alsu_scoreboard_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import alsu_sequence_item_pkg::*;

  class alsu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alsu_scoreboard)

    uvm_analysis_export #(alsu_sequence_item) sb_export;
    uvm_tlm_analysis_fifo #(alsu_sequence_item) sb_fifo;

    alsu_sequence_item seq_item_sb;
    logic signed [5:0] golden_model_output;

    int correct_count = 0;
    int error_count = 0;

    function new(string name = "alsu_scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sb_export = new("sb_export", this);
      sb_fifo = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      sb_export.connect (sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
	sb_fifo.get(seq_item_sb);
        ref_model(seq_item_sb);

        if (seq_item_sb.out != golden_model_output) begin
          `uvm_error("run_phase", $sformatf("Mismatch: DUT=%0d, REF=%0d", 
                                            seq_item_sb.out, golden_model_output))
          error_count++;
        end 
	else begin
          correct_count++;
        end
      end
    endtask

    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("report_phase", $sformatf("Correct transactions: %0d", correct_count), UVM_MEDIUM)
      `uvm_info("report_phase", $sformatf("Failed transactions: %0d", error_count), UVM_MEDIUM)
    endfunction

task ref_model(alsu_sequence_item chk);
  chk.out_old = chk.out;
  if (chk.rst) begin
    golden_model_output = 0;
  end 
  
  else begin
    if (chk.bypass_A && chk.bypass_B)
      golden_model_output = chk.A;
    else if (chk.bypass_A)
      golden_model_output = chk.A;
    else if (chk.bypass_B)
      golden_model_output = chk.B;
    else if ((chk.opcode == 3'b110 || chk.opcode == 3'b111) ||
      ((chk.red_op_A || chk.red_op_B) && !(chk.opcode == 3'b000 || chk.opcode == 3'b001)))
      golden_model_output = 0;
 
    else begin
      case (chk.opcode)
        3'h0: begin  // OR Operation
          if (chk.red_op_A && chk.red_op_B)
            golden_model_output = |chk.A;
          else if (chk.red_op_A)
            golden_model_output = |chk.A;
          else if (chk.red_op_B)
            golden_model_output = |chk.B;
          else
            golden_model_output = chk.A | chk.B;
        end
        3'h1: begin  // XOR Operation
          if (chk.red_op_A && chk.red_op_B)
            golden_model_output = ^chk.A;
          else if (chk.red_op_A)
            golden_model_output = ^chk.A;
          else if (chk.red_op_B)
            golden_model_output = ^chk.B;
          else
            golden_model_output = chk.A ^ chk.B;
        end
        3'h2: golden_model_output = chk.A + chk.B + chk.cin;  // ADD
        3'h3: golden_model_output = chk.A * chk.B;            // MULTIPLY
        3'h4: begin  // SHIFT
          if (chk.direction)
            golden_model_output = {chk.out_old[4:0], chk.serial_in};  // Shift left
          else
            golden_model_output = {chk.serial_in, chk.out_old[5:1]};  // Shift right
        end
        3'h5: begin  // ROTATE
          if (chk.direction)
            golden_model_output = {chk.out_old[4:0], chk.out_old[5]};  // Rotate left
          else
            golden_model_output = {chk.out_old[0], chk.out_old[5:1]};  // Rotate right
        end
        default: golden_model_output = 0;
      endcase
    end
  end

endtask

endclass

endpackage


