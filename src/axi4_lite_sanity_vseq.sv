class axi4_lite_sanity_vseq extends uvm_sequence;
	`uvm_object_utils(axi4_lite_sanity_vseq)
	
	`uvm_declare_p_sequencer(axi4_lite_vsqr)

	function new(string name = "axi4_lite_sanity_vseq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_write_seq wr_seq;
		axi4_lite_read_seq  rd_seq;

		wr_seq = axi4_lite_write_seq::type_id::create("wr_seq");
		rd_seq = axi4_lite_read_seq::type_id::create("rd_seq");

		`uvm_info("VSEQ", "Starting Write-then-Read sequence...", UVM_LOW)

		wr_seq.start(p_sequencer.wr_sqr);
		rd_seq.target_addr = wr_seq.target_addr;
		rd_seq.start(p_sequencer.rd_sqr);
		
		`uvm_info("VSEQ", "Write-then-Read sequence complete.", UVM_LOW)
	endtask
endclass
