transcript on

vlib work
vlog counter.v fall_edge_detect.v FMM.v master_spi.v mux.v register.v rise_edge_detect.v rom_inst.v shift_reg.v tb.v 
vsim -t 1ns -voptargs="+acc" testbench

add wave /testbench/clk
add wave -radix unsigned /testbench/master/i_rst_n

#mux_sck
add wave -radix hexadecimal /testbench/master/mux1/*

#miso
add wave -radix unsigned /testbench/master/sh_miso_reg/*

#miso_dat
add wave -radix unsigned /testbench/miso_dat
add wave -radix unsigned /testbench/master/miso_buffer/*

#mosi
add wave -radix unsigned /testbench/master/sh_mosi_reg/*

#mosi_dat
add wave -radix unsigned /testbench/mosi_dat



#FMM
#add wave -radix hexadecimal /testbench/master/fmm/*

#cnt_rom_inst
add wave -radix hexadecimal /testbench/master/cnt_rom_inst/*


add wave -radix hexadecimal /testbench/master/cnt_bit_miso/*
add wave -radix hexadecimal /testbench/master/cnt_bit_mosi/*

add wave -radix hexadecimal /testbench/master/o_cs
onbreak resume

configure wave -timelineunits ns
run -all

wave zoom full