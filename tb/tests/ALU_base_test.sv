class BaseTest extends uvm_test;

  //1. Component
  `uvm_component_utils(BaseTest)

  //2. Environment
  ALU_env env;

  //3. Constructor
  function new(string name = "BaseTest", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //4. Build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ALU_env::type_id::create("env", this);
  endfunction : build_phase

  //5. End of Elaboration: print the testbench hierarchy
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  //6. Report: PASS / FAIL for the whole test
  function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    svr = uvm_report_server::get_server();
    if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0)
      `uvm_info(get_type_name(), "******** TEST FAILED (errors were reported) ********", UVM_NONE)
    else
      `uvm_info(get_type_name(), "******** TEST PASSED ********", UVM_NONE)
  endfunction : report_phase

endclass : BaseTest
