### 1. RTL Design

#### 1.1. Design Specification

The operation of the design is sequential, requiring two clock edges for the data to propagate from input to output.

1.  **Before the 1st `pos-edge`:** The `a_in` and `b_in` inputs are stored in the `a_reg` and `b_reg` registers.
2.  **After the 1st `pos-edge`:** The outputs of `a_reg` and `b_reg` change (to the latched `a_in`/`b_in` values), pass through the XOR and AND combinational logic, and the results (`sum_int`, `carry_int`) are presented to the D-inputs of the `sum` and `carry` registers.
3.  **After the 2nd `pos-edge`:** The `sum` and `carry` registers capture these values, and their outputs (`sum_out`, `carry_out`) are updated with the final result.

All flip-flops share a common clock (`clk`) and an active-low asynchronous reset (`rst_n`).

#### 1.2. RTL Block Diagram

The design above can be represented by the following RTL block diagram.

![[image.jpg]]

On the left are the input signals, and on the right are the output signals. `clk` and `rst_n` are applied to all flip-flops (FFs). `a` and `b` are fed into the first two FFs, respectively. On the next clock cycle, the 'Q' outputs (now containing the values of `a` and `b`) enter the XOR and AND gates. Those signals then go into the `sum` and `carry` FFs, and on the following cycle, they emerge as the `sum` and `carry` outputs.

#### 1.3. RTL Code (Verilog HDL Code)

The Verilog code implementing the block diagram is as follows.

```verilog
module top (
    input clk,
    input rst_n,
    input a_in,
    input b_in,
    output reg sum_out,
    output reg carry_out
);

// Input registers
reg a_reg;
reg b_reg;

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

// Combinational logic stage
assign sum_int = a_reg ^ b_reg; // XOR for sum
assign carry_int = a_reg & b_reg; // AND for carry

// Output register stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_out <= 1'b0;
        carry_out <= 1'b0;
    end else begin
        sum_out <= sum_int;
        carry_out <= carry_int;
    end
end

endmodule
```

-----

### 2\. Synthesis

#### 2.1. Synthesis Environment

  - **Synthesis Tool:** Yosys
  - **Target Library:** `sky130_fd_sc_hd`, `tt` (Typical-Typical), `25C`, `1v80`(1.8V)
  - **PDK Version:** `8f2d1529c86235d726979eb9ecb7e9628108590b`

The meaning of the library name (`sky130_fd_sc_hd`) is as follows:

  - **130:** 130nm
  - **fd:** Fabricated at SkyWater Foundry
  - **sc:** Digital Standard Cells
  - **hd:** High Density

Source: https://sky130-unofficial.readthedocs.io/en/latest/contents/libraries.html#library-naming

#### 2.2. Yosys Synthesis Script (Tcl Script)

Synthesis was performed in Yosys using the following Tcl script (`yosys_command.tcl`), which is based on the provided lab document.

```tcl
read_verilog top.v
hierarchy -top top
proc
techmap
dfflibmap -liberty ~/.ciel/ciel/sky130/versions/8f2d1529c86235d726979eb9ecb7e9628108590b/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty ~/.ciel/ciel/sky130/versions/8f2d1529c86235d726979eb9ecb7e9628108590b/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
clean
write_verilog -noattr result.v
show
```

```shell
yosys> script yosys_command.tcl
```

-----

### 3\. Synthesis Results & Analysis

#### 3.1. Gate-Level Netlist

The final gate-level netlist (`result.v`) generated after synthesis is as follows.

```verilog
module top(clk, rst_n, a_in, b_in, sum_out, carry_out);
  input a_in;
  wire a_in;
  wire a_reg;
  input b_in;
  wire b_in;
  wire b_reg;
  wire carry_int;
  output carry_out;
  wire carry_out;
  input clk;
  wire clk;
  input rst_n;
  wire rst_n;
  wire sum_int;
  output sum_out;
  wire sum_out;

  sky130_fd_sc_hd__and2_0 _0_ (
    .A(a_reg),
    .B(b_reg),
    .X(carry_int)
  );
  sky130_fd_sc_hd__xor2_1 _1_ (
    .A(a_reg),
    .B(b_reg),
    .X(sum_int)
  );
  sky130_fd_sc_hd__dfrtp_1 _2_ (
    .CLK(clk),
    .D(sum_int),
    .Q(sum_out),
    .RESET_B(rst_n)
  );
  sky130_fd_sc_hd__dfrtp_1 _3_ (
    .CLK(clk),
    .D(carry_int),
    .Q(carry_out),
    .RESET_B(rst_n)
  );
  sky130_fd_sc_hd__dfrtp_1 _4_ (
    .CLK(clk),
    .D(a_in),
    .Q(a_reg),
    .RESET_B(rst_n)
  );
  sky130_fd_sc_hd__dfrtp_1 _5_ (
    .CLK(clk),
    .D(b_in),
    .Q(b_reg),
    .RESET_B(rst_n)
  );
endmodule
```

#### 3.2. Netlist Analysis

The synthesized netlist perfectly matches the intent of the RTL block diagram.

  * **Combinational Logic:**

      - `assign sum_int = a_reg ^ b_reg;` (RTL) → `sky130_fd_sc_hd__xor2_1 _1_ (...)` (Netlist)
      - `assign carry_int = a_reg & b_reg;` (RTL) → `sky130_fd_sc_hd__and2_0 _0_ (...)` (Netlist)

  * **Combinational Logic Analysis:**

      - `xor2` and `and2` are 2-input XOR and AND gates, respectively, so they were synthesized appropriately.

  * **Sequential Logic:**

      - The two `always @(posedge clk or negedge rst_n)` blocks (representing 4 registers: `a_reg`, `b_reg`, `sum_out`, `carry_out`) were correctly mapped to a total of four `sky130_fd_sc_hd__dfrtp_1` cells.

  * **Flip-Flop Cell Analysis (`dfrtp`):**
	  - `dfrtp` stands for **Delay flop, inverted reset, single output**, which means it was correctly synthesized to the desired FF (active-low reset).
	
  Source: https://sky130-unofficial.readthedocs.io/en/latest/contents/libraries/sky130_fd_sc_hd/README.html

  * **Netlist Diagram:**

    ![/home/wchoe/Workspace/ASIC_Project/Lab4/after_synthesis.png](file:///home/wchoe/Workspace/ASIC_Project/Lab4/after_synthesis.png)

-----

### 4\. Conclusion

Through this lab, a Half Adder with registers  was successfully designed in Verilog RTL. Yosys was used to synthesize this RTL code into the SKY130 standard cell library. Analysis of the generated netlist confirmed that the abstract RTL code (`always`, `assign`) was correctly transformed into specific physical cells (`sky130_fd_sc_hd__dfrtp_1`, `...__xor2_1`, `...__and2_0`). With this, the synthesis process was successfully completed.