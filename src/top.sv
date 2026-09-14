`include "axi4_lite.v"
`include "defines.svh"

module top;
	import uvm_pkg::*;
	import axi4_lite_pkg::*;

	logic ACLK;

	initial begin
		ACLK = 0;
		forever begin
			#5 ACLK = ~ACLK;
		end
	end

	axi4_lite_interface vif(ACLK);

	axi4_lite_slave #(
		.DATA_WIDTH(`DATA_WIDTH),
		.ADDR_WIDTH(`ADDR_WIDTH),
		.MEM_DEPTH(`MEM_DEPTH),
		.DEFAULT_PROT(`DEFAULT_PROT))
	dut (
		.ACLK(ACLK),
		.ARESETn(vif.ARESETn),
		.AWADDR(vif.AWADDR),
		.AWPROT(vif.AWPROT),
		.AWVALID(vif.AWVALID),
		.AWREADY(vif.AWREADY),
		.WDATA(vif.WDATA),
		.WSTRB(vif.WSTRB),
		.WVALID(vif.WVALID),
		.WREADY(vif.WREADY),
		.BRESP(vif.BRESP),
		.BVALID(vif.BVALID),
		.BREADY(vif.BREADY),
		.ARADDR(vif.ARADDR),
		.ARPROT(vif.ARPROT),
		.ARVALID(vif.ARVALID),
		.ARREADY(vif.ARREADY),
		.RDATA(vif.RDATA),
		.RRESP(vif.RRESP),
		.RVALID(vif.RVALID),
		.RREADY(vif.RREADY)
	);

	initial begin
		@(posedge ACLK);
		vif.ARESETn = 0;
		repeat (2) @(posedge ACLK);
		vif.ARESETn = 1;
		`uvm_info("TOP",$sformatf("Initial Reset Released"), UVM_LOW)
	end

	initial begin
		uvm_config_db#(virtual axi4_lite_interface)::set(null,"*","vif",vif);
		run_test();
	end
endmodule
	
