// RANDOM test: no constraints, anything can happen
class Random_Test extends BaseTest;

  `uvm_component_utils(Random_Test)

  function new(string name = "Random_Test", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_sequence_base seq;
    phase.raise_objection(this);

    seq = RESET_Sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Pure_Random_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Pure_Random_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Pure_Random_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);

    #50;                                   // let the last item reach the scoreboard
    phase.drop_objection(this);
  endtask : run_phase

endclass : Random_Test
