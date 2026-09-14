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
);

    property p_aw;
        @(posedge ACLK) disable iff (!ARESETn)
        (AWVALID && !AWREADY) |=> AWVALID;
    endproperty
    a_aw: assert property (p_aw) else $error("AWVALID dropped before AWREADY");

    property p_w;
        @(posedge ACLK) disable iff (!ARESETn)
        (WVALID && !WREADY) |=> WVALID;
    endproperty
    a_w: assert property (p_w) else $error("WVALID dropped before WREADY");

    property p_b;
        @(posedge ACLK) disable iff (!ARESETn)
        (BVALID && !BREADY) |=> BVALID;
    endproperty
    a_b: assert property (p_b) else $error("BVALID dropped before BREADY");

    property p_ar;
        @(posedge ACLK) disable iff (!ARESETn)
        (ARVALID && !ARREADY) |=> ARVALID;
    endproperty
    a_ar: assert property (p_ar) else $error("ARVALID dropped before ARREADY");

    property p_r;
        @(posedge ACLK) disable iff (!ARESETn)
        (RVALID && !RREADY) |=> RVALID;
    endproperty
    a_r: assert property (p_r) else $error("RVALID dropped before RREADY");

    property p_rst;
        @(posedge ACLK) (!ARESETn) |-> (!AWVALID && !WVALID && !ARVALID && !RVALID && !BVALID);
    endproperty
    a_rst: assert property (p_rst) else $error("Reset failed to clear valid signals");

endmodule
