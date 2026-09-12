class axi4_lite_config extends uvm_object;
	`uvm_object_utils(axi4_lite_config)

	uvm_active_passive enum is_active = UVM_ACTIVE;
	virtual axi4_lite_interface vif;
	
	function new(string name = "axi4_lite_config");
		super.new(name);
	endfunction
endclass

