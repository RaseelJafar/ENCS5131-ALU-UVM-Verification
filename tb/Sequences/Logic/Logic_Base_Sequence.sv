// Base for AND, OR, XOR. The child sets "op" in its constructor.
class Logic_Base_Sequence extends ALU_base_sequence;

  `uvm_object_utils(Logic_Base_Sequence)

  bit [3:0] op;

  function new(string name = "Logic_Base_Sequence");
    super.new(name);
  endfunction : new

  // A op A
  task same_operands();
    for (int i = 0; i < 6; i++) send(op, corner_values[i], corner_values[i]);
  endtask : same_operands

  // A with all zeros and with all ones (both sides)
  task with_zero_and_ones(bit [7:0] a);
    send(op, a, 8'h00);
    send(op, a, 8'hFF);
    send(op, 8'h00, a);
    send(op, 8'hFF, a);
  endtask : with_zero_and_ones

  // a single 1 moves through every bit position
  task walking_ones();
    for (int i = 0; i < 8; i++) begin
      send(op, 8'h01 << i, 8'hFF);
      send(op, 8'hFF, 8'h01 << i);
      send(op, 8'h01 << i, 8'h00);
    end
  endtask : walking_ones

endclass : Logic_Base_Sequence
