transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation {C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation/SdRambuffer.v}
vlog -vlog01compat -work work +incdir+C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation {C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation/processBuffer.v}
vlog -vlog01compat -work work +incdir+C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation {C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation/fillBuffer.v}
vlog -vlog01compat -work work +incdir+C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation {C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation/main.v}
vlog -sv -work work +incdir+C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation {C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation/sendDataToFillbuffer_fake.sv}
vlog -sv -work work +incdir+C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation {C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation/clockgen_fake.sv}

vlog -sv -work work +incdir+C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation {C:/Users/kite/Documents/programacao/quartus/bufferBetweenARMAndFPGA_simulation/simulation_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  simulation_tb

add wave *
view structure
view signals
run -all
