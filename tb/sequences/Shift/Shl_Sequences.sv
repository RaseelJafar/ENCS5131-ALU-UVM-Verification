class Shl_Directed_Seq extends Shift_Base_Sequence;

  `uvm_object_utils(Shl_Directed_Seq)

  function new(string name = "Shl_Directed_Seq");
    super.new(name);
    op = OP_SHL;
  endfunction : new

  // Directed: shift 0xA5 left by 1..7
  task body();
    for (int i = 1; i < 8; i++) send(op, 8'hA5, i[7:0]);
  endtask : body

endclass : Shl_Directed_Seq

class Shl_Corner_Seq extends Shift_Base_Sequence;

  `uvm_object_utils(Shl_Corner_Seq)

  function new(string name = "Shl_Corner_Seq");
    super.new(name);
    op = OP_SHL;
  endfunction : new

  // Corner: every boundary value by every amount, shift 0, big amounts
  task body();
    all_corner_a();                    // 6 values x 8 amounts
    masked_amounts(8'h81);             // only B[2:0] must be used
    masked_amounts(8'hFF);
    send(op, 8'h01, 8'h07);            // 0x80, carry 0
    send(op, 8'h80, 8'h01);            // 0x00, carry 1 (MSB shifted out)
    send(op, 8'hFF, 8'h00);            // shift by 0: carry must be 0
  endtask : body

endclass : Shl_Corner_Seq

