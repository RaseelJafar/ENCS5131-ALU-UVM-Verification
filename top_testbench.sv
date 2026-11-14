`include "uvm_macros.svh"
import uvm_pkg::*;

`include "rtl/ALU.sv"
`include "tb/ALU_interface.sv"
`include "tb/ALU_sequence_item.sv"
`include "tb/Sequences/RESET_Sequence.sv"
`include "tb/Sequences/Random_Sequence.sv"

`include "tb/ALU_sequencer.sv"
`include "tb/ALU_driver.sv"
`include "tb/ALU_monitor.sv"
`include "tb/ALU_agent.sv"
`include "tb/ALU_scoreboard.sv"
`include "tb/ALU_env.sv"
`include "tb/ALU_base_test.sv"
`include "tb/ALU_operation_test.sv"

`include "tb/Sequences/ALU_base_sequence.sv"

`include "tb/Sequences/Arithmetic/Arithmetic_Base_Sequence.sv"
`include "tb/Sequences/Arithmetic/Add_Sequences.sv"
`include "tb/Sequences/Arithmetic/Sub_Sequences.sv"
`include "tb/Sequences/Arithmetic/Div_Sequences.sv"

`include "tb/Sequences/Logic/Logic_Base_Sequence.sv"
`include "tb/Sequences/Logic/And_Sequences.sv"
`include "tb/Sequences/Logic/Or_Sequences.sv"
`include "tb/Sequences/Logic/Xor_Sequences.sv"

`include "tb/Sequences/Shift/Shift_Base_Sequence.sv"
`include "tb/Sequences/Shift/Shl_Sequences.sv"
`include "tb/Sequences/Shift/Shr_Sequences.sv"

`include "tb/Sequences/Flow/Flow_Sequences.sv"
`include "tb/Sequences/Reset/Reset_Sequences.sv"
`include "tb/Sequences/Undefined/Undefined_Sequences.sv"
`include "tb/Sequences/Random/Random_Sequences.sv"

module top;

  //Instantiation
  logic clock;

  ALU_interface intf (.clock(clock));

  ALU dut (
    .reset     (intf.reset),
    .clk       (intf.clock),
    .A         (intf.A),
    .B         (intf.B),
    .selection (intf.selection),
    .result    (intf.result),
    .carry_out (intf.carry_out)
  );

  //Interface Setting
  initial begin
    uvm_config_db#(virtual ALU_interface)::set(null, "*", "vif", intf);
  end

  //Start The Test
  initial begin
    run_test("ALU_test");
  end

  //Clock Generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  //Maximum Simulation Time
  initial begin
    #40000;
    $display("Sorry! Ran out of clock cycles!");
    $finish();
  end

  //Generate Waveforms (VCD; use $fsdbDumpfile/$fsdbDumpvars instead if you view in Verdi)
  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0, top);
  end

endmodule : top
