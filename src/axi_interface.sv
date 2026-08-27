interface axi_interface(input bit ACLK);

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
endinterface


	
