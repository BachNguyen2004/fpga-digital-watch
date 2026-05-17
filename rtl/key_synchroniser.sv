`timescale 1ns / 1ps

module key_synchroniser (
    input  logic       clk,
    input  logic [3:0] key_n,    // active-low, asynchronous
    output logic [3:0] key_sync  // active-high, synchronised
);

  logic [3:0] key_pressed;
  logic [3:0] key_stage1 = '0;

  assign key_pressed = ~key_n;

  initial key_sync = '0;

  always_ff @(posedge clk) begin
    key_stage1 <= key_pressed;
    key_sync   <= key_stage1;
  end

endmodule
