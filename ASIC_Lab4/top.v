module top (
    input clk,
    input rst_n,
    input a_in,
    input b_in,
    output reg sum_out,
    output reg carry_out
);

  // Input registers
  reg  a_reg;
  reg  b_reg;

  // Intermediate signals from half adder
  wire sum_int;
  wire carry_int;

  // Input register stage
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      a_reg <= 1'b0;
      b_reg <= 1'b0;
    end else begin
      a_reg <= a_in;
      b_reg <= b_in;
    end
  end

  // Half adder logic
  assign sum_int   = a_reg ^ b_reg;  // XOR for sum
  assign carry_int = a_reg & b_reg;  // AND for carry

  // Output register stage
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sum_out   <= 1'b0;
      carry_out <= 1'b0;
    end else begin
      sum_out   <= sum_int;
      carry_out <= carry_int;
    end
  end

endmodule
