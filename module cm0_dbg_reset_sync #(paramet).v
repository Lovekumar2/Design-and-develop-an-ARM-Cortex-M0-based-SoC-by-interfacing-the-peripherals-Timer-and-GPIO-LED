module cm0_dbg_reset_sync #(parameter PRESENT = 1)
                           (input  wire RSTIN,
                            input  wire CLK,
                            input  wire SE,
                            input  wire RSTBYPASS,
                            output wire RSTOUT);

  // This module is instantiated where a reset synchroniser is required.
  // The purpose of this module is to produce a reset which is asynchronously
  // asserted and synchronously deasserted from a reset that is both asserted
  // and deasserted asynchronously. Note that it is assumed here that
  // the resets in question are active LOW

  // ------------------------------------------------------------
  // NOTE: THIS MODULE IS NOT INTENDED FOR USE IN SYNTHESIS
  // IT IS STRONGLY RECOMMENDED THAT AN EQUIVALENT MODULE
  // DIRECTLY INSTANTIATING CELLS FROM YOUR LIBRARY THAT MEET
  // THE REQUIREMENTS DETAILED BELOW IS USED INSTEAD
  // ------------------------------------------------------------

  // Requirements
  // -------------

  // 1 - The final D-type in the synchroniser must be guaranteed to
  // change cleanly (i.e. never glitch) whilst reset is held
  // inactive

  // ------------------------------------------------------------
  // Reference model for reset synchroniser
  // ------------------------------------------------------------

  reg  rst_sync0, rst_sync1, rst_sync2;

  wire cfg_present = (PRESENT != 0);

  always @(posedge CLK or negedge RSTIN)
    if (~RSTIN) begin
      rst_sync0 <= 1'b0;
      rst_sync1 <= 1'b0;
      rst_sync2 <= 1'b0;
    end else if (cfg_present) begin
      rst_sync0 <= 1'b1;
      rst_sync1 <= rst_sync0;
      rst_sync2 <= rst_sync1;
    end

  assign RSTOUT = (RSTBYPASS | ~cfg_present) ? RSTIN : rst_sync2;

endmodule
