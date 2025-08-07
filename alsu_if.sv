interface alsu_if(input logic clk);

  logic rst;
  logic cin;
  logic red_op_A, red_op_B;
  logic bypass_A, bypass_B;
  logic direction;
  logic serial_in;
  logic [2:0] opcode;
  logic signed [2:0] A, B;

  logic [15:0] leds;
  logic signed [5:0] out;

  modport assertions (
    input clk, rst, opcode, A, B, cin, serial_in,
          red_op_A, red_op_B, bypass_A, bypass_B, direction,
          leds, out
  );

endinterface
