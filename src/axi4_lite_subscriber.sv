class axi4_lite_subscriber extends uvm_subscriber #(axi4_lite_transaction);
	`uvm_component_utils(axi4_lite_subscriber)

	axi4_lite_transaction tx;

	covergroup cg;
		option.per_instance = 1;

		// Track if we did both reads and writes
		dir: coverpoint tx.direction {
			bins r = {READ};
			bins w = {WRITE};
		}

		// Track which memory regions we wrote to
		waddr: coverpoint tx.AWADDR iff (tx.direction == WRITE) {
			bins rw = {[32'h00 : 32'h24]};
			bins ro = {[32'h28 : 32'h30]};
			bins wo = {[32'h34 : 32'h38]};
			bins rsvd = {32'h3C};
			bins out = default;
		}

		// Track which memory regions we read from
		raddr: coverpoint tx.ARADDR iff (tx.direction == READ) {
			bins rw = {[32'h00 : 32'h24]};
			bins ro = {[32'h28 : 32'h30]};
			bins wo = {[32'h34 : 32'h38]};
			bins rsvd = {32'h3C};
			bins out = default;
		}

		// Track write responses
		wresp: coverpoint tx.BRESP iff (tx.direction == WRITE) {
			bins okay = {2'b00};
			bins err = {2'b10};
		}

		// Track read responses
		rresp: coverpoint tx.RRESP iff (tx.direction == READ) {
			bins okay = {2'b00};
			bins err = {2'b10};
		}

	endgroup

	function new(string name = "axi4_lite_subscriber", uvm_component parent = null);
		super.new(name, parent);
		cg = new();
	endfunction

	virtual function void write(axi4_lite_transaction t);
		$cast(tx, t);
		cg.sample();
	endfunction
endclass
