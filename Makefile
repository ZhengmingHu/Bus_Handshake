testbentch_module = tb_handshakeType1
testbentch_file = ./sim/testbench/$(testbentch_module).sv
rtl_file = ./rtl/*.v
vvp_file = ./sim/vvp/$(testbentch_module).vvp
gtkw_file = $(testbentch_module).gtkw
vcd_file = $(testbentch_module).vcd

compile:
	iverilog -g2012 -o $(vvp_file) $(rtl_file) $(testbentch_file)

run:
	iverilog -g2012 -o $(vvp_file) $(rtl_file) $(testbentch_file)
	cd ./sim/waveform && vvp -n ../../$(vvp_file) -lxt2

wave:
	iverilog -g2012 -o $(vvp_file) $(rtl_file) $(testbentch_file)
	cd ./sim/waveform && vvp -n ../../$(vvp_file) -lxt2

    ifneq "$(wildcard $(gtkw_file))" ""
	    gtkwave ./sim/waveform/$(gtkw_file)
    else
	    gtkwave ./sim/waveform/$(vcd_file)
    endif

all: compile wave

# clear middle files
clean:
	rm -rf ./sim/vvp/*.vvp ./sim/waveform/*vcd *.gtkw
