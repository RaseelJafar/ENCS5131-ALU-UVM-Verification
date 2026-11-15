class Xor_Directed_Seq extends Logic_Base_Sequence;

  `uvm_object_utils(Xor_Directed_Seq)

  function new(string name = "Xor_Directed_Seq");
    super.new(name);
    op = OP_XOR;
  endfunction : new

  // Directed: bitwise XOR
  task body();
    send(op, 8'hAA, 8'h55);
    send(op, 8'hFF, 8'hFF);
    send(op, 8'hF0, 8'h0F);
    send(op, 8'h12, 8'h12);
  endtask : body

endclass : Xor_Directed_Seq

class Xor_Corner_Seq extends Logic_Base_Sequence;

  `uvm_object_utils(Xor_Corner_Seq)

  function new(string name = "Xor_Corner_Seq");
    super.new(name);
    op = OP_XOR;
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

endclass : Xor_Corner_Seq

