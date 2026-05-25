class Apb_sequence extends uvm_sequence#(Apb_sequence_item);

  `uvm_object_utils(Apb_sequence)

  Apb_sequence_item trans;

  function new(string name = "Apb_sequence");  
    super.new(name);
  endfunction

  virtual task body();
    trans = Apb_sequence_item::type_id::create("trans");

    repeat(100) begin 
      start_item(trans);

      if (!trans.randomize()) begin
        `uvm_warning("RANDOMIZE_FAIL", "Failed to randomize Apb_sequence_item");
      end

      `uvm_info("SEQ", $sformatf("\nSequence Randomized values at time %0t :\n  psel=%b, penable=%b, pwrite=%b,\n  paddr=%0h, pwdata=%0h, prdata=%0h, pready=%b",
                    $time, trans.psel, trans.penable, trans.pwrite,
                    trans.paddr, trans.pwdata, trans.prdata, trans.pready),
                    UVM_MEDIUM);

      finish_item(trans);

      repeat(4) @(static_event::clock_sync);
    end
  endtask

endclass

