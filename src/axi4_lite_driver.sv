class axi4_lite_driver extends uvm_driver #(axi4_lite_transaction);
	`uvm_component_utils(axi4_lite_driver)

	virtual axi4_lite_interface.DRV vif;

	uvm_seq_item_pull_port #(axi4_lite_transaction) wr_seq_item_port;
	uvm_seq_item_pull_port #(axi4_lite_transaction) rd_seq_item_port;

	function new(string name = "axi4_lite_driver", uvm_component parent = null);
		super.new(name,parent);
		wr_seq_item_port= new("wr_seq_item_port",this);
		rd_seq_item_port= new("rd_seq_item_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config#(axi4_lite_config)::get(this,"","axi4_lite_config",cfg)) begin
			`uvm_fatal("DRV", $sformatf("Driver Failed to get Config"));
		end
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

	endtask

	virtual task write();
		forever begin
			wr_seq_item_port.get_next_item(req);
			drive_write(req);
			wr_seq_item_port.item_done();
		end
	endtask

	virtual task drive_write(axi4_lite_transaction req);
		fork
			begin
				repeat(req.aw_delay) @(posedge vif.ACLK);
				vif.AWADDR <= req.AWADDR;
				vif.AWPROT <= req.AWPROT;
				vif.AWVALID <= 1;

				do begin 
					@(posedge vif.ACLK);
				end while (!vif.AWREADY);

				vif.AWVALID <= 0;
				vif.AWADDR <= 0;
			end

			begin
				repeat (req.w_delay) @(posedge vif.ACLK);
				vif.WDATA <= req.WDATA;
				vif.WSTRB <= req.WSTRB;
				vif.WVALID <= 1;

				do begin
					@(posedge vif.ACLK);
				end while (!vif.WREADY);

				vif.WVALID <= 0;
				vif.WDATA <= 0;
			end
		join

		repeat (req.bready_delay) @(posedge vif.ACLK);
		vif.BREADY <= 1;
		do begin
			@(posedge vif.ACLK);
		end while (!vif.BVALID);

		req.BRESP = vif.BRESP;
		vif.BREADY <= 0;
	endtask


	virtual task read();
		forever begin
			rd_seq_item_port.get_next_item(req);
			drive_read(req);
			rd_seq_item_port.item_done();
		end
	endtask

	virtual task drive_read(axi4_lite_transaction req);
		repeat (req.ar_delay) @(posedge vif.ACLK);

		vif.ARADDR <= req.ARADDR;
		vif.ARPROT <= req.ARPROT;
		vif.ARVALID <= 1;

		do begin
			@(posedge vif.ACLK);
		end while (!vif.ARREADY);

		vif.ARVALID <= 0;
		vif.ARADDR <= 0;

		repeat (req.rready_delay) @(posedge vif.ACLK);
		vif.ARREADY <= 1;

		do begin
			@(posedge vif.ACLK);
		end while (!vif.RVALID);
		req.RDATA = vif.RDATA;
		req.RRESP = vif.RRESP;
		vif.RREADY <= 0;
	endtask
endclass






