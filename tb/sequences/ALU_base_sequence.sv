// The opcodes, so the sequences can use names instead of numbers
typedef enum bit [3:0] {
  OP_ADD = 4'b0000,
  OP_SUB = 4'b0001,
  OP_AND = 4'b0010,
  OP_OR  = 4'b0011,
  OP_XOR = 4'b0100,
  OP_DIV = 4'b0101,
  OP_SHL = 4'b0110,
  OP_SHR = 4'b0111
} alu_op_e;

// General base sequence: every other sequence of exp6 extends this one
class ALU_base_sequence extends uvm_sequence #(ALU_sequence_item);

  `uvm_object_utils(ALU_base_sequence)

  // boundary values, used by many sequences
  bit [7:0] corner_values [6];

  function new(string name = "ALU_base_sequence");
    super.new(name);
    corner_values = '{8'h00, 8'h01, 8'h7F, 8'h80, 8'hFE, 8'hFF};
  endfunction : new

  // send ONE operation to the DUT
  task send(bit [3:0] op, bit [7:0] a, bit [7:0] b, bit rst = 1'b0);
    ALU_sequence_item item;
    item = ALU_sequence_item::type_id::create("item");
    start_item(item);
    if (!item.randomize() with { reset == rst; selection == op; A == a; B == b; })
      `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);
  endtask : send

  // try the operation with every pair of boundary values (6 x 6 = 36 items)
  task all_corner_pairs(bit [3:0] op);
    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 6; j++)
        send(op, corner_values[i], corner_values[j]);
  endtask : all_corner_pairs

  // make carry_out = 1 using different operations (k = 0..4)
  task make_carry(int k);
    case (k)
      0: send(OP_ADD, 8'hFF, 8'h01);   // overflow
      1: send(OP_SUB, 8'h00, 8'h01);   // borrow
      2: send(OP_DIV, 8'h05, 8'h00);   // divide by zero
      3: send(OP_SHL, 8'h80, 8'h01);   // MSB shifted out
      4: send(OP_SHR, 8'h01, 8'h01);   // LSB shifted out
    endcase
  endtask : make_carry

  virtual task pre_body();
    `uvm_info(get_type_name(), "===== sequence started =====", UVM_LOW)
  endtask

endclass : ALU_base_sequence
