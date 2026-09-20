class axi4_lite_config extends uvm_object;
	`uvm_object_utils(axi4_lite_config)

	uvm_active_passive_enum is_active = UVM_ACTIVE;
	virtual axi4_lite_interface vif;

	int max_writes = 1;
	int max_reads = 1;
	
	function new(string name = "axi4_lite_config");
		super.new(name);
	endfunction
endclass

