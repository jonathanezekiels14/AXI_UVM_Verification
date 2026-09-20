class axi4_lite_write_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_write_seq)

	bit [31:0] target_addrs[$]; // Queue to store all generated addresses

	function new(string name = "axi4_lite_write_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;
		
		// 1. Basic Full-Byte Writes
		repeat (10) begin
			tx = axi4_lite_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with {
				direction == WRITE;
				AWADDR inside {['h0:'h24]};
				AWADDR % 4 == 0;
				WSTRB == 4'b1111; // Full write
				aw_delay == 0; w_delay == 5; bready_delay == 0;
			});
			target_addrs.push_back(tx.AWADDR); // Save address to queue
			finish_item(tx);
		end

		// 2. Partial WSTRB Writes
		repeat (10) begin
			tx = axi4_lite_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with {
				direction == WRITE;
				AWADDR inside {['h0:'h24],'h3C};
				AWADDR % 4 == 0;
				WSTRB inside {4'b0101, 4'b1010}; // Alternating byte lanes
				aw_delay == 0; w_delay == 2; bready_delay == 0;
			});
			target_addrs.push_back(tx.AWADDR); // Save address to queue
			finish_item(tx);
		end

		// Random WSTRB Values
		repeat (10) begin
			tx = axi4_lite_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with {
				direction == WRITE;
				AWADDR inside {['h0:'h24],'h3C};
				AWADDR % 4 == 0;
				aw_delay == 0; w_delay == 5; bready_delay == 0;
			});
			target_addrs.push_back(tx.AWADDR); // Save address to queue
			finish_item(tx);
		end

		// Writing to Reserved Register
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == WRITE;
			AWADDR == 'h3C;
			aw_delay == 0; w_delay == 5; bready_delay == 0;
		});
		target_addrs.push_back(tx.AWADDR); // Save address to queue
		finish_item(tx);

		// Writing to Command Registers
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == WRITE;
			AWADDR inside {'h34, 'h38};
			aw_delay == 0; w_delay == 5; bready_delay == 0;
		});
		finish_item(tx);

		// Writing to AW Channel First
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == WRITE;
			AWADDR inside {['h0:'h24],'h3C};
			AWADDR % 4 == 0;
			aw_delay == 0; w_delay == 2; bready_delay == 0;
		});
		finish_item(tx);

		// Writing to W channel first
		tx = axi4_lite_transaction::type_id::create("tx");
		start_item(tx);
		assert(tx.randomize() with {
			direction == WRITE;
			AWADDR inside {['h0:'h24],'h3C};
			AWADDR % 4 == 0;
			aw_delay == 2; w_delay == 0; bready_delay == 0;
		});
		finish_item(tx);
	endtask
endclass
