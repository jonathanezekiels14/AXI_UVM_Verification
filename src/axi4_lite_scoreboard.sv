typedef enum bit[2:0] {
	RW,
	RO,
	WO,
	OUT_OF_BOUND,
	INVALID
} reg_access;

class axi4_lite_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(axi4_lite_scoreboard)

	uvm_analysis_imp #(axi4_lite_transaction,axi4_lite_scoreboard) ap_imp;
	bit [7:0] mem[bit[31:0]];

	function new(string name = "axi4_lite_scoreboard", uvm_component parent = null);
		super.new(name,parent);
		ap_imp = new("ap_imp",this);
	endfunction

	virtual function reg_access access_type(bit [31:0] addr);
		// 1. Highest Priority: Unaligned accesses are always invalid
		if (addr % 4 != 0 && addr < 32'h3F)
			return INVALID;
		
		// 2. Range Checks
		if (addr >= 32'h00 && addr <= 32'h24)
			return RW;
		else if (addr >= 32'h28 && addr <= 32'h30)
			return RO;
		else if (addr >= 32'h34 && addr <= 32'h38)
			return WO;
		else if (addr == 32'h3C)
			return RW;
		else 
			return OUT_OF_BOUND; // Anything > 32'h3C
	endfunction

	virtual function void write(axi4_lite_transaction tx);
		reg_access reg_type;

		if(tx.direction == WRITE) begin
			reg_type = access_type(tx.AWADDR);

			// Handle DECERR (Address out of range)
			if (reg_type == OUT_OF_BOUND) begin
				if(tx.BRESP !== 2'b11)
					`uvm_error("SCB_ERR", $sformatf("Expected DECERR (2'b11) for out of bounds write at %0h, got %0b", tx.AWADDR, tx.BRESP))
			end
			// Handle SLVERR (Unaligned or Write to RO)
			else if(reg_type == INVALID || reg_type == RO) begin
				if(tx.BRESP !== 2'b10)
					`uvm_error("SCB_ERR", $sformatf("Expected SLVERR (2'b10) for invalid write at %h, got %b", tx.AWADDR, tx.BRESP))
			end
			// Handle OKAY (Valid write)
			else begin
				if(tx.BRESP !== 2'b00)
					`uvm_error("SCB_ERR", $sformatf("Expected OKAY (2'b00) for valid write at %0h, got %b", tx.AWADDR, tx.BRESP))
				else begin
					// Only update memory if the response was actually OKAY
					for(int i = 0; i < (`DATA_WIDTH/8); i++) begin
						if(tx.WSTRB[i] == 1)
							mem[tx.AWADDR + i] = tx.WDATA[8*i +: 8];
					end
				end
			end
		end

		else if(tx.direction == READ) begin
			reg_type = access_type(tx.ARADDR);

			// Handle DECERR (Address out of range)
			if (reg_type == OUT_OF_BOUND) begin
				if(tx.RRESP !== 2'b11)
					`uvm_error("SCB_ERR", $sformatf("Expected DECERR (2'b11) for out of bounds read at %0h, got %0b", tx.ARADDR, tx.RRESP))
			end
			// Handle SLVERR (Unaligned or Read to WO)
			else if(reg_type == INVALID || reg_type == WO) begin
				if(tx.RRESP !== 2'b10)
					`uvm_error("SCB_ERR", $sformatf("Expected SLVERR (2'b10) for invalid read at %0h, got %0b", tx.ARADDR, tx.RRESP))
			end
			// Handle OKAY (Valid read)
			else begin
				logic [`DATA_WIDTH-1:0] exp_data;

				if(tx.RRESP !== 2'b00)
					`uvm_error("SCB_ERR", $sformatf("Expected OKAY (2'b00) for valid read at %0h, got %0b", tx.ARADDR, tx.RRESP))
				else begin
					for(int i = 0; i < (`DATA_WIDTH/8); i++) begin
						if(mem.exists(tx.ARADDR + i))
							exp_data[8*i +: 8] = mem[tx.ARADDR + i];
						else
							exp_data[8*i +: 8] = 0;
					end

					if(tx.RDATA !== exp_data)
						`uvm_error("SCB_FAIL", $sformatf("Data Mismatch at Addr: %h | Expected: %h, Actual: %h", tx.ARADDR, exp_data, tx.RDATA))
					else
						`uvm_info("SCB_PASS", $sformatf("Data Match at Addr: %h | Data: %h", tx.ARADDR, tx.RDATA), UVM_LOW)
				end
			end
		end
	endfunction
endclass
