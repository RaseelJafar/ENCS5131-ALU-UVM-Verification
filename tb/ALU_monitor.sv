class ALU_monitor extends uvm_monitor;

  //1. UVM component
  `uvm_component_utils(ALU_monitor)

  //2. Virtual interface + item
  virtual ALU_interface vif;
  ALU_sequence_item item;

  //3. Analysis port (to the scoreboard)
  uvm_analysis_port #(ALU_sequence_item) monitor_port;

  //4. Constructor
  function new(string name = "ALU_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //5. Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor_port = new("monitor_port", this);
    if (!uvm_config_db#(virtual ALU_interface)::get(this, "", "vif", vif))
      `uvm_fatal("ALU_monitor", "Failed to get VIF from config DB!")
  endfunction : build_phase

  //6. Run Phase: the driver holds every item for 2 clock edges, so sample
  //   once every 2 edges (inputs and the DUT's registered outputs together)
  task run_phase(uvm_phase phase);
    forever begin
      item = ALU_sequence_item::type_id::create("item");
      repeat (2) @(posedge vif.clock);

      item.reset     = vif.reset;
      item.A         = vif.A;
      item.B         = vif.B;
      item.selection = vif.selection;
      item.result    = vif.result;
      item.carry_out = vif.carry_out;

      `uvm_info(get_type_name(), "Monitor: Sending data to Scoreboard", UVM_HIGH)
      monitor_port.write(item);
    end
  endtask : run_phase

endclass : ALU_monitor
