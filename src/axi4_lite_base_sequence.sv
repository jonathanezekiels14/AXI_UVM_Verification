class axi4_lite_base_sequence extends uvm_sequence #(axi4_lite_transaction);
	`uvm_object_utils(axi4_lite_base_sequence)

	function new(string name = "axi4_lite_base_sequence");
		super.new(name);
	endfunction
endclass
