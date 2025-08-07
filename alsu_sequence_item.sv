package alsu_sequence_item_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

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

  class alsu_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(alsu_sequence_item)

    rand bit rst;
    rand bit red_op_A;
    rand bit red_op_B;
    rand bit bypass_A;
    rand bit bypass_B;
    rand opcode_e opcode;
    rand bit signed [2:0] A, B;
    rand bit cin;
    rand bit serial_in;
    rand bit direction;
    logic signed [5:0] out;
    logic signed [5:0] out_old;

    bit clk;

    constraint reset {
      rst dist {1:/1, 0:/99};
    }


    constraint adder_inputs {
      if (opcode inside {ADD, MULT}) {
        A dist {
          3 := 60,   // +3 (MAXPOS)
          0 := 60,   // 0
          -4 := 60,  // -4 (MAXNEG)
          [1:2] := 10,  // +1 to +2
          [-3:-1] := 10  // -3 to -1
        };
        B dist {
          3 := 60,   // +3 (MAXPOS)
          0 := 60,   // 0
          -4 := 60,  // -4 (MAXNEG)
          [1:2] := 10,  // +1 to +2
          [-3:-1] := 10  // -3 to -1
        };
      }
    }


    constraint red_op_A_high {
      if (opcode inside {OR, XOR} && red_op_A) {
        A dist { 
          0 := 5,     
          1 := 40,
          2 := 40,
          3 := 5,
          -4 := 40,
          [-3:-1] := 15
        };
        B == 0;  // B should be 0 when red_op_A is high
      }
    }


    constraint red_op_B_high {
      if (opcode inside {OR, XOR} && red_op_B) {
        B dist { 
          0 := 5,     
          1 := 40,
          2 := 40,
          3 := 5,
          -4 := 40,
          [-3:-1] := 15
        };
        A == 0;  // A should be 0 when red_op_B is high
      }
    }


    constraint invalid_cases {
      opcode dist {
        INVALID_6 := 5,
        INVALID_7 := 5,
        OR := 50,
        XOR := 50,
        ADD := 50,
        MULT := 50,
        SHIFT := 50,
        ROTATE := 50
      };
      red_op_A dist {1:/5, 0:/95};
      red_op_B dist {1:/5, 0:/95};
    }


    constraint bypass_behavior {
      bypass_A dist {1:/5, 0:/95};
      bypass_B dist {1:/5, 0:/95};
    }

//8th constraint
    rand opcode_e op_arr[6];

constraint constraint8 {
  foreach(op_arr[i])
    op_arr[i] inside {OR, XOR, ADD, MULT, SHIFT, ROTATE};
  unique { op_arr };
}

    function new(string name = "alsu_sequence_item");
      super.new(name);
    endfunction

    function string convert2string();
      return $sformatf("A=%0d B=%0d cin=%0b red_op_A=%0b red_op_B=%0b bypass_A=%0b bypass_B=%0b direction=%0b serial_in=%0b opcode=%0d",
                        A, B, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode);
    endfunction
  
  endclass

endpackage
