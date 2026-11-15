# ALU UVM Testbench

This is my UVM testbench for the 8-bit ALU (ENCS5131, Exp 5 and 6). It sends directed, corner case and random tests to the ALU, and the scoreboard checks `result` and `carry_out` against a reference model I wrote from the lab spec.

The bugs I found are in [RESULTS.md](RESULTS.md).

## Folders

```
makefile
top_testbench.sv
rtl/
  ALU.sv            original ALU (has bugs)
  ALU_fixed.sv      my corrected ALU
tb/
  env/              interface, item, sequencer, driver, monitor, agent, scoreboard, env
  tests/            the tests
  sequences/        Arithmetic, Logic, Shift, Flow, Reset, Undefined, Random
docs/waveforms/     screenshots used in RESULTS.md
```

## How to run

You need Synopsys VCS (with UVM 1.2). Verdi is only needed for the waveforms.

```
make compile                 # original ALU
make run TEST=Flow_Test      # run one test
make regress                 # run all 5 tests

make compile DUT=fixed       # corrected ALU
make run TEST=Flow_Test DUT=fixed
make regress DUT=fixed

make clean
```

The logs are saved as `<test>.log` (and `<test>_fixed.log` for the fixed ALU). To see the failures:

```
grep MISMATCH Flow_Test.log
```

## Tests

- `ALU_test`: reset then random operations (Exp 5, the default)
- `Directed_Test`: normal cases of every operation
- `Corner_Test`: boundary values (0, 1, 7F, 80, FE, FF), overflow, borrow, divide by zero, shift by 0
- `Flow_Test`: operations in a bad order (carry left from the previous operation, reset, undefined opcodes)
- `Random_Test`: fully random
- `Pseudo_Random_Test`: random with constraints

## Waveforms

Every run also saves a waveform (`Flow_Test.vcd`, or `Flow_Test_fixed.vcd`). Open it with:

```
verdi -dbdir simv.daidir -ssf Flow_Test.vcd &
```

