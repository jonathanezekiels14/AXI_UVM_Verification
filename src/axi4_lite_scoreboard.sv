typedef enum bit[1:0] {
	RW,
	RO,
	WO,
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
		if(addr >= 32'h00000000 && addr <= 32'h0000003C)
			return RW;
		else
			return INVALID;
	endfunction

	virtual function void write(axi4_lite_transaction tx);
		reg_access reg_type;
		
		if(tx.direction == WRITE) begin
			reg_type = access_type(tx.AWADDR);

			if(reg_type == INVALID || reg_type == RO) begin
				if(tx.BRESP !== 2'b10)
					`uvm_error("SCB_ERR", $sformatf("Expected SLVERR for invalid write at %h, got %b",tx.AWADDR,tx.BRESP))
			end
			else begin
				if(tx.BRESP !== 2'b00)
					`uvm_error("SCB_ERR", $sformatf("Expected OKAY for valid write at %0h, got %b",tx.AWADDR, tx.BRESP))
				
				for(int i = 0; i < (`DATA_WIDTH/8); i++) begin
					if(tx.WSTRB[i] == 1)
						mem[tx.AWADDR + i] = tx.WDATA[8*i +: 8]; 
				end
			end
		end

		else if(tx.direction == READ) begin
			reg_type = access_type(tx.ARADDR);
			
			if(reg_type == INVALID || reg_type == WO) begin
				if(tx.RRESP != 2'b10) 
					`uvm_error("SCB_ERR", $sformatf("Expected SLVERR for invalid read at %0h, got %0b", tx.ARADDR, tx.RRESP))
			end
			else begin
				logic [`DATA_WIDTH-1:0] exp_data;

				if(tx.RRESP != 2'b00) 
					`uvm_error("SCB_ERR", $sformatf("Expected OKAY for valid read at %0h, got %0b",tx.ARADDR, tx.RRESP))

				for(int i = 0; i < (`DATA_WIDTH/8); i++) begin
					if(mem.exists(tx.ARADDR + i))
						exp_data[8*i +: 8] = mem[tx.ARADDR + i];
					else
						exp_data[8*i +: 8] = 0;
				end

				if(tx.RDATA !== exp_data)
					`uvm_error("SCB_FAIL", $sformatf("Data Mismatch at Addr: %h | Expected: %h, Actual: %h",tx.ARADDR, exp_data,tx.RDATA))
				else
					`uvm_info("SCB_PASS", $sformatf("Data Match at Addr: %h | Data: %h",tx.ARADDR,tx.RDATA), UVM_LOW)
			end
		end
	endfunction
endclass
