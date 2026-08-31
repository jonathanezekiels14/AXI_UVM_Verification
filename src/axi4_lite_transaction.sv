class axi4_lite_transaction extends uvm_sequence_item;

	// Write Address
	rand logic [`ADDR_WIDTH-1:0] AWADDR;
	rand logic [2:0] AWPROT;
	rand logic AWVALID,
	logic AWREADY;

	// Write Data
	rand logic [`DATA_WIDTH-1:0] WDATA;
	rand logic [(`DATA_WIDTH/8)-1:0] WSTRB;
	rand logic WVALID;
	logic WREADY;

	// Response Channel
	logic [1:0] BRESP;
	logic BVALID;
	rand logic BREADY;

	// Read Address
	rand logic [`ADDR_WIDTH-1:0] ARADDR;
	rand logic [2:0] ARPROT;
	rand logic ARVALID;
	logic ARREADY;

	// Read Data
	logic [`DATA_WIDTH-1:0] RDATA;
	logic [1:0] RRESP;
	logic RVALID;
	rand logic RREADY;
	
	
	`uvm_object_utils_begin(axi4_lite_transaction)
		// Write Address
		`uvm_field_int(AWADDR,  UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(AWPROT,  UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(AWVALID, UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(AWREADY, UVM_ALL_ON | UVM_BIN)
	
		// Write Data
		`uvm_field_int(WDATA,   UVM_ALL_ON | UVM_DEC)
		`uvm_field_int(WSTRB,   UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(WVALID,  UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(WREADY,  UVM_ALL_ON | UVM_BIN)

		// Response Channel
		`uvm_field_int(BRESP,   UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(BVALID,  UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(BREADY,  UVM_ALL_ON | UVM_BIN)

		// Read Address
		`uvm_field_int(ARADDR,  UVM_ALL_ON | UVM_HEX)
		`uvm_field_int(ARPROT,  UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(ARVALID, UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(ARREADY, UVM_ALL_ON | UVM_BIN)

		// Read Data
		`uvm_field_int(RDATA,   UVM_ALL_ON | UVM_DEC)
		`uvm_field_int(RRESP,   UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(RVALID,  UVM_ALL_ON | UVM_BIN)
		`uvm_field_int(RREADY,  UVM_ALL_ON | UVM_BIN)
	`uvm_object_utils_end

	function new(string name = "axi4_lite_transaction");
		super.new(name);
	endfunction

	virtual function string convert2string();
		return $sformatf("AW[A:'h%0h P:'b%0b V:%0b R:%0b] W[D:'d%0d S:'b%0b V:%0b R:%0b] B[Rsp:'b%0b V:%0b R:%0b] | AR[A:'h%0h P:'b%0b V:%0b R:%0b] R[D:'d%0d Rsp:'b%0b V:%0b R:%0b]",
                     AWADDR, AWPROT, AWVALID, AWREADY,
                     WDATA, WSTRB, WVALID, WREADY,
                     BRESP, BVALID, BREADY,
                     ARADDR, ARPROT, ARVALID, ARREADY,
                     RDATA, RRESP, RVALID, RREADY);
	endfunction
endclass
