class axi4_lite_write_aw_seq extends axi4_lite_base_sequence; 
	`uvm_object_utils(axi4_lite_write_aw_seq)

	function new(string name = "axi4_lite_write_aw_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx1, tx2;
		// Transaction 1: Drive AW immediately, but stall W for 50 cycles
		tx1 = axi4_lite_transaction::type_id::create("tx1");
		start_item(tx1);
		assert(tx1.randomize() with {
			direction == WRITE;
			AWADDR[1:0] == 2'b00;
			AWADDR == 'h10;
			aw_delay == 0;  
			w_delay  == 50; // Stalls the driver's w_q task
		});
		finish_item(tx1);

		// Transaction 2: Follow up immediately
		tx2 = axi4_lite_transaction::type_id::create("tx2");
		start_item(tx2);
		assert(tx2.randomize() with {
			direction == WRITE;
			AWADDR == 'h10;
			aw_delay == 0; // AW hits the bus right after tx1's AW
			w_delay  == 2; 
		});
		finish_item(tx2);
	endtask
endclass
