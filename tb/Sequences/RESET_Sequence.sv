class RESET_Sequence extends uvm_sequence #(ALU_sequence_item);

  //1. an Object
  `uvm_object_utils(RESET_Sequence)

  //2. Constructor
  function new(string name = "RESET_Sequence");
    super.new(name);
  endfunction : new

  //3. Task body: one item with reset = 1, then one with reset = 0
  task body();
    ALU_sequence_item transaction;

    transaction = ALU_sequence_item::type_id::create("transaction");
    start_item(transaction);
    if (!transaction.randomize() with { reset == 1; })
      `uvm_error(get_type_name(), "Randomization failed")
    `uvm_info(get_type_name(), $sformatf("Sequence reset:\n %s", transaction.sprint()), UVM_HIGH)
    finish_item(transaction);

    transaction = ALU_sequence_item::type_id::create("transaction");
    start_item(transaction);
    if (!transaction.randomize() with { reset == 0; selection inside {[0:7]}; })
      `uvm_error(get_type_name(), "Randomization failed")
    `uvm_info(get_type_name(), $sformatf("Sequence reset:\n %s", transaction.sprint()), UVM_HIGH)
    finish_item(transaction);
  endtask : body

endclass : RESET_Sequence
