interface axi4_lite_interface(input bit ACLK);

	logic ARESETn;

	// Write Address Channel
	logic [`ADDR_WIDTH-1:0] AWADDR;
	logic [2:0] AWPROT;
	logic AWVALID,AWREADY;

	// Write Data Channel
	logic [`DATA_WIDTH-1:0] WDATA;
	logic [(`DATA_WIDTH/8)-1:0] WSTRB;
	logic WVALID,WREADY;

	// Response Channel
	logic [1:0] BRESP;
	logic BVALID,BREADY;

	//Read Address Channel
	logic [`ADDR_WIDTH-1:0] ARADDR;
	logic [2:0] ARPROT;
	logic ARVALID,ARREADY;

	// Read Data Channel
	logic [`ADDR_WIDTH-1:0] RDATA;
	logic [1:0] RRESP;
	logic RVALID,RREADY;

	clocking drv_cb @(posedge ACLK);
		default input #1ns output #1ns;
		output 
		// Write address
		AWADDR,AWPROT,AWVALID,  
		// Write Data
		WDATA, WSTRB, WVALID, 
		// Write Response
		BREADY,
		// Read Address
		ARADDR,ARPROT,ARVALID,
		// Read Data
		RREADY;

		input AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID;
	endclocking

	clocking mon_cb @(posedge ACLK);
		default input #1ns;
		input
		// Write address
		AWADDR,AWPROT,AWVALID,AWREADY,  
		// Write Data
		WDATA, WSTRB, WVALID, WREADY,
		// Write Response
		BREADY,BRESP,BVALID,
		// Read Address
		ARADDR,ARPROT,ARVALID, ARREADY
		// Read Data
		RREADY, RRESP, RVALID, RDATA;
	endclocking


endinterface


	
