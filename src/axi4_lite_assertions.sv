module axi4_lite_assertions (
	input wire ACLK,
	input wire ARESETn,
	input wire AWVALID,
	input wire AWREADY,
	input wire WVALID,
	input wire WREADY,
	input wire BVALID,
	input wire BREADY,
	input wire ARVALID,
	input wire ARREADY,
	input wire RVALID,
	input wire RREADY
	/*
	input wire AWPROT,
	input wire AWADDR,
	input wire WDATA,
	input wire WSTRB,
	input wire ARADDR,
	input wire ARPROT
*/
);

	// AWVALID must stay high until AWREADY
	property p_aw;
		@(posedge ACLK) disable iff (!ARESETn)
		(AWVALID && !AWREADY) |=> AWVALID;
	endproperty
	a_aw: assert property (p_aw) else $error("AWVALID dropped before AWREADY");


	// WVALID must stay high until WREADY
	property p_w;
		@(posedge ACLK) disable iff (!ARESETn)
		(WVALID && !WREADY) |=> WVALID;
	endproperty
	a_w: assert property (p_w) else $error("WVALID dropped before WREADY");

	// BVALID must stay high until BREADY
	property p_b;
		@(posedge ACLK) disable iff (!ARESETn)
		(BVALID && !BREADY) |=> BVALID;
	endproperty
	a_b: assert property (p_b) else $error("BVALID dropped before BREADY");

	// ARVALID must stay high until ARREADY
	property p_ar;
		@(posedge ACLK) disable iff (!ARESETn)
		(ARVALID && !ARREADY) |=> ARVALID;
	endproperty
	a_ar: assert property (p_ar) else $error("ARVALID dropped before ARREADY");



	// RVALID must stay high until RREADY
	property p_r;
		@(posedge ACLK) disable iff (!ARESETn)
		(RVALID && !RREADY) |=> RVALID;
	endproperty
	a_r: assert property (p_r) else $error("RVALID dropped before RREADY");

	// Reset clears all valids
	property p_rst;
		@(posedge ACLK) (!ARESETn) |-> (!AWVALID && !WVALID && !ARVALID && !RVALID && !BVALID);
	endproperty
	a_rst: assert property (p_rst) else $error("Reset failed to clear valid signals");
/*
	// AWADDR and AWPROT must be stable at Handshake
	property check_stable_aw;
		@(posedge ACLK) disable iff (!ARESETn)
		(AWVALID && !AWREADY) |=> $stable(AWADDR) && $stable(AWPROT);
	endproperty
	a_stable_aw: assert property(check_stable_aw) else $error("AWADDR and AWPROT were not stable at Handshake");

	// WDATA and WSTRB must be stable at Handshake
	property check_stable_w;
		@(posedge ACLK) disable iff (!ARESETn)
		(WVALID && !WREADY) |=> $stable(WDATA) && $stable(WSTRB);
	endproperty
	a_stable_w: assert property(check_stable_w) else $error("WDATA and WSTRB were not stable at Handshake");

	// ARADDR and ARPROT must be stable at Handshake
	property check_stable_ar;
		@(posedge ACLK) disable iff (!ARESETn)
		(ARVALID && !ARREADY) |=> $stable(ARADDR) && $stable(ARPROT);
	endproperty
	a_stable_ar: assert property(check_stable_ar) else $error("ARADDR and ARPROT were not stable at Handshake");
	*/
endmodule
