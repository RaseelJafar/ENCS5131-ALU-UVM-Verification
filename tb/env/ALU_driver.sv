class ALU_driver extends uvm_driver #(ALU_sequence_item);

  //1. UVM component
  `uvm_component_utils(ALU_driver)

  //2. Virtual interface
  virtual ALU_interface vif;

  //3. Constructor
  function new(string name = "ALU_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //4. Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ALU_interface)::get(this, "", "vif", vif))
      `uvm_fatal("ALU_driver", "Failed to get VIF from config DB!")
  endfunction : build_phase

  //5. Run Phase: get an item, drive it, tell the sequencer we are done
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive(req);
      seq_item_port.item_done();
    end
  endtask : run_phase

  //6. Drive: put the item on the pins and hold it for 2 clock edges
  task drive(ALU_sequence_item item);
    `uvm_info(get_type_name(), $sformatf("Driver: Sending data to DUT\n %s", item.sprint()), UVM_HIGH)
    vif.reset     <= item.reset;
    vif.A         <= item.A;
    vif.B         <= item.B;
    vif.selection <= item.selection;
    repeat (2) @(posedge vif.clock);
  endtask : drive

endclass : ALU_driver
