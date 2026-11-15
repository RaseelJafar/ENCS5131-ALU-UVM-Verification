interface ALU_interface (input logic clock);

  // inputs of the DUT
  logic         reset;
  logic [7:0]   A;
  logic [7:0]   B;
  logic [3:0]   selection;

  // outputs of the DUT
  logic [7:0]   result;
  logic         carry_out;

endinterface : ALU_interface
