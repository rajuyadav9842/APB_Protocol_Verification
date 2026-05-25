`include "static_event.sv"

class Apb_driver extends uvm_driver #(Apb_sequence_item);
  `uvm_component_utils(Apb_driver)

  virtual dut_if dif;

  function new(string name = "Apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dif", dif)) begin
      `uvm_fatal("DRV_IF", "Virtual interface not set for driver");
    end
  endfunction

  task write(input Apb_sequence_item trans);
    `uvm_info("DRV", $sformatf("WRITE -> addr = 0x%0h, data = 0x%0h", trans.paddr, trans.pwdata), UVM_MEDIUM)

    
    dif.paddr   = trans.paddr;
    dif.pwrite  = 1;
    dif.pwdata  = trans.pwdata;
    dif.psel    = 1;
    dif.penable = 0;
    dif.prdata  = 0;

    @(static_event::clock_sync); 
    dif.penable = 1;

    wait (dif.pready == 1);    

    @(static_event::clock_sync); 

  
    dif.psel    = 0;
    dif.penable = 0;
  endtask

  task read(input Apb_sequence_item trans);
    `uvm_info("DRV", $sformatf("READ -> addr = 0x%0h", trans.paddr), UVM_MEDIUM)

    dif.paddr   = trans.paddr;
    dif.pwrite  = 0;
    dif.psel    = 1;
    dif.penable = 0;
    dif.pwdata = 0;
    @(static_event::clock_sync);
    dif.penable = 1;

    wait (dif.pready == 1);      

    @(static_event::clock_sync); 

    dif.psel    = 0;
    dif.penable = 0;
  endtask

  task run_phase(uvm_phase phase);
    Apb_sequence_item trans;
    forever begin
      seq_item_port.get_next_item(trans);
      `uvm_info("DRV", "Got item from sequence", UVM_LOW)

      if (trans.pwrite)
        write(trans);
      else
        read(trans);

      seq_item_port.item_done();
    end
  endtask

endclass

