class axi4_lite_rand_read_seq extends axi4_lite_base_sequence; 
	`uvm_object_utils(axi4_lite_rand_read_seq)

	int num_tx = 1000;
	bit [31:0] max_valid_addr = 32'h3C;

	function new(string name = "axi4_lite_rand_read_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction req;

		`uvm_info("SEQ", $sformatf("Starting %0d randomized read transactions", num_tx), UVM_LOW)

		repeat (num_tx) begin
			req = axi4_lite_transaction::type_id::create("req");
			start_item(req);
			
			assert(req.randomize() with {
				direction == READ;
				ARADDR <= max_valid_addr;
				ARADDR[1:0] == 2'b00; 
				ar_delay != rready_delay;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			finish_item(req);
		end
		`uvm_info("SEQ", "Completed randomized read sweep", UVM_LOW)

		`uvm_info("SEQ", $sformatf("Starting %0d randomized read transactions for Coverage", num_tx), UVM_LOW)

		repeat (num_tx) begin
			req = axi4_lite_transaction::type_id::create("req");
			start_item(req);
			
			assert(req.randomize() with {
				direction == READ;
				ar_delay != rready_delay;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			finish_item(req);
		end
		`uvm_info("SEQ", "Completed randomized read sweep for Coverage", UVM_LOW)
	endtask
endclass
