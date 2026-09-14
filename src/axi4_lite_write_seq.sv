class axi4_lite_write_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_write_seq)

	function new(string name = "axi4_lite_write_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;
		bit [31:0] target_addr; // Variable to hold the address

		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);

		assert(tx.randomize() with {
			direction == WRITE;
			
			AWADDR inside {[0:60]};
			AWADDR % 4 == 0;
			
			aw_delay == 0;
			w_delay == 0;
			bready_delay == 0;
		});
		
		target_addr = tx.AWADDR; 

		finish_item(tx);

		tx = axi4_lite_transaction::type_id::create("tx"); 
		start_item(tx);

		assert(tx.randomize() with {
			direction == READ;
			
			ARADDR == target_addr; 
			
			aw_delay == 0;
			w_delay == 0;
			bready_delay == 0;
		});

		finish_item(tx);
	endtask
endclass
