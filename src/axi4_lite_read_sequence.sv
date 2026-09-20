class axi4_lite_read_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_read_seq)

	int num_reads = 10; 

	function new(string name = "axi4_lite_read_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;

		`uvm_info("SEQ", $sformatf("Starting %0d random valid reads", num_reads), UVM_LOW)

		// Reading from Random
		repeat (num_reads) begin
			tx = axi4_lite_transaction::type_id::create("tx");
			
			start_item(tx);
			
			assert(tx.randomize() with {
				direction == READ;
				ARADDR inside {[32'h00 : 32'h3C]};
				!(ARADDR inside {32'h34, 32'h38});
				ARADDR % 4 == 0;
				ar_delay == 0; 
				rready_delay == 4;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			finish_item(tx);
		end
		`uvm_info("SEQ", "Completed random reads", UVM_LOW)

		// Reading from Status Registers
		tx = axi4_lite_transaction::type_id::create("tx");
			
		start_item(tx);
			
		assert(tx.randomize() with {
			direction == READ;
			ARADDR inside {32'h28, 32'h3C, 32'h30};
			ar_delay == 0; 
			rready_delay == 4;
		}) else `uvm_error("SEQ", "Transaction randomization failed")
		finish_item(tx);
	endtask
endclass
