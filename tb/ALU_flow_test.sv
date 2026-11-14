// FLOW test: operations in a bad ORDER (carry leftovers, reset, undefined opcodes)
class Flow_Test extends BaseTest;

  `uvm_component_utils(Flow_Test)

  function new(string name = "Flow_Test", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_sequence_base seq;
    phase.raise_objection(this);

    seq = RESET_Sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Carry_Then_Valid_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Op_Pair_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Same_Op_Repeat_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = DivZero_Then_Div_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Shift_Chain_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Reset_Mid_Op_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Reset_After_Carry_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Back_To_Back_Reset_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Reset_Each_Op_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Op_After_Reset_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Undefined_Opcode_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Nand_Opcode_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Carry_Then_Undefined_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Valid_After_Undefined_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);

    #50;                                   // let the last item reach the scoreboard
    phase.drop_objection(this);
  endtask : run_phase

endclass : Flow_Test
