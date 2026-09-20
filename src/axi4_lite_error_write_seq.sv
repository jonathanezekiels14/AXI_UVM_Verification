class axi4_lite_error_write_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_error_write_seq)

	function new(string name = "axi4_lite_error_write_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;
		
		// 1. UNALIGNED_ADDRESS_ACCESS (Write)
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == WRITE;
			AWADDR inside {['h0:'h3C]};
			AWADDR % 4 != 0; // Force an unaligned byte address
			aw_delay == 0; w_delay == 0; bready_delay == 0;
		});
		finish_item(tx);

		// 2. OUT_OF_RANGE_ACCESS (Write)
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == WRITE;
			AWADDR > 32'h3C; // Target address outside valid map
			AWADDR % 4 == 0; // Keep aligned to isolate the out-of-range error
			aw_delay == 0; w_delay == 0; bready_delay == 0;
		});
		finish_item(tx);

		// 3. READ_ONLY_WRITE
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == WRITE;
			AWADDR inside {32'h28, 32'h2C, 32'h30}; // Target Status registers
			aw_delay == 0; w_delay == 0; bready_delay == 0;
		});
		finish_item(tx);
	endtask
endclass
