class axi4_lite_environment extends uvm_env;
	`uvm_component_utils(axi4_lite_environment)

	axi4_lite_agent agt;
	axi4_lite_scoreboard scb;
	axi4_lite_vsqr vsqr;
	axi4_lite_config cfg;

	function new(string name = "axi4_lite_environment", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(axi4_lite_config)::get(this,"","axi4_lite_config",cfg))
			`uvm_fatal(get_name(),"Environment Failed to get Config_db");	
		uvm_config_db#(uvm_active_passive_enum)::set(this,"agt","is_active",cfg.is_active);
		agt = axi4_lite_agent::type_id::create("agt",this);
		scb = axi4_lite_scoreboard::type_id::create("scb",this);
		vsqr = axi4_lite_vsqr::type_id::create("vsqr",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agt.ap.connect(scb.ap_imp);
		vsqr.rd_sqr = agt.sqr_rd;
		vsqr.wr_sqr = agt.sqr_wr;
	endfunction
endclass



