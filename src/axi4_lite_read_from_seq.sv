class axi4_lite_read_from_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_read_from_seq)

	bit [31:0] target_addrs[$]; // Queue of addresses passed in from the test/virtual sequence

	function new(string name = "axi4_lite_read_from_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;
		`uvm_info("SEQ", $sformatf("Starting reads for %0d saved addresses", target_addrs.size()), UVM_LOW)

		// Loop through every address that was saved in the queue
		foreach (target_addrs[i]) begin
			tx = axi4_lite_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with {
				direction == READ;
				ARADDR == target_addrs[i];
				ar_delay == 0; 
				rready_delay == 4;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			
			finish_item(tx);
		end
		
		`uvm_info("SEQ", "Completed reads for all saved addresses", UVM_LOW)
	endtask
endclass
