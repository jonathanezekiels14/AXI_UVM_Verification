class axi4_lite_rand_write_seq extends axi4_lite_base_sequence; 
	`uvm_object_utils(axi4_lite_rand_write_seq)

	int num_tx = 1000;
	bit [31:0] max_valid_addr = 32'h3C; 

	function new(string name = "axi4_lite_rand_write_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction req;

		`uvm_info("SEQ", $sformatf("Starting %0d randomized write transactions", num_tx), UVM_LOW)

		repeat (num_tx) begin
			req = axi4_lite_transaction::type_id::create("req");
			
			start_item(req);
			
			assert(req.randomize() with {
				direction == WRITE;
				AWADDR <= max_valid_addr;
				AWADDR[1:0] == 2'b00;
				aw_delay != w_delay;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			
			finish_item(req);
		end
		
		`uvm_info("SEQ", "Completed randomized write sweep", UVM_LOW)

		// Randomized Writes for Coverage

		`uvm_info("SEQ", $sformatf("Starting %0d randomized write transactions for Coverage", num_tx), UVM_LOW)

		repeat (num_tx) begin
			req = axi4_lite_transaction::type_id::create("req");
			
			start_item(req);
			
			assert(req.randomize() with {
				direction == WRITE;
				aw_delay != w_delay;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			
			finish_item(req);
		end
		
		`uvm_info("SEQ", "Completed randomized write For Coverage", UVM_LOW)
	endtask
endclass
