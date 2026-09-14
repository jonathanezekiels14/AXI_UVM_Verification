class axi4_lite_read_seq extends axi4_lite_base_sequence;
    `uvm_object_utils(axi4_lite_read_seq)
    
    bit [31:0] target_addr; // Passed in from the Test

    function new(string name = "axi4_lite_read_seq");
        super.new(name);
    endfunction

    virtual task body();
        axi4_lite_transaction tx = axi4_lite_transaction::type_id::create("tx");
        start_item(tx);
        assert(tx.randomize() with {
            direction == READ;
            ARADDR == target_addr; // Use the address passed from the test
            ar_delay == 0; rready_delay == 0; 
        });
        finish_item(tx);
    endtask
endclass
