class axi4_lite_driver extends uvm_driver #(axi4_lite_transaction);
	`uvm_component_utils(axi4_lite_driver)

	axi4_lite_config cfg;
	virtual axi4_lite_interface.DRV vif;

	uvm_seq_item_pull_port #(axi4_lite_transaction) wr_seq_item_port;
	uvm_seq_item_pull_port #(axi4_lite_transaction) rd_seq_item_port;

	function new(string name = "axi4_lite_driver", uvm_component parent = null);
		super.new(name,parent);
		wr_seq_item_port = new("wr_seq_item_port",this);
		rd_seq_item_port = new("rd_seq_item_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(axi4_lite_config)::get(this,"","axi4_lite_config",cfg)) begin
			`uvm_fatal("DRV", $sformatf("Driver Failed to get Config"));
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		reset();
		wait(vif.ARESETn == 1); 

		fork
			write();
			read();
		join
	endtask

	virtual task reset();
		vif.drv_cb.AWVALID <= 0;
		vif.drv_cb.AWADDR <= 0;
		vif.drv_cb.AWPROT <= 0;
		vif.drv_cb.WVALID <= 0;
		vif.drv_cb.WDATA <= 0;
		vif.drv_cb.WSTRB <= 0;
		vif.drv_cb.BREADY <= 0;
		vif.drv_cb.ARVALID <= 0;
		vif.drv_cb.ARADDR <= 0;
		vif.drv_cb.ARPROT <= 0; 
		vif.drv_cb.RREADY <= 0;
	endtask

	virtual task write();
		axi4_lite_transaction req; 
		forever begin
			wr_seq_item_port.get_next_item(req);
			drive_write(req);
			wr_seq_item_port.item_done();
		end
	endtask

	virtual task drive_write(axi4_lite_transaction req);
		fork
			begin
				repeat(req.aw_delay) @(vif.drv_cb);
				vif.drv_cb.AWADDR <= req.AWADDR;
				vif.drv_cb.AWPROT <= req.AWPROT;
				vif.drv_cb.AWVALID <= 1;

				do begin
					@(vif.drv_cb);
				end while (!vif.drv_cb.AWREADY);

				vif.drv_cb.AWVALID <= 0;
				vif.drv_cb.AWADDR <= 0;
			end

			begin
				repeat (req.w_delay) @(vif.drv_cb);
				vif.drv_cb.WDATA <= req.WDATA;
				vif.drv_cb.WSTRB <= req.WSTRB;
				vif.drv_cb.WVALID <= 1;

				do begin
					@(vif.drv_cb);
				end while (!vif.drv_cb.WREADY);

				vif.drv_cb.WVALID <= 0;
				vif.drv_cb.WDATA <= 0;
			end
		join

		repeat (req.bready_delay) @(vif.drv_cb);
		vif.drv_cb.BREADY <= 1;
		
		do begin
			@(vif.drv_cb);
		end while (!vif.drv_cb.BVALID);

		req.BRESP = vif.drv_cb.BRESP;
		vif.drv_cb.BREADY <= 0;
	endtask

	virtual task read();
		axi4_lite_transaction req; 
		forever begin
			rd_seq_item_port.get_next_item(req);
			drive_read(req);
			rd_seq_item_port.item_done();
		end
	endtask

	virtual task drive_read(axi4_lite_transaction req);
		repeat (req.ar_delay) @(vif.drv_cb);

		vif.drv_cb.ARADDR <= req.ARADDR;
		vif.drv_cb.ARPROT <= req.ARPROT;
		vif.drv_cb.ARVALID <= 1;

		do begin
			@(vif.drv_cb);
		end while (!vif.drv_cb.ARREADY);

		vif.drv_cb.ARVALID <= 0;
		vif.drv_cb.ARADDR <= 0;

		repeat (req.rready_delay) @(vif.drv_cb);
		vif.drv_cb.RREADY <= 1; 

		do begin
			@(vif.drv_cb);
		end while (!vif.drv_cb.RVALID);
		
		req.RDATA = vif.drv_cb.RDATA;
		req.RRESP = vif.drv_cb.RRESP;
		vif.drv_cb.RREADY <= 0;
	endtask
endclass
