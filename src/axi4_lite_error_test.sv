class axi4_lite_error_test extends uvm_test;
	`uvm_component_utils(axi4_lite_error_test)

	axi4_lite_environment env;
	axi4_lite_config cfg;

	function new(string name = "axi4_lite_error_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cfg = axi4_lite_config::type_id::create("cfg");
		cfg.is_active = UVM_ACTIVE;
		cfg.max_writes = 2;
		cfg.max_reads = 2;
		if(!uvm_config_db#(virtual axi4_lite_interface)::get(this, "", "vif", cfg.vif)) begin
			`uvm_fatal("TEST", "Failed to get virtual interface from top.sv!");
		end
		uvm_config_db#(axi4_lite_config)::set(this, "*", "axi4_lite_config", cfg);
		env = axi4_lite_environment::type_id::create("env", this);
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info("ERROR_TEST", "Printing UVM Topology:", UVM_NONE)
		uvm_top.print_topology();
	endfunction

	virtual task run_phase(uvm_phase phase);
		axi4_lite_error_vseq evseq;
		
		phase.phase_done.set_drain_time(this, 500ns);
		phase.raise_objection(this);
		
		evseq = axi4_lite_error_vseq::type_id::create("evseq");
		evseq.start(env.vsqr);
		phase.drop_objection(this);
	endtask
endclass
