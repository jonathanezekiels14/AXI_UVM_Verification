class axi4_lite_error_read_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_error_read_seq)

	function new(string name = "axi4_lite_error_read_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;
		
		// 1. UNALIGNED_ADDRESS_ACCESS (Read)
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == READ;
			ARADDR inside {['h0:'h3C]};
			ARADDR % 4 != 0; // Force an unaligned byte address
			ar_delay == 0; rready_delay == 0;
		});
		finish_item(tx);

		// 2. OUT_OF_RANGE_ACCESS (Read)
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == READ;
			ARADDR > 32'h3C; // Target address outside valid map
			ARADDR % 4 == 0; // Keep aligned to isolate the out-of-range error
			ar_delay == 0; rready_delay == 0;
		});
		finish_item(tx);

		// 3. WRITE_ONLY_READ
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == READ;
			ARADDR inside {32'h34, 32'h38}; // Target Command registers
			ar_delay == 0; rready_delay == 0;
		});
		finish_item(tx);
	endtask
endclass
