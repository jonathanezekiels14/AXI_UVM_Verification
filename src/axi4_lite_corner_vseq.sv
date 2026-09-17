class axi4_lite_corner_vseq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_corner_vseq)
	`uvm_declare_p_sequencer(axi4_lite_vsqr)

	function new(string name ="axi4_lite_corner_vseq");
		super.new(name);
	endfunction

	virtual task body();

		axi4_lite_corner_write_seq full_wr_seq = axi4_lite_corner_write_seq::type_id::create("full_wr_seq");
		axi4_lite_write_seq wr_seq = axi4_lite_write_seq::type_id::create("wr_seq");
		axi4_lite_read_seq rd_seq = axi4_lite_read_seq::type_id::create("rd_seq");

		`uvm_info("CORNER_VSEQ","Starting Full Write",UVM_LOW)

		full_wr_seq.start(p_sequencer.wr_sqr);

		`uvm_info("CORNER_VSEQ","Starting Paralell Read/Write",UVM_LOW)
		fork
			wr_seq.start(p_sequencer.wr_sqr);
			rd_seq.start(p_sequencer.rd_sqr);
		join
	endtask
endclass	
