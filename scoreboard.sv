class Apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(Apb_scoreboard)

  uvm_analysis_imp#(Apb_sequence_item, Apb_scoreboard) analysis_export;

 
  typedef bit [31:0] addr_t;
  typedef bit [31:0] data_t;
  typedef uvm_queue #(data_t) data_queue_t;


  data_t write_data_mem[addr_t];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  virtual function void write(Apb_sequence_item trans);
    if (trans.psel && trans.penable && trans.pready) begin
      if (trans.pwrite) begin
      
        write_data_mem[trans.paddr] = trans.pwdata;
      end else begin
       
        if (write_data_mem.exists(trans.paddr)) begin
          if (write_data_mem[trans.paddr] == trans.prdata) begin
            `uvm_info("APB_SCB", $sformatf("MATCH:  address %0h -> %0h", trans.paddr, trans.prdata), UVM_LOW)
          end else begin
            `uvm_warning("APB_SCB", $sformatf("MISMATCH:  address %0h -> expected: %0h, got: %0h",
                       trans.paddr, write_data_mem[trans.paddr], trans.prdata))
          end
        end else begin
          `uvm_info("APB_SCB", $sformatf("NO PREVIOUS WRITE: Read at address %0h with data %0h", trans.paddr, trans.prdata), UVM_LOW)
        end
      end
    end
  endfunction
endclass

