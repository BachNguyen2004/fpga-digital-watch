`timescale 1ns / 1ps

module rising_edge_detector (
    input  logic clk,
    input  logic sig_in,
    output logic rise
);

  logic sig_prev = 1'b0;

  always_ff @(posedge clk) sig_prev <= sig_in;

  assign rise = sig_in && !sig_prev;

endmodule
