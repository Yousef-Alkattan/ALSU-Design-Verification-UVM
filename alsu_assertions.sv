module alsu_assertions (alsu_if.assertions intf);

  logic invalid;
  assign invalid = ((intf.red_op_A | intf.red_op_B) & (intf.opcode[1] | intf.opcode[2])) |
                   (intf.opcode[1] & intf.opcode[2]);

int x; 
assign x = intf.cin;

  // Reset behavior
  always_comb begin
    if (intf.rst)
      a_reset: assert final(intf.out == 0);
  end
  
 // LEDs toggle on invalid
  property leds_blink_on_invalid;
    @(posedge intf.clk) disable iff (intf.rst)
      invalid |=> ##1 intf.leds == ~($past(intf.leds));
  endproperty
  assert property (leds_blink_on_invalid)
    else $error("LEDs are not blinking correctly on invalid operation.");

  // LEDs off on valid
  property leds_off_on_valid;
    @(posedge intf.clk) disable iff (intf.rst)
      !invalid |=> ##1 intf.leds == 0;
  endproperty
  assert property (leds_off_on_valid)
    else $error("LEDs should be off for valid operations.");

  // Bypass A and B
  property bypass_A_and_B_output_check;
    @(posedge intf.clk) disable iff (intf.rst)
      intf.bypass_A && intf.bypass_B |=> ##1 intf.out == $past(intf.A, 2);
  endproperty
  assert property (bypass_A_and_B_output_check)
    else $error("Bypass A and B mismatch.");

  // Bypass A only
  property bypass_A_only_output_check;
    @(posedge intf.clk) disable iff (intf.rst)
      intf.bypass_A && !intf.bypass_B |=> ##1 intf.out == $past(intf.A, 2);
  endproperty
  assert property (bypass_A_only_output_check)
    else $error("Bypass A only mismatch.");

  // Bypass B only
  property bypass_B_only_output_check;
    @(posedge intf.clk) disable iff (intf.rst)
      !intf.bypass_A && intf.bypass_B |=> ##1 intf.out == $past(intf.B, 2);
  endproperty
  assert property (bypass_B_only_output_check)
    else $error("Bypass B only mismatch.");

  // Addition
  property addition_output_check;
    @(posedge intf.clk) disable iff (intf.rst || intf.red_op_A || intf.red_op_B || intf.bypass_B || intf.bypass_A)
      (intf.opcode == 2) |-> ##2
        intf.out == ($past(intf.A, 2) + $past(intf.B, 2) + $past(x, 2));
  endproperty
  assert property (addition_output_check)
    else $error("Addition mismatch.");

  // Multiplication
  property multiply_output_check;
    @(posedge intf.clk) disable iff (intf.rst || intf.red_op_A || intf.red_op_B || intf.bypass_B || intf.bypass_A)
      (intf.opcode == 3) |-> ##2
        intf.out == ($past(intf.A, 2) * $past(intf.B, 2));
  endproperty
  assert property (multiply_output_check)
    else $error("Multiply mismatch.");



endmodule