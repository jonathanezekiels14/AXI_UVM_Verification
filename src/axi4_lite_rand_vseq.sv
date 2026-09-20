class axi4_lite_rand_vseq extends uvm_sequence;
	`uvm_object_utils(axi4_lite_rand_vseq)
	`uvm_declare_p_sequencer(axi4_lite_vsqr)

	function new(string name = "axi4_lite_rand_vseq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_rand_write_seq wr_seq = axi4_lite_rand_write_seq::type_id::create("wr_seq");
		axi4_lite_rand_read_seq  rd_seq = axi4_lite_rand_read_seq::type_id::create("rd_seq");

		`uvm_info("VSEQ", "Starting Randomized Wrie and Read Sequence...", UVM_LOW)

		wr_seq.start(p_sequencer.wr_sqr);
		rd_seq.start(p_sequencer.rd_sqr);
		
		`uvm_info("VSEQ", "Random Sequence Complete!", UVM_LOW)
	endtask
endclass
