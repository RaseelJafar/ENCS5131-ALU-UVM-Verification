// Base for ADD, SUB, DIV. The child sets "op" in its constructor.
class Arithmetic_Base_Sequence extends ALU_base_sequence;

  `uvm_object_utils(Arithmetic_Base_Sequence)

  bit [3:0] op;

  function new(string name = "Arithmetic_Base_Sequence");
    super.new(name);
  endfunction : new

  // A op A
  task same_operands();
    for (int i = 0; i < 6; i++) send(op, corner_values[i], corner_values[i]);
  endtask : same_operands

  // 0 op B
  task a_is_zero();
    for (int i = 0; i < 6; i++) send(op, 8'h00, corner_values[i]);
  endtask : a_is_zero

  // A op 0
  task b_is_zero();
    for (int i = 0; i < 6; i++) send(op, corner_values[i], 8'h00);
  endtask : b_is_zero

  // A op B and then B op A (the order matters for SUB and DIV)
  task swapped_operands(bit [7:0] a, bit [7:0] b);
    send(op, a, b);
    send(op, b, a);
  endtask : swapped_operands

endclass : Arithmetic_Base_Sequence
