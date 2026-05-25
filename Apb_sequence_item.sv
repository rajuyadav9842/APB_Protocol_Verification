class Apb_sequence_item extends uvm_sequence_item;

  bit psel;
  bit penable;
  rand bit pwrite;
  rand bit [31:0] paddr;
  rand bit [31:0] pwdata;
  bit [31:0] prdata;
  bit pready;

  static bit prev_pwrite = 0;
  static bit [31:0] prev_paddr = 0;

  `uvm_object_utils_begin(Apb_sequence_item)
    `uvm_field_int(psel, UVM_ALL_ON)
    `uvm_field_int(penable, UVM_ALL_ON)
    `uvm_field_int(pwrite, UVM_ALL_ON)
    `uvm_field_int(paddr, UVM_ALL_ON)
    `uvm_field_int(pwdata, UVM_ALL_ON)
    `uvm_field_int(prdata, UVM_ALL_ON)
    `uvm_field_int(pready, UVM_ALL_ON)
  `uvm_object_utils_end

  
  constraint paddr_range { paddr inside {[0:255]}; }

  constraint alternate_pwrite { pwrite == ~prev_pwrite; }

  constraint read_write { if (!pwrite) paddr == prev_paddr; }

  constraint pwdata_valid {
    if (pwrite)
      pwdata inside {[32'h00000000 : 32'hFFFFFFFF]};
    else
      pwdata == '0;
  }

  function new(string name = "Apb_sequence_item");
    super.new(name);
  endfunction

  function void post_randomize();
    prev_pwrite = pwrite;
    prev_paddr = paddr;
  endfunction

  function string display_sequence_item();
    return $sformatf("display [Apb_sequence_item] %0t psel=%b, penable=%b, pwrite=%b, paddr=%0h, pwdata=%0h, prdata=%0h, pready=%b", 
                      $time, psel, penable, pwrite, paddr, pwdata, prdata, pready);
  endfunction

endclass

