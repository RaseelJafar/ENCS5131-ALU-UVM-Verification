class Div_Directed_Seq extends Arithmetic_Base_Sequence;

  `uvm_object_utils(Div_Directed_Seq)

  function new(string name = "Div_Directed_Seq");
    super.new(name);
    op = OP_DIV;
  endfunction : new

  // Directed: normal divisions (B != 0)
  task body();
    send(op, 8'h64, 8'h0A);
    send(op, 8'hFF, 8'h01);
    send(op, 8'hFF, 8'hFF);
    send(op, 8'h10, 8'h03);
    send(op, 8'h80, 8'h02);
  endtask : body

endclass : Div_Directed_Seq

class Div_Corner_Seq extends Arithmetic_Base_Sequence;

  `uvm_object_utils(Div_Corner_Seq)

  function new(string name = "Div_Corner_Seq");
    super.new(name);
    op = OP_DIV;
  endfunction : new

  // Corner: divide by zero, A < B, A = B, 0 / B
  task body();
    all_corner_pairs(op);              // includes B = 0
    b_is_zero();                       // divide by zero: result 0, carry 1
    a_is_zero();                       // 0 / B = 0
    same_operands();                   // A / A = 1 (and 0 / 0 = divide by zero)
    swapped_operands(8'h01, 8'hFF);    // 1/255 = 0 and 255/1 = 255
    swapped_operands(8'h7F, 8'h80);
    send(op, 8'h00, 8'h00);            // 0 / 0
    send(op, 8'hFF, 8'h02);            // 0x7F
  endtask : body

endclass : Div_Corner_Seq

