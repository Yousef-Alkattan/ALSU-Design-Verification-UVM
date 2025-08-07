import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_test_pkg::*;

module fifo_top;

bit clk;
  initial begin 
    clk=0; 
    forever #1 clk = ~clk; 
  end

  FIFO_interface intf(clk);

  FIFO dut (intf);
  

  initial begin
    uvm_config_db#(virtual FIFO_interface)::set(null, "*", "fifo_vif", intf);
    run_test("fifo_test");
  end

endmodule
