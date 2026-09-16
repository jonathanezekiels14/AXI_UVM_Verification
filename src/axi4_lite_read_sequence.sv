class axi4_lite_read_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_read_seq)

	bit [31:0] target_addrs[$]; // Queue of addresses passed from the test

	function new(string name = "axi4_lite_read_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;
		
		// Loop through every address that was written to
		foreach (target_addrs[i]) begin
			tx = axi4_lite_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with {
				direction == READ;
				ARADDR == target_addrs[i];
				ar_delay == 0; rready_delay == 0;
			});
			finish_item(tx);
		end

		`uvm_info("[READ_SEQ]",$sformatf("Reading from STATUS Register"),UVM_LOW)
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == READ;
			ARADDR inside {['h28:'h30]};
			ARADDR % 4 == 0;
			ar_delay == 0; rready_delay == 0;
		});
		finish_item(tx);

	endtask
endclass
