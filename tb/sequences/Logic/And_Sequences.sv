class And_Directed_Seq extends Logic_Base_Sequence;

  `uvm_object_utils(And_Directed_Seq)

  function new(string name = "And_Directed_Seq");
    super.new(name);
    op = OP_AND;
  endfunction : new

  // Directed: bitwise AND
  task body();
    send(op, 8'hF0, 8'h3C);
    send(op, 8'hFF, 8'h00);
    send(op, 8'hAA, 8'h55);
    send(op, 8'hFF, 8'hFF);
  endtask : body

endclass : And_Directed_Seq

class And_Corner_Seq extends Logic_Base_Sequence;

  `uvm_object_utils(And_Corner_Seq)

  function new(string name = "And_Corner_Seq");
    super.new(name);
    op = OP_AND;
  endfunction : new

  // Corner: boundary values, all zeros / all ones, walking ones
  task body();
    all_corner_pairs(op);
    same_operands();
    with_zero_and_ones(8'h55);
    with_zero_and_ones(8'hAA);
    walking_ones();
    send(op, 8'hAA, 8'h55);            // opposite bits
  endtask : body

endclass : And_Corner_Seq

