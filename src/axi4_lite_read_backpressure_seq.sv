class axi4_lite_read_ar_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_read_ar_seq)

	function new(string name = "axi4_lite_read_ar_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx1, tx2;

		// Transaction 1: Drive AR immediately, stall RREADY to block completion
		tx1 = axi4_lite_transaction::type_id::create("tx1");
		start_item(tx1);
		assert(tx1.randomize() with {
			direction == READ;
			ARADDR[1:0] == 2'b00;
			ar_delay == 0;
			rready_delay == 50; // Stalls the master from completing the read
		});
		finish_item(tx1);

		// Transaction 2: Follow up immediately
		tx2 = axi4_lite_transaction::type_id::create("tx2");
		start_item(tx2);
		assert(tx2.randomize() with {
			direction == READ;
			ARADDR[1:0] == 2'b00;
			ar_delay == 0; // AR hits the bus right after tx1's AR
			rready_delay == 0;
		});
		finish_item(tx2);
	endtask
endclass
