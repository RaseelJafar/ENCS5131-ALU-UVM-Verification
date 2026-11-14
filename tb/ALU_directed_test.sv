// DIRECTED test: hand-written normal cases of every operation
class Directed_Test extends BaseTest;

  `uvm_component_utils(Directed_Test)

  function new(string name = "Directed_Test", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_sequence_base seq;
    phase.raise_objection(this);

    seq = RESET_Sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Add_Directed_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Sub_Directed_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Div_Directed_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = And_Directed_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Or_Directed_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Xor_Directed_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Shl_Directed_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Shr_Directed_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);

    #50;                                   // let the last item reach the scoreboard
    phase.drop_objection(this);
  endtask : run_phase

endclass : Directed_Test
