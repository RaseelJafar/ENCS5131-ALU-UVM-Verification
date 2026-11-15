class ALU_scoreboard extends uvm_scoreboard;

  //1. Component
  `uvm_component_utils(ALU_scoreboard)

  //2. Port (analysis imp: implements write())
  uvm_analysis_imp #(ALU_sequence_item, ALU_scoreboard) scoreboard_port;

  //3. Transactions queue + counters
  ALU_sequence_item transactions[$];
  int pass_count = 0;
  int fail_count = 0;

  //4. Constructor
  function new(string name = "ALU_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //5. Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scoreboard_port = new("scoreboard_port", this);
  endfunction : build_phase

  //6. Write: called by the monitor
  function void write(ALU_sequence_item item);
    transactions.push_back(item);
  endfunction : write

  //7. Run Phase
  task run_phase(uvm_phase phase);
    ALU_sequence_item trans;
    forever begin
      wait (transactions.size() != 0);
      trans = transactions.pop_front();
      compare(trans);
    end
  endtask : run_phase

  //8. Compare: reference model (from the spec) + check
  function void compare(ALU_sequence_item trans);
    logic [7:0] predicted_result;
    logic       predicted_carry;
    bit   [8:0] tmp;
    bit   [2:0] sh;

    sh               = trans.B[2:0];
    predicted_result = 8'h00;
    predicted_carry  = 1'b0;

    if (!trans.reset) begin
      case (trans.selection)
        4'b0000: begin                                   // ADD
          tmp = {1'b0, trans.A} + {1'b0, trans.B};
          {predicted_carry, predicted_result} = tmp;
        end
        4'b0001: begin                                   // SUB
          tmp = {1'b0, trans.A} - {1'b0, trans.B};
          {predicted_carry, predicted_result} = tmp;
        end
        4'b0010: predicted_result = trans.A & trans.B;   // AND
        4'b0011: predicted_result = trans.A | trans.B;   // OR
        4'b0100: predicted_result = trans.A ^ trans.B;   // XOR
        4'b0101: begin                                   // DIV
          if (trans.B != 0) predicted_result = trans.A / trans.B;
          else              predicted_carry  = 1'b1;     // divide by zero
        end
        4'b0110: begin                                   // SHIFT LEFT
          predicted_result = trans.A << sh;
          predicted_carry  = (sh == 0) ? 1'b0 : trans.A[8 - sh];
        end
        4'b0111: begin                                   // SHIFT RIGHT
          predicted_result = trans.A >> sh;
          predicted_carry  = (sh == 0) ? 1'b0 : trans.A[sh - 1];
        end
        default: begin                                   // undefined opcode
          predicted_result = 8'h00;
          predicted_carry  = 1'b0;
        end
      endcase
    end

    // !== so that X on the DUT outputs counts as a mismatch
    if (trans.result !== predicted_result || trans.carry_out !== predicted_carry) begin
      fail_count++;
      `uvm_error(get_type_name(),
        $sformatf("MISMATCH rst=%0b sel=%04b A=%h B=%h | DUT: result=%h carry=%b | EXPECTED: result=%h carry=%b",
                  trans.reset, trans.selection, trans.A, trans.B,
                  trans.result, trans.carry_out, predicted_result, predicted_carry))
    end else begin
      pass_count++;
      `uvm_info(get_type_name(),
        $sformatf("MATCH    rst=%0b sel=%04b A=%h B=%h | result=%h carry=%b",
                  trans.reset, trans.selection, trans.A, trans.B,
                  trans.result, trans.carry_out), UVM_MEDIUM)
    end
  endfunction : compare

  //9. Report Phase
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),
      $sformatf("Checked %0d transactions: %0d matches, %0d mismatches",
                pass_count + fail_count, pass_count, fail_count), UVM_NONE)
  endfunction : report_phase

endclass : ALU_scoreboard
