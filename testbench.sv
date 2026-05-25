`include "uvm_macros.svh"
import uvm_pkg::*;
`include "Apb_test.sv"

module tb_top;

  logic pclk, rst_n;

  dut_if dif(pclk, rst_n); 

  apb_slave uut(dif.slave); 

  
  initial begin
    pclk = 1;
    forever #5 pclk = ~pclk;
  end

  
  always @(posedge pclk) begin
    -> static_event::clock_sync;
  end

  
  initial begin
    rst_n = 0;
    repeat(3)@(posedge pclk);
    rst_n = 1;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

 
  initial begin
    uvm_config_db#(virtual dut_if)::set(null, "*", "dif", dif);
    run_test("Apb_test");
  end

endmodule
