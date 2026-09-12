class axi4_lite_vsqr extends uvm_sequencer;
	`uvm_component_utils(axi4_lite_vsqr)

	axi4_lite_sequencer wr_sqr;
	axi4_lite_sequencer rd_sqr;

	function new(string name = "axi4_lite_vsqr", uvm_component parent = null);
		super.new(name,parent);
	endfunction

endclass
