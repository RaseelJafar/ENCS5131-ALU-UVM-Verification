class ALU_test extends BaseTest;

  //1. Component
  `uvm_component_utils(ALU_test)

  RESET_Sequence  reset_seq;
  Random_Sequence random_seq;

  //2. Constructor
  function new(string name = "ALU_test", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //3. Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reset_seq  = RESET_Sequence::type_id::create("reset_seq");
    random_seq = Random_Sequence::type_id::create("random_seq");
  endfunction : build_phase

  //4. Run Phase: reset first, then random operations
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    reset_seq.start(env.agent.sequencer);
    random_seq.start(env.agent.sequencer);
    #50;                                   // let the last item reach the scoreboard
    phase.drop_objection(this);
  endtask : run_phase

endclass : ALU_test
