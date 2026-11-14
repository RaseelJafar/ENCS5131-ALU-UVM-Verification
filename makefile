TEST ?= ALU_test

all: compile run

compile:
	vcs top_testbench.sv -o simv -full64 -sverilog -ntb_opts uvm-1.2 -l compile.log -timescale=1ns/1ns +vcs+flush+all -kdb -lca -debug_access+all -reportstats

# make run TEST=Directed_Test
run:
	./simv +UVM_TESTNAME=$(TEST) | tee $(TEST).log

# run every test one after the other
regress:
	for t in Directed_Test Corner_Test Flow_Test Random_Test Pseudo_Random_Test; do ./simv +UVM_TESTNAME=$$t > $$t.log; echo $$t; grep "Checked" $$t.log; done

clean:
	rm -rf simv simv.daidir csrc ucli.key *.log *.vcd vc_hdrs.h DVEfiles verdiLog novas* AN.DB
