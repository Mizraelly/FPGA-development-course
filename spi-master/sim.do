transcript on

vlib work
vlog counter.v fall_edge_detect.v FMM.v master_spi.v mux.v register.v rise_edge_detect.v rom_inst.v shift_reg.v tb.v 
vsim -t 1ns -voptargs="+acc" testbench

add wave /testbench/clk

#mux_sck
add wave -radix hexadecimal /testbench/master/mux1/*

#miso
add wave -radix hexadecimal /testbench/master/sh_miso_reg/*

#FMM
#add wave -radix hexadecimal /testbench/master/fmm/*

#cnt_rom_inst
add wave -radix hexadecimal /testbench/master/cnt_rom_inst/*



add wave -radix hexadecimal /testbench/master/cnt_bit_miso/*
add wave -radix hexadecimal /testbench/master/cnt_bit_mosi/*

add wave -radix unsigned /testbench/master/miso_buffer/*
onbreak resume

configure wave -timelineunits ns
run -all

wave zoom full