class Carry_Then_Valid_Seq extends ALU_base_sequence;

  `uvm_object_utils(Carry_Then_Valid_Seq)

  function new(string name = "Carry_Then_Valid_Seq");
    super.new(name);
  endfunction : new

  // Flow: carry = 1 from one op, then every op (all give carry 0 with A=0x10, B=2)
  task body();
    for (int k = 0; k < 5; k++)          // 5 ways to make carry = 1
      for (int next = 0; next < 8; next++) begin
        make_carry(k);
        send(next[3:0], 8'h10, 8'h02);     // carry must go back to 0
      end
  endtask : body

endclass : Carry_Then_Valid_Seq

class Op_Pair_Seq extends ALU_base_sequence;

  `uvm_object_utils(Op_Pair_Seq)

  function new(string name = "Op_Pair_Seq");
    super.new(name);
  endfunction : new

  // Flow: every opcode followed by every opcode, with the SAME A and B
  task body();
    bit [7:0] a, b;
    for (int d = 0; d < 2; d++) begin
      if (d == 0) begin a = 8'hA5; b = 8'h03; end
      else        begin a = 8'hFF; b = 8'h00; end
      for (int first = 0; first < 8; first++)
        for (int second = 0; second < 8; second++) begin
          send(first[3:0],  a, b);
          send(second[3:0], a, b);
        end
    end
  endtask : body

endclass : Op_Pair_Seq

class Same_Op_Repeat_Seq extends ALU_base_sequence;

  `uvm_object_utils(Same_Op_Repeat_Seq)

  function new(string name = "Same_Op_Repeat_Seq");
    super.new(name);
  endfunction : new

  // Flow: the same op several times in a row (different data, then the same data)
  task body();
    for (int op = 0; op < 8; op++) begin
      send(op[3:0], 8'h11, 8'h22);
      send(op[3:0], 8'h33, 8'h44);
      send(op[3:0], 8'h55, 8'h06);
      send(op[3:0], 8'hFF, 8'hFF);
      send(op[3:0], 8'hFF, 8'hFF);
      send(op[3:0], 8'h00, 8'h00);
      send(op[3:0], 8'h00, 8'h00);
    end
  endtask : body

endclass : Same_Op_Repeat_Seq

class DivZero_Then_Div_Seq extends ALU_base_sequence;

  `uvm_object_utils(DivZero_Then_Div_Seq)

  function new(string name = "DivZero_Then_Div_Seq");
    super.new(name);
  endfunction : new

  // Flow: divide by zero followed by normal divisions (carry must clear again)
  task body();
    send(OP_DIV, 8'h05, 8'h00);
    send(OP_DIV, 8'h0A, 8'h02);
    send(OP_DIV, 8'h05, 8'h00);
    send(OP_DIV, 8'h00, 8'h00);
    send(OP_DIV, 8'h07, 8'h00);
    send(OP_DIV, 8'hFF, 8'h01);
    send(OP_DIV, 8'h07, 8'h00);
    send(OP_DIV, 8'h00, 8'h01);
  endtask : body

endclass : DivZero_Then_Div_Seq

class Shift_Chain_Seq extends ALU_base_sequence;

  `uvm_object_utils(Shift_Chain_Seq)

  function new(string name = "Shift_Chain_Seq");
    super.new(name);
  endfunction : new

  // Flow: SHL then SHR then SHL ... with every shift amount
  task body();
    for (int i = 0; i < 8; i++) begin
      send(OP_SHL, 8'h81, i[7:0]);
      send(OP_SHR, 8'h81, i[7:0]);
      send(OP_SHL, 8'hFF, i[7:0]);
      send(OP_SHR, 8'hFF, i[7:0]);
    end
  endtask : body

endclass : Shift_Chain_Seq

