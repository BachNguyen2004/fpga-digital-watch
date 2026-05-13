`timescale 1ns / 1ps

module top_time_display_v1 #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
    input logic CLOCK_50,
    input logic [1:0] SW,

    output logic [6:0] HEX5,
    output logic [6:0] HEX4,
    output logic [6:0] HEX3,
    output logic [6:0] HEX2,
    output logic [6:0] HEX1,
    output logic [6:0] HEX0
);

  // Tick signals
  logic tick_1hz;
  logic tick_25hz;
  logic tick_1khz;

  logic tick;

  // Time values
  logic [4:0] hours;
  logic [5:0] minutes;
  logic [5:0] seconds;

  // BCD digits
  logic [3:0] hour_tens;
  logic [3:0] hour_ones;

  logic [3:0] minute_tens;
  logic [3:0] minute_ones;

  logic [3:0] second_tens;
  logic [3:0] second_ones;

  // Rate generators

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND)
  ) u_tick_1hz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_1hz)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 25)
  ) u_tick_25hz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_25hz)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 1000)
  ) u_tick_1khz (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(tick_1khz)
  );

  // Tick selection

  always_comb begin
    unique case (SW)

      2'b00: tick = tick_1hz;
      2'b01: tick = tick_25hz;
      2'b10: tick = tick_1khz;
      2'b11: tick = 1'b1;

    endcase
  end

  // HMS counter

  hms_counter u_hms (
      .clk(CLOCK_50),
      .enable(tick),
      .hours(hours),
      .minutes(minutes),
      .seconds(seconds)
  );

  // Binary to BCD converters

  binary_to_bcd u_bcd_hours (
      .bin ({2'b0, hours}),
      .tens(hour_tens),
      .ones(hour_ones)
  );

  binary_to_bcd u_bcd_minutes (
      .bin ({1'b0, minutes}),
      .tens(minute_tens),
      .ones(minute_ones)
  );

  binary_to_bcd u_bcd_seconds (
      .bin ({1'b0, seconds}),
      .tens(second_tens),
      .ones(second_ones)
  );

  // Seven segment displays

  seven_segment u_HEX5 (
      .digit(hour_tens),
      .blank(1'b0),
      .segments(HEX5)
  );

  seven_segment u_HEX4 (
      .digit(hour_ones),
      .blank(1'b0),
      .segments(HEX4)
  );

  seven_segment u_HEX3 (
      .digit(minute_tens),
      .blank(1'b0),
      .segments(HEX3)
  );

  seven_segment u_HEX2 (
      .digit(minute_ones),
      .blank(1'b0),
      .segments(HEX2)
  );

  seven_segment u_HEX1 (
      .digit(second_tens),
      .blank(1'b0),
      .segments(HEX1)
  );

  seven_segment u_HEX0 (
      .digit(second_ones),
      .blank(1'b0),
      .segments(HEX0)
  );

endmodule
