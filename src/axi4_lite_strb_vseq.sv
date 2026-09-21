class axi4_lite_strb_vseq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_strb_vseq)
	`uvm_declare_p_sequencer(axi4_lite_vsqr)

	function new(string name = "axi4_lite_strb_vseq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_strb_write_seq wr_seq;
		axi4_lite_strb_read_seq rd_seq;

		wr_seq = axi4_lite_strb_write_seq::type_id::create("wr_seq");
		rd_seq = axi4_lite_strb_read_seq::type_id::create("rd_seq");

		`uvm_info("VSEQ","Starting corner WSTRB error at addresses 0x00, 0x08, 0x3C", UVM_LOW)

		wr_seq.start(p_sequencer.wr_sqr);

		rd_seq.start(p_sequencer.rd_sqr);

	endtask
endclass


