vlib work
vlog -f alsu_files.list
vsim alsu_top
add wave /alsu_top/intf/clk
add wave /alsu_top/intf/rst
add wave /alsu_top/intf/red_op_A
add wave /alsu_top/intf/red_op_B
add wave /alsu_top/intf/bypass_A
add wave /alsu_top/intf/bypass_B
add wave /alsu_top/intf/direction
add wave /alsu_top/intf/serial_in
add wave /alsu_top/intf/cin
add wave /alsu_top/intf/A
add wave /alsu_top/intf/B
add wave /alsu_top/intf/opcode
add wave /alsu_top/intf/out
add wave /alsu_top/intf/leds
run -all
