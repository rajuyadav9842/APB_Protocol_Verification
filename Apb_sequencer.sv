class Apb_sequencer extends uvm_sequencer#(Apb_sequence_item);
  `uvm_component_utils(Apb_sequencer)

  function new(string name = "Apb_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass

