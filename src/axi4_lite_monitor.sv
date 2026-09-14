class axi4_lite_monitor extends uvm_monitor;
	`uvm_component_utils(axi4_lite_monitor)

	virtual axi4_lite_interface.MON vif;
	axi4_lite_config cfg;
	uvm_analysis_port #(axi4_lite_transaction) mon_ap;

	function new(string name = "axi4_lite_monitor", uvm_component parent = null);
		super.new(name,parent);
		mon_ap = new("mon_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(axi4_lite_config)::get(this,"","axi4_lite_config",cfg)) begin
			`uvm_fatal("MON", $sformatf("Monitor Failed to get Config"));
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif = cfg.vif;
	endfunction

	task run_phase (uvm_phase phase);
		wait(vif.ARESETn == 1);

		fork
			write();
			read();
		join
	endtask

	virtual task write();
		forever begin
			axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
			tx.direction = WRITE;

			fork
				begin
					do begin
						@(vif.mon_cb);
					end while (!(vif.mon_cb.AWVALID && vif.mon_cb.AWREADY));
					tx.AWADDR = vif.mon_cb.AWADDR;
					tx.AWPROT = vif.mon_cb.AWPROT;
				end
				begin
					do begin
						@(vif.mon_cb);
					end while(!(vif.mon_cb.WVALID && vif.mon_cb.WREADY));
					tx.WDATA = vif.mon_cb.WDATA;
					tx.WSTRB = vif.mon_cb.WSTRB;
				end
			join

			do begin
				@(vif.mon_cb);
			end while (!(vif.mon_cb.BVALID && vif.mon_cb.BREADY));

			tx.BRESP = vif.mon_cb.BRESP;
			`uvm_info("MON_WRITE",$sformatf("Captured: %s",tx.convert2string()),UVM_MEDIUM);
			mon_ap.write(tx);
		end
	endtask

	virtual task read();
		forever begin
			axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
			tx.direction = READ;

			do begin
				@(vif.mon_cb);
			end while (!(vif.mon_cb.ARVALID && vif.mon_cb.ARREADY));

			tx.ARADDR = vif.mon_cb.ARADDR;
			tx.ARPROT = vif.mon_cb.ARPROT;

			do begin
				@(vif.mon_cb);
			end while(!(vif.mon_cb.RVALID && vif.mon_cb.RREADY));

			tx.RDATA = vif.mon_cb.RDATA;
			tx.RRESP = vif.mon_cb.RRESP;

			`uvm_info("MON_READ",$sformatf("Captured: %s ",tx.convert2string()),UVM_HIGH);
			mon_ap.write(tx);
		end
	endtask
endclass
