`timescale 1ns / 1ps

module rising_edge_detector (

    input  logic clk,
    input  logic sig_in,
    output logic rise

);

  logic prev = 1'b0;
  always_ff @(posedge clk) begin
    rise <= sig_in && !prev;
    prev <= sig_in;
  end

endmodule
