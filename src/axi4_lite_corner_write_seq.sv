class axi4_lite_corner_write_seq extends axi4_lite_base_sequence; 
	`uvm_object_utils(axi4_lite_corner_write_seq)

	bit [31:0] start_addr = 32'h00;
	bit [31:0] end_addr   = 32'h3C; 

	bit [31:0] ro_addr[$] = '{32'h28, 32'h2C, 32'h30}; 

	function new(string name = "axi4_lite_corner_write_seq");
		super.new(name);
	endfunction

	virtual task body();
		axi4_lite_transaction req;

		`uvm_info("SEQ", "Starting full memory map write sweep", UVM_LOW)

		for (bit [31:0] addr = start_addr; addr <= end_addr; addr += 4) begin
			
			if (addr inside {ro_addr}) begin
				`uvm_info("SEQ", $sformatf("Skipping RO/Reserved address: 'h%0h", addr), UVM_HIGH)
				continue;
			end

			req = axi4_lite_transaction::type_id::create("req");
			
			start_item(req);
			
			assert(req.randomize() with {
				AWADDR == addr;
				WSTRB  == 4'hF;
				aw_delay == 1;
				w_delay == 4;
			}) else `uvm_error("SEQ", "Transaction randomization failed")
			
			finish_item(req);
			
		end
		
		`uvm_info("SEQ", "Completed full memory map write sweep", UVM_LOW)
	endtask
endclass
