class Undefined_Opcode_Seq extends ALU_base_sequence;

  `uvm_object_utils(Undefined_Opcode_Seq)

  function new(string name = "Undefined_Opcode_Seq");
    super.new(name);
  endfunction : new

  // Undefined: opcodes 8..15 (expected result 0, carry 0)
  task body();
    for (int op = 8; op < 16; op++) begin
      send(op[3:0], 8'hA5, 8'h3C);
      send(op[3:0], 8'hFF, 8'h00);
    end
  endtask : body

endclass : Undefined_Opcode_Seq

class Nand_Opcode_Seq extends ALU_base_sequence;

  `uvm_object_utils(Nand_Opcode_Seq)

  function new(string name = "Nand_Opcode_Seq");
    super.new(name);
  endfunction : new

  // Undefined: opcode 4'b1000 is not in the spec (result must be 0)
  task body();
    send(4'b1000, 8'hFF, 8'hFF);
    send(4'b1000, 8'hF0, 8'h0F);
    send(4'b1000, 8'hAA, 8'h55);
    send(4'b1000, 8'h00, 8'h00);
    send(4'b1000, 8'hFF, 8'h00);
  endtask : body

endclass : Nand_Opcode_Seq

class Carry_Then_Undefined_Seq extends ALU_base_sequence;

  `uvm_object_utils(Carry_Then_Undefined_Seq)

  function new(string name = "Carry_Then_Undefined_Seq");
    super.new(name);
  endfunction : new

  // Undefined: carry = 1, then an undefined opcode (carry must clear)
  task body();
    for (int k = 0; k < 5; k++)
      for (int u = 8; u < 16; u++) begin
        make_carry(k);                        // carry = 1
        send(u[3:0], 8'h12, 8'h34);           // carry must be 0
      end
  endtask : body

endclass : Carry_Then_Undefined_Seq

class Valid_After_Undefined_Seq extends ALU_base_sequence;

  `uvm_object_utils(Valid_After_Undefined_Seq)

  function new(string name = "Valid_After_Undefined_Seq");
    super.new(name);
  endfunction : new

  // Undefined: a valid op right after an undefined opcode
  task body();
    for (int op = 0; op < 8; op++) begin
      send(4'b1001, 8'hAA, 8'h55);
      send(op[3:0], 8'h10, 8'h02);
    end
  endtask : body

endclass : Valid_After_Undefined_Seq

