TEST ?= ALU_test
# DUT = buggy (rtl/ALU.sv, default)  or  fixed (rtl/ALU_fixed.sv)
DUT  ?= buggy

ifeq ($(DUT),fixed)
  DEFINE = +define+FIXED_DUT
  SIMV   = simv_fixed
  SUFFIX = _fixed
else
  DEFINE =
  SIMV   = simv
  SUFFIX =
endif

all: compile run

# make compile            -> original DUT
# make compile DUT=fixed  -> corrected DUT (a different executable, simv_fixed)
compile:
	vcs top_testbench.sv -o $(SIMV) -full64 -sverilog -ntb_opts uvm-1.2 -l compile$(SUFFIX).log -timescale=1ns/1ns +vcs+flush+all -kdb -lca -debug_access+all -reportstats $(DEFINE)

# make run TEST=Directed_Test            (log: Directed_Test.log)
# make run TEST=Directed_Test DUT=fixed  (log: Directed_Test_fixed.log)
run:
	./$(SIMV) +UVM_TESTNAME=$(TEST) | tee $(TEST)$(SUFFIX).log

# run every test one after the other (add DUT=fixed for the corrected DUT)
regress:
	for t in Directed_Test Corner_Test Flow_Test Random_Test Pseudo_Random_Test; do ./$(SIMV) +UVM_TESTNAME=$$t > $${t}$(SUFFIX).log; echo $$t; grep "Checked" $${t}$(SUFFIX).log; done

clean:
	rm -rf simv* csrc ucli.key *.log *.vcd *.fsdb *.vpd *.vdb vc_hdrs.h DVEfiles verdiLog novas* AN.DB simprofile_dir .inter.vpd.uvm .vlogansetup* .fsm.sch.verilog.xml .restartSimSession.tcl.old