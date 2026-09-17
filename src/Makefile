# --- Variables ---
# Defaults (can be overridden from command line)
TEST      ?= axi4_lite_sanity_test
VERBOSITY ?= UVM_HIGH

# Source files
FILES = axi4_lite_interface.sv axi4_lite_pkg.sv top.sv

# Compilation and Coverage Flags (Updated with your exact commands)
VCS_CMD   = vcs -full64 -sverilog -ntb_opts uvm +incdir+. -timescale=1ns/1ps -debug_access+all +cover=bce
COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

# List of tests to run in the regression suite
REGRESSION_TESTS = \
	axi4_lite_sanity_test \
	axi4_lite_corner_test 

# --- Targets ---
.PHONY: all compile run regression coverage clean

# Default target
all: compile run

# 1. Compile the design and testbench with coverage enabled
compile:
	$(VCS_CMD) $(COV_FLAGS) $(FILES) -l compile.log

# 2. Run a single test
run:
	./simv $(COV_FLAGS) +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VERBOSITY) -cm_name $(TEST) -l $(TEST).log

# 3. Run all tests in the REGRESSION_TESTS list
regression: compile
	@for t in $(REGRESSION_TESTS); do \
		echo "--------------------------------------------------"; \
		echo "Running Test: $$t"; \
		echo "--------------------------------------------------"; \
		$(MAKE) run TEST=$$t; \
	done
	$(MAKE) coverage

# 4. Generate merged HTML coverage report
coverage:
	urg -dir simv.vdb -report coverage_report_html

# 5. Clean up all generated files
clean:
	rm -rf simv simv.daidir csrc *.log *.vpd *.fsdb *.key vc_hdrs.h simv.vdb coverage_report_html
