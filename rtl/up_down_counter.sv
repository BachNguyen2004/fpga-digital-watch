`timescale 1ns / 1ps

module up_down_counter #(
    parameter int MAX   = 2,  //Max value = 2, not 2 bits
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic enable,
    input logic up,
    output logic [WIDTH-1:0] count     //Start at 0 represent using 2 bits -> so 00
);
  // Width-correct constants for lint cleanliness
  localparam logic [WIDTH-1:0] Max = WIDTH'(MAX);
  localparam logic [WIDTH-1:0] One = WIDTH'(1);

  // Next-state signal
  logic [WIDTH-1:0] next_count;  //next count will be 2 bits length

  // Initialise counter to 0
  initial count = '0;  //' to make sure the initial count = 0
                       //will have exact number of bits you specified in the module

  // Next-state logic
  always_comb begin   //pure combinational logic (no memory, no clock, continously calculates next count)
    if (up) begin
      // Count up
      if (count == Max) begin
        next_count = '0;
      end else begin
        next_count = count + One;
      end
    end else begin
      // Count down
      if (count == '0) begin
        next_count = Max;
      end else begin
        next_count = count - One;
      end
    end
  end
  // State register
  always_ff @(posedge clk) begin
    if (enable) begin  //enable = 1 -> Count = Next count; enable = 0 -> count keeps old value
      count <= next_count;
    end
  end
endmodule
