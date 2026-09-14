class axi4_lite_write_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_write_seq)

	bit [31:0] target_addr; // Store the chosen address here

	function new(string name = "axi4_lite_write_seq");
		super.new(name);
	endfunction

	virtual task body();
		// Basic Write
		axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == WRITE;
			AWADDR inside {['h0:'h24]};
			AWADDR % 4 == 0;
			aw_delay == 0; w_delay == 0; bready_delay == 0;
		});
		target_addr = tx.AWADDR; // Save it for the read sequence
		finish_item(tx);

		// WSTRB
		repeat (20) begin
			axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with {
				direction == WRITE;
				AWADDR inside {['h0:'h24],['h34:'h3C]};
				WSTRB inside {5,10};
				AWADDR % 4 == 0;
				aw_delay == 0; w_delay == 0; bready_delay == 0;
			});
			target_addr = tx.AWADDR; // Save it for the read sequence
			finish_item(tx);
		end
	endtask
endclass
