class Pure_Random_Seq extends ALU_base_sequence;

  `uvm_object_utils(Pure_Random_Seq)

  function new(string name = "Pure_Random_Seq");
    super.new(name);
  endfunction : new

  // RANDOM: no constraints at all (any opcode, any data, any reset)
  task body();
    ALU_sequence_item item;
    repeat (100) begin
      item = ALU_sequence_item::type_id::create("item");
      start_item(item);
      if (!item.randomize())
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(item);
    end
  endtask : body

endclass : Pure_Random_Seq

class Random_Arith_Seq extends ALU_base_sequence;

  `uvm_object_utils(Random_Arith_Seq)

  function new(string name = "Random_Arith_Seq");
    super.new(name);
  endfunction : new

  // Pseudorandom: ADD / SUB / DIV only, B = 0 sometimes
  task body();
    ALU_sequence_item item;
    repeat (50) begin
      item = ALU_sequence_item::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { reset == 0; selection inside {0, 1, 5}; B dist { 8'h00 := 1, [8'h01:8'hFF] :/ 9 }; })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(item);
    end
  endtask : body

endclass : Random_Arith_Seq

class Random_Logic_Seq extends ALU_base_sequence;

  `uvm_object_utils(Random_Logic_Seq)

  function new(string name = "Random_Logic_Seq");
    super.new(name);
  endfunction : new

  // Pseudorandom: AND / OR / XOR only
  task body();
    ALU_sequence_item item;
    repeat (50) begin
      item = ALU_sequence_item::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { reset == 0; selection inside {[2:4]}; })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(item);
    end
  endtask : body

endclass : Random_Logic_Seq

class Random_Shift_Seq extends ALU_base_sequence;

  `uvm_object_utils(Random_Shift_Seq)

  function new(string name = "Random_Shift_Seq");
    super.new(name);
  endfunction : new

  // Pseudorandom: SHL / SHR only
  task body();
    ALU_sequence_item item;
    repeat (50) begin
      item = ALU_sequence_item::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { reset == 0; selection inside {[6:7]}; })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(item);
    end
  endtask : body

endclass : Random_Shift_Seq

class Random_Reset_Seq extends ALU_base_sequence;

  `uvm_object_utils(Random_Reset_Seq)

  function new(string name = "Random_Reset_Seq");
    super.new(name);
  endfunction : new

  // Pseudorandom: valid opcodes, reset 50 % of the time
  task body();
    ALU_sequence_item item;
    repeat (50) begin
      item = ALU_sequence_item::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { selection inside {[0:7]}; reset dist { 1'b0 := 1, 1'b1 := 1 }; })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(item);
    end
  endtask : body

endclass : Random_Reset_Seq

class Random_Undefined_Seq extends ALU_base_sequence;

  `uvm_object_utils(Random_Undefined_Seq)

  function new(string name = "Random_Undefined_Seq");
    super.new(name);
  endfunction : new

  // Pseudorandom: only undefined opcodes 8..15
  task body();
    ALU_sequence_item item;
    repeat (50) begin
      item = ALU_sequence_item::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { reset == 0; selection inside {[8:15]}; })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(item);
    end
  endtask : body

endclass : Random_Undefined_Seq

class Random_Corner_Seq extends ALU_base_sequence;

  `uvm_object_utils(Random_Corner_Seq)

  function new(string name = "Random_Corner_Seq");
    super.new(name);
  endfunction : new

  // Pseudorandom: valid opcodes, but A and B only boundary values
  task body();
    ALU_sequence_item item;
    repeat (100) begin
      item = ALU_sequence_item::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { reset == 0; selection inside {[0:7]}; A inside {8'h00, 8'h01, 8'h7F, 8'h80, 8'hFE, 8'hFF}; B inside {8'h00, 8'h01, 8'h7F, 8'h80, 8'hFE, 8'hFF}; })
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(item);
    end
  endtask : body

endclass : Random_Corner_Seq

