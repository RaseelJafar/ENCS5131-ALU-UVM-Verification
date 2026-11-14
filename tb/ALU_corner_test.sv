// CORNER CASE test: boundary values of every operation
class Corner_Test extends BaseTest;

  `uvm_component_utils(Corner_Test)

  function new(string name = "Corner_Test", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_sequence_base seq;
    phase.raise_objection(this);

    seq = RESET_Sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Add_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Sub_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Div_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = And_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Or_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Xor_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Shl_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
    seq = Shr_Corner_Seq::type_id::create("seq");
    seq.start(env.agent.sequencer);

    #50;                                   // let the last item reach the scoreboard
    phase.drop_objection(this);
  endtask : run_phase

endclass : Corner_Test
