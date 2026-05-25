`include "Apb_sequence_item.sv"
`include "Apb_driver.sv"
`include "Apb_sequencer.sv"
`include "Apb_monitor.sv"

class Apb_agent extends uvm_agent;

  `uvm_component_utils(Apb_agent)
  
  function new(string name = "Apb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  Apb_sequencer seq;
  Apb_driver    drv;
  Apb_monitor   mon;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = Apb_sequencer::type_id::create("seq", this);
    drv = Apb_driver::type_id::create("drv", this);
    mon = Apb_monitor::type_id::create("mon", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seq.seq_item_export);
  endfunction

endclass

