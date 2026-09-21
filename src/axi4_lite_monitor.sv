class axi4_lite_monitor extends uvm_monitor;
	`uvm_component_utils(axi4_lite_monitor)

	virtual axi4_lite_interface.MON vif;
	axi4_lite_config cfg;
	uvm_analysis_port #(axi4_lite_transaction) mon_ap;

	int max_wait = 100; // Watchdog timeout limit

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
		wait(vif.wait_reset == 1);
		fork
			write();
			read();
		join
	endtask

	virtual task write();
		int aw_timer, w_timer, b_timer;

		forever begin
			axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
			tx.direction = WRITE;

			fork
				begin
					aw_timer = 0;
					do begin
						@(vif.mon_cb);
						// Only increment timer if waiting for READY
						if (vif.mon_cb.AWVALID && !vif.mon_cb.AWREADY) aw_timer++;
						else aw_timer = 0; // Reset if idle

						if (aw_timer > max_wait) 
							`uvm_fatal("MON_TIMEOUT", "AWREADY hung!")
					end while (!(vif.mon_cb.AWVALID && vif.mon_cb.AWREADY));
					
					tx.AWADDR = vif.mon_cb.AWADDR;
					tx.AWPROT = vif.mon_cb.AWPROT;
					tx.AWVALID = vif.mon_cb.AWVALID;
					tx.AWREADY = vif.mon_cb.AWREADY;
				end
				begin
					w_timer = 0;
					do begin
						@(vif.mon_cb);
						if (vif.mon_cb.WVALID && !vif.mon_cb.WREADY) w_timer++;
						else w_timer = 0;

						if (w_timer > max_wait) 
							`uvm_fatal("MON_TIMEOUT", "WREADY hung!")
					end while(!(vif.mon_cb.WVALID && vif.mon_cb.WREADY));
					
					tx.WDATA = vif.mon_cb.WDATA;
					tx.WSTRB = vif.mon_cb.WSTRB;
					tx.WVALID = vif.mon_cb.WVALID;
					tx.WREADY = vif.mon_cb.WREADY;
				end
			join

			b_timer = 0;
			do begin
				@(vif.mon_cb);
				if (vif.mon_cb.BVALID && !vif.mon_cb.BREADY) b_timer++;
				else b_timer = 0;

				if (b_timer > max_wait) 
					`uvm_fatal("MON_TIMEOUT", "BREADY hung!")
			end while (!(vif.mon_cb.BVALID && vif.mon_cb.BREADY));

			tx.BRESP = vif.mon_cb.BRESP;
			tx.BVALID = vif.mon_cb.BVALID;
			tx.BREADY = vif.mon_cb.BREADY;
			
			`uvm_info("MON_WRITE",$sformatf("Captured: %s",tx.convert2string()),UVM_MEDIUM);
			mon_ap.write(tx);
		end
	endtask

	virtual task read();
		int ar_timer, r_timer;

		forever begin
			axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
			tx.direction = READ;

			ar_timer = 0;
			do begin
				@(vif.mon_cb);
				if (vif.mon_cb.ARVALID && !vif.mon_cb.ARREADY) ar_timer++;
				else ar_timer = 0;

				if (ar_timer > max_wait) 
					`uvm_fatal("MON_TIMEOUT", "ARREADY hung!")
			end while (!(vif.mon_cb.ARVALID && vif.mon_cb.ARREADY));

			tx.ARADDR = vif.mon_cb.ARADDR;
			tx.ARPROT = vif.mon_cb.ARPROT;
			tx.ARVALID = vif.mon_cb.ARVALID;
			tx.ARREADY = vif.mon_cb.ARREADY;

			r_timer = 0;
			do begin
				@(vif.mon_cb);
				if (vif.mon_cb.RVALID && !vif.mon_cb.RREADY) r_timer++;
				else r_timer = 0;

				if (r_timer > max_wait) 
					`uvm_fatal("MON_TIMEOUT", "RREADY hung!")
			end while(!(vif.mon_cb.RVALID && vif.mon_cb.RREADY));

			tx.RDATA = vif.mon_cb.RDATA;
			tx.RRESP = vif.mon_cb.RRESP;
			tx.RVALID = vif.mon_cb.RVALID;
			tx.RREADY = vif.mon_cb.RREADY;

			`uvm_info("MON_READ",$sformatf("Captured: %s ",tx.convert2string()),UVM_HIGH);
			mon_ap.write(tx);
		end
	endtask
endclass
