class axi4_lite_write_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_write_seq)

	function new(string name = "axi4_lite_write_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;
		repeat(10) begin
			tx = axi4_lite_transaction::type_id::create("tx");
			start_item(tx);
			assert(tx.randomize() with {direction == WRITE;
				AWADDR % 4 == 0;
			});
			finish_item(tx);
		end
	endtask
endclass
