`timescale 1ns / 1ps

module wave_restartable_rate_generator_special;

  logic clk = 1'b0;
  always #5 clk = ~clk;

  logic run;
  logic tick;

  restartable_rate_generator #(
      .CYCLE_COUNT(1)
  ) dut (
      .clk (clk),
      .run (run),
      .tick(tick)
  );

  initial begin

    $dumpfile("wave_restartable_rate_generator_special.vcd");
    $dumpvars;

    run = 1'b0;
    #20;

    run = 1'b1;
    #40;

    run = 1'b0;
    #20;

    $finish;

  end

endmodule
