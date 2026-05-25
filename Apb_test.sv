`include "Apb_env.sv"
`include "Apb_sequence.sv"

class Apb_test extends uvm_test;
  
  `uvm_component_utils(Apb_test)
  
  Apb_env env;
  Apb_sequence seq;
  
  function new(string name = "Apb_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = Apb_env::type_id::create("env", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = Apb_sequence::type_id::create("seq");
    seq.start(env.agent.seq);
    phase.drop_objection(this);
  endtask
endclass

