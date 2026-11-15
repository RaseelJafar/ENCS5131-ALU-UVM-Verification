class Sub_Directed_Seq extends Arithmetic_Base_Sequence;

  `uvm_object_utils(Sub_Directed_Seq)

  function new(string name = "Sub_Directed_Seq");
    super.new(name);
    op = OP_SUB;
  endfunction : new

  // Directed: normal subtractions, no borrow
  task body();
    send(op, 8'h10, 8'h05);
    send(op, 8'hFF, 8'h0F);
    send(op, 8'h33, 8'h33);
    send(op, 8'h80, 8'h01);
  endtask : body

endclass : Sub_Directed_Seq

class Sub_Corner_Seq extends Arithmetic_Base_Sequence;

  `uvm_object_utils(Sub_Corner_Seq)

  function new(string name = "Sub_Corner_Seq");
    super.new(name);
    op = OP_SUB;
  endfunction : new

  // Corner: boundary values and borrow
  task body();
    all_corner_pairs(op);
    same_operands();                   // A - A = 0, no borrow
    a_is_zero();                       // 0 - B
    b_is_zero();                       // A - 0
    swapped_operands(8'h05, 8'h10);    // 5-16 (borrow) and 16-5
    swapped_operands(8'h00, 8'hFF);
    send(op, 8'h00, 8'h01);            // borrow, carry = 1
    send(op, 8'h80, 8'h80);            // 0, no borrow
    send(op, 8'h80, 8'h81);            // borrow, carry = 1
  endtask : body

endclass : Sub_Corner_Seq

