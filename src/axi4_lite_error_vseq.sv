class axi4_lite_error_vseq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_error_vseq)
	`uvm_declare_p_sequencer(axi4_lite_vsqr)

	function new(string name = "axi4_lite_error_vseq");
		super.new(name);
	endfunction

	virtual task body();
		// 1. Declare the sequences
		axi4_lite_error_write_seq  wr_err_seq;
		axi4_lite_error_read_seq   rd_err_seq;
		axi4_lite_outstanding_vseq outstanding_vseq;

		// 2. Create the sequences
		wr_err_seq = axi4_lite_error_write_seq::type_id::create("wr_err_seq");
		rd_err_seq = axi4_lite_error_read_seq::type_id::create("rd_err_seq");
		outstanding_vseq = axi4_lite_outstanding_vseq::type_id::create("outstanding_vseq");

		`uvm_info("VSEQ", "--- Starting Error Write Sequences ---", UVM_LOW)
		wr_err_seq.start(p_sequencer.wr_sqr); // Started on the physical write sequencer

		`uvm_info("VSEQ", "--- Starting Error Read Sequences ---", UVM_LOW)
		rd_err_seq.start(p_sequencer.rd_sqr); // Started on the physical read sequencer

		`uvm_info("VSEQ", "--- Starting Outstanding Virtual Sequence ---", UVM_LOW)
		// 3. Start the nested virtual sequence on the virtual sequencer
		outstanding_vseq.start(p_sequencer); 
		
		`uvm_info("VSEQ", "--- Master Virtual Sequence Complete ---", UVM_LOW)
	endtask
endclass
