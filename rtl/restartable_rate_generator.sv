`timescale 1ns / 1ps

module restartable_rate_generator #(
    parameter int CYCLE_COUNT = 2
) (
    input  logic clk,
    input  logic run,
    output logic tick
);

  // Tick becomes high at end of cycle
  logic tick_qualifier;  //the counter has reached the tick point

  logic running = 1'b0;  //stored version of run

  always_ff @(posedge clk)
    running <= run;  //on eveery rising edge, running becomes the current value of run

  assign tick = running && tick_qualifier;  //tick = 1 only when running and tick_qualifier = 1

  generate
    if (CYCLE_COUNT > 1) begin : g_general

      localparam int CountWidth = $clog2(CYCLE_COUNT);  //calculates how many bits the counter needs
                                                        //eg: cycle_count = 8 then CountWidth = 3 bits

      logic rst_count;
      logic enable_count;
      logic [CountWidth-1:0] count;

      mod_n_counter #(
          .N(CYCLE_COUNT),
          .WIDTH(CountWidth)
      ) u_count (
          .clk(clk),
          .rst(rst_count),
          .enable(enable_count),
          .count(count)
      );

      assign rst_count = !run;
      assign enable_count = run;
      assign tick_qualifier = (count == CountWidth'(CYCLE_COUNT - 1));

    end else begin : g_special
      assign tick_qualifier = 1'b1;
    end
  endgenerate
endmodule
