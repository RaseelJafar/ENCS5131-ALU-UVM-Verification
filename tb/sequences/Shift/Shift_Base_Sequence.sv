// Base for SHL, SHR. The child sets "op" in its constructor.
class Shift_Base_Sequence extends ALU_base_sequence;

  `uvm_object_utils(Shift_Base_Sequence)

  bit [3:0] op;

  function new(string name = "Shift_Base_Sequence");
    super.new(name);
  endfunction : new

  // shift "a" by 0,1,2,...,7
  task all_amounts(bit [7:0] a);
    for (int i = 0; i < 8; i++) send(op, a, i[7:0]);
  endtask : all_amounts

  // shift amounts bigger than 7: only B[2:0] should be used
  task masked_amounts(bit [7:0] a);
    bit [7:0] big [7];
    big = '{8'h08, 8'h09, 8'h0F, 8'h10, 8'h80, 8'hF8, 8'hFF};
    for (int i = 0; i < 7; i++) send(op, a, big[i]);
  endtask : masked_amounts

  // every boundary value of A, shifted by every amount (6 x 8 = 48 items)
  task all_corner_a();
    for (int i = 0; i < 6; i++) all_amounts(corner_values[i]);
  endtask : all_corner_a

endclass : Shift_Base_Sequence
