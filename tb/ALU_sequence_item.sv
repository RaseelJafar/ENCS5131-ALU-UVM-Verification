class ALU_sequence_item extends uvm_sequence_item;

  //1. Constructor
  function new(string name = "ALU_sequence_item");
    super.new(name);
  endfunction : new

  //2. Inputs (randomized)
  rand bit         reset;
  rand bit [7:0]   A;
  rand bit [7:0]   B;
  rand bit [3:0]   selection;

  //   Outputs (filled in by the monitor)
  logic [7:0]      result;
  logic            carry_out;

  //3. UVM Registration Macros
  `uvm_object_utils_begin(ALU_sequence_item)
    `uvm_field_int(reset,     UVM_ALL_ON)
    `uvm_field_int(A,         UVM_ALL_ON)
    `uvm_field_int(B,         UVM_ALL_ON)
    `uvm_field_int(selection, UVM_ALL_ON)
    `uvm_field_int(result,    UVM_ALL_ON)
    `uvm_field_int(carry_out, UVM_ALL_ON)
  `uvm_object_utils_end

endclass : ALU_sequence_item
