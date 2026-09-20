class axi4_lite_driver extends uvm_driver #(axi4_lite_transaction);
	`uvm_component_utils(axi4_lite_driver)

	axi4_lite_config cfg;
	virtual axi4_lite_interface.DRV vif;

	uvm_seq_item_pull_port #(axi4_lite_transaction) wr_seq_item_port;
	uvm_seq_item_pull_port #(axi4_lite_transaction) rd_seq_item_port;

	axi4_lite_transaction aw_q[$];
	axi4_lite_transaction w_q[$];
	axi4_lite_transaction b_q[$];
	axi4_lite_transaction ar_q[$];
	axi4_lite_transaction r_q[$];

	semaphore wr_pipeline;
	semaphore rd_pipeline;

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
		wr_pipeline = new(cfg.max_writes);
		rd_pipeline = new(cfg.max_reads);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		reset();
		wait(vif.ARESETn == 1);

		fork
			get_write();
			get_read();

			drive_aw();
			drive_w();
			wait_b();

			drive_ar();
			wait_r();
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

	virtual task get_write();
		axi4_lite_transaction req;
		forever begin
			wr_pipeline.get(1);
			wr_seq_item_port.get_next_item(req);
			aw_q.push_front(req);
			w_q.push_front(req);
			b_q.push_front(req);
			wr_seq_item_port.item_done();
		end
	endtask

	virtual task get_read();
		axi4_lite_transaction req;
		forever begin
			rd_pipeline.get(1);
			rd_seq_item_port.get_next_item(req);
			ar_q.push_front(req);
			r_q.push_front(req);
			rd_seq_item_port.item_done();
		end
	endtask

	virtual task drive_aw();
		axi4_lite_transaction tx;
		forever begin
			wait (aw_q.size() > 0);
			tx = aw_q.pop_back();

			repeat(tx.aw_delay) @(vif.drv_cb);

			vif.drv_cb.AWADDR <= tx.AWADDR;
			vif.drv_cb.AWPROT <= tx.AWPROT;
			vif.drv_cb.AWVALID <= 1;

			do
				@(vif.drv_cb);
			while (!vif.drv_cb.AWREADY);

			vif.drv_cb.AWVALID <= 0;
		end
	endtask

	virtual task drive_w();
		axi4_lite_transaction tx;
		forever begin
			wait (w_q.size() > 0);
			tx = w_q.pop_back();

			repeat(tx.w_delay) @(vif.drv_cb);

			vif.drv_cb.WDATA <= tx.WDATA;
			vif.drv_cb.WSTRB <= tx.WSTRB;
			vif.drv_cb.WVALID <= 1;

			do
				@(vif.drv_cb);
			while (!vif.drv_cb.WREADY);

			vif.drv_cb.WVALID <= 0;
		end
	endtask

	virtual task wait_b();
		axi4_lite_transaction tx;
		forever begin
			wait (b_q.size() > 0);
			tx = b_q.pop_back();

			repeat(tx.bready_delay) @(vif.drv_cb);
			vif.drv_cb.BREADY <= 1;

			do
				@(vif.drv_cb);
			while (!vif.drv_cb.BVALID);
			vif.drv_cb.BREADY <= 0;

			wr_pipeline.put(1);
		end
	endtask

	virtual task drive_ar();
		axi4_lite_transaction tx;
		forever begin
			wait (ar_q.size() > 0);
			tx = ar_q.pop_back();

			repeat(tx.ar_delay) @(vif.drv_cb);

			vif.drv_cb.ARADDR <= tx.ARADDR;
			vif.drv_cb.ARPROT <= tx.ARPROT;
			vif.drv_cb.ARVALID <= 1;

			do
				@(vif.drv_cb);
			while (!vif.drv_cb.ARREADY);
			vif.drv_cb.ARVALID <= 0;
		end
	endtask

	virtual task wait_r();
		axi4_lite_transaction tx;
		forever begin
			wait(r_q.size() > 0);
			tx = r_q.pop_back();

			repeat (tx.rready_delay) @(vif.drv_cb);
			vif.drv_cb.RREADY <= 1;

			do
				@(vif.drv_cb);
			while (!vif.drv_cb.RVALID);
			vif.drv_cb.RREADY <= 0;

			rd_pipeline.put(1);
		end
	endtask
endclass
