# Bugs found in the ALU

I found 4 bugs in `rtl/ALU.sv`. With `rtl/ALU_fixed.sv` the same testbench gives 0 mismatches in all tests.

## Bug 1: left shift gives the wrong carry_out (opcode 0110)

The carry should be the last bit shifted out, which is `A[8-n]`, but the ALU uses `A[7-n]`.

Found in `Directed_Test` at 555 ns:
`sel=0110 A=a5 B=01 | DUT: result=4a carry=0 | EXPECTED: result=4a carry=1`

![bug 1](docs/waveforms/bug1_buggy.png)

## Bug 2: right shift by 0 gives carry_out = X (opcode 0111)

The ALU uses `A[B[2:0] - 1]`, which is `A[-1]` when the shift amount is 0.

Found in `Corner_Test` at 9475 ns:
`sel=0111 A=00 B=00 | DUT: result=00 carry=x | EXPECTED: result=00 carry=0`

![bug 2](docs/waveforms/bug2_buggy.png)

## Bug 3: opcode 1000 does a NAND (not in the spec)

The spec says undefined opcodes give result 0 and carry 0, but the ALU calculates `~(A & B)`.

Found in `Flow_Test` at 9975 ns:
`sel=1000 A=a5 B=3c | DUT: result=db carry=0 | EXPECTED: result=00 carry=0`

![bug 3](docs/waveforms/bug3_buggy.png)

## Bug 4: undefined opcodes keep the old carry_out (opcodes 1001 to 1111)

The default case sets `result` to 0 but never sets `carry_out`, so the old carry stays. I only saw this when the carry was 1 before the undefined opcode, so `Carry_Then_Undefined_Seq` makes the carry 1 first (for example overflow in ADD) and then sends the undefined opcode.

Found in `Flow_Test` at 10455 ns:
`sel=1001 A=12 B=34 | DUT: result=00 carry=1 | EXPECTED: result=00 carry=0`

![bug 4](docs/waveforms/bug4_buggy.png)
