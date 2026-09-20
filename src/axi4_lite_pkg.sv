package axi4_lite_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "defines.svh"

	`include "axi4_lite_transaction.sv"
	`include "axi4_lite_config.sv"

	`include "axi4_lite_sequencer.sv"
	`include "axi4_lite_virtual_sequencer.sv"

	`include "axi4_lite_base_sequence.sv"
	`include "axi4_lite_write_seq.sv"
	`include "axi4_lite_read_sequence.sv"
	`include "axi4_lite_read_from_seq.sv"
	`include "axi4_lite_full_write_seq.sv"
	`include "axi4_lite_full_read_seq.sv"
	`include "axi4_lite_rand_write_seq.sv"
	`include "axi4_lite_rand_read_seq.sv"
	`include "axi4_lite_sanity_vseq.sv"
	`include "axi4_lite_corner_vseq.sv"
	`include "axi4_lite_rand_vseq.sv"
	`include "axi4_lite_write_backpressure_seq.sv"
	`include "axi4_lite_read_backpressure_seq.sv"
	`include "axi4_lite_outstanding_vseq.sv"
	`include "axi4_lite_error_write_seq.sv"
	`include "axi4_lite_error_read_seq.sv"
	`include "axi4_lite_error_vseq.sv"

	`include "axi4_lite_driver.sv"
	`include "axi4_lite_monitor.sv"

	`include "axi4_lite_agent.sv"

	`include "axi4_lite_scoreboard.sv"
	`include "axi4_lite_subscriber.sv"

	`include "axi4_lite_environment.sv"

	`include "axi4_lite_sanity_test.sv"
	`include "axi4_lite_corner_test.sv"
	`include "axi4_lite_rand_test.sv"
	`include "axi4_lite_error_test.sv"
endpackage
