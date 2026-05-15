`timescale 1ns / 1ps

module pwm_generator #(
    parameter int PERIOD_CYCLES = 50_000_000,
    parameter int DUTY_CYCLES   = 25_000_000
) (
    input  logic clk,
    input  logic rst,
    output logic pwm_out
);

  //Calculates how many bits required for the counter
  localparam int CountWidth = $clog2(PERIOD_CYCLES);

  localparam int CompareWidth = CountWidth + 1;

  logic [CountWidth-1:0] count;

  //LHS: Size of DutyCycles, RHS: Values goes into DutyCycle, resized to that size
  localparam logic [CompareWidth-1:0] DutyCycles = CompareWidth'(DUTY_CYCLES);

  mod_n_counter #(
      .N(PERIOD_CYCLES),
      .WIDTH(CountWidth)
  ) u_counter (
      .clk(clk),
      .rst(rst),
      .enable(1'b1),
      .count(count)
  );

  //{1'b0, count} -> adds one extra bit before comparison. Ensure DUTY_CYCLES bits not get cutoff when equals Period_Cycle
  assign pwm_out = ({1'b0, count} < DutyCycles);

endmodule
