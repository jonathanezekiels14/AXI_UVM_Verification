class axi4_lite_outstanding_vseq extends uvm_sequence;
	`uvm_object_utils(axi4_lite_outstanding_vseq)
	`uvm_declare_p_sequencer(axi4_lite_vsqr)

	function new(string name = "axi4_lite_outstanding_vseq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_write_aw_seq wr_seq;
		axi4_lite_read_ar_seq  rd_seq;

		wr_seq = axi4_lite_write_aw_seq::type_id::create("wr_seq");
		rd_seq = axi4_lite_read_ar_seq::type_id::create("rd_seq");

		`uvm_info("VSEQ", "--- Starting Write Outstanding AW Test ---", UVM_LOW)
		// This will fire two AWs before the first W completes
		wr_seq.start(p_sequencer.wr_sqr);

		`uvm_info("VSEQ", "--- Starting Read Outstanding AR Test ---", UVM_LOW)
		// This will fire two ARs before the first R completes
		rd_seq.start(p_sequencer.rd_sqr);
		
		`uvm_info("VSEQ", "--- Outstanding Transactions Test Complete ---", UVM_LOW)
	endtask
endclass
