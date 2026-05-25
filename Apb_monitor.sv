class Apb_monitor extends uvm_monitor;
  `uvm_component_utils(Apb_monitor)

  Apb_sequence_item trans;
  uvm_analysis_port#(Apb_sequence_item) ap;

  virtual dut_if dif;

  function new(string name = "Apb_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);

    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dif", dif)) begin
      `uvm_fatal("MON_IF", "Failed to get virtual interface")
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(static_event::clock_sync);  

      if (dif.psel && dif.penable && dif.pready) begin
        trans = Apb_sequence_item::type_id::create("trans", this);

        trans.psel    = dif.psel;
        trans.penable = dif.penable; 
        trans.pwrite  = dif.pwrite;
        trans.paddr   = dif.paddr;
        trans.pwdata  = dif.pwdata;
        trans.prdata  = dif.prdata;
        trans.pready  = dif.pready;

    

        `uvm_info("MONITOR", $sformatf("\n monitor %0t : Observed - psel = %b, penable = %b, pwrite = %b, paddr = %0h, pwdata = %0h, prdata = %0h, pready = %b",
          $time, trans.psel, trans.penable, trans.pwrite, trans.paddr, trans.pwdata, trans.prdata, trans.pready),UVM_MEDIUM);
        repeat(3)@(static_event::clock_sync); 
            ap.write(trans);
      end
    end
  endtask
endclass

