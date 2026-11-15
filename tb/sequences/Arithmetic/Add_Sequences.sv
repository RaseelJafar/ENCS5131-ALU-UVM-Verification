class Add_Directed_Seq extends Arithmetic_Base_Sequence;

  `uvm_object_utils(Add_Directed_Seq)

  function new(string name = "Add_Directed_Seq");
    super.new(name);
    op = OP_ADD;
  endfunction : new

  // Directed: normal additions, no overflow
  task body();
    send(op, 8'h0F, 8'h01);
    send(op, 8'h12, 8'h34);
    send(op, 8'h55, 8'h2A);
    send(op, 8'h7F, 8'h01);
  endtask : body

endclass : Add_Directed_Seq

class Add_Corner_Seq extends Arithmetic_Base_Sequence;

  `uvm_object_utils(Add_Corner_Seq)

  function new(string name = "Add_Corner_Seq");
    super.new(name);
    op = OP_ADD;
  endfunction : new

  // Corner: boundary values and overflow
  task body();
    all_corner_pairs(op);        // boundary values with boundary values
    same_operands();             // A + A
    a_is_zero();                 // 0 + B
    b_is_zero();                 // A + 0
    send(op, 8'h7F, 8'h01);      // 0x80, no carry
    send(op, 8'hFE, 8'h01);      // 0xFF, no carry (just below overflow)
    send(op, 8'hFE, 8'h02);      // overflow, carry = 1
    send(op, 8'hFF, 8'h01);      // overflow, carry = 1
    send(op, 8'h80, 8'h80);      // overflow, carry = 1
    send(op, 8'hFF, 8'hFF);      // biggest sum
  endtask : body

endclass : Add_Corner_Seq

