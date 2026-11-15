class Reset_Mid_Op_Seq extends ALU_base_sequence;

  `uvm_object_utils(Reset_Mid_Op_Seq)

  function new(string name = "Reset_Mid_Op_Seq");
    super.new(name);
  endfunction : new

  // Reset: asserted in the middle of normal operation
  task body();
    send(OP_ADD, 8'h55, 8'h33);              // non-zero result
    send(OP_ADD, 8'h55, 8'h33, 1'b1);        // reset: result 0, carry 0
    send(OP_ADD, 8'h55, 8'h33);              // back to normal
    send(OP_ADD, 8'hFF, 8'hFF, 1'b1);        // reset while it would overflow
    send(OP_XOR, 8'hFF, 8'h0F);
  endtask : body

endclass : Reset_Mid_Op_Seq

class Reset_After_Carry_Seq extends ALU_base_sequence;

  `uvm_object_utils(Reset_After_Carry_Seq)

  function new(string name = "Reset_After_Carry_Seq");
    super.new(name);
  endfunction : new

  // Reset: must clear a carry that is 1
  task body();
    for (int k = 0; k < 5; k++) begin
      make_carry(k);                          // carry = 1
      send(OP_ADD, 8'h01, 8'h01, 1'b1);       // reset: carry must be 0
      send(OP_ADD, 8'h01, 8'h01);             // normal again
    end
  endtask : body

endclass : Reset_After_Carry_Seq

class Back_To_Back_Reset_Seq extends ALU_base_sequence;

  `uvm_object_utils(Back_To_Back_Reset_Seq)

  function new(string name = "Back_To_Back_Reset_Seq");
    super.new(name);
  endfunction : new

  // Reset: several reset items in a row
  task body();
    send(OP_ADD, 8'hFF, 8'hFF, 1'b1);
    send(OP_SUB, 8'h00, 8'h01, 1'b1);
    send(OP_DIV, 8'h05, 8'h00, 1'b1);
    send(OP_ADD, 8'h01, 8'h02);
  endtask : body

endclass : Back_To_Back_Reset_Seq

class Reset_Each_Op_Seq extends ALU_base_sequence;

  `uvm_object_utils(Reset_Each_Op_Seq)

  function new(string name = "Reset_Each_Op_Seq");
    super.new(name);
  endfunction : new

  // Reset: every op once with reset = 1 and once with reset = 0
  task body();
    for (int op = 0; op < 8; op++) begin
      send(op[3:0], 8'hF3, 8'h07, 1'b1);
      send(op[3:0], 8'hF3, 8'h07, 1'b0);
    end
  endtask : body

endclass : Reset_Each_Op_Seq

class Op_After_Reset_Seq extends ALU_base_sequence;

  `uvm_object_utils(Op_After_Reset_Seq)

  function new(string name = "Op_After_Reset_Seq");
    super.new(name);
  endfunction : new

  // Reset: the first op after a reset, for every op
  task body();
    for (int op = 0; op < 8; op++) begin
      send(op[3:0], 8'hFF, 8'h01);            // normal op
      send(op[3:0], 8'hFF, 8'h01, 1'b1);      // reset
      send(op[3:0], 8'h0F, 8'h01);            // first op after the reset
    end
  endtask : body

endclass : Op_After_Reset_Seq

