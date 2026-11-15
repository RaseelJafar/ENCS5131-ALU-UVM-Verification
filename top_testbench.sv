`include "uvm_macros.svh"
import uvm_pkg::*;

`ifdef FIXED_DUT
  `include "rtl/ALU_fixed.sv"
`else
  `include "rtl/ALU.sv"
`endif

`include "tb/env/ALU_interface.sv"
`include "tb/env/ALU_sequence_item.sv"
`include "tb/sequences/RESET_Sequence.sv"
`include "tb/sequences/Random_Sequence.sv"

`include "tb/env/ALU_sequencer.sv"
`include "tb/env/ALU_driver.sv"
`include "tb/env/ALU_monitor.sv"
`include "tb/env/ALU_agent.sv"
`include "tb/env/ALU_scoreboard.sv"
`include "tb/env/ALU_env.sv"
`include "tb/tests/ALU_base_test.sv"
`include "tb/tests/ALU_operation_test.sv"

`include "tb/sequences/ALU_base_sequence.sv"

`include "tb/sequences/Arithmetic/Arithmetic_Base_Sequence.sv"
`include "tb/sequences/Arithmetic/Add_Sequences.sv"
`include "tb/sequences/Arithmetic/Sub_Sequences.sv"
`include "tb/sequences/Arithmetic/Div_Sequences.sv"

`include "tb/sequences/Logic/Logic_Base_Sequence.sv"
`include "tb/sequences/Logic/And_Sequences.sv"
`include "tb/sequences/Logic/Or_Sequences.sv"
`include "tb/sequences/Logic/Xor_Sequences.sv"

`include "tb/sequences/Shift/Shift_Base_Sequence.sv"
`include "tb/sequences/Shift/Shl_Sequences.sv"
`include "tb/sequences/Shift/Shr_Sequences.sv"

`include "tb/sequences/Flow/Flow_Sequences.sv"
`include "tb/sequences/Reset/Reset_Sequences.sv"
`include "tb/sequences/Undefined/Undefined_Sequences.sv"
`include "tb/sequences/Random/Random_Sequences.sv"

`include "tb/tests/ALU_directed_test.sv"
`include "tb/tests/ALU_corner_test.sv"
`include "tb/tests/ALU_flow_test.sv"
`include "tb/tests/ALU_random_test.sv"
`include "tb/tests/ALU_pseudo_random_test.sv"


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
