class axi4_lite_full_read_seq extends axi4_lite_base_sequence;
	`uvm_object_utils(axi4_lite_full_read_seq)

	bit [31:0] start_addr = 32'h00;
	bit [31:0] end_addr   = 32'h3C;

	bit [31:0] wo_addr[$] = '{32'h34, 32'h38};

	function new(string name = "axi4_lite_full_read_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction req;
		`uvm_info("SEQ", "Starting full memory map read sweep", UVM_LOW)
		for (bit [31:0] addr = start_addr; addr <= end_addr; addr += 4) begin
			if (addr inside {wo_addr}) begin
				`uvm_info("SEQ", $sformatf("Skipping WO address: 'h%0h", addr), UVM_HIGH)
				continue;
			end
			req = axi4_lite_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				direction == READ;
				ARADDR == addr;
				ARADDR % 4 == 0; 
				ar_delay == 1;
				rready_delay == 4;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			finish_item(req);
		end
		`uvm_info("SEQ", "Completed full memory map read sweep", UVM_LOW)
	endtask
endclass
