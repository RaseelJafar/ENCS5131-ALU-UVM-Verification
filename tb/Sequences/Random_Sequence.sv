class Random_Sequence extends uvm_sequence #(ALU_sequence_item);

  //1. an Object
  `uvm_object_utils(Random_Sequence)

  //2. Constructor
  function new(string name = "Random_Sequence");
    super.new(name);
  endfunction : new

  //3. Task body: 100 random operations (opcodes 0..7, no reset).
  //   B = 0 is made more likely so divide-by-zero gets tested.
  task body();
    ALU_sequence_item transaction;

    repeat (100) begin
      transaction = ALU_sequence_item::type_id::create("transaction");
      start_item(transaction);
      if (!transaction.randomize() with {
            reset == 0;
            selection inside {[0:7]};
            B dist { 8'h00 := 1, [8'h01:8'hFF] :/ 9 };
          })
        `uvm_error(get_type_name(), "Randomization failed")
      `uvm_info(get_type_name(), $sformatf("Random_Sequence:\n %s", transaction.sprint()), UVM_HIGH)
      finish_item(transaction);
    end
  endtask : body

endclass : Random_Sequence
