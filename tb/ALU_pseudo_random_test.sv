// PSEUDORANDOM test: random, but constrained
class Pseudo_Random_Test extends BaseTest;

  `uvm_component_utils(Pseudo_Random_Test)

  function new(string name = "Pseudo_Random_Test", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_sequence_base seq;
    phase.raise_objection(this);

    seq = RESET_Sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Random_Sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Random_Arith_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Random_Logic_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Random_Shift_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Random_Reset_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Random_Undefined_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Random_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);

    #50;                                   // let the last item reach the scoreboard
    phase.drop_objection(this);
  endtask : run_phase

endclass : Pseudo_Random_Test
