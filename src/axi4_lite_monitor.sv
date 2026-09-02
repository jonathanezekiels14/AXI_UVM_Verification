class axi4_lite_monitor extends uvm_monitor;
	`uvm_component_utils(axi4_lite_monitor)

	virtual axi4_lite_interface.MON vif;
	axi4_lite_config cfg;
	uvm_analysis_port #(axi4_lite_transaction) mon_port;

	function new(string name = "axi4_lite_monitor", uvm_component parent = null);
		super.new(name,parent);
		mon_port = new("mon_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config#(axi4_lite_config)::get(this,"","axi4_lite_config",cfg)) begin
			`uvm_fatal("MON", $sformatf("Monitor Failed to get Config"));
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif=cfg.vif;
	endfunction

	task run_phase (uvm_phase phase);
		wait(vif.ARESETn == 1);

		fork
			write();
			read();
		join
	endtask

	virtual task  write();
		forever begin
			axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
			tx.axi_dir = WRITE;

			fork
				begin
					do begin
						@(posedge vif.mon_cb);
					end while (!(vif.AWVALID && vif.AWREADY));
					tx.AWADDR = vif.AWADDR;
					tx.AWPROT = vif.AWPROT;
				end
				begin
					do begin
						@(posedge vif.mon_cb);
					end while(!(vif.WVALID && vif.WREADY));
					tx.WDATA = vif.WDATA;
					tx.WSTRB = vif.WSTRB;
				end
			join

			do begin
				@(posedge vif.mon_cb);
			end while (!(vif.BVALID && vif.BREADY));

			tx.BRESP = vif.BRESP;
			`uvm_info("MON_WRITE",$sformatf("Captured: %s",tx.convert2string),UVM_MED);
			mon_port.write(tx);
		end
	endtask

	virtual task read();
		forever begin
			axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
			tx.axi_dir = READ;

			do begin
				@(posedge vif.mon_cb);
			end while (!(vif.ARVALID && ARREADY));

			tx.ARADDR = vif.ARADDR;
			tx.ARPROT = vif.ARPROT;

			do begin
				@(posedge vif.mon_cb);
			end while(!(vif.RVALID && vif.RREADY));

			tx.RDATA = vif.RDATA;
			tx.RRESP = vif.RRESP;

			`uvm_info("MON_READ",$sformatf("Captured: %s ",tx.convert2string()),UVM_HIGH);
			mon_ap.write(tx);
		end
	endtask

