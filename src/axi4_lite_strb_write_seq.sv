class axi4_lite_strb_write_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_strb_write_seq)

	function new(string name = "axi4_lite_strb_write_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;
		
		repeat (100) begin
			// 1. Basic Full-Byte Writes
			tx = axi4_lite_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with {
				direction == WRITE;
				AWADDR inside {'h0,'h8,'h3C};
				AWADDR % 4 == 0;
				aw_delay == 0; w_delay == 5; bready_delay == 0;
			});
			finish_item(tx);
		end
	endtask
endclass
