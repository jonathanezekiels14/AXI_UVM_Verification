class axi4_lite_strb_read_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_strb_read_seq)

	function new(string name = "axi4_lite_strb_read_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction tx;


		repeat (100) begin

			tx = axi4_lite_transaction::type_id::create("tx");
			
			start_item(tx);
			
			assert(tx.randomize() with {
				direction == READ;
				ARADDR inside {'h0,'h3C,'h8};
				ARADDR % 4 == 0;
				ar_delay == 0; 
				rready_delay == 4;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			finish_item(tx);
		end
	endtask
endclass
