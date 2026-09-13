package axi4_lite_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "defines.svh"

	`include "axi4_lite_transaction.sv"
	`include "axi4_lite_config.sv"

	`include "axi4_lite_base_sequence.sv"
	`include "axi4_lite_write_seq.sv"
	
	`include "axi4_lite_sequencer.sv"
	`include "axi4_lite_virtual_sequencer.sv"

	`include "axi4_lite_driver.sv"
	`include "axi4_lite_monitor.sv"

	`include "axi4_lite_agent.sv"

	`include "axi4_lite_scoreboard.sv"

	`include "axi4_lite_environment.sv"

	`include "axi4_lite_write_test.sv"
endpackage
