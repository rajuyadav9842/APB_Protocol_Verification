`include "Apb_agent.sv"
`include "Apb_scoreboard.sv"

class Apb_env extends uvm_env;
  `uvm_component_utils(Apb_env)

  Apb_agent agent;
  Apb_scoreboard soc;

  function new(string name = "Apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = Apb_agent::type_id::create("agent", this);
    soc   = Apb_scoreboard::type_id::create("soc", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.ap.connect(soc.analysis_export);
  endfunction
endclass

