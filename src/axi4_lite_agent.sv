class axi4_lite_agent extends uvm_agent;
	`uvm_component_utils(axi4_lite_agent)

	axi4_lite_driver drv;
	axi4_lite_monitor mon;
	axi4_lite_sequencer sqr_rd;
	axi4_lite_sequencer sqr_wr;
	uvm_analysis_port #(axi4_lite_transaction) ap;

	axi4_lite_config cfg;

	function new(string name = "axi4_lite_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(axi4_lite_config)::get(this,"","axi4_lite_config",cfg))
                        `uvm_fatal(get_name(),"Agent Failed to get Config_db");
                mon = axi4_lite_monitor::type_id::create("mon",this);
                ap  = new("ap", this);
                if (cfg.is_active == UVM_ACTIVE) begin
                        drv = axi4_lite_driver::type_id::create("drv", this);
			sqr_rd = axi4_lite_sequencer::type_id::create("sqr_rd", this);
			sqr_wr = axi4_lite_sequencer::type_id::create("sqr_wr", this);
                end
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mon.mon_ap.connect(this.ap);
		if (get_is_active() == UVM_ACTIVE) begin
			drv.rd_seq_item_port.connect(sqr_rd.seq_item_export);
			drv.wr_seq_item_port.connect(sqr_wr.seq_item_export);
		end
	endfunction
endclass
