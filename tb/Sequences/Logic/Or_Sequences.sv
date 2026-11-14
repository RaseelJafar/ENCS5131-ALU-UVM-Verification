class Or_Directed_Seq extends Logic_Base_Sequence;

  `uvm_object_utils(Or_Directed_Seq)

  function new(string name = "Or_Directed_Seq");
    super.new(name);
    op = OP_OR;
  endfunction : new

  // Directed: bitwise OR
  task body();
    send(op, 8'hF0, 8'h0F);
    send(op, 8'h00, 8'h00);
    send(op, 8'hA0, 8'h05);
    send(op, 8'h80, 8'h01);
  endtask : body

endclass : Or_Directed_Seq

class Or_Corner_Seq extends Logic_Base_Sequence;

  `uvm_object_utils(Or_Corner_Seq)

  function new(string name = "Or_Corner_Seq");
    super.new(name);
    op = OP_OR;
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

endclass : Or_Corner_Seq

